package ggc.app.main;

import ggc.app.exception.InvalidDateException;
import ggc.core.WarehouseManager;
import ggc.core.exception.NegativeDaysException;
import pt.tecnico.uilib.menus.Command;
import pt.tecnico.uilib.menus.CommandException;

/**
 * Advance current date.
 */
final class DoAdvanceDate extends Command<WarehouseManager> {
  DoAdvanceDate(WarehouseManager receiver) {
    super(Label.ADVANCE_DATE, receiver);
    addIntegerField("days", Message.requestDaysToAdvance());
  }

  @Override
  protected void execute() throws CommandException {
    int daysToAdvance = integerField("days");
    try {
      _receiver.advanceDate(daysToAdvance);
    }
    catch (NegativeDaysException e) {
      throw new InvalidDateException(daysToAdvance);
    }
  }
}
