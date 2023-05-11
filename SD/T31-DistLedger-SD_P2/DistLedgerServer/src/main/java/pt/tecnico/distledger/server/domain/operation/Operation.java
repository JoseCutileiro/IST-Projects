package pt.tecnico.distledger.server.domain.operation;

import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions;

public abstract class Operation {
    private String account;

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
}
