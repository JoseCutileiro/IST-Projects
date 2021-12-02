package ggc.app.partners;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchPartnerException;

/**
 * Show partner.
 */
final class DoShowPartner extends GGCCommand {
  DoShowPartner(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER, receiver);
    addStringField("key", Message.requestPartnerKey());
  }

  @Override
  protected void doExecute() throws NoSuchPartnerException {
    String key = stringField("key");
    _display.popup(DoShowAllPartners.partnerToString(_receiver, key));
    String type;
    while ((type = _receiver.getNotification(key)) != null) {
      _display.addLine(type + "|" + _receiver.getNotificationProduct() + "|" + 
                       Math.round(_receiver.getNotificationPrice()));
    }
    _display.display();
  }
}
