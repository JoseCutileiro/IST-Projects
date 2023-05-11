package pt.tecnico.distledger.server.domain.operation;

import java.util.ArrayList;

import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions;

public abstract class Operation {
    private String account;
    private ArrayList<Integer> prevTS;
    private ArrayList<Integer> replicaTS;
    private boolean stable;

    public Operation(String fromAccount) {
        this.account = fromAccount;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    // Converts Operation to the Operation defined in the contract proto
    public abstract DistLedgerCommonDefinitions.Operation toGRPC();

    public boolean isStable() {
        return stable;
    }

    public ArrayList<Integer> getReplicaTS() {
        return replicaTS;
    }

    public ArrayList<Integer> getPrevTS() {
        return prevTS;
    }

    public void setStable(Boolean stable) {
        this.stable = stable;
    }

    public void setReplicaTS(ArrayList<Integer> replica) {
        replicaTS = replica;
    }

    public void setPrevTS(ArrayList<Integer> prev) {
        prevTS = prev;
    }
}
