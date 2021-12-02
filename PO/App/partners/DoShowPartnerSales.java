package ggc.app.partners;

import ggc.app.transactions.ShowTransactionCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchTransactionException;

/**
 * Show all transactions for a specific partner.
 */
final class DoShowPartnerSales extends ShowTransactionCommand {
  DoShowPartnerSales(WarehouseManager receiver) {
    super(Label.SHOW_PARTNER_SALES, receiver);
    addStringField("partner", Message.requestPartnerKey());
  }

  @Override
  protected void doExecute() throws NoSuchPartnerException {
    try {
      int[] sales = _receiver.getSales(stringField("partner"));
      for (int sale : sales) {
        showTransaction(sale);
      }
      _display.display();
    }
    catch (NoSuchTransactionException e) {
      e.printStackTrace();
    }
  }
}
