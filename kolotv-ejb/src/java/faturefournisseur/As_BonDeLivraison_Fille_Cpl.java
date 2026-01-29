/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package faturefournisseur;


public class As_BonDeLivraison_Fille_Cpl extends As_BonDeLivraison_Fille{
   String produitlib,unitelib;
   String compte;
   double pu, tva;

    public As_BonDeLivraison_Fille_Cpl() {
        this.setNomTable("AS_BONDELIVRAISON_LIBCPL");
    }

    public String getProduitlib() {
        return produitlib;
    }

    public void setProduitlib(String produitlib) {
        this.produitlib = produitlib;
    }

    public String getUnitelib() {
        return unitelib;
    }

    public void setUnitelib(String unitelib) {
        this.unitelib = unitelib;
    }

    public String getCompte() {
        return compte;
    }

    public void setCompte(String compte) {
        this.compte = compte;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }
   
}
