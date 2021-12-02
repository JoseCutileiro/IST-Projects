package ggc.app.partners;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.DuplicatePartnerException;

/**
 * Register new partner.
 */
final class DoRegisterPartner extends GGCCommand {
  DoRegisterPartner(WarehouseManager receiver) {
    super(Label.REGISTER_PARTNER, receiver);
    addStringField("key", Message.requestPartnerKey());
    addStringField("name", Message.requestPartnerName());
    addStringField("address", Message.requestPartnerAddress());
  }

  @Override
  protected void doExecute() throws DuplicatePartnerException {
      _receiver.registerPartner(stringField("key"), stringField("name"), stringField("address"));
  }
}
