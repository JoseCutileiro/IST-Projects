package ggc.app.exception;

import pt.tecnico.uilib.menus.CommandException;

/** Exception for unknown service levels. */
public class UnknownServiceLevelException extends CommandException {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202109091821L;

  /** @param level Unknown level to report. */
  public UnknownServiceLevelException(String level) {
    super(Message.unknownServiceLevel(level));
  }

}
