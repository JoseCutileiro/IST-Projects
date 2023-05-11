package pt.tecnico.distledger.server;

import java.util.List;
import io.grpc.stub.StreamObserver;
import pt.tecnico.distledger.server.domain.ServerState;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.LedgerState;
import pt.tecnico.distledger.server.domain.operation.Operation;
import pt.ulisboa.tecnico.distledger.contract.admin.*;
import pt.ulisboa.tecnico.distledger.contract.admin.AdminDistLedger.*;

public class AdminServiceImpl extends AdminServiceGrpc.AdminServiceImplBase {

    private ServerState state;

    public AdminServiceImpl(ServerState state) {
        this.state = state;
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

}
