package ggc.app.products;

import ggc.core.WarehouseManager;

/** Products menu. */
public class Menu extends pt.tecnico.uilib.menus.Menu {

  /** @param receiver command executor */
  public Menu(WarehouseManager receiver) {
    super(Label.TITLE, //
        new DoShowAllProducts(receiver), //
        new DoShowAvailableBatches(receiver), //
        new DoShowBatchesByPartner(receiver), //
        new DoShowBatchesByProduct(receiver) //
    );
  }

}
