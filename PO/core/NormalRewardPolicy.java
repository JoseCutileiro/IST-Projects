package ggc.core;

public class NormalRewardPolicy implements RewardPolicy {
    @Override
    public void promotePartner(Sale sale) {
        Partner partner = sale.getPartner();
        double points = partner.getPoints() + 10 * sale.getValue();
        partner.setPoints(points);
        if (points > 25000) {
            partner.setStatus(Status.ELITE);
        }
        else if (points > 2000) {
            partner.setStatus(Status.SELECTION);
        }
    }

    @Override
    public void demotePartner(Sale sale) {
        int difference = Warehouse._instance.getDate() - sale.getDeadline();
        if (difference <= 0) {
            return;
        }
        Partner partner = sale.getPartner();
        difference *= -1; // poupar linhas 
        switch (partner.getStatus()) {
            case NORMAL:
                partner.setPoints(0.0);
                break;
            case SELECTION:
                if (difference < -2) {
                    partner.setPoints(0.1 * partner.getPoints());
                    partner.setStatus(Status.NORMAL);
                }
                break;
            case ELITE: 
                if (difference < -15) {
                    partner.setPoints(0.25 * partner.getPoints());
                    partner.setStatus(Status.SELECTION);
                }
                break;
        }
    }

    @Override
    public double getValueToPay(Sale sale, int date) {
        int period;
        Partner partner = sale.getPartner();
        int n = sale.getProduct().getRecipe() == null ? 5 : 3;
        int difference = sale.getDeadline() - date;
        if (difference >= n) {
            return 0.9 * sale.getBaseValue();
        }
        if (difference >= 0) {
            period = 2;
        }
        else if (difference >= -n) {
            period = 3;
        }
        else {
            period = 4;
        }
        double multiplier = 0.0;
        switch (partner.getStatus()) {
            case NORMAL:
                multiplier = 1.0 + (period - 2) * 0.05 * -difference;
                break;
            case SELECTION:
                switch (period) {
                    case 2:
                        multiplier = difference >= 2 ? 0.95 : 1;
                        break;
                    case 3:
                        multiplier = difference >= -1 ? 1 : 1 + 0.02 * -difference;
                        break;
                    case 4:
                        multiplier = 0.05 * -difference;
                        break;
                }
                break;
            case ELITE:
                multiplier = 0.90 + (period - 2) * 0.05;
                break;
        }
        return multiplier * sale.getBaseValue();
    }
}
