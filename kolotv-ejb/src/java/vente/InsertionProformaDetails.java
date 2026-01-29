package vente;

import bean.ClassMAPTable;

import java.sql.Connection;

public class InsertionProformaDetails extends ProformaDetails{
    String uniteRemise;

    public InsertionProformaDetails() {
        this.setNomTable("INSERTION_PROFORMA_DETAILS");
    }

    public String getUniteRemise() {
        return uniteRemise;
    }

    public void setUniteRemise(String uniteRemise) {
        this.uniteRemise = uniteRemise;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        super.setNomTable("PROFORMA_DETAILS");
        return super.createObject(u, c);
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        setNomTable("PROFORMA_DETAILS");
        return super.updateToTableWithHisto(refUser, c);
    }
    @Override
    public boolean getEstIndexable() {
        return true;
    }
}
