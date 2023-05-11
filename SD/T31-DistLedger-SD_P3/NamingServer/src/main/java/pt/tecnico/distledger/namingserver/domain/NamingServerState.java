package pt.tecnico.distledger.namingserver.domain;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class NamingServerState {

    HashMap<String, ServiceEntry> serviceMap = new HashMap<>();
    
    public NamingServerState() {
    }

    public synchronized void register(String service, String target, String qual) throws Exception {
        ServiceEntry serviceEntry = registerService(service);
        addService(service, serviceEntry);
        ServerEntry server = new ServerEntry(target, qual);
        serviceEntry.addServer(server);
    }

    public synchronized List<String> lookup(String service) {
        List<ServerEntry> se = serviceMap.get(service).getServers();
        List<String> targets = new ArrayList<>();
        se.forEach(s -> targets.add(s.getTarget()));
        return targets;
    }

    public synchronized List<String> lookup(String service, String qual) {
        if (qual.equals("")) {
            return lookup(service);
        }
        List<ServerEntry> se = serviceMap.get(service).getServers();
        List<String> targets = new ArrayList<>();
        se.forEach(s -> {
            if (s.getQual().equals(qual))
                targets.add(s.getTarget());
        });
        return targets;
    }

    public synchronized int delete(String service, String target) {
        List<ServerEntry> servers = serviceMap.get(service).getServers();

        for (int i = 0; i < servers.size(); i++) {
            if (servers.get(i).target.equals(target)) {
                serviceMap.get(service).getServers().remove(servers.get(i));
                return 0;
            }
        }
        return -1;
    }

    private synchronized ServiceEntry registerService(String service) {
        ServiceEntry serviceEntry = serviceMap.get(service);
        if (serviceEntry != null) {
            return serviceEntry;
        }
        serviceEntry = new ServiceEntry(service);
        return serviceEntry;
    }

    public synchronized void addService(String serviceName, ServiceEntry serviceEntry) {
        serviceMap.put(serviceName, serviceEntry);
    }
}
