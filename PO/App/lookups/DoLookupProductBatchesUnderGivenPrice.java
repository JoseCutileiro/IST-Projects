package ggc.app.lookups;

import ggc.app.products.ShowBatchCommand;
import ggc.core.WarehouseManager;

/**
 * Lookup products cheaper than a given price.
 */
class DoLookupProductBatchesUnderGivenPrice extends ShowBatchCommand {
  DoLookupProductBatchesUnderGivenPrice(WarehouseManager receiver) {
    super(Label.PRODUCTS_UNDER_PRICE, receiver);
    addIntegerField("limit", Message.requestPriceLimit());
  }

  @Override
  protected void doExecute() {
    for (int b : _receiver.getBatches()) {
      if (_receiver.getPrice(b) < integerField("limit")) {
        showBatch(b);
      }
    }
    _display.display();
  }
}
