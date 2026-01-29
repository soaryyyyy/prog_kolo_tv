package fabrication;

import java.sql.Date;

public class OfFilleCpl extends OfFille{
    String iduniteLib,libelleMere;
    double qteFabrique,qteReste;
    java.sql.Date daty;


    String libelleexacte;

    
    public OfFilleCpl() throws Exception {
        super.setNomTable("OfFilleResteLib");
    }

    public String getIduniteLib() {
        return iduniteLib;
    }

    public void setIduniteLib(String iduniteLib) {
        this.iduniteLib = iduniteLib;
    }

    public double getQteFabrique() {
        return qteFabrique;
    }

    public void setQteFabrique(double qteFabrique) {
        this.qteFabrique = qteFabrique;
    }

    public double getQteReste() {
        return qteReste;
    }

    public void setQteReste(double qteReste) {
        this.qteReste = qteReste;
    }

    public String getLibelleMere() {
        return libelleMere;
    }

    public void setLibelleMere(String libelleMere) {
        this.libelleMere = libelleMere;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getLibelleexacte() {
        return libelleexacte;
    }

    public void setLibelleexacte(String libelleexacte) {
        this.libelleexacte = libelleexacte;
    }




    
   
}
