/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package vente;

import bean.ClassMAPTable;
import java.sql.Connection;

/**
 *
 * @author Sahy
 */
public class InsertionVente extends Vente{
    String idDevise,idreservation,idSupport;

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public String getIdreservation() {
        return idreservation;
    }

    public void setIdreservation(String idreservation) {
        this.idreservation = idreservation;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public InsertionVente() {
        this.setNomTable("INSERTION_VENTE");
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        super.setNomTable("VENTE");
        this.setRemarque(this.getDesignation());
        VenteDetails [] filles = (VenteDetails[]) this.getFille();
        if (filles!=null){
            for (VenteDetails v : filles) {
                v.setNomTable("Vente_Details");
                v.setIdDevise(this.getIdDevise());
            }
        }
        return super.createObject(u, c);
    }

    @Override
    public boolean getEstIndexable() {
        return true;
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        setNomTable("VENTE");
        this.setRemarque(this.getDesignation());
        VenteDetails [] filles = (VenteDetails[]) this.getFille();
        if (filles!=null){
            for (VenteDetails v : filles) {
                v.setIdDevise(this.getIdDevise());
            }
        }
        return super.updateToTableWithHisto(refUser, c);
    }
}
