package ggc.app.main;

import ggc.core.WarehouseManager;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;

/**
 * Show current date.
 */
final class DoDisplayDate extends Command<WarehouseManager> {
  DoDisplayDate(WarehouseManager receiver) {
    super(Label.SHOW_DATE, receiver);
  }

  @Override
  protected void execute() throws CommandException {
    _display.popup(Message.currentDate(_receiver.getDate()));
  }
}
