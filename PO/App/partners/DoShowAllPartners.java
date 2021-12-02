package ggc.app.partners;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchPartnerException;

/**
 * Show all partners.
 */
final class DoShowAllPartners extends GGCCommand {
  DoShowAllPartners(WarehouseManager receiver) {
    super(Label.SHOW_ALL_PARTNERS, receiver);
  }

  static String partnerToString(WarehouseManager manager, String partner) throws NoSuchPartnerException {
    return manager.getIdentifier(partner) + "|" +
           manager.getName(partner) + "|" +
           manager.getAddress(partner) + "|" +
           manager.getStatus(partner) + "|" + 
           Math.round(manager.getPoints(partner)) + "|" +
           Math.round(manager.getValueOfPurchases(partner)) + "|" +
           Math.round(manager.getValueOfSales(partner)) + "|" +
           Math.round(manager.getValueOfPaidSales(partner));
  }

  @Override
  protected void doExecute() {
    for (String partner : _receiver.getPartners()) {
      try {
        _display.addLine(partnerToString(_receiver, partner));
      }
      catch (NoSuchPartnerException e) {
        e.printStackTrace();
      }
    }
    _display.display();
  }
}
