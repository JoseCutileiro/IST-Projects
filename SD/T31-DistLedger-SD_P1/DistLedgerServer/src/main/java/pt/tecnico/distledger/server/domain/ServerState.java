package pt.tecnico.distledger.server.domain;

import pt.tecnico.distledger.server.domain.operation.CreateOp;
import pt.tecnico.distledger.server.domain.operation.DeleteOp;
import pt.tecnico.distledger.server.domain.operation.Operation;
import pt.tecnico.distledger.server.domain.operation.TransferOp;

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

public class ServerState {

    // defenitions
    private final int ACTIVE = 0;
    private final int INACTIVE = 1;
    private final String OWNER = "broker";
    private final int INITIAL_AMOUNT = 1000;

    private List<Operation> ledger;
    private Hashtable<String, UserInfo> users;
    private int state;

    public ServerState() {
        this.ledger = new ArrayList<>();
        state = ACTIVE;
        users = new Hashtable<String, UserInfo>();

        // Initial user
        createUser(OWNER);
        UserInfo owner = users.get(OWNER);
        owner.addBalance(INITIAL_AMOUNT);
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
        return ledger;
    }

    // Check if user exists
    private boolean checkUser(String uid) {
        if (users.get(uid) == null) {
            return false;
        }
        return true;
    }

    // Check is server is active
    private boolean checkState() {
        return (state == ACTIVE);
    }

    ////////////////////////
    ////// OPERATIONS //////
    ////////////////////////

    public synchronized int createUser(String uid) {
        // Check state and arguments
        if (!checkState()) {
            return ErrorCodes.ERROR_SERVER_INACTIVE;
        }
        if (checkUser(uid)) {
            return ErrorCodes.ERROR_DUPE_USER;
        }
        // Create and Save User
        UserInfo new_user = new UserInfo(uid);
        users.put(uid, new_user);
        // Create and Save CreateUser operation
        CreateOp op = new CreateOp(uid);
        ledger.add(op);
        System.out.println("[SERVER] Created user with uid:" + uid);
        return ErrorCodes.SUCESS;
    }

    public synchronized int deleteUser(String uid) {
        // Check state and arguments
        if (!checkState()) {
            return ErrorCodes.ERROR_SERVER_INACTIVE;
        }
        if (!checkUser(uid)) {
            return ErrorCodes.ERROR_USER_NOT_FOUND;
        }
        UserInfo user_info = users.get(uid);
        if (user_info.getBalance() != 0) {
            return ErrorCodes.ERROR_DELETE_WITH_BALANCE;
        }
        // Remove user from state
        users.remove(uid);
        // Create and save RemoveUser operation
        DeleteOp op = new DeleteOp(uid);
        ledger.add(op);
        System.out.println("[SERVER] Deleted user with uid: " + uid);
        return ErrorCodes.SUCESS;
    }

    public synchronized int transferTo(String from, String to, int amount) {
        // Check state and arguments
        if (!checkState()) {
            return ErrorCodes.ERROR_SERVER_INACTIVE;
        }
        if (amount <= 0) {
            return ErrorCodes.ERROR_INVALID_TRANSFER;
        }
        // Get user fields
        UserInfo from_info = users.get(from);
        UserInfo to_info = users.get(to);
        // Check if operation is valid
        if (!checkUser(from) || !checkUser(to)) {
            return ErrorCodes.ERROR_USER_NOT_FOUND;
        }

        if (from.equals(to)) {
            return ErrorCodes.ERROR_INVALID_TRANSFER;
        }

        if (from_info.getBalance() < amount) {
            return ErrorCodes.ERROR_NOT_ENOUGH_BALANCE;
        } else {
            from_info.removeBalance(amount);
            to_info.addBalance(amount);
            TransferOp op = new TransferOp(from, to, amount);
            ledger.add(op);
            System.out.println("[SERVER] Transfer " + amount + "$ from " + from + " to " + to);
            return ErrorCodes.SUCESS;
        }
    }
}