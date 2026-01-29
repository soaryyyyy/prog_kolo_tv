package vente;

import bean.ClassMAPTable;

import java.sql.Connection;

public class InsertionVenteDetails extends VenteDetails{
    private String uniteRemise;

    public String getUniteRemise() {
        return uniteRemise;
    }

    public void setUniteRemise(String uniteRemise) {
        this.uniteRemise = uniteRemise;
    }

    public InsertionVenteDetails() {
        this.setNomTable("INSERTVENTEDETAILS");
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        super.setNomTable("Vente_Details");
        return super.createObject(u, c);
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        setNomTable("VENTE_DETAILS");
        return super.updateToTableWithHisto(refUser, c);
    }
}
