package reservation;

import reservation.Check;
import reservation.CheckOut;

public class CheckInSansCheckOutCPL extends Check
{
    String chambre;

    public String getChambre() {
        return chambre;
    }

    public void setChambre(String chambre) {
        this.chambre = chambre;
    }

    public CheckInSansCheckOutCPL() {
        setNomTable("CHECKINSANSCHEKOUTCPL");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","chambre","daty", "heure", "client"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"chambre","daty", "heure", "client"};
        return motCles;
    }
}
