package pt.tecnico.distledger.adminclient.grpc;

import java.util.ArrayList;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.StatusRuntimeException;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.LedgerState;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.GossipRequest;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.GossipResponse;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.getLedgerStateRequest;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.getLedgerStateResponse;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.getTimeStampsRequest;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.getTimeStampsResponse;

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
        try {
            getLedgerStateResponse response = stub
                    .getLedgerState(getLedgerStateRequest.newBuilder().build());
            return response.getLedgerState();
        } catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println(e.getStatus().getDescription());
            return null;
        }
    }

    public void getTimeStamps() {
        getTimeStampsResponse response = stub.getTimeStamps(getTimeStampsRequest.newBuilder().build());
        System.out.println("ValueTS: " + response.getValueTSList() + "| ReplicaTS: " + response.getReplicaTSList());
    }

    public void gossip() {
        stub.gossip(GossipRequest.newBuilder().build());
        System.out.println("[Admin] Gossip Called");
    }

}
