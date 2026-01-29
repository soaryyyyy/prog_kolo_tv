package emission;

public class PlateauCpl extends Plateau {
    String idClientLib;
    String idEmissionLib;
    String etatlib;

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public PlateauCpl() {
        setNomTable("PLATEAU_CPL");
    }

    public String getIdClientLib() {
        return idClientLib;
    }

    public void setIdClientLib(String idClientLib) {
        this.idClientLib = idClientLib;
    }

    public String getIdEmissionLib() {
        return idEmissionLib;
    }

    public void setIdEmissionLib(String idEmissionLib) {
        this.idEmissionLib = idEmissionLib;
    }
}
