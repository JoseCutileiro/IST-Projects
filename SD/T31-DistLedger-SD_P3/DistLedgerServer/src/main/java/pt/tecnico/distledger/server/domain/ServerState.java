package pt.tecnico.distledger.server.domain;

import pt.tecnico.distledger.server.domain.operation.CreateOp;
import pt.tecnico.distledger.server.domain.operation.Operation;
import pt.tecnico.distledger.server.domain.operation.TransferOp;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.LedgerState;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.OperationType;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

public class ServerState {

    // definitions
    private final int ACTIVE = 0;
    private final int INACTIVE = 1;
    private final String OWNER = "broker";
    private final int INITIAL_AMOUNT = 1000;

    public final static String HOST = "localhost";
    public final static String PORT = "5001";
    public final static String TARGET = HOST + ":" + PORT;
    public final static String SERVICE = "DistLedger";

    private List<Operation> ledger;
    private Hashtable<String, UserInfo> users;
    private int state;
    private VectorClock serverClock;
    private VectorClock replicaClock;

    public ServerState(int size) {
        this.ledger = new ArrayList<>();
        state = ACTIVE;
        users = new Hashtable<String, UserInfo>();
        serverClock = new VectorClock(size);
        replicaClock = new VectorClock(size);

        // Initial user
        createUser(OWNER, true, new ArrayList<>(), new ArrayList<>());
        UserInfo owner = users.get(OWNER);
        owner.addBalance(INITIAL_AMOUNT);
    }

    public synchronized boolean validRead(ArrayList<Integer> prev) {
        if (prev.size() == 0) {
            return true;
        }
        VectorClock prevTS = new VectorClock(prev);
        return serverClock.greaterEqual(prevTS);
    }

    public synchronized void addServerTS() {
        serverClock.addTS();
        replicaClock.addTS();
        System.out.println("[CROSS SERVER -> SERVER] updated TS | size: " + serverClock.getTS().size() +
                " | server index: " + serverClock.getServerIndex());
    }

    public synchronized ArrayList<Integer> getTS() {
        return serverClock.getShallowTS();
    }

    public synchronized ArrayList<Integer> getReplicaTS() {
        return replicaClock.getShallowTS();
    }

    public synchronized ArrayList<Integer> replicateTS(ArrayList<Integer> prev) {
        replicaClock.increaseTime();

        int index = serverClock.getServerIndex();
        if (prev.size() == 0) {
            return replicaClock.getShallowTS();
        }
        ArrayList<Integer> copy = new ArrayList<>();
        copy.addAll(prev);
        copy.set(index, replicaClock.getTS().get(index));

        return copy;
    }

    public synchronized int getState() {
        return state;
    }

    public synchronized void activate() {
        System.out.println("[SERVER] Activated");
        state = ACTIVE;
    }

    public synchronized void deactivate() {
        System.out.println("[SERVER] Deactivated");
        state = INACTIVE;
    }

    public synchronized Hashtable<String, UserInfo> getUsers() {
        Hashtable<String, UserInfo> usersCopy = new Hashtable<>();
        usersCopy.putAll(users);
        return usersCopy;
    }

    public synchronized void setUsers(Hashtable<String, UserInfo> users) {
        this.users = users;
    }

    public synchronized int getBalance(String uid) {
        // Check state and arguments
        if (!checkState()) {
            return ErrorCodes.ERROR_SERVER_INACTIVE;
        }
        if (!checkUser(uid)) {
            return ErrorCodes.ERROR_USER_NOT_FOUND;
        }
        UserInfo user_info = users.get(uid);
        int balance = user_info.getBalance();
        System.out.println("[SERVER] Sended balance information");
        return balance;
    }

    public synchronized List<Operation> getLedgerState() {
        List<Operation> ledgerCopy = new ArrayList<>();
        ledgerCopy.addAll(ledger);
        return ledgerCopy;
    }

    public synchronized void setLedgerState(List<Operation> ledger) {
        this.ledger = ledger;
    }

    public synchronized int updateLedgerState(LedgerState state, ArrayList<Integer> replicaA) {
        if (!checkState()) {
            return ErrorCodes.ERROR_SERVER_INACTIVE;
        }

        List<DistLedgerCommonDefinitions.Operation> list = state.getLedgerList();

        for (int i = 0; i < list.size(); i++) {
            DistLedgerCommonDefinitions.Operation op = list.get(i);
            ArrayList<Integer> opTS = new ArrayList<>();
            opTS.addAll(op.getTSList());
            ArrayList<Integer> opPrevTS = new ArrayList<>();
            opPrevTS.addAll(op.getPrevTSList());
            VectorClock opTSClock = new VectorClock(opTS);
            VectorClock opPrevTSClock = new VectorClock(opPrevTS);
            if (!replicaClock.greaterEqual(opTSClock)) {
                Boolean stable = false;
                if (serverClock.greaterEqual(opPrevTSClock)) {
                    stable = true;
                }
                if (op.getType().equals(OperationType.OP_CREATE_ACCOUNT)) {
                    createUser(op.getUserId(), stable, opTS, opPrevTS);
                } else if (op.getType().equals(OperationType.OP_TRANSFER_TO)) {
                    transferTo(op.getUserId(), op.getDestUserId(), op.getAmount(), stable, opTS,
                            opPrevTS);
                }
            }
        }

        VectorClock clockA = new VectorClock(replicaA);
        replicaClock.merge(clockA);

        for (int i = 0; i < ledger.size(); i++) {
            Operation op = ledger.get(i);
            VectorClock opPrev = new VectorClock(op.getPrevTS());
            if (serverClock.greaterEqual(opPrev) && !(op.isStable())) {
                op.setStable(true);
                if (op instanceof CreateOp) {
                    executeCreateUser(op.getAccount(), op.getReplicaTS());
                    System.out.println("[GOSSIP SELF] Create user " + op.getAccount());
                } else if (op instanceof TransferOp) {
                    TransferOp opT = (TransferOp) op;
                    executeTransferTo(opT.getAccount(), opT.getDestAccount(), opT.getAmount(), opT.getReplicaTS());
                    System.out.println("[GOSSIP SELF] Transfered " + opT.getAmount() + "$ from " + opT.getAccount()
                            + " to " + opT.getDestAccount());
                }
            }
        }
        return ErrorCodes.SUCESS;
    }

    // Check if user exists
    private synchronized boolean checkUser(String uid) {
        if (users.get(uid) == null) {
            return false;
        }
        return true;
    }

    // Check is server is active
    public synchronized boolean checkState() {
        return (state == ACTIVE);
    }

    ////////////////////////
    ////// OPERATIONS //////
    ////////////////////////

    public synchronized int createUser(String uid, Boolean stable, ArrayList<Integer> replicaTS,
            ArrayList<Integer> prevTS) {
        // Create and Save CreateUser operation
        CreateOp op = new CreateOp(uid);
        op.setReplicaTS(replicaTS);
        op.setPrevTS(prevTS);
        op.setStable(stable);
        ledger.add(op);
        System.out.println("[SERVER] Added op to ledger with uid " + uid);

        // Create and Save User
        if (stable) {
            System.out.println("[SERVER] created user with " + uid);
            executeCreateUser(uid, replicaTS);
        }
        return ErrorCodes.SUCESS;
    }

    public synchronized void executeCreateUser(String uid, ArrayList<Integer> replicaTS) {
        if (!checkUser(uid)) {
            UserInfo new_user = new UserInfo(uid);
            users.put(uid, new_user);
        }
        VectorClock opTS = new VectorClock(replicaTS);
        serverClock.merge(opTS);
    }

    public synchronized int transferTo(String from, String to, int amount, Boolean stable,
            ArrayList<Integer> replicaTS, ArrayList<Integer> prevTS) {
        // Create and Save TransferTo operation
        TransferOp op = new TransferOp(from, to, amount);
        op.setReplicaTS(replicaTS);
        op.setStable(stable);
        op.setPrevTS(prevTS);
        ledger.add(op);
        System.out.println("[SERVER] Added TransferTo op to ledger");
        // Check arguments
        if (stable) {
            System.out.println("[SERVER] transfered " + amount + "$ from " + from + " to " + to);
            executeTransferTo(from, to, amount, replicaTS);
        }
        return ErrorCodes.SUCESS;
    }

    public synchronized void executeTransferTo(String from, String to, int amount, ArrayList<Integer> replicaTS) {
        UserInfo from_info = users.get(from);
        if (!(amount <= 0 || !checkUser(from) || !checkUser(to) || from.equals(to)
                || from_info.getBalance() < amount)) {
            UserInfo to_info = users.get(to);
            from_info.removeBalance(amount);
            to_info.addBalance(amount);
        }
        VectorClock opTS = new VectorClock(replicaTS);
        serverClock.merge(opTS);
    }

}