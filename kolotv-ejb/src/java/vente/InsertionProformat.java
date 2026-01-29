package vente;

import bean.ClassMAPTable;

import java.sql.Connection;

public class InsertionProformat extends Proforma{
    String idSupport;

    public InsertionProformat() {
        this.setNomTable("INSERTIONPROFORMAT");
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        super.setNomTable("BONDECOMMANDE_CLIENT");
        return super.createObject(u, c);
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        setNomTable("BONDECOMMANDE_CLIENT");
        return super.updateToTableWithHisto(refUser, c);
    }
}
