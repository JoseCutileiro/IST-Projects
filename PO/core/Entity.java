package ggc.core;

public interface Entity {
    DeliveryMode getDeliveryMode();
    void registerNotification(Notification notification);
}
