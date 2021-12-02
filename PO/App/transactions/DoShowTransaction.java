package ggc.app.transactions;

import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchTransactionException;

/**
 * Show specific transaction.
 */
final class DoShowTransaction extends ShowTransactionCommand {
  DoShowTransaction(WarehouseManager receiver) {
    super(Label.SHOW_TRANSACTION, receiver);
    addIntegerField("transaction", Message.requestTransactionKey());
  }

  @Override
  protected void doExecute() throws NoSuchTransactionException {
    showTransaction(integerField("transaction"));
    _display.display();
  }
}
