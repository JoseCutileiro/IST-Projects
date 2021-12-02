package ggc.core;

import java.io.Serializable;

public abstract class Transaction implements Serializable {
    private int _id;
    private Partner _partner;
    private Product _product;
    private int _paymentDate;
    private int _quantity;

    public Transaction(int id, Partner partner, Product product, int paymentDate, int quantity) {
        _id = id;
        _partner = partner;
        _product = product;
        _paymentDate = paymentDate;
        _quantity = quantity;
    }

    public abstract int getType();
    public abstract double getValue();
    public abstract double getBaseValue();

    public int getIdentifier() {
        return _id;
    }

    public Partner getPartner() {
        return _partner;
    }

    public Product getProduct() {
        return _product;
    }

    public int getPaymentDate() {
        return _paymentDate;
    }

    public int getQuantity() {
        return _quantity;
    }

    protected void setPaymentDate(int date) {
        _paymentDate = date;
    }
}
