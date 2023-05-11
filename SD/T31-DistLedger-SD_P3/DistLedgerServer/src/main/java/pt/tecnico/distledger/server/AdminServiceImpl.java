package pt.tecnico.distledger.server;

import java.util.ArrayList;
import java.util.List;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.stub.StreamObserver;
import pt.tecnico.distledger.server.domain.ServerState;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.LedgerState;
import pt.tecnico.distledger.server.domain.operation.Operation;
import pt.ulisboa.tecnico.distledger.contract.admin.*;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.*;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.DistLedgerCrossServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.CrossServerDistLedger.PropagateStateRequest;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.DistLedgerCrossServerServiceGrpc.DistLedgerCrossServerServiceBlockingStub;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupRequest;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupResponse;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc.NamingServerServiceBlockingStub;

public class AdminServiceImpl extends AdminServiceGrpc.AdminServiceImplBase {

    private ServerState state;
    private String target;

    public AdminServiceImpl(ServerState state, String target) {
        this.state = state;
        this.target = target;
    }

    @Override
    public void activate(ActivateRequest request, StreamObserver<ActivateResponse> responseObserver) {
        state.activate();
        // BUILD RESPONSE
        ActivateResponse response = ActivateResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void deactivate(DeactivateRequest request, StreamObserver<DeactivateResponse> responseObserver) {
        state.deactivate();
        // BUILD RESPONSE
        DeactivateResponse response = DeactivateResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void getLedgerState(getLedgerStateRequest request, StreamObserver<getLedgerStateResponse> responseObserver) {
        List<Operation> ledger = state.getLedgerState();
        LedgerState.Builder lsBuilder = LedgerState.newBuilder();
        // Iterate through every Operation and add their
        // converted gRPC defined form to the ledger state
        ledger.forEach(op -> {
            DistLedgerCommonDefinitions.Operation operation = op.toGRPC();
            lsBuilder.addLedger(operation);
        });
        // BUILD RESPONSE
        LedgerState lstate = lsBuilder.build();
        getLedgerStateResponse response = getLedgerStateResponse.newBuilder().setLedgerState(lstate).build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void getTimeStamps(getTimeStampsRequest request, StreamObserver<getTimeStampsResponse> responseObserver) {
        getTimeStampsResponse response = getTimeStampsResponse.newBuilder().addAllValueTS(state.getTS())
                .addAllReplicaTS(state.getReplicaTS()).build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void gossip(GossipRequest request, StreamObserver<GossipResponse> responseObserver) {
        ManagedChannel channel = ManagedChannelBuilder.forTarget("localhost:5001").usePlaintext().build();
        NamingServerServiceBlockingStub stub = NamingServerServiceGrpc.newBlockingStub(channel);
        LookupResponse lookupResponse = stub.lookup(LookupRequest.newBuilder().setService("DistLedger").build());
        channel.shutdown();
        for (int i = 0; i < lookupResponse.getTargetCount(); i++) {
            String t = lookupResponse.getTarget(i);
            if (t.equals(target)) {
                continue;
            }
            ManagedChannel crossChannel = ManagedChannelBuilder.forTarget(t).usePlaintext().build();
            DistLedgerCrossServerServiceBlockingStub crossStub = DistLedgerCrossServerServiceGrpc
                    .newBlockingStub(crossChannel);
            LedgerState.Builder lsBuilder = LedgerState.newBuilder();
            state.getLedgerState().forEach(op -> {
                DistLedgerCommonDefinitions.Operation operation = op.toGRPC();
                lsBuilder.addLedger(operation);
            });
            try {
                crossStub.propagateState(PropagateStateRequest.newBuilder().setState(lsBuilder.build())
                        .addAllReplicaTS(state.getReplicaTS()).build());
            } catch (Exception e) {
                System.out.println("[NOT OK] Cross server with target: " + t + ", is unreachable");
            }
            crossChannel.shutdown();
        }
        responseObserver.onNext(GossipResponse.newBuilder().build());
        responseObserver.onCompleted();
    }

}
