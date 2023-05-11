package pt.tecnico.distledger.namingserver;

import java.util.List;

import io.grpc.stub.StreamObserver;
import pt.tecnico.distledger.namingserver.domain.NamingServerState;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.DeleteRequest;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.DeleteResponse;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupRequest;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupResponse;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.RegisterRequest;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.RegisterResponse;

import static io.grpc.Status.INVALID_ARGUMENT;

public class NamingServerImpl extends NamingServerServiceGrpc.NamingServerServiceImplBase {

    private NamingServerState state;

    public NamingServerImpl(NamingServerState state) {
        this.state = state;
    }

    @Override
    public void register(RegisterRequest request, StreamObserver<RegisterResponse> responseObserver) {
        try {
            state.register(request.getService(), request.getTarget(), request.getQual());   
        }
        catch (Exception e) {
            responseObserver.onError(
                INVALID_ARGUMENT.withDescription(e.getMessage())
                        .asRuntimeException());
            return;
        }
        
        // BUILD RESPONSE
        System.out.println("[NAMING SERVER]: Server was registered with " + request.getQual() + " qual and "
                + request.getTarget());
        RegisterResponse response = RegisterResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void lookup(LookupRequest request, StreamObserver<LookupResponse> responseObserver) {
        List<String> targets = state.lookup(request.getService(), request.getQual());
        // BUILD RESPONSE
        LookupResponse response = LookupResponse.newBuilder().addAllTarget(targets).build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

    @Override
    public void delete(DeleteRequest request, StreamObserver<DeleteResponse> responseObserver) {
        int ret = state.delete(request.getService(), request.getTarget());
        if (ret == -1) {
            responseObserver.onError(INVALID_ARGUMENT
                    .withDescription("[NOT OK] Trying to remove a server that does not exist").asRuntimeException());
            return;
        }
        // BUILD RESPONSE
        System.out.println("[NAMING SERVER]: Server was deleted with " + request.getTarget() + " target");
        DeleteResponse response = DeleteResponse.newBuilder().build();
        responseObserver.onNext(response);
        responseObserver.onCompleted();
    }

}
