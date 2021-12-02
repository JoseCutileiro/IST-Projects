package ggc.app.transactions;

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

  /** @return string prompting for a date. */
  static String requestPaymentDeadline() {
    return "Data limite de pagamento: ";
  }

  /** @return string prompting for a quantity. */
  static String requestAmount() {
    return "Quantidade: ";
  }

  /** @return string prompting for recipe. */
  static String requestAddRecipe() {
    return "Registar receita? ";
  }

  /** @return string prompting for number of components. */
  static String requestNumberOfComponents() {
    return "Número de componentes: ";
  }

  /** @return string prompting for a price. */
  static String requestPrice() {
    return "Preço: ";
  }
 
  /** @return string prompting for alpha. */
  static String requestAlpha() {
    return "Agravamento: ";
  }
}
