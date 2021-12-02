package ggc.app.products;

/**
 * Messages.
 */
interface Message {

  /** @return string prompting for product identifier */
  static String requestProductKey() {
    return "Identificador do produto: ";
  }

  /** @return string prompting for partner identifier */
  static String requestPartnerKey() {
    return "Identificador do parceiro: ";
  }
}
