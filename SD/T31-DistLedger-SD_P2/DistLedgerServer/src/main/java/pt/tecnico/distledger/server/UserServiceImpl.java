package pt.tecnico.distledger.server;

import io.grpc.stub.StreamObserver;
import pt.tecnico.distledger.server.domain.ErrorCodes;
import pt.tecnico.distledger.server.domain.ServerState;
import pt.tecnico.distledger.server.domain.UserInfo;
import pt.tecnico.distledger.server.domain.operation.Operation;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.LedgerState;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.DistLedgerCrossServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.CrossServerDistLedger.PropagateStateRequest;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.DistLedgerCrossServerServiceGrpc.DistLedgerCrossServerServiceBlockingStub;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupRequest;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupResponse;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc.NamingServerServiceBlockingStub;
import pt.ulisboa.tecnico.distledger.contract.user.*;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.*;

import static io.grpc.Status.INVALID_ARGUMENT;

import java.util.Hashtable;
import java.util.List;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

public class UserServiceImpl extends UserServiceGrpc.UserServiceImplBase {
    private ServerState state;
    private String qual;
    private String target;

    private String PRIMARY = "A";

    public UserServiceImpl(ServerState state, String qual, String target) {
        this.state = state;
        this.qual = qual;
        this.target = target;
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
        List<Operation> operations = state.getLedgerState();
        Hashtable<String, UserInfo> users = state.getUsers();
        if (!qual.equals(PRIMARY)) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Secondary Server can't perform write operations")
                            .asRuntimeException());
            return;
        }
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
        // PROPAGATE STAE WITH ERROR CHECKING
        if (propagateState(operations, users) == ErrorCodes.ERROR_PROPAGATE_FAILED) {
            responseObserver.onError(INVALID_ARGUMENT.withDescription("[NOT OK] Secundary Server is unreachable")
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
        List<Operation> operations = state.getLedgerState();
        Hashtable<String, UserInfo> users = state.getUsers();
        if (!qual.equals(PRIMARY)) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Secondary Server can't perform write operations")
                            .asRuntimeException());
            return;
        }
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
        // PROPAGATE STAE WITH ERROR CHECKING
        if (propagateState(operations, users) == ErrorCodes.ERROR_PROPAGATE_FAILED) {
            responseObserver.onError(INVALID_ARGUMENT.withDescription("[NOT OK] Secundary Server is unreachable")
                    .asRuntimeException());
            return;
        }
        // BUILD RESPONSE
        DeleteAccountResponse response = DeleteAccountResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void transferTo(TransferToRequest request, StreamObserver<TransferToResponse> responseObserver) {
        List<Operation> operations = state.getLedgerState();
        Hashtable<String, UserInfo> users = state.getUsers();
        if (!qual.equals(PRIMARY)) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Secondary Server can't perform write operations")
                            .asRuntimeException());
            return;
        }
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
        // PROPAGATE STAE WITH ERROR CHECKING
        if (propagateState(operations, users) == ErrorCodes.ERROR_PROPAGATE_FAILED) {
            responseObserver.onError(INVALID_ARGUMENT.withDescription("[NOT OK] Secundary Server is unreachable")
                    .asRuntimeException());
            return;
        }
        // BUILD RESPONSE
        TransferToResponse response = TransferToResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    private int propagateState(List<Operation> operations, Hashtable<String, UserInfo> users) {
        int ret = ErrorCodes.SUCESS;
        System.out.println("[SERVER->CROSS SERVER] Build propagate request");

        ManagedChannel channel = ManagedChannelBuilder.forTarget("localhost:5001").usePlaintext().build();
        NamingServerServiceBlockingStub NStub = NamingServerServiceGrpc.newBlockingStub(channel);
        LookupResponse response = NStub
                .lookup(LookupRequest.newBuilder().setService("DistLedger").build());
        channel.shutdown();
        List<String> targetList = response.getTargetList();
        for (int i = 0; i < targetList.size(); i++) {
            String t = targetList.get(i);
            if (!t.equals(target)) {
                ManagedChannel tempChannel = ManagedChannelBuilder.forTarget(t).usePlaintext().build();
                DistLedgerCrossServerServiceBlockingStub stub = DistLedgerCrossServerServiceGrpc
                        .newBlockingStub(tempChannel);

                LedgerState.Builder lsBuilder = LedgerState.newBuilder();
                state.getLedgerState().forEach(op -> {
                    DistLedgerCommonDefinitions.Operation operation = op.toGRPC();
                    lsBuilder.addLedger(operation);
                });
                try {
                    stub.propagateState(PropagateStateRequest.newBuilder().setState(lsBuilder.build()).build());
                } catch (Exception e) {
                    System.out.println("[NOT OK] Secundary server is unreachable");
                    state.setLedgerState(operations);
                    state.setUsers(users);
                    ret = ErrorCodes.ERROR_PROPAGATE_FAILED;
                }
                tempChannel.shutdown();
            }
        }
        return ret;
    }
}