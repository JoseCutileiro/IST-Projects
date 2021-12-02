package ggc.app.exception;

import pt.tecnico.uilib.menus.CommandException;

/** Exception for reporting general problems opening and processing files. */
public class FileOpenFailedException extends CommandException {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 202109091821L;

  /** @param filename Problematic filename to report. */
  public FileOpenFailedException(String filename) {
    super(Message.problemOpeningFile(filename));
  }

}
