package pt.tecnico.distledger.server.domain;

public class ErrorCodes {

    // SUCESS:
    public static final int SUCESS = 200;

    // DELETE ERRORS:
    public static final int ERROR_DELETE_WITH_BALANCE = -1;
    public static final int ERROR_NOT_ENOUGH_BALANCE = -2;
    public static final int ERROR_INVALID_TRANSFER = -3;
    public static final int ERROR_USER_NOT_FOUND = -4;
    public static final int ERROR_DUPE_USER = -5;
    public static final int ERROR_SERVER_INACTIVE = -6;
    public static final int ERROR_INVALID_VALUE = -7;
    public static final int ERROR_PROPAGATE_FAILED = -8;
}
