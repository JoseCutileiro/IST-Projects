package pt.tecnico.distledger.adminclient;

import pt.tecnico.distledger.adminclient.grpc.AdminService;
import pt.ulisboa.tecnico.distledger.contract.DistLedgerCommonDefinitions.LedgerState;

import java.util.Scanner;

public class CommandParser {

    private static final String SPACE = " ";
    private static final String ACTIVATE = "activate";
    private static final String DEACTIVATE = "deactivate";
    private static final String GET_LEDGER_STATE = "getLedgerState";
    private static final String GOSSIP = "gossip";
    private static final String HELP = "help";
    private static final String EXIT = "exit";

    private final AdminService adminService;

    public CommandParser(AdminService adminService) {
        this.adminService = adminService;
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

                case GOSSIP:
                    this.gossip(line);
                    break;

                case HELP:
                    this.printUsage();
                    break;

                case EXIT:
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

        adminService.activate();
        System.out.println("[OK] Server activated");
    }

    // Deactivates server
    private void deactivate(String line) {
        String[] split = line.split(SPACE);

        if (split.length != 2) {
            this.printUsage();
            return;
        }
        String server = split[1];

        adminService.deactivate();
        System.out.println("[OK] Server deactivated");
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

        LedgerState ls = adminService.getLedgerState();
        System.out.println("[OK]");
        System.out.println(ls);

    }

    @SuppressWarnings("unused")
    private void gossip(String line) {
        /* TODO Phase-3 */
        adminService.gossip();
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