package pt.tecnico.distledger.adminclient;

import pt.tecnico.distledger.adminclient.grpc.AdminService;

public class AdminClientMain {
    public static void main(String[] args) {

        System.out.println(AdminClientMain.class.getSimpleName());

        // receive and print arguments
        System.out.printf("Received %d arguments%n", args.length);
        for (int i = 0; i < args.length; i++) {
            System.out.printf("arg[%d] = %s%n", i, args[i]);
        }

        // check arguments
        if (args.length != 2) {
            System.err.println("Argument(s) missing!");
            System.err.println("Usage: mvn exec:java -Dexec.args=<host> <port>");
            return;
        }
        // Build server fields
        final String host = args[0];
        final int port = Integer.parseInt(args[1]);
        final String target = host + ":" + port;
        // Build channel and stub
        AdminService adminSer = new AdminService();
        adminSer.buildChannel(target);
        adminSer.buildStub();
        // Run CommandParser
        CommandParser parser = new CommandParser(adminSer);
        parser.parseInput();

    }
}
