package ggc.app.products;

import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchPartnerException;

/**
 * Show batches supplied by partner.
 */
final class DoShowBatchesByPartner extends ShowBatchCommand {
  DoShowBatchesByPartner(WarehouseManager receiver) {
    super(Label.SHOW_BATCHES_SUPPLIED_BY_PARTNER, receiver);
    addStringField("partner", Message.requestPartnerKey());
  }

  @Override
  protected void doExecute() throws NoSuchPartnerException {
    String partner = stringField("partner");
    for (int batch : _receiver.getBatchesByPartner(partner)) {
      showBatch(batch);
    }
    _display.display();
  }
}
