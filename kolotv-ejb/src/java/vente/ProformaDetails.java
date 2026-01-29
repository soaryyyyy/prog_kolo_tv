/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;

import annexe.Produit;
import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import produits.Ingredients;
import produits.Recette;
import stock.EtatStock;
import stock.MvtStockFille;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Toky20
 */
public class ProformaDetails extends ClassFille {

    private String id;
    private String idProforma;
    private String idProduit;
    private String idOrigine;
    private double qte;
    private double pu;
    protected double remise;
    protected double tva;
    protected double puAchat;
    protected double puVente;
    private String idDevise;
    private double tauxDeChange;
    private String designation;
    private String compte , reference;
    double puRevient;

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }
    
    public String getLiaisonMere() {
        return "idProforma";
    }

    public String getNomClasseMere() {
        return "vente.Proforma";
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        try{
            this.setNomTable("PROFORMA_DETAILS");
            return super.updateToTableWithHisto(refUser, c);
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
    }

    public double getMontantRevient() {
        return montantRevient;
    }

    public void setMontantRevient(double montantRevient) {
        this.montantRevient = montantRevient;
    }
    public double getMargeBrute()
    {
        return margeBrute;
    }
    public void setMargeBrute(double margeBrute) {
        this.margeBrute = margeBrute;
    }
    protected double margeBrute;

    double montantRevient;

    public double getPuRevient() {
        return puRevient;
    }

    public void setPuRevient(double puRevient) {
        this.puRevient = puRevient;
    }

    public String getDesignation() {
        return designation;
    }

    public void setDesignation(String designation) {
        this.designation = designation;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        if(this.getMode().equals("modif")){
            if(idDevise.isEmpty()){
                this.setIdDevise("MGA");
            }
        }
        this.idDevise = idDevise;
    }

    public double getTauxDeChange() {
        return tauxDeChange;
    }

    public void setTauxDeChange(double tauxDeChange) throws Exception{
        if(this.getMode().equals("modif")){
            if(tauxDeChange<=0){
                tauxDeChange=1;
            }
        }
        this.tauxDeChange = tauxDeChange;
    }

    @Override
    public boolean isSynchro(){
        return true;
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise)throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0)
        {
            if(remise>100||remise<0) throw new Exception("Remise invalide");
        }
        this.remise = remise;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public double getPuAchat() {
        return puAchat;
    }

    public void setPuAchat(double puAchat) {
        this.puAchat = puAchat;
    }

    public double getPuVente() {
        return puVente;
    }

    public void setPuVente(double puVente) {
        this.puVente = puVente;
    }

    public ProformaDetails(String nomtable){
        super.setNomTable(nomtable);
    }

    public ProformaDetails() {
        super.setNomTable("PROFORMA_DETAILS");
        try {
            this.setNomClasseMere("vente.Proforma");
            this.setLiaisonMere("idProforma");
        } catch (Exception ex) {
            Logger.getLogger(ProformaDetails.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdProforma() {
        return idProforma;
    }

    public void setIdProforma(String idProforma) {
        this.idProforma = idProforma;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) throws Exception {
        /*if(this.getMode().compareTo("modif")==0)
        {
            if(idProduit==null||idProduit.compareToIgnoreCase("")==0)
                throw new Exception("produit obligatoire");
        }*/
        this.idProduit = idProduit;
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) throws Exception{
        if(this.getMode().equals("modif") && compte.isEmpty()){
            throw new Exception("Compte obligatoire pour les details");
        }
        this.compte = compte;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception{
        if(this.getMode().equals("modif")){
            if(qte <= 0){
                throw new Exception("Qte insuffisant pour une ligne");
            }
        }
        this.qte = qte;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }


    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PFF", "getSEQ_Proforma_Details");
        this.setId(makePK(c));
    }

    @Override
    public void setLiaisonMere(String liaisonMere) {
        super.setLiaisonMere("idProforma");
    }

    public Produit getProduit(Connection c) throws Exception {
        Produit produit = new Produit();
        produit.setId(this.getIdProduit());
        Produit[] produits = (Produit[]) CGenUtil.rechercher(produit, null, null, c, " ");
        if (produits.length > 0) {
            return produits[0];
        }
        return null;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        //Produit produit = getProduit(c);
       // this.setPu(produit.getPuVente());
        return super.createObject(u, c);
    }

    public MvtStockFille createMvtStockFille() throws Exception {
        MvtStockFille msf = new MvtStockFille();
        msf.setIdProduit(this.getIdProduit());
        msf.setSortie(this.getQte());
        return msf;
    }

    @Override
    public void controler(Connection c) throws Exception {
       super.controler(c);
       //CheckEtatStock( c);
    }
}
