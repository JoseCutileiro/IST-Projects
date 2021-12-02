package ggc.app.exception;

import pt.tecnico.uilib.menus.CommandException;

/** Exception for unknown product keys. */
public class UnknownProductKeyException extends CommandException {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202109091821L;

  /** @param key Unknown key to report. */
  public UnknownProductKeyException(String key) {
    super(Message.unknownProductKey(key));
  }

}
