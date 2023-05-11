package pt.tecnico.distledger.server;

import io.grpc.stub.StreamObserver;
import pt.tecnico.distledger.server.domain.ErrorCodes;
import pt.tecnico.distledger.server.domain.ServerState;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.DistLedgerCrossServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.CrossServerDistLedger.PropagateStateRequest;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.CrossServerDistLedger.PropagateStateResponse;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.CrossServerDistLedger.ServerInitRequest;
import pt.ulisboa.tecnico.distledger.contract.distledgerserver.CrossServerDistLedger.ServerInitResponse;

import static io.grpc.Status.INVALID_ARGUMENT;

import java.util.ArrayList;

public class CrossServerServiceImpl extends DistLedgerCrossServerServiceGrpc.DistLedgerCrossServerServiceImplBase {
	private ServerState state;

	public CrossServerServiceImpl(ServerState state) {
		this.state = state;
	}

	@Override
	public void propagateState(PropagateStateRequest request, StreamObserver<PropagateStateResponse> responseObserver) {
		System.out.println("[CROSS SERVER->SERVER] Received a propagate state request");
		ArrayList<Integer> replicaTS = new ArrayList<>();
		replicaTS.addAll(request.getReplicaTSList());
		if (state.updateLedgerState(request.getState(), replicaTS) == ErrorCodes.ERROR_SERVER_INACTIVE) {
			responseObserver.onError(
					INVALID_ARGUMENT.withDescription("[NOT OK] Server is inactive, contact admin to more information")
							.asRuntimeException());
			return;
		}
		responseObserver.onNext(null);
		responseObserver.onCompleted();
	}

	@Override
	public void serverInit(ServerInitRequest request, StreamObserver<ServerInitResponse> responseObserver) {
		state.addServerTS();
		responseObserver.onNext(ServerInitResponse.newBuilder().build());
		responseObserver.onCompleted();
	}
}
