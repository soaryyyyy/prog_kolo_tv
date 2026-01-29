/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package annexe;

import chatbot.ClassIA;

/**
 *
 * @author Angela
 */
public class ProduitLib  extends Produit implements ClassIA {

    private String idCategorie , val , desce;

    private String idCategorieLib, idSupportLib;
    private String idUniteLib;
    private String idTypeProduitLib;
    private double taux;
    private String compte;
    private double montant, montantprimetime, montantheurebasse;
    public String getIdSupportLib() {
        return idSupportLib;
    }
    public void setIdSupportLib(String idSupportLib) {
        this.idSupportLib = idSupportLib;
    }
    public double getMontantheurebasse() {
        return montantheurebasse;
    }
    public void setMontantheurebasse(double montantheurebasse) {
        this.montantheurebasse = montantheurebasse;
    }
    public double getMontantprimetime() {
        return montantprimetime;
    }
    public void setMontantprimetime(double montantprimetime) {
        this.montantprimetime = montantprimetime;
    }

    private int duree;

    @Override
    public String getUrlListe() {
        return "/pages/module.jsp?but=annexe/produit/produit-liste.jsp&currentMenu=MNDN000012";
    }
    @Override
    public String getNomTableIA() {
        return "PRODUIT_LIB";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }

    public double getTaux() {
        return taux;
    }

    public void setTaux(double taux) {
        this.taux = taux;
    }

    public String getVal() {
        return val;
    }

    public void setVal(String val) {
        this.val = val;
    }

    public String getDesce() {
        return desce;
    }

    public void setDesce(String desce) {
        this.desce = desce;
    }


    public ProduitLib() {
        this.setNomTable("PRODUIT_LIB");
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

    public String getIdUniteLib() {
        return idUniteLib;
    }

    public void setIdUniteLib(String idUniteLib) {
        this.idUniteLib = idUniteLib;
    }

    public String getIdTypeProduitLib() {
        return idTypeProduitLib;
    }

    public void setIdTypeProduitLib(String idTypeProduitLib) {
        this.idTypeProduitLib = idTypeProduitLib;
    }

    @Override
    public String getValColLibelle() {
        return this.getVal()+";"+this.getPuVente();
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"id","val"};
      }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public int getDuree() {
        return duree;
    }

    public void setDuree(int duree) {
        this.duree = duree;
    }
}
