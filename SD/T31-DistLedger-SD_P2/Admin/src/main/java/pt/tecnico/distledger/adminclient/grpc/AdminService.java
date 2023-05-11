package pt.tecnico.distledger.adminclient.grpc;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.LedgerState;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.getLedgerStateResponse;

public class AdminService {
    private ManagedChannel channel;
    private AdminServiceGrpc.AdminServiceBlockingStub stub;

    public final static String HOST = "localhost";
    public final static String PORT = "5001";
    public final static String TARGET = HOST + ":" + PORT;
    public final static String SERVICE = "DistLedger";

    public AdminService() {
    }

    // Channel is the abstraction to connect to a service endpoint.
    public void buildChannel(String target) {
        channel = ManagedChannelBuilder.forTarget(target).usePlaintext().build();
    }

    public void closeChannel() {
        channel.shutdown();
    }

    public void buildStub() {
        stub = AdminServiceGrpc.newBlockingStub(channel);
    }

    public void activate() {
        stub.activate(null);
    }

    public void deactivate() {
        stub.deactivate(null);
    }

    public LedgerState getLedgerState() {
        getLedgerStateResponse response = stub.getLedgerState(null);
        return response.getLedgerState();
    }

    public void gossip() {
        stub.gossip(null);
    }

}
