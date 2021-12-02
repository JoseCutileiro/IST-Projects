package ggc.core;

import java.io.Serializable;

public class Notification implements Serializable {
    private String _description;
    private Product _product;
    private double _price;

    public Notification(String description, Product product, double price) {
        _description = description;
        _product = product;
        _price = price;
    }

    public String getDescription() { 
        return _description;
    }

    public Product getProduct() {
        return _product;
    }

    public double getPrice() {
        return _price;
    }
}
