package ggc.app.transactions;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.InsufficientStockException;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchProductException;

/**
 * Register order.
 */
final class DoRegisterBreakdownTransaction extends GGCCommand {
  DoRegisterBreakdownTransaction(WarehouseManager receiver) {
    super(Label.REGISTER_BREAKDOWN_TRANSACTION, receiver);
    addStringField("partner", Message.requestPartnerKey());
    addStringField("product", Message.requestProductKey());
    addIntegerField("quantity", Message.requestAmount());
  }

  @Override
  protected void doExecute() throws InsufficientStockException, NoSuchPartnerException,
      NoSuchProductException {
    String partnerId = stringField("partner");
    String productId = stringField("product");
    int quantity = integerField("quantity");
    _receiver.dissociate(partnerId, productId, quantity);
  }
}
