package ggc.core;

class ConsumptionResult {
    private double _value;
    private double _maximumPrice;

    ConsumptionResult(double value, double maximumPrice) {
        _value = value;
        _maximumPrice = maximumPrice;
    }

    double getValue() {
        return _value;
    }

    double getMaximumPrice() {
        return _maximumPrice;
    }
}
