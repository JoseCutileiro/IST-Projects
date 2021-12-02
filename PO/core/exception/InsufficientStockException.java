package ggc.core.exception;

import ggc.core.Product;

public class InsufficientStockException extends Exception {
    private String _product;
    private int _requested;
    private int _available;

    public InsufficientStockException(Product product, int requested, int available) {
        _product = product.getIdentifier();
        _requested = requested;
        _available = available;
    }

    public String getProduct() {
        return _product;
    }

    public int getRequested() {
        return _requested;
    }

    public int getAvailable() {
        return _available;
    }
}
