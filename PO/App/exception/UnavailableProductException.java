package ggc.app.exception;

import pt.tecnico.uilib.menus.CommandException;

/** Exception thrown when a product is unavailable. */
public class UnavailableProductException extends CommandException {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202109091821L;

  /**
   * @param key       the requested key
   * @param requested Requested amount.
   * @param available Available amount.
   */
  public UnavailableProductException(String key, int requested, int available) {
    super(Message.unavailable(key, requested, available));
  }

}
