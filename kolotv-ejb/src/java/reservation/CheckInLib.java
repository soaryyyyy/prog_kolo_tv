package reservation;

public class CheckInLib extends Check{
     
    String client,compteVente;
    String etatlib;

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getClient() {
        return client;
    }

    public void setClient(String client) {
        this.client = client;
    }

    public String getCompteVente() {
        return compteVente;
    }

    public void setCompteVente(String compteVente) {
        this.compteVente = compteVente;
    }

    public CheckInLib()
    {
        super.setNomTable("CHECKINLIBELLE");
    }

 

}
