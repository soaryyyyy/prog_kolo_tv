package plage;

public class PlageCpl extends Plage {
    private String heureDescription;
    private String heureValeur;
    private String idSupportLib;

    public PlageCpl() {
        setNomTable("PLAGE_CPL");
    }

    public String getHeureDescription() {
        return heureDescription;
    }

    public void setHeureDescription(String heureDescription) {
        this.heureDescription = heureDescription;
    }

    public String getHeureValeur() {
        return heureValeur;
    }

    public void setHeureValeur(String heureValeur) {
        this.heureValeur = heureValeur;
    }

    public String getIdSupportLib() {
        return idSupportLib;
    }

    public void setIdSupportLib(String idSuppportLib) {
        this.idSupportLib = idSuppportLib;
    }
}
