package ggc.app.exception;

import pt.tecnico.uilib.menus.CommandException;

/** Exception for date-related problems. */
public class InvalidDateException extends CommandException {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202109091821L;

  /** @param date bad date to report. */
  public InvalidDateException(int date) {
    super(Message.invalidDate(date));
  }

}
