package pt.tecnico.distledger.userclient.grpc;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.StatusRuntimeException;
import pt.ulisboa.tecnico.distledger.contract.user.UserServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.BalanceRequest;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.CreateAccountRequest;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.DeleteAccountRequest;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.TransferToRequest;

public class UserService {
    private ManagedChannel channel;
    private UserServiceGrpc.UserServiceBlockingStub stub;

    public UserService() {
    }

    // Channel is the abstraction to connect to a service endpoint.
    public void buildChannel(String target) {
        channel = ManagedChannelBuilder.forTarget(target).usePlaintext().build();
    }

    public void buildStub() {
        stub = UserServiceGrpc.newBlockingStub(channel);
    }

    public void balance(String userId) {
        try {
            // BUILD REQUEST
            BalanceRequest request = BalanceRequest.newBuilder().setUserId(userId).build();
            int response = stub.balance(request).getValue();
            System.out.println("[OK] account with uid " + userId + " has " + response + "$ in his balance");
        } catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println(e.getStatus().getDescription());
        }
    }

    public void createAccount(String userId) {
        try {
            // BUILD REQUEST
            CreateAccountRequest request = CreateAccountRequest.newBuilder().setUserId(userId).build();
            stub.createAccount(request);
            System.out.println("[OK] account with uid " + userId + " was created with sucess");
        } catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println(e.getStatus().getDescription());
        }

    }

    public void deleteAccount(String userId) {
        try {
            // BUILD REQUEST
            DeleteAccountRequest request = DeleteAccountRequest.newBuilder().setUserId(userId).build();
            stub.deleteAccount(request);
            System.out.println("[OK] account with uid " + userId + " was deleted with sucess");
        } catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println(e.getStatus().getDescription());
        }
    }

    public void transferTo(String accountFrom, String accountTo, int amount) {
        try {
            // BUILD REQUEST
            TransferToRequest.Builder requestBuilder = TransferToRequest.newBuilder();
            requestBuilder.setAccountFrom(accountFrom);
            requestBuilder.setAccountTo(accountTo);
            requestBuilder.setAmount(amount);
            stub.transferTo(requestBuilder.build());
            System.out.println("[OK] Transferred " + amount + "$ from " + accountFrom + " to " + accountTo);
        } catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println(e.getStatus().getDescription());
        }

    }

}