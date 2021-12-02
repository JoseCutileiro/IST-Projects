package ggc.app.transactions;

import ggc.core.exception.NoSuchProductException;
import ggc.core.exception.NoSuchTransactionException;
import ggc.app.GGCCommand;
import ggc.core.WarehouseManager; 

public abstract class ShowTransactionCommand extends GGCCommand {
  public ShowTransactionCommand(String title, WarehouseManager receiver) {
    super(title, receiver);
  }

  protected void showTransaction(int transactionId) throws NoSuchTransactionException {
    switch (_receiver.getType(transactionId)) {
      case 0: showPurchase(transactionId); break;
      case 1: showSale(transactionId); break;
      case 2: showDissociation(transactionId); break;
    }
  }

  private void showSale(int id) throws NoSuchTransactionException {
    _display.add("VENDA|" + id + "|" + 
                    _receiver.getTransactionPartner(id) + "|" + 
                    _receiver.getTransactionProduct(id) + "|" +
                    _receiver.getQuantity(id) + "|" +
                    Math.round(_receiver.getBaseValue(id)) + "|" +
                    Math.round(_receiver.getValueToPay(id)) + "|" +
                    _receiver.getDeadline(id));
    if (_receiver.getPaymentDate(id) != -1) {
        _display.add("|" + _receiver.getPaymentDate(id));
    }
    _display.addLine("");
  }

  private void showPurchase(int id) throws NoSuchTransactionException {
    _display.addLine("COMPRA|" + id + "|" + 
                     _receiver.getTransactionPartner(id) + "|" + 
                     _receiver.getTransactionProduct(id) + "|" + 
                     _receiver.getQuantity(id) + "|" + 
                     Math.round(_receiver.getValueToPay(id)) + "|" +
                     _receiver.getPaymentDate(id));
  }

  private void showDissociation(int id) throws NoSuchTransactionException {
    String product = _receiver.getTransactionProduct(id);
    int quantity = _receiver.getQuantity(id);
    _display.add("DESAGREGAÇÃO|" + id + "|" +
                 _receiver.getTransactionPartner(id) + "|" + 
                 product + "|" + quantity + "|" +
                 Math.round(_receiver.getBaseValue(id)) + "|" +
                 Math.round(_receiver.getValueToPay(id)) + "|" +
                 _receiver.getPaymentDate(id) + "|");
    try {
      String[]  components = _receiver.getComponents(product);
      int[] quantities = _receiver.getQuantities(product);
      for (int i = 0; i < components.length; i++) {
        if (i != 0) {
          _display.add("#");
        }
        _display.add(components[i] + ":" + quantity * quantities[i] + ":" + 
                     Math.round(_receiver.getDissociationValue(id, i)));
      }
      _display.addLine("");
    }
    catch (NoSuchProductException e) {
      e.printStackTrace();
    }
  }
}
