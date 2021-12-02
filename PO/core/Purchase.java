package ggc.core;

public class Purchase extends Transaction {
    private double _value;

    public Purchase(int id, Partner partner, Product product, int paymentDate, int quantity, double value) {
        super(id, partner, product, paymentDate, quantity);
        _value = value;
    }

    public int getType() {
        return 0;
    }

    public double getValue() {
        return _value;
    }

    public double getBaseValue() {
        return _value;
    }
}
