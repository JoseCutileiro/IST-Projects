package ggc.core;

import ggc.core.exception.BadEntryException;
import ggc.core.exception.DuplicatePartnerException;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchProductException;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Parser {
  private Warehouse _store;

  public Parser(Warehouse warehouse) {
    _store = warehouse;
  }

  public void parseFile(String filename) throws IOException, BadEntryException {
    try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
      String line;
      while ((line = reader.readLine()) != null) {
        parseLine(line);
      }
    }
    for (Partner p : _store.getPartners()) {
      p.removeNotifications();
    }
  }

  private void parseLine(String line) throws BadEntryException {
    String[] components = line.split("\\|");
    switch (components[0]) {
      case "PARTNER":
        parsePartner(components, line);
        break;
      case "BATCH_S":
        parseSimpleProduct(components, line);
        break;
      case "BATCH_M":
        parseAggregateProduct(components, line);
        break;
      default:
        throw new BadEntryException("Invalid type element: " + components[0]);
    }
  }

  // PARTNER|id|name|address
  private void parsePartner(String[] components, String line) throws BadEntryException {
    if (components.length != 4) {
      throw new BadEntryException("Invalid partner with wrong number of fields (should be 4): " + line);
    }
    try {
    _store.registerPartner(components[1], components[2], components[3]);
    }
    catch (DuplicatePartnerException e) {
      throw new BadEntryException("Duplicate identifier in partner description: " + line);
    }
  }

  // BATCH_S|productId|partnerId|price|stock
  private void parseSimpleProduct(String[] components, String line) throws BadEntryException {
    if (components.length != 5) {
      throw new BadEntryException("Invalid number of fields (should be 5) in simple batch description: " + line);
    }
    String productId = components[1];
    double price = Double.parseDouble(components[3]);
    int stock = Integer.parseInt(components[4]);
    if (!_store.hasProduct(productId)) {
      _store.addSimpleProduct(productId);
    }
    try {
      Product product = _store.getProduct(productId);
      Partner partner = _store.getPartner(components[2]);
      _store.addBatch(product, partner, price, stock);
    }
    catch (NoSuchProductException e) {
      throw new BadEntryException("Nonexistent product in simple batch description: " + line);
    }
    catch (NoSuchPartnerException e) {
      throw new BadEntryException("Nonexistent partner in simple batch description: " + line);
    }
  }

  // BATCH_M|productId|partnerId|price|stock|aggravation|component-1:quantity-1#...#component-n:quantity-n
  private void parseAggregateProduct(String[] components, String line) throws BadEntryException {
    if (components.length != 7) {
      throw new BadEntryException("Invalid number of fields (should be 7) in aggregate batch description: " + line);
    }
    String productId = components[1];
    if (!_store.hasProduct(productId)) {
      String[] recipe = components[6].split("#");
      Product[] products = new Product[recipe.length];
      int[] quantities = new int[recipe.length];
      for (int i = 0; i < recipe.length; i += 1) {
        try {
          String[] componentAndQuantity = recipe[i].split(":");
          products[i] = _store.getProduct(componentAndQuantity[0]);
          quantities[i] = Integer.parseInt(componentAndQuantity[1]);
        }
        catch (NoSuchProductException e) {
          throw new BadEntryException("Nonexistent component in aggregate batch description: " + line);
        }
      }
      double aggravation = Double.parseDouble(components[5]);
      _store.addDerivedProduct(productId, new Recipe(products, quantities, aggravation));
    }
    try {
      Product product = _store.getProduct(productId);
      Partner provider = _store.getPartner(components[2]);
      double price = Double.parseDouble(components[3]);
      int stock = Integer.parseInt(components[4]);
      _store.addBatch(product, provider, price, stock);
    }
    catch (NoSuchProductException e) {
      throw new BadEntryException("Nonexistent product in aggregate batch description: " + line);
    }
    catch (NoSuchPartnerException e) {
      throw new BadEntryException("Nonexistent partner in aggregate batch description: " + line);
    }
  }
}
