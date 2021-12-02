package ggc.app.main;

import ggc.core.WarehouseManager;
import pt.tecnico.uilib.menus.DoOpenMenu;

/** Main menu. */
public class Menu extends pt.tecnico.uilib.menus.Menu {

  /** @param receiver command executor */
  public Menu(WarehouseManager receiver) {
    super(Label.TITLE, //
        new DoOpenFile(receiver), //
        new DoSaveFile(receiver), //
        new DoDisplayDate(receiver), //
        new DoAdvanceDate(receiver), //
        new DoOpenMenu(Label.OPEN_MENU_PRODUCTS, new ggc.app.products.Menu(receiver)), //
        new DoOpenMenu(Label.OPEN_MENU_PARTNERS, new ggc.app.partners.Menu(receiver)), //
        new DoOpenMenu(Label.OPEN_MENU_TRANSACTIONS, new ggc.app.transactions.Menu(receiver)), //
        new DoOpenMenu(Label.OPEN_MENU_LOOKUPS, new ggc.app.lookups.Menu(receiver)), //
        new DoShowGlobalBalance(receiver) //
    );
  }

}
