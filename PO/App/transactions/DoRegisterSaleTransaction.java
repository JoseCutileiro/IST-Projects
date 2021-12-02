package ggc.app.transactions;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.InsufficientStockException;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchProductException;

/**
 * 
 */
final class DoRegisterSaleTransaction extends GGCCommand {
  DoRegisterSaleTransaction(WarehouseManager receiver) {
    super(Label.REGISTER_SALE_TRANSACTION, receiver);
    addStringField("partner", Message.requestPartnerKey());
    addIntegerField("deadline", Message.requestPaymentDeadline());
    addStringField("product", Message.requestProductKey());
    addIntegerField("quantity", Message.requestAmount());
  }

  @Override
  protected void doExecute() throws InsufficientStockException, NoSuchPartnerException,
      NoSuchProductException {
    String partnerId = stringField("partner");
    int deadline = integerField("deadline");
    String productId = stringField("product");
    int quantity = integerField("quantity");
    _receiver.sell(partnerId, deadline, productId, quantity);
  }
}
