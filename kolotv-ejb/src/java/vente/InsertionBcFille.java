package vente;

import bean.ClassMAPTable;

import java.sql.Connection;

public class InsertionBcFille extends BonDeCommandeFille{
    String uniteRemise;

    public InsertionBcFille() throws Exception {
        super();
        this.setNomTable("InsertionBcFille");
    }

    public String getUniteRemise() {
        return uniteRemise;
    }

    public void setUniteRemise(String uniteRemise) {
        this.uniteRemise = uniteRemise;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        super.setNomTable("BONDECOMMANDE_CLIENT_FILLE");
        return super.createObject(u, c);
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        setNomTable("BONDECOMMANDE_CLIENT_FILLE");
        return super.updateToTableWithHisto(refUser, c);
    }
}
