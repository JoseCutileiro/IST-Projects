package ggc.app.products;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;

public abstract class ShowBatchCommand extends GGCCommand {

  public ShowBatchCommand(String title, WarehouseManager receiver) {
    super(title, receiver);
  }

  protected void showBatch(int batch) {
    _display.addLine(_receiver.getProduct(batch) + "|" +
                      _receiver.getPartner(batch) + "|" +
                      Math.round(_receiver.getPrice(batch)) + "|" +
                      _receiver.getStock(batch));
  }
}
