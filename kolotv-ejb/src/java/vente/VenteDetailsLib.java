/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;

import chatbot.ClassIA;
import encaissement.EncaissementDetails;
import utils.ConstanteAsync;

import java.sql.Date;

/**
 *
 * @author Angela
 */
public class VenteDetailsLib  extends VenteDetails implements ClassIA {

    protected String idProduitLib;
    protected String idCategorie;
    protected String idCategorieLib;
    protected double puRevient;
    protected  double puTotal;
    protected Date daty;
    protected String idMagasin;
    protected String idMagasinLib;
    protected String idPoint;
    protected String idPointLib;
    protected double reste,montant,montantTva,montantTtc;
    protected String idUnite;
    protected String idDeviseLib;
    protected String idSupport;
    protected String idSupportLib;

    public String getIdSupportLib() {
        return idSupportLib;
    }

    public void setIdSupportLib(String idSupportLib) {
        this.idSupportLib = idSupportLib;
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    @Override
    public String getNomTableIA() {
        return "VENTE_DETAILS_CPL_2_VISEE";
    }
    @Override
    public String getUrlListe() {
        return "/pages/module.jsp?but=vente/vente-liste.jsp&currentMenu=MNDN000000007";
    }
    @Override
    public String getUrlAnalyse() {
        return "/pages/module.jsp?but=vente/vente-analyse.jsp&currentMenu=MNDN0000000111";
    }
    @Override
    public String getUrlSaisie() {
        return "/pages/module.jsp?but=vente/vente-saisie.jsp&currentMenu=MNDN000000006";
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
    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public String getIdUnite() {
        return idUnite;
    }

    public void setIdUnite(String idUnite) {
        this.idUnite = idUnite;
    }

    public String getIdDeviseLib() {
        return idDeviseLib;
    }

    public void setIdDeviseLib(String idDeviseLib) {
        this.idDeviseLib = idDeviseLib;
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

    public double getPuRevient() {
        return puRevient;
    }

    public void setPuRevient(double puRevient) {
        this.puRevient = puRevient;
    }

    public VenteDetailsLib() {
        this.setNomTable("VENTE_DETAILS_LIB");
    }



    public String getIdProduitLib() {
        return idProduitLib;
    }

    public void setIdProduitLib(String idProduitLib) {
        this.idProduitLib = idProduitLib;
    }

    public double getPuTotal() {
        return puTotal;
    }

    public void setPuTotal(double puTotal) {
        this.puTotal = puTotal;
    }


        public EncaissementDetails generateEncaissementDetails()throws Exception{
        EncaissementDetails encaissementDetails = new EncaissementDetails();
        encaissementDetails.setMontant(montant);
        encaissementDetails.setIdOrigine(this.getId());
        encaissementDetails.setIdDevise(this.getIdDevise());
        encaissementDetails.setRemarque("Encaissement Vente "+this.getIdProduitLib());

        return encaissementDetails;
    }

    public double getMargeBrute() {
        return margeBrute;
    }


}
