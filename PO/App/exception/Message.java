package ggc.app.exception;

/** Messages for error reporting. */
interface Message {

  /**
   * @return string with "file not found" message.
   */
  static String fileNotFound() {
    return "O ficheiro não existe.";
  }

  /**
   * @param filename
   * @return string with "file not found" message (more elaborate).
   */
  static String fileNotFound(String filename) {
    return "O ficheiro '" + filename + "' não existe.";
  }

  /**
   * @param filename
   * @return string with problem description.
   */
  static String problemOpeningFile(String filename) {
    return "Problema ao abrir '" + filename + "'.";
  }

  /**
   * @param key
   * @return string with problem description.
   */
  static String unknownPartnerKey(String key) {
    return "O parceiro '" + key + "' não existe.";
  }

  /**
   * @param key partner key
   * @return string reporting a duplicate partner
   */
  static String duplicatePartnerKey(String key) {
    return "O parceiro '" + key + "' já existe.";
  }

  /**
   * @param key
   * @return string with problem description.
   */
  static String unknownProductKey(String key) {
    return "O produto '" + key + "' não existe.";
  }

  /**
   * @param product   key
   * @param requested
   * @param available
   * @return string with requested quantity.
   */
  static String unavailable(String key, int requested, int available) {
    return "Produto '" + key + "': pedido=" + requested + ", existências=" + available;
  }

  /**
   * @param key
   * @return string with problem description.
   */
  static String unknownTransactionKey(int key) {
    return "A transacção '" + key + "' não existe.";
  }

  /**
   * @param key
   * @return string with problem description.
   */
  public static String duplicateTransactionKey(int key) {
    return "A transacção '" + key + "' já existe.";
  }

  /**
   * @param type Type of service.
   * @return string with problem description.
   */
  static String unknownServiceType(String type) {
    return "Tipo de serviço desconhecido: '" + type + "'.";
  }

  /**
   * @param level service level.
   * @return string with problem description.
   */
  static String unknownServiceLevel(String level) {
    return "Nível de serviço desconhecido: '" + level + "'.";
  }

  /**
   * @param date Bad date..
   * @return string with problem description.
   */
  public static String invalidDate(int date) {
    return "Data inválida: " + date;
  }

}
