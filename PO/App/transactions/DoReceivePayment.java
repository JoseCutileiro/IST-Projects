package ggc.app.transactions;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchTransactionException;

/**
 * Receive payment for sale transaction.
 */
final class DoReceivePayment extends GGCCommand {
  DoReceivePayment(WarehouseManager receiver) {
    super(Label.RECEIVE_PAYMENT, receiver);
    addIntegerField("transaction", Message.requestTransactionKey());
  }

  @Override
  protected void doExecute() throws NoSuchTransactionException {
    _receiver.receiveSalePayment(integerField("transaction"));
  }
}
