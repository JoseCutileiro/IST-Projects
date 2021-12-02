package ggc.app.exception;

import pt.tecnico.uilib.menus.CommandException;

/** Exception for unknown partner keys. */
public class UnknownPartnerKeyException extends CommandException {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202109091821L;

  /** @param key Unknown key to report. */
  public UnknownPartnerKeyException(String key) {
    super(Message.unknownPartnerKey(key));
  }

}
