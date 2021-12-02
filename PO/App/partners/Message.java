package ggc.app.partners;

/** Messages for partner menu interactions. */
interface Message {

 /** @return string prompting for a partner identifier. */
  static String requestPartnerKey() {
    return "Identificador do parceiro: ";
  }

  /** @return string prompting for a partner name. */
  static String requestPartnerName() {
    return "Nome do parceiro: ";
  }

  /** @return string prompting for an address. */
  static String requestPartnerAddress() {
    return "Endereço do parceiro: ";
  }

  /** @return string prompting for a product identifier. */
  static String requestProductKey() {
    return "Identificador do produto: ";
  }

}
