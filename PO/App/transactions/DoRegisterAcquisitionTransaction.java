package ggc.app.transactions;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchProductException;
import pt.tecnico.uilib.forms.Form;

/**
 * Register order.
 */
final class DoRegisterAcquisitionTransaction extends GGCCommand {
  DoRegisterAcquisitionTransaction(WarehouseManager receiver) {
    super(Label.REGISTER_ACQUISITION_TRANSACTION, receiver);
    addStringField("partner", Message.requestPartnerKey());
    addStringField("product", Message.requestProductKey());
    addIntegerField("price", Message.requestPrice());
    addIntegerField("quantity", Message.requestAmount());
  }

  @Override
  protected void doExecute() throws NoSuchPartnerException, NoSuchProductException {
    String partnerId = stringField("partner");
    String productId = stringField("product");
    int price = integerField("price");
    int quantity = integerField("quantity");
    if (!_receiver.hasProduct(productId)) {
      if (Form.confirm(Message.requestAddRecipe())) {
        int size = Form.requestInteger(Message.requestNumberOfComponents());
        double aggravation = Form.requestReal(Message.requestAlpha());
        String[] components = new String[size];
        int[] quantities = new int[size];
        Form f = new Form();
        f.addStringField("component", Message.requestProductKey());
        f.addIntegerField("quantity", Message.requestAmount());
        for (int i = 0; i < size; i++) {
          f.parse();
          components[i] = f.stringField("component");
          quantities[i] = f.integerField("quantity");
        }
        _receiver.addDerivedProduct(productId, components, quantities, aggravation);
      }
      else {
        _receiver.addSimpleProduct(productId);
      }
    }
    _receiver.buy(partnerId, productId, price, quantity);
  }
}
