package ggc.core.exception;

public class NoSuchPartnerException extends Exception {
    private String _id;

    public NoSuchPartnerException(String id) {
        super("No such partner: " + id);
        _id = id;
    }

    public String getIdentifier() {
        return _id;
    }
}
