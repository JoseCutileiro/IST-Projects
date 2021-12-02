package ggc.core.exception;

/**
 * Class for representing a read error.
 */
public class ImportFileException extends Exception {

  /** Serial number for serialization. */
  private static final long serialVersionUID = 201708301010L;

  /**
   * Default constructor
   */
  public ImportFileException() {
    // do nothing
  }

  /**
   * @param description
   */
  public ImportFileException(String description) {
    super(description);
  }

  /**
   * @param importFile
   * @param cause
   */
  public ImportFileException(String importFile, Exception cause) {
    super("Erro em ficheiro de import: " + importFile, cause);
  }

}
