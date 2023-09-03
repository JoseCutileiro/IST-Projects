package pt.tecnico.distledger.server;

import java.io.IOException;

import io.grpc.BindableService;
import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import io.grpc.Server;
import io.grpc.ServerBuilder;
import io.grpc.StatusRuntimeException;
import pt.tecnico.distledger.server.domain.ServerState;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc.NamingServerServiceBlockingStub;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.DeleteRequest;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.RegisterRequest;

public class ServerMain {

    public final static String HOST = "localhost";
    public final static String PORT = "5001";
    public final static String TARGET = HOST + ":" + PORT;
    public final static String SERVICE = "DistLedger";

    public static void main(String[] args) throws IOException, InterruptedException {

        System.out.println(ServerMain.class.getSimpleName());

        // receive and print arguments
        System.out.printf("Received %d arguments%n", args.length);
        for (int i = 0; i < args.length; i++) {
            System.out.printf("arg[%d] = %s%n", i, args[i]);
        }

        // check arguments
        if (args.length < 1) {
            System.err.println("Argument(s) missing!");
            System.err.printf("Usage: java %s port%n", ServerMain.class.getName());
            return;
        }

        final int port = Integer.parseInt(args[0]);
        String qual = args[1];
        String target = HOST + ":" + port;
        String service = SERVICE;
        ServerState state = new ServerState();
        final BindableService userImpl = new UserServiceImpl(state, qual, target);
        final BindableService adminImpl = new AdminServiceImpl(state);
        final BindableService crossImpl = new CrossServerServiceImpl(state);

        Server server = null;

        // CHANNEL
        ManagedChannel channel = ManagedChannelBuilder.forTarget("localhost:5001").usePlaintext().build();
        NamingServerServiceBlockingStub stub = NamingServerServiceGrpc.newBlockingStub(channel);

        // Create a new server to listen on port with the required services
        try {
            stub.register(RegisterRequest.newBuilder().setQual(qual).setTarget(target).setService(service)
                    .build());

            System.out.println("[SERVER] registered");
        }
        catch (StatusRuntimeException e) {
            // ERROR HANDLING
            System.out.println("[NOT OK] Naming server is not available or you are using a dulplicate qual");
            channel.shutdown();
            return;
        }

        try {
            // START SERVER
            server = ServerBuilder.forPort(port).addService(userImpl).addService(adminImpl).addService(crossImpl)
                    .build();

            // Start the server
            server.start();
            System.out.println("[SERVER] started");
        } catch (IOException e) {
            System.out.println("[NOT OK] Server was not able to start");;
        }
        try {
            System.out.println("[SERVER] Press enter to shutdown");
            System.in.read();

            stub.delete(DeleteRequest.newBuilder().setTarget(target).setService(service).build());
            System.out.println("[SERVER] deleted from NamingServer");
            channel.shutdown();
            server.shutdown();
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
            System.exit(-1);
        } finally {
            if (server != null)
                server.shutdown();
        }
    }
}