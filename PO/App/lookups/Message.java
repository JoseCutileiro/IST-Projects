package ggc.app.lookups;

/**
 * Messages.
 */
interface Message {

  /** @return string prompting for product identifier */
  static String requestProductKey() {
    return "Identificador do produto: ";
  }

  /** @return string prompting for a partner identifier. */
  static String requestPartnerKey() {
    return "Identificador do parceiro: ";
  }

  /** @return string prompting for identifier */
  static String requestTransactionKey() {
    return "Identificador da transacção: ";
  }

  /** @return string prompting for a price. */
  static String requestPriceLimit() {
    return "Preço: ";
  }

  /** @return string prompting for a delay. */
  static String requestDelay() {
    return "Atraso: ";
  }

}
