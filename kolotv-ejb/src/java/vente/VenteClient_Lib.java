package vente;

public class VenteClient_Lib extends VenteLib{
    public String nif;
    public String stat;
    public String adresse;
    public String contact;

    public VenteClient_Lib() {
        this.setNomTable("VENTE_CLIENT_CPL");
    }

    public String getNif() {
        return nif;
    }

    public void setNif(String nif) {
        this.nif = nif;
    }

    public String getStat() {
        return stat;
    }

    public void setStat(String stat) {
        this.stat = stat;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }
}
