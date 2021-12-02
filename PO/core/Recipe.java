package ggc.core;

import java.io.Serializable;

public class Recipe implements Serializable {
    private Product[] _components;
    private int[] _quantities;
    private double _aggravation;

    public Recipe(Product[] components, int[] quantities, double aggravation) {
        _components = components;
        _quantities = quantities;
        _aggravation = aggravation;
    }

    public Product[] getComponents() {
        Product[] ret = new Product[_components.length];
        for (int i = 0; i < _components.length; i++) {
            ret[i] = _components[i];
        }
        return ret;
    }

    public int[] getQuantities() {
        int[] ret = new int[_quantities.length];
        for (int i = 0; i < _quantities.length; i++) {
            ret[i] = _quantities[i];
        }
        return ret;
    }

    public double getAggravation() {
        return _aggravation;
    }
}
