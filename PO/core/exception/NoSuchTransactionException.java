package ggc.core.exception;

public class NoSuchTransactionException extends Exception {
    private int _id;

    public NoSuchTransactionException(int id) {
        super("No such transaction: " + id);
        _id = id;
    }

    public int getIdentifier() {
        return _id;
    }
}
