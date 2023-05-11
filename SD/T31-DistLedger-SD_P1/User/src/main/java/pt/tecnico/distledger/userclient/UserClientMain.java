package pt.tecnico.distledger.userclient;

import pt.tecnico.distledger.userclient.grpc.UserService;

public class UserClientMain {
    public static void main(String[] args) {

        System.out.println(UserClientMain.class.getSimpleName());

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
        UserService userSer = new UserService();
        userSer.buildChannel(target);
        userSer.buildStub();

        // Run CommandParser
        CommandParser parser = new CommandParser(userSer);
        parser.parseInput();

    }
}
