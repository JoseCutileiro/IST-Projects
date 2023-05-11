package pt.tecnico.distledger.userclient.grpc;

import java.util.ArrayList;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.StatusRuntimeException;
import pt.ulisboa.tecnico.distledger.contract.user.UserServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.BalanceRequest;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.BalanceResponse;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.CreateAccountRequest;
import pt.ulisboa.tecnico.distledger.contract.user.UserDistLedger.TransferToRequest;

public class UserService {
    private ManagedChannel channel;
    private UserServiceGrpc.UserServiceBlockingStub stub;

    public final static String HOST = "localhost";
    public final static String PORT = "5001";
    public final static String TARGET = HOST + ":" + PORT;
    public final static String SERVICE = "DistLedger";

    public UserService() {
    }

    // Channel is the abstraction to connect to a service endpoint.
    public void buildChannel(String target) {
        channel = ManagedChannelBuilder.forTarget(target).usePlaintext().build();
    }

    public void closeChannel() {
        channel.shutdown();
    }

    public void buildStub() {
        stub = UserServiceGrpc.newBlockingStub(channel);
    }

    public ArrayList<Integer> balance(String userId, ArrayList<Integer> prev) {
        try {
            // BUILD REQUEST
            BalanceRequest request = BalanceRequest.newBuilder().setUserId(userId).addAllPrevTS(prev).build();
            BalanceResponse response = stub.balance(request);
            int value = response.getValue();
            ArrayList<Integer> serverTS = new ArrayList<>();
            serverTS.addAll(response.getValueTSList());
            System.out.println("[OK] account with uid " + userId + " has " + value + "$ in his balance"
                    + " with TS = " + serverTS);
            return serverTS;
        } catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println(e.getStatus().getDescription());
            return null;
        }
    }

    public ArrayList<Integer> createAccount(String userId, ArrayList<Integer> prev) {
        try {
            // BUILD REQUEST
            CreateAccountRequest request = CreateAccountRequest.newBuilder().setUserId(userId).addAllPrevTS(prev)
                    .build();
            ArrayList<Integer> serverTS = new ArrayList<>();
            serverTS.addAll(stub.createAccount(request).getValueTSList());
            System.out.println("[OK] account with uid " + userId + " was created with sucess TS:" + serverTS);
            return serverTS;
        } catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println(e.getStatus().getDescription());
            return null;
        }

    }

    public ArrayList<Integer> transferTo(String accountFrom, String accountTo, int amount, ArrayList<Integer> prev) {
        try {
            // BUILD REQUEST
            TransferToRequest.Builder requestBuilder = TransferToRequest.newBuilder();
            requestBuilder.setAccountFrom(accountFrom);
            requestBuilder.setAccountTo(accountTo);
            requestBuilder.setAmount(amount);
            requestBuilder.addAllPrevTS(prev);
            ArrayList<Integer> serverTS = new ArrayList<>();
            serverTS.addAll(stub.transferTo(requestBuilder.build()).getValueTSList());
            System.out.println("[OK] Transferred " + amount + "$ from " + accountFrom + " to " + accountTo
                    + " was created with sucess TS:" + serverTS);
            return serverTS;
        } catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println(e.getStatus().getDescription());
            return null;
        }

    }

}