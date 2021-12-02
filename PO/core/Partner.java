package ggc.core;

import java.util.List;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;

public class Partner implements Entity, Serializable, Comparable<Partner> {
    private String _id;
    private String _name;
    private String _address;
    private Status _status;
    private double _points;
    private List<Notification> _notifications;
    private DeliveryMode _deliveryMode;

    public Partner(String id, String name, String address) {
        _id = id;
        _name = name;
        _address = address;
        _status = Status.NORMAL;
        _points = 0;
        _notifications = new ArrayList<>();
        _deliveryMode = DeliveryMode.DEFAULT;
    }

    /**
     * @return Partner identifier
     */
    public String getIdentifier() { 
        return _id;
    }

    /**
     * @return Partner name
     */
    public String getName() {
        return _name;
    }

    /**
     * @return Partner address
     */
    public String getAddress() {
        return _address;
    }

    /**
     * @return Partner status
     */
    public Status getStatus() {
        return _status;
    }

    /**
     * Update partner Status
     * @param status new status
     */
    public void setStatus(Status status) {
        _status = status;
    }

    /**
     * @return Partner points
     */
    public double getPoints() {
        return _points;
    }

    /**
     * Update partner points
     * @param points new points
     */
    public void setPoints(double points) {
        _points = points;
    }

    /**
     * @return Partner notifications
     */
    public List<Notification> getNotifications() {
        return Collections.unmodifiableList(_notifications);
    }

    @Override
    public DeliveryMode getDeliveryMode() {
        return _deliveryMode;
    }

    /**
     * Add a new notification to a partner
     * @param New notification
     */
    public void registerNotification(Notification notification) {
        _notifications.add(notification);
    }

    public void removeNotifications() {
        _notifications.clear();
    }

    public int compareTo(Partner partner) {
        return _id.compareToIgnoreCase(partner._id);
    }
}
