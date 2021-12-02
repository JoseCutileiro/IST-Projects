package ggc.app.exception;

import pt.tecnico.uilib.menus.CommandException;

/** Exception for unknown service types. */
public class UnknownServiceTypeException extends CommandException {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202109091821L;

  /** @param type Unknown type to report. */
  public UnknownServiceTypeException(String type) {
    super(Message.unknownServiceType(type));
  }

}
