package ggc.core.exception;

public class DuplicatePartnerException extends Exception {
    private String _id;

    public DuplicatePartnerException(String id) {
        super("Duplicate partner: " + id);
        _id = id;
    }

    public String getIdentifier() {
        return _id;
    }
}
