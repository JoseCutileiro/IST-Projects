package ggc.core;

import java.io.Serializable;

public interface RewardPolicy extends Serializable {
    double getValueToPay(Sale sale, int date);
    void demotePartner(Sale sale);
    void promotePartner(Sale sale);
}
