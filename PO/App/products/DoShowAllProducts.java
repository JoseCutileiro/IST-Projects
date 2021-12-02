package ggc.app.products;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;
import ggc.core.exception.NoSuchProductException;

/**
 * Show all products.
 */
final class DoShowAllProducts extends GGCCommand {
  DoShowAllProducts(WarehouseManager receiver) {
    super(Label.SHOW_ALL_PRODUCTS, receiver);
  }

  @Override
  protected void doExecute() {
    try {
      for (String product : _receiver.getProducts()) {
        _display.add(product + "|" +
                     Math.round(_receiver.getMaximumPrice(product)) + "|" +
                     _receiver.getTotalStock(product));
        if (_receiver.isDerived(product)) {
          String[] components = _receiver.getComponents(product);
          int[] quantities = _receiver.getQuantities(product);
          _display.add("|");
          for (int i = 0; i < components.length; i++) {
            if (i != 0) {
              _display.add("#");
            }
            _display.add(components[i] + ":" + quantities[i]);
          }
        }
        _display.addLine("");
      }
      _display.display();
    }
    catch (NoSuchProductException e) {
      e.printStackTrace();
    }
  }
}
