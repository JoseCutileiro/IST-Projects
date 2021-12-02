package ggc.app.products;

import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchProductException;

/**
 * Show all products.
 */
final class DoShowBatchesByProduct extends ShowBatchCommand {
  DoShowBatchesByProduct(WarehouseManager receiver) {
    super(Label.SHOW_BATCHES_BY_PRODUCT, receiver);
    addStringField("product", Message.requestProductKey());
  }

  @Override
  protected void doExecute() throws NoSuchProductException {
    String product = stringField("product");
    for (int batch : _receiver.getBatchesByProduct(product)) {
      showBatch(batch);
    }
    _display.display();
  }
}
