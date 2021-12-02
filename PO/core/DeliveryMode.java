package ggc.core;

import java.io.Serializable;

public interface DeliveryMode extends Serializable {
    DeliveryMode DEFAULT = new DeliveryMode() {
        @Override
        public void deliver(Entity entity, Notification notification) {
            entity.registerNotification(notification);
        }
    };

    void deliver(Entity entity, Notification notification);
}
