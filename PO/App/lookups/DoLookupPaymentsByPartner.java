package ggc.app.lookups;

import ggc.app.transactions.ShowTransactionCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchTransactionException;

/**
 * Lookup payments by given partner.
 */
final class DoLookupPaymentsByPartner extends ShowTransactionCommand {
  DoLookupPaymentsByPartner(WarehouseManager receiver) {
    super(Label.PAID_BY_PARTNER, receiver);
    addStringField("partner", Message.requestPartnerKey());
  }

  @Override
  protected void doExecute() throws NoSuchPartnerException {
    String partner = stringField("partner");
    try {
      for (int t : _receiver.getSales(partner)) {
        if (_receiver.getPaymentDate(t) != -1) {
          showTransaction(t);
        }
      }
      _display.display();
    }
    catch (NoSuchTransactionException e) {
      e.printStackTrace();
    }
  }
}
