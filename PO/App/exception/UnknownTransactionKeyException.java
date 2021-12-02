package ggc.app.exception;

import pt.tecnico.uilib.menus.CommandException;

/** Exception for unknown transaction keys. */
public class UnknownTransactionKeyException extends CommandException {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202109091821L;

  /** @param key Unknown key to report. */
  public UnknownTransactionKeyException(int key) {
    super(Message.unknownTransactionKey(key));
  }

}
