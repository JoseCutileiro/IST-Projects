package pt.tecnico.distledger.userclient;

import pt.tecnico.distledger.userclient.grpc.UserService;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupRequest;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupResponse;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc.NamingServerServiceBlockingStub;

import java.util.ArrayList;
import java.util.Scanner;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

public class CommandParser {

    private static final String SPACE = " ";
    private static final String CREATE_ACCOUNT = "createAccount";
    private static final String TRANSFER_TO = "transferTo";
    private static final String BALANCE = "balance";
    private static final String HELP = "help";
    private static final String EXIT = "exit";

    private final UserService userService;
    private ArrayList<Integer> prev;

    private ManagedChannel NamingServerChannel;
    private NamingServerServiceBlockingStub stub;

    private void openChannel() {
        NamingServerChannel = ManagedChannelBuilder.forTarget(UserService.TARGET).usePlaintext().build();
        stub = NamingServerServiceGrpc.newBlockingStub(NamingServerChannel);
    }

    private void closeChannel() {
        NamingServerChannel.shutdown();
    }

    public CommandParser(UserService userService) {
        this.userService = userService;
        prev = new ArrayList<>();
        openChannel();
    }

    void parseInput() {

        Scanner scanner = new Scanner(System.in);
        boolean exit = false;

        while (!exit) {
            System.out.print("> ");
            String line = scanner.nextLine().trim();
            String cmd = line.split(SPACE)[0];

            try {
                switch (cmd) {
                    case CREATE_ACCOUNT:
                        this.createAccount(line);
                        break;

                    case TRANSFER_TO:
                        this.transferTo(line);
                        break;

                    case BALANCE:
                        this.balance(line);
                        break;

                    case HELP:
                        this.printUsage();
                        break;

                    case EXIT:
                        this.closeChannel();
                        exit = true;
                        break;

                    default:
                        break;
                }
            } catch (Exception e) {
                System.err.println(e.getMessage());
            }
        }
    }

    private void createAccount(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 3) {
            this.printUsage();
            return;
        }
        String server = split[1];
        String username = split[2];

        LookupResponse response = stub
                .lookup(LookupRequest.newBuilder().setQual(server).setService(UserService.SERVICE).build());

        userService.buildChannel(response.getTarget(0));
        userService.buildStub();

        ArrayList<Integer> serverTS = userService.createAccount(username, prev);
        System.out.println("[User] Received TS: " + serverTS);
        if (serverTS != null) {
            prev = serverTS;
        }

        userService.closeChannel();
    }

    private void balance(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 3) {
            this.printUsage();
            return;
        }
        String server = split[1];
        String username = split[2];

        LookupResponse response = stub
                .lookup(LookupRequest.newBuilder().setQual(server).setService(UserService.SERVICE).build());

        userService.buildChannel(response.getTarget(0));
        userService.buildStub();
        ArrayList<Integer> serverTS = userService.balance(username, prev);
        if (serverTS != null) {
            prev = serverTS;
        }
        userService.closeChannel();

    }

    private void transferTo(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 5) {
            this.printUsage();
            return;
        }
        String server = split[1];
        String from = split[2];
        String dest = split[3];
        Integer amount = Integer.valueOf(split[4]);

        LookupResponse response = stub
                .lookup(LookupRequest.newBuilder().setQual(server).setService(UserService.SERVICE).build());

        userService.buildChannel(response.getTarget(0));
        userService.buildStub();
        ArrayList<Integer> serverTS = userService.transferTo(from, dest, amount, prev);
        System.out.println("[User] Received TS: " + serverTS);
        if (serverTS != null) {
            prev = serverTS;
        }
        userService.closeChannel();
    }

    private void printUsage() {
        System.out.println("Usage:\n" +
                "- createAccount <server> <username>\n" +
                "- deleteAccount <server> <username>\n" +
                "- balance <server> <username>\n" +
                "- transferTo <server> <username_from> <username_to> <amount>\n" +
                "- exit\n");
    }
}