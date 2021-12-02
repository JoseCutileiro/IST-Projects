package ggc.core;

public class Dissociation extends Transaction {
    //private double _originValue;
    private double[] _componentPrices;
    private double _value;

    public Dissociation(int id, Product product, Partner requester, int date, int quantity,
        double[] componentPrices, double value) {
        super(id, requester, product, date, quantity);
        _componentPrices = componentPrices;
        _value = value;
    }

    public int getType() {
        return 2;
    }

    public double getComponentPrice(int component) {
        return _componentPrices[component];
    }

    public double getValue() {
        return Math.max(_value, 0);
    }

    public double getBaseValue() {
        return _value;
    }
}