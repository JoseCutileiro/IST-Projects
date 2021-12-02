package ggc.app.partners;

import ggc.app.transactions.ShowTransactionCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchTransactionException;

/**
 * Show all transactions for a specific partner.
 */
final class DoShowPartnerAcquisitions extends ShowTransactionCommand {
  DoShowPartnerAcquisitions(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER_ACQUISITIONS, receiver);
    addStringField("partner", Message.requestPartnerKey());
  }

  @Override
  protected void doExecute() throws NoSuchPartnerException {
    try {
      int[] purchases = _receiver.getPurchases(stringField("partner"));
      for (int purchase : purchases) {
        showTransaction(purchase);
      }
      _display.display();
    }
    catch (NoSuchTransactionException e) {
      e.printStackTrace();
    }
  }
}
