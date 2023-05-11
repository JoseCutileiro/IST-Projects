package pt.tecnico.distledger.server.domain;

public class UserInfo {

    private String uid;
    private int balance;

    public UserInfo(String uid) {
        this.uid = uid;

        // Balance starts at 0
        this.balance = 0;
    }

    public String getUid() {
        return uid;
    }

    public int getBalance() {
        return balance;
    }

    public void addBalance(int added_amount) {
        this.balance += added_amount;
    }

    public void removeBalance(int removed_amount) {
        this.balance -= removed_amount;
    }
}
