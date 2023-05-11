package pt.tecnico.distledger.namingserver.domain;

import java.util.ArrayList;
import java.util.List;

public class ServiceEntry {

    List<ServerEntry> servers = new ArrayList<>();
    String service;

    public ServiceEntry(String service) {
        this.service = service;
    }

    public void addServer(ServerEntry server) throws Exception {

        for (int i = 0; i < servers.size(); i++) {
            ServerEntry s = servers.get(i);
            if (s.getQual().equals(server.getQual())) {
                System.out.println("[NAMING SERVER] Duplicate qual exception");
                s.setTarget(server.getTarget());
                throw new Exception("[NOT OK] Not possible to register the server (duplicated qual)");
            }
        }
        servers.add(server);
    }

    public void addServers(List<ServerEntry> servers) {
        this.servers.addAll(servers);
    }

    public List<ServerEntry> getServers() {
        return servers;
    }

    public String getService() {
        return service;
    }

}
