package ggc.core;

import ggc.core.exception.InsufficientStockException;
import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

/** Represents a product. */
public class Product implements Serializable, Comparable<Product> {
    private String _id;
    private Recipe _recipe;
    private int _totalStock;
    private double _lowestPrice = Double.POSITIVE_INFINITY;
    private double _highestPrice;
    private boolean _isNew = true;
    private Set<Entity> _notifiees = new HashSet<>(Warehouse._instance.getPartners());

    /**
     * Creates a simple product.
     * @param id The identifier of the product.
     */
    public Product(String id) {
        _id = id;
        _recipe = null;
    }

    /**
     * Creates a derivative product.
     * @param id The identifier of the product.
     * @param recipe The recipe of the product.
     */
    public Product(String id, Recipe recipe) {
        _id = id;
        _recipe = recipe;
    }

    /** Returns the identifier. */
    public String getIdentifier() {
        return _id;
    }

    /** Returns the recipe, or null if this product is simple. */
    public Recipe getRecipe() {
        return _recipe;
    }

    public int getTotalStock() {
        return _totalStock;
    }

    public void addToTotalStock(int quantity) {
        _totalStock += quantity;
    }

    public double getHighestPrice() {
        return _highestPrice;
    }

    public int compareTo(Product product) {
        return _id.compareToIgnoreCase(product._id);
    }

    public void toggleNotifications(Entity entity) {
        if (!_notifiees.add(entity)) {
            _notifiees.remove(entity);
        }
    }

    private void notifyObservers(Notification notification) {
        for (Entity e : _notifiees) {
            e.getDeliveryMode().deliver(e, notification);
        }
    }

    public void newBatch(double price) {
        if (!_isNew && _totalStock == 0) {
            notifyObservers(new Notification("NEW", this, price));
        }
        _isNew = false;
        if (price < _lowestPrice) {
            _lowestPrice = price;
            if (_totalStock != 0) {
                notifyObservers(new Notification("BARGAIN", this, price));
            }
        }
        if (price > _highestPrice) {
            _highestPrice = price;
        }
    }

    void checkStock(int quantity) throws InsufficientStockException {
        if (_totalStock >= quantity) {
            return;
        }
        if (_recipe == null) {
            throw new InsufficientStockException(this, quantity, _totalStock);
        }
        Product[] components = _recipe.getComponents();
        int[] quantities = _recipe.getQuantities();
        int missing = quantity - _totalStock;
        for (int i = 0; i < components.length; i += 1) {
            components[i].checkStock(missing * quantities[i]);
        }
    }
}
