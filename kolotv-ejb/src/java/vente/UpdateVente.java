package vente;

import java.sql.Connection;

public class UpdateVente extends InsertionVente {
    public UpdateVente() {
        setNomTable("UPDATEVENTE");
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        setNomTable("VENTE");
        VenteDetails [] filles = (VenteDetails[]) this.getFille();
        if (filles!=null){
            for (VenteDetails v : filles) {
                v.setIdDevise(this.getIdDevise());
            }
        }
        return super.updateToTableWithHisto(refUser, c);
    }
}
