package ggc.app.partners;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchProductException;

/**
 * Toggle product-related notifications.
 */
final class DoToggleProductNotifications extends GGCCommand {
  DoToggleProductNotifications(WarehouseManager receiver) {
    super(Label.TOGGLE_PRODUCT_NOTIFICATIONS, receiver);
    addStringField("partner", Message.requestPartnerKey());
    addStringField("product", Message.requestProductKey());
  }

  @Override
  protected void doExecute() throws NoSuchPartnerException, NoSuchProductException {
    String partnerId = stringField("partner");
    String productId = stringField("product");
    _receiver.toggleNotifications(partnerId, productId);
  }
}
