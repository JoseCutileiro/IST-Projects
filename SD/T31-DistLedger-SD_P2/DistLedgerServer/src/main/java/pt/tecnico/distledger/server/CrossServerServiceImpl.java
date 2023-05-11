package pt.tecnico.distledger.server;

import io.grpc.stub.StreamObserver;
import pt.tecnico.distledger.server.domain.ErrorCodes;
import pt.tecnico.distledger.server.domain.ServerState;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.DistLedgerCrossServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.CrossServerDistLedger.PropagateStateRequest;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.CrossServerDistLedger.PropagateStateResponse;

import static io.grpc.Status.INVALID_ARGUMENT;

public class CrossServerServiceImpl extends DistLedgerCrossServerServiceGrpc.DistLedgerCrossServerServiceImplBase {
	private ServerState state;

	public CrossServerServiceImpl(ServerState state) {
		this.state = state;
	}

	@Override
	public void propagateState(PropagateStateRequest request, StreamObserver<PropagateStateResponse> responseObserver) {
		System.out.println("[CROSS SERVER->SERVER] Received a propagate state request");
		if (state.updateLedgerState(request.getState()) == ErrorCodes.ERROR_SERVER_INACTIVE) {
			responseObserver.onError(
					INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
							.asRuntimeException());
			return;
		}
		responseObserver.onNext(null);
		responseObserver.onCompleted();
	}
}
