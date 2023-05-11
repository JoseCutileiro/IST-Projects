package pt.tecnico.distledger.server;

import java.io.IOException;

import io.grpc.BindableService;
import io.grpc.Server;
import io.grpc.ServerBuilder;
import pt.tecnico.distledger.server.domain.ServerState;

public class ServerMain {

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
        ServerState state = new ServerState();
        final BindableService userImpl = new UserServiceImpl(state);
        final BindableService adminImpl = new AdminServiceImpl(state);

        // Create a new server to listen on port with the required services
        Server server = ServerBuilder.forPort(port).addService(userImpl).addService(adminImpl).build();

        // Start the server
        server.start();

        // Server threads are running in the background.
        System.out.println("Server started");

        // Do not exit the main thread. Wait until server is terminated.
        server.awaitTermination();

    }

}