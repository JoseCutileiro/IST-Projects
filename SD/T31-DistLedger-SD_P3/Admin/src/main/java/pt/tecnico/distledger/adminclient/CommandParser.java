package pt.tecnico.distledger.adminclient;

import pt.tecnico.distledger.adminclient.grpc.AdminService;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.LedgerState;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupRequest;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServer.LookupResponse;
import pt.ulisboa.tecnico.distledger.contract.namingserver.NamingServerServiceGrpc.NamingServerServiceBlockingStub;

import java.util.Scanner;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

public class CommandParser {

    private static final String SPACE = " ";
    private static final String ACTIVATE = "activate";
    private static final String DEACTIVATE = "deactivate";
    private static final String GET_LEDGER_STATE = "getLedgerState";
    private static final String GET_TIMESTAMP = "getTS";
    private static final String GOSSIP = "gossip";
    private static final String HELP = "help";
    private static final String EXIT = "exit";

    private final AdminService adminService;
    private ManagedChannel NamingServerChannel;
    private NamingServerServiceBlockingStub stub;

    private void openChannel() {
        NamingServerChannel = ManagedChannelBuilder.forTarget(AdminService.TARGET).usePlaintext().build();
        stub = NamingServerServiceGrpc.newBlockingStub(NamingServerChannel);
    }

    private void closeChannel() {
        NamingServerChannel.shutdown();
    }

    public CommandParser(AdminService adminService) {
        this.adminService = adminService;
        openChannel();
    }

    void parseInput() {

        Scanner scanner = new Scanner(System.in);
        boolean exit = false;

        while (!exit) {
            System.out.print("> ");
            String line = scanner.nextLine().trim();
            String cmd = line.split(SPACE)[0];

            switch (cmd) {
                case ACTIVATE:
                    this.activate(line);
                    break;

                case DEACTIVATE:
                    this.deactivate(line);
                    break;

                case GET_LEDGER_STATE:
                    this.dump(line);
                    break;

                case GET_TIMESTAMP:
                    this.getTimeStamps(line);
                    break;

                case GOSSIP:
                    this.gossip(line);
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

        }
    }

    // Activates server
    private void activate(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 2) {
            this.printUsage();
            return;
        }
        String server = split[1];

        LookupResponse response = stub
                .lookup(LookupRequest.newBuilder().setQual(server).setService(AdminService.SERVICE).build());
        adminService.buildChannel(response.getTarget(0));
        adminService.buildStub();
        adminService.activate();

        System.out.println("[OK] Server activated");

        adminService.closeChannel();
    }

    // Deactivates server
    private void deactivate(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 2) {
            this.printUsage();
            return;
        }
        String server = split[1];

        LookupResponse response = stub
                .lookup(LookupRequest.newBuilder().setQual(server).setService(AdminService.SERVICE).build());

        adminService.buildChannel(response.getTarget(0));
        adminService.buildStub();
        adminService.deactivate();

        System.out.println("[OK] Server deactivated");

        adminService.closeChannel();
    }

    // Returns a track of all the operations that
    // happened during the server runtime
    private void dump(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 2) {
            this.printUsage();
            return;
        }
        String server = split[1];

        LookupResponse response = stub
                .lookup(LookupRequest.newBuilder().setQual(server).setService(AdminService.SERVICE).build());

        adminService.buildChannel(response.getTarget(0));
        adminService.buildStub();

        LedgerState ls = adminService.getLedgerState();
        System.out.println(ls);
        adminService.closeChannel();

    }

    private void getTimeStamps(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 2) {
            this.printUsage();
            return;
        }
        String server = split[1];

        LookupResponse response = stub
                .lookup(LookupRequest.newBuilder().setQual(server).setService(AdminService.SERVICE).build());

        adminService.buildChannel(response.getTarget(0));
        adminService.buildStub();
        adminService.getTimeStamps();
        adminService.closeChannel();

    }

    private void gossip(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 2) {
            this.printUsage();
            return;
        }
        String server = split[1];

        LookupResponse response = stub
                .lookup(LookupRequest.newBuilder().setQual(server).setService(AdminService.SERVICE).build());

        adminService.buildChannel(response.getTarget(0));
        adminService.buildStub();
        adminService.gossip();
        adminService.closeChannel();
    }

    private void printUsage() {
        System.out.println("Usage:\n" +
                "- activate <server>\n" +
                "- deactivate <server>\n" +
                "- getLedgerState <server>\n" +
                "- gossip <server>\n" +
                "- exit\n");
    }

}