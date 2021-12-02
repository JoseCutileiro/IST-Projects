package ggc.core.exception;

public class NegativeDaysException extends Exception {
    private int _days;

    public NegativeDaysException(int days) {
        super("Negative number of days: " + days);
        _days = days;
    }

    public int getDays() {
        return _days;
    }
}
