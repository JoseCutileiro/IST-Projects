package ggc.core;

public class Sale extends Transaction {
    private int _deadline;
    private double _baseValue;
    private double _value;

    public Sale(int id, Partner buyer, Product product, int quantity, int deadline,
	    double value) {
        super(id, buyer, product, -1, quantity);
        _deadline = deadline;
        _baseValue = value;
    }

    public int getType() {
        return 1;
    }

    public int getDeadline() {
        return _deadline;
    }

    @Override
    public double getValue() {
        return getPaymentDate() == -1 ? _baseValue : _value;
    }

    public void pay(double value, int date) {
        _value = value;
        setPaymentDate(date);
    }

    public double getBaseValue() {
        return _baseValue;
    }
}
