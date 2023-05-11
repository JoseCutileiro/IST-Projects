package pt.tecnico.distledger.namingserver.domain;

public class ServerEntry {
    String target;
    String qual;

    public ServerEntry() {}

    public ServerEntry(String target,String qual) {
        this.target = target;
        this.qual = qual;
    }

    public void setTarget(String target) {
        this.target = target; 
    }

    public void setQual(String qual) {
        this.qual = qual;
    }

    public String getTarget() {
        return target;
    }

    public String getQual() {
        return qual;
    }
} 
