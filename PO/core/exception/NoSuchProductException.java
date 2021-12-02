package ggc.core.exception;

public class NoSuchProductException extends Exception {
    private String _id;

    public NoSuchProductException(String id) {
        super("No such product: " + id);
        _id = id;
    }

    public String getIdentifier() {
        return _id;
    }
}
