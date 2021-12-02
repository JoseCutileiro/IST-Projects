package ggc.app.lookups;

import ggc.core.WarehouseManager;

/** Lookups menu. */
public class Menu extends pt.tecnico.uilib.menus.Menu {

  /** @param receiver command executor */
  public Menu(WarehouseManager receiver) {
    super(Label.TITLE, //
        new DoLookupProductBatchesUnderGivenPrice(receiver), //
        new DoLookupPaymentsByPartner(receiver) //
    );
  }

}
