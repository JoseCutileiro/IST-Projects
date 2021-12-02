package ggc.app.main;

import ggc.app.GGCCommand;
import ggc.core.WarehouseManager;

/**
 * Show global balance.
 */
final class DoShowGlobalBalance extends GGCCommand {
  DoShowGlobalBalance(WarehouseManager receiver) {
    super(Label.SHOW_BALANCE, receiver);
  }

  @Override
  protected void doExecute() {
    double availableBalance = _receiver.getAvailableBalance();
    double accountingBalance = _receiver.getAccountingBalance(); 
    _display.add(Message.currentBalance(availableBalance, accountingBalance));
    _display.display();
  }
}
