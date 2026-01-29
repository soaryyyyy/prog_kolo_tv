package emission;

public class ParrainageEmissionDetailsLib extends ParrainageEmissionDetails{
    String idProduitLib,idMediaLib;

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public String getIdMediaLib() {
        return idMediaLib;
    }

    public void setIdMediaLib(String idMediaLib) {
        this.idMediaLib = idMediaLib;
    }

    public ParrainageEmissionDetailsLib() throws Exception {
        setNomTable("PARRAINAGEEMISSIONDETAILS_LIB");
    }
}
