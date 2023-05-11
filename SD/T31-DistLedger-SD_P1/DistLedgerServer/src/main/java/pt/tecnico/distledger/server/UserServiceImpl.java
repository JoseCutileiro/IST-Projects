package pt.tecnico.distledger.server;

import io.grpc.stub.StreamObserver;
import pt.tecnico.distledger.server.domain.ErrorCodes;
import pt.tecnico.distledger.server.domain.ServerState;
import pt.ulisboa.tecnico.distledger.contract.user.*;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.*;

import static io.grpc.Status.INVALID_ARGUMENT;

public class UserServiceImpl extends UserServiceGrpc.UserServiceImplBase {
    private ServerState state;

    public UserServiceImpl(ServerState state) {
        this.state = state;
    }

    @Override
    public void balance(BalanceRequest request, StreamObserver<BalanceResponse> responseObserver) {
        String uid = request.getUserId();
        int balance = state.getBalance(uid);
        // ERROR VERIFICATION
        if (balance == ErrorCodes.ERROR_SERVER_INACTIVE) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
                            .asRuntimeException());
            return;
        }
        if (balance == ErrorCodes.ERROR_USER_NOT_FOUND) {
            responseObserver.onError(INVALID_ARGUMENT
                    .withDescription("[NOT OK] This user does not exist, try with other UID").asRuntimeException());
            return;
        }
        // BUILD RESPONSE
        BalanceResponse.Builder builder = BalanceResponse.newBuilder();
        builder.setValue(balance);
        BalanceResponse response = builder.build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void createAccount(CreateAccountRequest request, StreamObserver<CreateAccountResponse> responseObserver) {
        String uid = request.getUserId();
        int code = state.createUser(uid);
        // ERROR VERIFICATION
        if (code == ErrorCodes.ERROR_SERVER_INACTIVE) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
                            .asRuntimeException());
            return;
        }
        if (code == ErrorCodes.ERROR_DUPE_USER) {
            responseObserver.onError(INVALID_ARGUMENT
                    .withDescription("[NOT OK] User id already taken, select another user id to continue")
                    .asRuntimeException());
            return;
        }
        // BUILD RESPONSE
        CreateAccountResponse response = CreateAccountResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void deleteAccount(DeleteAccountRequest request, StreamObserver<DeleteAccountResponse> responseObserver) {
        String uid = request.getUserId();
        int code = state.deleteUser(uid);
        // ERROR VERIFICATION
        if (code == ErrorCodes.ERROR_SERVER_INACTIVE) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
                            .asRuntimeException());
            return;
        }
        if (code == ErrorCodes.ERROR_USER_NOT_FOUND) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] That user does not exist").asRuntimeException());
            return;
        }
        if (code == ErrorCodes.ERROR_DELETE_WITH_BALANCE) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Cant delete account with balance").asRuntimeException());
            return;
        }
        // BUILD RESPONSE
        DeleteAccountResponse response = DeleteAccountResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void transferTo(TransferToRequest request, StreamObserver<TransferToResponse> responseObserver) {
        String uid_from = request.getAccountFrom();
        String uid_to = request.getAccountTo();
        int amount = request.getAmount();
        int code = state.transferTo(uid_from, uid_to, amount);
        // ERROR VERIFICATION
        if (code == ErrorCodes.ERROR_SERVER_INACTIVE) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
                            .asRuntimeException());
            return;
        }
        if (code == ErrorCodes.ERROR_USER_NOT_FOUND) {
            responseObserver
                    .onError(INVALID_ARGUMENT.withDescription("[NOT OK] Both users MUST exist").asRuntimeException());
            return;
        }
        if (code == ErrorCodes.ERROR_INVALID_TRANSFER) {
            responseObserver.onError(INVALID_ARGUMENT
                    .withDescription("[NOT OK] Transfering money to yourself is not valid").asRuntimeException());
            return;
        }
        if (code == ErrorCodes.ERROR_NOT_ENOUGH_BALANCE) {
            responseObserver.onError(INVALID_ARGUMENT
                    .withDescription("[NOT OK] You need more money to complete this operation").asRuntimeException());
            return;
        }
        if (code == ErrorCodes.ERROR_INVALID_TRANSFER) {
            responseObserver.onError(INVALID_ARGUMENT.withDescription("[NOT OK] <amount> MUST be a postitive value")
                    .asRuntimeException());
            return;
        }

        // BUILD RESPONSE
        TransferToResponse response = TransferToResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

}
