package ggc.core;

import java.io.Serializable;

/** Represents a batch. */
public class Batch implements Comparable<Batch>, Serializable {
    private int _id;
    private double _price;
    private int _stock;
    private Product _product;
    private Partner _provider;

    /** Creates a batch.
     * @param id The identifier of the batch.
     * @param product The product of the batch.
     * @param provider The provider of the batch.
     * @param price The unit price of the batch.
     * @param quantity The number of units in the batch.
     */
    public Batch(int id, Product product, Partner provider, double price, int quantity) {
        _id = id;
        _product = product;
        _provider = provider;
        _price = price;
        _stock = quantity;
    }

    /** Consumes {@code quantity} units.
     * @param quantity The number of units to consume.
     */
    public void consume(int quantity) {
        _stock -= quantity;
    }

    /** Returns the product. */
    public Product getProduct() {
        return _product;
    }

    /** Returns the provider. */
    public Partner getProvider() {
        return _provider;
    }

    /** Returns the price. */
    public double getPrice() {
        return _price;
    }

    /** Returns the number of units. */
    public int getStock() {
        return _stock;
    }

    /** Returns the identifier. */
    public int getIdentifier() {
        return _id;
    }

    /** Compares this batch with a given batch,
     * by product, provider, price and stock.
     * @param batch The batch to compare with this batch.
     */
    public int compareTo(Batch batch) {
        if (_product.getIdentifier() != batch._product.getIdentifier()) {
            return _product.getIdentifier().compareTo(batch._product.getIdentifier());
        }
        if (_provider.getIdentifier() != batch._provider.getIdentifier()) {
            return _provider.getIdentifier().compareTo(batch._provider.getIdentifier());
        }
        if (_price != batch._price) {
            return _price < batch._price ? -1 : 1;
        }
        return _stock - batch._stock;
    }
}
