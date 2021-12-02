package ggc.app.main;

/** Messages for interaction. */
interface Message {

  /** @return string showing current date. */
  static String currentDate(int date) {
    return "Data actual: " + date;
  }

  /**
   * @param available  available balance
   * @param accounting accounting balance
   * @return string describing balance.
   */
  static String currentBalance(double available, double accounting) {
    return "Saldo disponível: " + Math.round(available) + "\n" + "Saldo contabilístico: " + Math.round(accounting);
  }

  /** @return string with prompt for filename to open. */
  static String openFile() {
    return "Ficheiro a abrir: ";
  }

  /** @return string with a warning and a question. */
  static String newSaveAs() {
    return "Ficheiro sem nome. " + saveAs();
  }

  /** @return string asking for a filename. */
  static String saveAs() {
    return "Guardar ficheiro como: ";
  }

  /** @return string prompting for the number of days to advance (integer). */
  static String requestDaysToAdvance() {
    return "Número de dias a avançar: ";
  }

}
