/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;

import chatbot.ClassIA;
import utils.ConstanteAsync;

import java.sql.Date;

/**
 *
 * @author nouta
 */
public class FactureFournisseurDetailsCpl extends FactureFournisseurDetails implements ClassIA {
    protected String idProduitLib;
    protected String idMagasin;
    protected String idMagasinLib;
    protected String idPoint;
    protected String idPointLib;
    protected String montanttotal;
    protected String idCategorie;
    protected String idCategorieLib;
    protected Date daty;
    String libelleexacte;

    @Override
    public String getNomTableIA() {
        return "FFFILLECPL_VISEE";
    }
    @Override
    public String getUrlListe() {
        return "/pages/module.jsp?but=facturefournisseur/facturefournisseur-liste.jsp&currentMenu=MNDN000000007";
    }
    @Override
    public String getUrlAnalyse() {
        return "/pages/module.jsp?but=facturefournisseur/achat-analyse.jsp";
    }
    @Override
    public String getUrlSaisie() {
        return "/pages/module.jsp?but=facturefournisseur/facturefournisseur-saisie.jsp&currentMenu=MNDN000000014";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassAnalyse() {
        return this;
    }

    @Override
    public ClassIA getClassSaisie() {
        return this;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdCategorie() {
        return idCategorie;
    }

    public void setIdCategorie(String idCategorie) {
        this.idCategorie = idCategorie;
    }

    public String getIdCategorieLib() {
        return idCategorieLib;
    }

    public void setIdCategorieLib(String idCategorieLib) {
        this.idCategorieLib = idCategorieLib;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }

    public String getIdPointLib() {
        return idPointLib;
    }

    public void setIdPointLib(String idPointLib) {
        this.idPointLib = idPointLib;
    }

    public String getMontanttotal() {
        return montanttotal;
    }

    public void setMontanttotal(String montanttotal) {
        this.montanttotal = montanttotal;
    }

    public FactureFournisseurDetailsCpl()throws Exception{
        super.setNomTable("FACTUREFOURNISSEURFILLECPL");
    }

    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }
    public String getLibelleexacte() {
        return libelleexacte;
    }
    public void setLibelleexacte(String libelleexacte) {
        this.libelleexacte = libelleexacte;
    }
    
    
}
