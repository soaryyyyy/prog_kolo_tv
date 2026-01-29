package produits;

import java.sql.Connection;

public class ActeLib extends Acte{

    private double montant;
    String idchambre, chambre;
    String idsupportlib;
    String idmedialib;
    String idemissionlib;

    public ActeLib()
    {
        this.setNomTable("acte_lib");
    }
    public double getMontant() {
        return montant;
    }
    public void setMontant(double montant) {
        this.montant = montant;
    }

    @Override
    public String getIdchambre() {
        return idchambre;
    }

    @Override
    public void setIdchambre(String idchambre) {
        this.idchambre = idchambre;
    }

    public String getChambre() {
        return chambre;
    }

    public void setChambre(String chambre) {
        this.chambre = chambre;
    }


    public String getIdsupportlib() {
        return idsupportlib;
    }

    public void setIdsupportlib(String idsupportlib) {
        this.idsupportlib = idsupportlib;
    }

    public String getIdmedialib() {
        return idmedialib;
    }

    public void setIdmedialib(String idmedialib) {
        this.idmedialib = idmedialib;
    }

    public String getIdemissionlib() {
        return idemissionlib;
    }

    public void setIdemissionlib(String idemissionlib) {
        this.idemissionlib = idemissionlib;
    }

}
