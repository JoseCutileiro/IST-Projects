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

import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

public class UserServiceImpl extends UserServiceGrpc.UserServiceImplBase {
    private ServerState state;
    private String target;

    public UserServiceImpl(ServerState state, String target) {
        this.state = state;
        this.target = target;
    }

    @Override
    public void balance(BalanceRequest request, StreamObserver<BalanceResponse> responseObserver) {
        ArrayList<Integer> prevTS = new ArrayList<>();
        prevTS.addAll(request.getPrevTSList());

        // ERROR VERIFICATION
        if (!state.checkState()) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
                            .asRuntimeException());
            return;
        }

        // Timestamp correct
        if (!state.validRead(prevTS)) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Server timestamp is not up to date")
                            .asRuntimeException());
            return;
        }

        String uid = request.getUserId();
        int balance = state.getBalance(uid);

        if (balance == ErrorCodes.ERROR_USER_NOT_FOUND) {
            responseObserver.onError(INVALID_ARGUMENT
                    .withDescription("[NOT OK] This user does not exist, try with other UID").asRuntimeException());
            return;
        }
        // BUILD RESPONSE
        BalanceResponse.Builder builder = BalanceResponse.newBuilder();
        builder.setValue(balance);
        builder.addAllValueTS(state.getTS());
        BalanceResponse response = builder.build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void createAccount(CreateAccountRequest request, StreamObserver<CreateAccountResponse> responseObserver) {

        // ERROR VERIFICATION
        if (!state.checkState()) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
                            .asRuntimeException());
            return;
        }

        ArrayList<Integer> prevTS = new ArrayList<>();
        prevTS.addAll(request.getPrevTSList());

        ArrayList<Integer> replicaTS = state.replicateTS(prevTS);

        // BUILD RESPONSE
        CreateAccountResponse response = CreateAccountResponse.newBuilder().addAllValueTS(replicaTS).build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();

        Boolean stable = state.validRead(prevTS);
        String uid = request.getUserId();
        state.createUser(uid, stable, state.getReplicaTS(), prevTS);

    }

    @Override
    public void transferTo(TransferToRequest request, StreamObserver<TransferToResponse> responseObserver) {
        // ERROR VERIFICATION
        if (!state.checkState()) {
            responseObserver.onError(
                    INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
                            .asRuntimeException());
            return;
        }

        ArrayList<Integer> prevTS = new ArrayList<>();
        prevTS.addAll(request.getPrevTSList());
        ArrayList<Integer> replicaTS = state.replicateTS(prevTS);

        // BUILD RESPONSE
        TransferToResponse response = TransferToResponse.newBuilder().addAllValueTS(replicaTS).build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();

        String uid_from = request.getAccountFrom();
        String uid_to = request.getAccountTo();
        int amount = request.getAmount();
        Boolean stable = state.validRead(prevTS);
        int code = state.transferTo(uid_from, uid_to, amount, stable, state.getReplicaTS(), prevTS);
        // ERROR VERIFICATION
        if (code == ErrorCodes.ERROR_SERVER_INACTIVE) {
            System.out.println("[NOT OK] Server is inactive, contact admin to more information");
            return;
        }
        if (code == ErrorCodes.ERROR_USER_NOT_FOUND) {
            System.out.println("[NOT OK] Both users MUST exist");
            return;
        }
        if (code == ErrorCodes.ERROR_INVALID_TRANSFER) {
            System.out.println("[NOT OK] Transfering money to yourself is not valid");
            return;
        }
        if (code == ErrorCodes.ERROR_NOT_ENOUGH_BALANCE) {
            System.out.println("[NOT OK] You need more money to complete this operation");
            return;
        }
        if (code == ErrorCodes.ERROR_INVALID_TRANSFER) {
            System.out.println("[NOT OK] <amount> MUST be a positive value");
            return;
        }
    }

}