package ggc.app.products;

import ggc.core.WarehouseManager;

/**
 * Show available batches.
 */
final class DoShowAvailableBatches extends ShowBatchCommand {
  DoShowAvailableBatches(WarehouseManager receiver) {
    super(Label.SHOW_AVAILABLE_BATCHES, receiver);
  }

  @Override
  protected void doExecute() {
    for (int batch : _receiver.getBatches()) {
      showBatch(batch);
    }
    _display.display();
  }
}
