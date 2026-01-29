package vente;

import chatbot.ClassIA;

import java.io.Serializable;

public class BonDeCommandeFIlleCpl extends BonDeCommandeFille implements ClassIA {
    String produitLib;
    double qteOfRestante;
    double qteFabRestante;
    double qteNonLivre;
    String compte;
    double montantHt;
    double montantTva;
    double montantTtc;

    public double getMontantHt() {
        return montantHt;
    }

    public void setMontantHt(double montantHt) {
        this.montantHt = montantHt;
    }

    public double getMontantTva() {
        return montantTva;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
    }

    public double getMontantTtc() {
        return montantTtc;
    }

    public void setMontantTtc(double montantTtc) {
        this.montantTtc = montantTtc;
    }

    @Override
    public String getNomTableIA() {
        return "BC_CLIENT_FILLE_CPL_LIB_VISEE";
    }
    @Override
    public String getUrlListe() {
        return "/artisanat/pages/module.jsp?but=vente/bondecommande-liste.jsp&currentMenu=MNDN000000001072";
    }
    @Override
    public String getUrlAnalyse() {
        return "/artisanat/pages/module.jsp?but=vente/bondecommande-liste.jsp&currentMenu=MNDN000000001072";
    }
    @Override
    public String getUrlSaisie() {
        return "/artisanat/pages/module.jsp?but=vente/bondecommande/bondecommande-saisie.jsp&currentMenu=MNDN000000001071";
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
        return new BonDeCommande();
    }

    public BonDeCommandeFIlleCpl() throws Exception {
        super();
        setNomTable("BC_CLIENT_FILLE_CPL_LIB");
    }

    public String getProduitLib() {
        return produitLib;
    }

    public void setProduitLib(String produitLib) {
        this.produitLib = produitLib;
    }

    public String getCompte(){
        return compte;
    }

    public void setCompte(String compte){
        this.compte=compte;
    }

    public double getQteOfRestante() {
        return qteOfRestante;
    }

    public void setQteOfRestante(double qteOfRestante) {
        this.qteOfRestante = qteOfRestante;
    }

    public double getQteFabRestante() {
        return qteFabRestante;
    }

    public void setQteFabRestante(double qteFabRestante) {
        this.qteFabRestante = qteFabRestante;
    }

    public double getQteNonLivre() {
        return qteNonLivre;
    }

    public void setQteNonLivre(double qteNonLivre) {
        this.qteNonLivre = qteNonLivre;
    }

    public double getMontant() {
        return this.getPu() * this.getQuantite();
    }
}
