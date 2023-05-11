package pt.tecnico.distledger.server.domain;

import java.util.ArrayList;

public class VectorClock {

    private final ArrayList<Integer> timeStamps;
    private int serverIndex;

    public VectorClock(int serverIndex) {
        timeStamps = new ArrayList<>();
        this.serverIndex = serverIndex - 1;
        for (int i = 0; i < serverIndex; i++) {
            timeStamps.add(0);
        }
    }

    public VectorClock(ArrayList<Integer> ts) {
        timeStamps = new ArrayList<>();
        for (int i = 0; i < ts.size(); i++) {
            timeStamps.add(ts.get(i));
        }
    }

    public void addTS() {
        timeStamps.add(0);
    }

    public int getServerIndex() {
        return serverIndex;
    }

    public void setServerIndex(int serverIndex) {
        this.serverIndex = serverIndex;
    }

    public ArrayList<Integer> getTS() {
        return timeStamps;
    }

    public ArrayList<Integer> getShallowTS() {
        ArrayList<Integer> copyTS = new ArrayList<>();
        copyTS.addAll(timeStamps);
        return copyTS;
    }

    public void setTS(Integer i, Integer value) {
        timeStamps.set(i, value);
    }

    public boolean greaterEqual(VectorClock v) {

        ArrayList<Integer> tsOther = v.getTS();

        for (int i = 0; i < tsOther.size(); i++) {
            if (timeStamps.get(i) < tsOther.get(i)) {
                return false;
            }
        }
        return true;
    }

    public void merge(VectorClock v) {
        ArrayList<Integer> tsOther = v.getTS();
        for (int i = 0; i < tsOther.size(); i++) {
            Integer temp = tsOther.get(i);
            if (timeStamps.get(i) < temp) {
                timeStamps.set(i, temp);
            }
        }
    }

    public void increaseTime() {
        Integer v = timeStamps.get(serverIndex) + 1;
        timeStamps.set(serverIndex, v);
    }
}
