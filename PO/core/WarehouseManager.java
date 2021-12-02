package ggc.core;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import ggc.core.exception.BadEntryException;
import ggc.core.exception.DuplicatePartnerException;
import ggc.core.exception.ImportFileException;
import ggc.core.exception.InsufficientStockException;
import ggc.core.exception.UnavailableFileException;
import ggc.core.exception.MissingFileAssociationException;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchProductException;
import ggc.core.exception.NoSuchTransactionException;
import ggc.core.exception.NegativeDaysException;

/** Façade for access. */
public class WarehouseManager {
  /** Name of file storing current warehouse. */
  private String _filename;

  /** The warehouse itself. */
  private Warehouse _warehouse = new Warehouse();
  private String _notificationProduct;
  private double _notificationPrice;
  private int _nextNotification;

  public WarehouseManager() {
      Warehouse._instance = _warehouse;
  }

  public int getDate() {
    return _warehouse.getDate();
  }

  public void advanceDate(int days) throws NegativeDaysException {
    _warehouse.advanceDate(days);
  }

  public double getAvailableBalance() {
    return _warehouse.getAvailableBalance();
  }

  public double getAccountingBalance() {
    return _warehouse.getAccountingBalance();
  }

  public String[] getProducts() {
    List<Product> products = _warehouse.getProducts();
    String[] ret = new String[products.size()];
    int i = 0;
    for (Product product : products) {
      ret[i] = product.getIdentifier();
      i++;
    }
    return ret;
  }

  public double getMaximumPrice(String productId) throws NoSuchProductException {
    Product product = _warehouse.getProduct(productId);
    Batch[] batches = _warehouse.getBatchesByProduct(product);
    if (true) { // De modo a alterar menos linhas de código
      return product.getHighestPrice();
    } 
    double ret = 0;
    for (Batch b : batches) {
      if (b.getPrice() > ret) {
        ret = b.getPrice();
      }
    } 
    return ret;
  }

  public int getTotalStock(String productId) throws NoSuchProductException {
    int totalStock = 0;
    Product product = _warehouse.getProduct(productId);
    Batch[] batches = _warehouse.getBatchesByProduct(product);
    int length = batches.length;
    for (int i = 0; i < length; i++) {
      totalStock += batches[i].getStock();
    }
    return totalStock;
  }

  public boolean isDerived(String product) throws NoSuchProductException {
    return _warehouse.getProduct(product).getRecipe() != null;
  }

  public String[] getComponents(String product) throws NoSuchProductException {
    Recipe recipe = _warehouse.getProduct(product).getRecipe();
    Product[] products = recipe.getComponents();
    String[] components = new String[products.length];
    for (int i = 0; i < products.length; i++) {
      components[i] = products[i].getIdentifier();
    }
    return components;
  }

  public int[] getQuantities(String product) throws NoSuchProductException {
    Recipe recipe = _warehouse.getProduct(product).getRecipe();
    return recipe.getQuantities();
  }

  public int[] getBatches() {
    Batch[] batches = _warehouse.getBatches();
    Collections.sort(Arrays.asList(batches));
    int[] ret = new int[batches.length];
    for (int i = 0; i < batches.length; i++) {
      ret[i] = batches[i].getIdentifier();
    }
    return ret;
  }

  public String getProduct(int id) {
    return _warehouse.getBatch(id).getProduct().getIdentifier();
  }

  public boolean hasProduct(String id) {
    return _warehouse.hasProduct(id);
  }

  public String getPartner(int id) {
    return _warehouse.getBatch(id).getProvider().getIdentifier();
  }

  public double getPrice(int id) {
    return _warehouse.getBatch(id).getPrice();    
  }

  public int getStock(int id) {
    return _warehouse.getBatch(id).getStock();
  }

  public List<Integer> getBatchesByPartner(String partnerId) throws NoSuchPartnerException {
    List<Integer> ret = new ArrayList<>();
    Partner partner = _warehouse.getPartner(partnerId);
    for (Batch b : _warehouse.getBatchesByPartner(partner)) {
      ret.add(b.getIdentifier());
    }
    return ret;
  }

  public List<Integer> getBatchesByProduct(String productId) throws NoSuchProductException {
    List<Integer> ret = new ArrayList<>();
    Product product = _warehouse.getProduct(productId);
    for (Batch b : _warehouse.getBatchesByProduct(product)) {
      ret.add(b.getIdentifier());
    }
    return ret;
  }

  public String[] getPartners() {
    List<Partner> partners = _warehouse.getPartners();
    String[] ret = new String[partners.size()];
    for (int i = 0; i < partners.size(); i++) {
      ret[i] = partners.get(i).getIdentifier();
    }
    return ret;
  }

  public String getIdentifier(String id) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(id);
    return partner.getIdentifier();
  }

  public String getName(String id) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(id);
    return partner.getName();
  }

  public String getAddress(String id) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(id);
    return partner.getAddress();
  }

  public String getStatus(String id) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(id);
    return partner.getStatus().toString();
  }

  public double getPoints(String id) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(id);
    return partner.getPoints();
  }

  public double getValueOfPurchases(String id) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(id);
    double ret = 0;
    for (Purchase p : _warehouse.getPurchases(partner)) {
      ret += p.getValue();
    }
    return ret;
  }

  public double getValueOfSales(String id) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(id);
    double ret = 0;
    for (Transaction t : _warehouse.getSales(partner)) {
      ret += t.getBaseValue();
    }
    return ret;
  }

  public double getValueOfPaidSales(String id) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(id);
    double ret = 0;
    for (Transaction t : _warehouse.getSales(partner)) {
      if (t.getPaymentDate() != -1) {
        ret += t.getValue();
      }
    }
    return ret;
  }

  public String getNotification(String partnerId) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(partnerId);
    List<Notification> notifications = partner.getNotifications();
    if (_nextNotification == notifications.size()) {
      partner.removeNotifications();
      _nextNotification = 0;
      return null;
    }
    Notification notification = notifications.get(_nextNotification);
    _nextNotification++;
    _notificationPrice = notification.getPrice();
    _notificationProduct = notification.getProduct().getIdentifier();
    return notification.getDescription();
  }

  public String getNotificationProduct() {
    return _notificationProduct;
  }

  public double getNotificationPrice() {
    return _notificationPrice;
  }

  public void registerPartner(String id, String name, String address) throws DuplicatePartnerException {
    _warehouse.registerPartner(id, name, address);
  }

  public void toggleNotifications(String partnerId, String productId) 
      throws NoSuchPartnerException, NoSuchProductException {
    Partner partner = _warehouse.getPartner(partnerId);
    Product product = _warehouse.getProduct(productId);
    product.toggleNotifications(partner);
  }

  public int[] getPurchases(String partnerId) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(partnerId);
    Purchase[] purchases = _warehouse.getPurchases(partner);
    int[] ret = new int[purchases.length];
    for (int i = 0; i < ret.length; i++) {
      ret[i] = purchases[i].getIdentifier();
    }
    return ret;
  }

  public int[] getSales(String partnerId) throws NoSuchPartnerException {
    Partner partner = _warehouse.getPartner(partnerId);
    Transaction[] sales = _warehouse.getSales(partner);
    int[] ret = new int[sales.length];
    for (int i = 0; i < ret.length; i++) {
      ret[i] = sales[i].getIdentifier();
    }
    return ret;
  }

  public int getType(int transactionId) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(transactionId);
    return transaction.getType();
  }

  public String getTransactionPartner(int transactionId) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(transactionId);
    return transaction.getPartner().getIdentifier();
  }

  public String getTransactionProduct(int transactionId) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(transactionId);
    return transaction.getProduct().getIdentifier();
  }

  public int getQuantity(int transactionId) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(transactionId);
    return transaction.getQuantity();
  }

  /**
   * return the base value of a sale or dissociation
   */
  public double getBaseValue(int transactionId) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(transactionId);
    return transaction.getBaseValue();
  }

  public double getValueToPay(int transactionId) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(transactionId);
    return _warehouse.getValueToPay(transaction);
  }

  public int getDeadline(int transactionId) throws NoSuchTransactionException {
    Sale sale = (Sale)_warehouse.getTransaction(transactionId);
    return sale.getDeadline();
  }

  public int getPaymentDate(int transactionId) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(transactionId);
    return transaction.getPaymentDate();
  }

  public double getDissociationValue(int transactionId, int component) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(transactionId);
    return _warehouse.getDissociationValue((Dissociation)transaction, component);
  }

  public void dissociate(String partnerId, String productId, int quantity) 
      throws NoSuchPartnerException, NoSuchProductException, InsufficientStockException {
    Partner partner = _warehouse.getPartner(partnerId);
    Product product = _warehouse.getProduct(productId);
    _warehouse.dissociate(partner, product, quantity);
  }

  public void sell(String partnerId, int deadline, String productId, int quantity) 
      throws NoSuchPartnerException, NoSuchProductException, InsufficientStockException {
    Partner partner = _warehouse.getPartner(partnerId);
    Product product = _warehouse.getProduct(productId);
    _warehouse.sell(partner, deadline, product, quantity);
  }

  public void buy(String partnerId, String productId, double price, int quantity)
      throws NoSuchPartnerException, NoSuchProductException {
    Partner partner = _warehouse.getPartner(partnerId);
    Product product = _warehouse.getProduct(productId);
    _warehouse.buy(partner, product, quantity, price);
  }

  public void addSimpleProduct(String productId) {
    _warehouse.addSimpleProduct(productId);
  }

  public void addDerivedProduct(String productId, String[] components, int[] quantities, double aggravation) 
      throws NoSuchProductException {
    Product[] products = new Product[components.length];
    for (int i = 0; i < components.length; i++) {
      Product product = _warehouse.getProduct(components[i]);
      products[i] = product;
    }
    Recipe recipe = new Recipe(products, quantities, aggravation);
    _warehouse.addDerivedProduct(productId, recipe);
  }

  public void receiveSalePayment(int saleId) throws NoSuchTransactionException {
    Transaction transaction = _warehouse.getTransaction(saleId);
    if (transaction instanceof Sale) {
      _warehouse.receiveSalePayment((Sale)transaction);
    }
  }

  public void addBatch(String productId, String partnerId, double price, int stock) 
      throws NoSuchProductException, NoSuchPartnerException {
    Product product = _warehouse.getProduct(productId);
    Partner partner = _warehouse.getPartner(partnerId);
    _warehouse.addBatch(product, partner, price, stock);
  }

  public boolean hasFilename() {
    return _filename != null;
  }

  public String getFilename() {
    return _filename;
  }

  /**
   * @@throws IOException
   * @@throws FileNotFoundException
   * @@throws MissingFileAssociationException
   */
  public void save() throws IOException, FileNotFoundException, MissingFileAssociationException {
    if (_filename == null) {
      throw new MissingFileAssociationException();
    }
    try (ObjectOutputStream obOut = new ObjectOutputStream(new FileOutputStream(_filename))) {
      obOut.writeObject(_warehouse);
      obOut.writeObject(_filename);
    }
  }

  /**
   * @@param filename
   * @@throws MissingFileAssociationException
   * @@throws IOException
   * @@throws FileNotFoundException
   */
  public void saveAs(String filename) throws MissingFileAssociationException, FileNotFoundException, IOException {
    _filename = filename;
    save();
  }

  /**
   * @@param filename
   * @@throws UnavailableFileException
   */
  public void load(String filename) throws UnavailableFileException, ClassNotFoundException {
    try (ObjectInputStream objIn = new ObjectInputStream(new FileInputStream(filename))) {
      _warehouse = (Warehouse)objIn.readObject();
      Warehouse._instance = _warehouse;
      _filename = (String)objIn.readObject();
    }
    catch (IOException e) {
      throw new UnavailableFileException(filename);
    }
  }

  /**
   * @param textfile
   * @throws ImportFileException
   */
  public void importFile(String textfile) throws ImportFileException {
    try {
      _warehouse.importFile(textfile);
    }
    catch (IOException | BadEntryException e) {
      throw new ImportFileException(textfile, e);
    }
  }
}
