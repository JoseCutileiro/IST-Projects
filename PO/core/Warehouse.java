package ggc.core;

import ggc.core.exception.BadEntryException;
import ggc.core.exception.DuplicatePartnerException;
import ggc.core.exception.InsufficientStockException;
import ggc.core.exception.NegativeDaysException;
import ggc.core.exception.NoSuchPartnerException;
import ggc.core.exception.NoSuchProductException;
import ggc.core.exception.NoSuchTransactionException;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class Warehouse implements Serializable {
    /** Serial number for serialization. */
    private static final long serialVersionUID = 202109192006L;

    static Warehouse _instance;

    private int _date;
    private double _availableBalance;
    private double _accountingBalance;
    private List<Batch> _batches;
    private Map<Integer, Batch> _batchesMap;
    private int _nextBatch;
    private Map<String, Product> _products;
    private Map<String, Partner> _partners;
    private Map<Integer, Transaction> _transactions;
    private RewardPolicy _rewardPolicy; 

    public Warehouse() {
        _batches = new LinkedList<Batch>();
        _batchesMap = new HashMap<Integer, Batch>();
        _products = new TreeMap<String, Product>();
        _partners = new TreeMap<String, Partner>();
        _transactions = new TreeMap<Integer, Transaction>();
        _rewardPolicy = new NormalRewardPolicy();
    }

    public void buy(Partner seller, Product product, int quantity, double price) {
        addBatch(product, seller, price, quantity);
        double value = quantity * price;
        addTransaction(new Purchase(_transactions.size(), seller, product, _date, quantity, value));
        _availableBalance -= value;
        _accountingBalance -= value;
    }

    private void addTransaction(Transaction transaction) {
        _transactions.put(_transactions.size(), transaction);
    }

    private ConsumptionResult aggregate(Product product, int quantity) {
        int stock = product.getTotalStock();
        Recipe recipe = product.getRecipe();
        if (stock >= quantity) {
            return consume(product, quantity);
        }
        Product[] components = recipe.getComponents();
        int[] quantities = recipe.getQuantities();
        double value = 0.0;
        double maximumPrice = 0.0;
        for (int i = 0; i < components.length; i += 1) {
            ConsumptionResult result = aggregate(components[i], (quantity - stock) * quantities[i]);
            value += result.getValue();
            maximumPrice += quantities[i] * result.getMaximumPrice();
        }
        ConsumptionResult result = consume(product, stock);
        double multiplier = 1.0 + recipe.getAggravation();
        value = value * multiplier + result.getValue();
        maximumPrice = Math.max(maximumPrice * multiplier, result.getMaximumPrice());
        product.newBatch(maximumPrice);
        return new ConsumptionResult(value, maximumPrice);
    } 

    public void sell(Partner buyer, int deadline, Product product, int quantity) throws InsufficientStockException {
        int stock = product.getTotalStock();
        double value;
        if (stock >= quantity) {
            value = consume(product, quantity).getValue();
        }
        else {
            product.checkStock(quantity);
            value = aggregate(product, quantity).getValue();
        }
        Sale sale = new Sale(_transactions.size(), buyer, product, quantity, deadline, value);
        addTransaction(sale);
        _accountingBalance += _rewardPolicy.getValueToPay(sale, _date);
    }

    private static class PriceComparator implements Comparator<Batch> {
        public int compare(Batch batch1, Batch batch2) {
            double price1 = batch1.getPrice();
            double price2 = batch2.getPrice();
            if (price1 == price2) {
                return 0;
            }
            return price1 < price2 ? -1 : 1;
        }
    }

    private ConsumptionResult consume(Product product, int quantity) {
        List<Batch> batches = new ArrayList<>();
        for (Batch b : _batches) {
            if (b.getProduct() == product) {
                batches.add(b);
            }
        }
        Collections.sort(batches, new PriceComparator());
        double totalValue = 0.0;
        int remaining = quantity;
        double maximumPrice = 0.0;
        for (Batch batch : batches) {
            if (remaining == 0) {
                break;
            }
            int stock = batch.getStock();
            maximumPrice = batch.getPrice();
            if (remaining < stock) {
                batch.consume(remaining);
                totalValue += remaining * batch.getPrice();
                break;
            }
            totalValue += stock * batch.getPrice();
            remaining -= stock;
            _batches.remove(batch);
            _batchesMap.remove(batch.getIdentifier());
        }
        product.addToTotalStock(-quantity);
        return new ConsumptionResult(totalValue, maximumPrice);
    }

    public void dissociate(Partner requester, Product product, int quantity) throws InsufficientStockException {
        int stock = product.getTotalStock();
        if (stock < quantity) {
            throw new InsufficientStockException(product, quantity, stock);
        }
        Recipe recipe = product.getRecipe();
        if (recipe == null) {
            return;
        }
        double value = consume(product, quantity).getValue();
        Product[] components = recipe.getComponents();
        int[] quantities = recipe.getQuantities();
        double[] prices = new double[components.length];
        for (int i = 0; i < components.length; i += 1) {
            double price = getDissociationValue(components[i]);
            int componentQuantity = quantity * quantities[i];
            addBatch(components[i], requester, price, componentQuantity);
            value -= componentQuantity * price;
            prices[i] = price;
        }
        addTransaction(new Dissociation(_transactions.size(), product, requester, _date, quantity,
            prices, value));
        value = Math.min(value, 0);
        _availableBalance += value;
        _accountingBalance += value;
    }

    private double getDissociationValue(Product product) {
        double lowestPrice = 0.0;
        for (Batch b : _batches) {
            if (b.getProduct() == product && (lowestPrice == 0.0 || lowestPrice < b.getPrice())) {
                lowestPrice = b.getPrice();
            }
        }
        return lowestPrice == 0.0 ? product.getHighestPrice() : lowestPrice;
    }

    public int getDate() {
        return _date;
    }

    public void advanceDate(int days) throws NegativeDaysException {
        if (days < 0) {
            throw new NegativeDaysException(days);
        }
        int oldDate = _date;
        _date += days;
        for (Transaction t : _transactions.values()) {
            if (t.getPaymentDate() == -1) {
                Sale sale = (Sale)t;
                _accountingBalance += _rewardPolicy.getValueToPay(sale, _date) - 
                    _rewardPolicy.getValueToPay(sale, oldDate);
            }
        }
    }

    public double getAvailableBalance() {
        return _availableBalance;
    }

    public double getAccountingBalance() {
        return _accountingBalance;
    }

    public List<Product> getProducts() {
        List<Product> ret = new ArrayList<>(_products.values());
        Collections.sort(ret);
        return ret;
    }

    public Product getProduct(String id) throws NoSuchProductException {
        Product product = _products.get(id.toLowerCase());
        if (product == null) {
            throw new NoSuchProductException(id);
        }
        return product;
    }

    public boolean hasProduct(String id) {
        return _products.containsKey(id.toLowerCase());
    }

    public Batch[] getBatches() {
        return _batches.toArray(new Batch[_batches.size()]);
    }

    public Batch getBatch(int id) {
        return _batchesMap.get(id);
    }

    public Batch[] getBatchesByPartner(Partner partner) {
        List<Batch> batches = new ArrayList<>();
        for (Batch b : _batches) {
            if (b.getProvider() == partner) {
                batches.add(b);
            }
        }
        Collections.sort(batches);
        return batches.toArray(new Batch[batches.size()]);
    }

    public Batch[] getBatchesByProduct(Product product) {
        List<Batch> batches = new ArrayList<>();
        for (Batch b : _batches) {
            if (b.getProduct() == product) {
                batches.add(b);
            }
        }
        Collections.sort(batches);
        return batches.toArray(new Batch[batches.size()]);
    }

    public List<Partner> getPartners() {
        List<Partner> ret = new ArrayList<>(_partners.values());
        Collections.sort(ret);
        return ret;
    }

    public Partner getPartner(String id) throws NoSuchPartnerException {
        Partner partner = _partners.get(id.toLowerCase());
        if (partner == null) {
            throw new NoSuchPartnerException(id);
        }
        return partner;
    }

    public void registerPartner(String id, String name, String address) throws DuplicatePartnerException {
        if (_partners.containsKey(id.toLowerCase())) {
            throw new DuplicatePartnerException(id);
        }
        Partner partner = new Partner(id, name, address);
        _partners.put(id.toLowerCase(), partner);
        for (Product p : _products.values()) {
            p.toggleNotifications(partner);
        }
    }

    public Purchase[] getPurchases(Partner partner) {
        List<Purchase> purchases = new ArrayList<>();
        for (Transaction t : _transactions.values()) {
            if (t instanceof Purchase && t.getPartner() == partner) {
                purchases.add((Purchase)t);
            }
        }
        return purchases.toArray(new Purchase[purchases.size()]);
    }

    public Transaction[] getSales(Partner partner) {
        List<Transaction> sales = new ArrayList<>();
        for (Transaction t : _transactions.values()) {
            if (!(t instanceof Purchase) && t.getPartner() == partner) {
               sales.add(t);
            }
        }
        return sales.toArray(new Transaction[sales.size()]);
    }

    public Transaction getTransaction(int id) throws NoSuchTransactionException {
        Transaction ret = _transactions.get(id);
        if (ret == null) {
            throw new NoSuchTransactionException(id);
        }
        return ret;
    }

    public double getDissociationValue(Dissociation dissociation, int component) {
        int quantity = dissociation.getProduct().getRecipe().getQuantities()[component];
        return quantity * dissociation.getQuantity() * dissociation.getComponentPrice(component);
    }

    public void addSimpleProduct(String id) {
        _products.put(id.toLowerCase(), new Product(id));
    }

    public void addDerivedProduct(String id, Recipe recipe) {
        _products.put(id.toLowerCase(), new Product(id, recipe));
    }

    public void receiveSalePayment(Sale sale) {
        if (sale.getPaymentDate() != -1) {
            return;
        }
        double value = _rewardPolicy.getValueToPay(sale, _date);
        sale.pay(value, _date);
        if (sale.getDeadline() - _date >= 0) {
            _rewardPolicy.promotePartner(sale);
        }
        else {
            _rewardPolicy.demotePartner(sale);
        }
        _availableBalance += value;
    }

    public double getValueToPay(Transaction transaction) {
        if (transaction.getPaymentDate() == -1) {
            return _rewardPolicy.getValueToPay((Sale)transaction, _date);
        }
        return transaction.getValue();
    }

    public void addBatch(Product product, Partner provider, double price, int quantity) {
        Batch batch = new Batch(_nextBatch, product, provider, price, quantity);
        _batches.add(batch);
        _batchesMap.put(_nextBatch, batch);
        _nextBatch += 1;
        product.newBatch(price);
        product.addToTotalStock(quantity);
    }

    /**
     * @param filename filename to be loaded.
     * @throws IOException
     * @throws BadEntryException
     */
    public void importFile(String filename) throws IOException, BadEntryException {
        Parser parser = new Parser(this);
        parser.parseFile(filename);
    }
}
