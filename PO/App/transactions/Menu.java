package ggc.app.transactions;

import ggc.core.WarehouseManager;

/** Transactions menu. */
public class Menu extends pt.tecnico.uilib.menus.Menu {

  /** @param receiver command executor */
  public Menu(WarehouseManager receiver) {
    super(Label.TITLE, //
        new DoShowTransaction(receiver), //
        new DoRegisterBreakdownTransaction(receiver), //
        new DoRegisterSaleTransaction(receiver), //
        new DoRegisterAcquisitionTransaction(receiver), //
        new DoReceivePayment(receiver) //
    );
  }

}
