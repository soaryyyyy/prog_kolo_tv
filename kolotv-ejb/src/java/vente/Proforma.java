/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package vente;

import bean.CGenUtil;
import bean.ClassMere;
import client.Client;

import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Toky20
 */
public class Proforma extends ClassMere {
    protected String id;
    protected String designation;
    protected String idMagasin;
    java.sql.Date daty;
    protected String remarque;
    protected String idOrigine;
    protected String idClient;
    int estPrevu;
    protected String idReservation;
    private String echeance;
    private String reglement;
    java.sql.Date datyPrevu;
    protected double montantttc, montanttva, montantht,montantttcAr;
    protected String compte;
    protected double  tauxdechange;
    protected ProformaDetails[] proformaDetails;
    double montantRevient;
    double margeBrute;

    public String getLiaisonFille() {
        return "idProforma";
    }

    public String getNomClasseFille() {
        return "vente.ProformaDetails";
    }

    @Override
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        try{
            this.setNomTable("PROFORMA");
            return super.updateToTableWithHisto(refUser, c);
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
    }

    public String getEcheance() {
        return echeance;
    }

    public void setEcheance(String echeance) {
        this.echeance = echeance;
    }

    public String getReglement() {
        return reglement;
    }

    public void setReglement(String reglement) {
        this.reglement = reglement;
    }

    public void setMargeBrute(double margeBrute) {
        this.margeBrute = margeBrute;
    }

    public double getMontantRevient() {
        return montantRevient;
    }

    public void setMontantRevient(double montantRevient) {
        this.montantRevient = montantRevient;
    }

    @Override
    public boolean isSynchro(){
        return true;
    }


    public String getTiers(){
        return this.getIdClient();
    }
    @Override
    public String getSensPrev(){
        return "credit";
    }

    public String getIdReservation() {
        return this.idReservation;
    }

    public void setIdReservation(String idReservation) {
        this.idReservation = idReservation;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Date getDatyPrevu() {
        return datyPrevu;
    }

    public void setDatyPrevu(Date datyPrevu) {
        this.datyPrevu = datyPrevu;
    }

    public double getMontantttc() {
        return montantttc;
    }

    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }

    public double getMontanttva() {
        return montanttva;
    }

    public void setMontanttva(double montanttva) {
        this.montanttva = montanttva;
    }

    public double getMontantht() {
        return montantht;
    }

    public void setMontantht(double montantht) {
        this.montantht = montantht;
    }

    public double getMontantttcAr() {
        return montantttcAr;
    }

    public void setMontantttcAr(double montantttcAr) {
        this.montantttcAr = montantttcAr;
    }

    public double getMargeBrute() {
        return margeBrute;
    }


    public String getCompte() {
        return compte;
    }


    public void setCompte(String compte) {
        this.compte = compte;
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) throws Exception {
        if(this.getMode().compareTo("modif")==0)
        {
            if(idClient==null||idClient.compareToIgnoreCase("")==0)
                throw new Exception("Client obligatoire");
        }
        this.idClient = idClient;
    }

    public Proforma() {
        this.setNomTable("PROFORMA");
    }

    public Proforma(String nomtable) {
        setNomTable(nomtable);
    }

    public int getEstPrevu() {
	 return estPrevu;
    }

    public void setEstPrevu(int estPrevu) {
	 this.estPrevu = estPrevu;
    }

    public String getIdMagasin() {
        return idMagasin;
    }

    public void setIdMagasin(String idMagasin) {
        this.idMagasin = idMagasin;
    }

    public double getTauxdechange() {
        return tauxdechange;
    }

    public void setTauxdechange(double tauxdechange) {
        this.tauxdechange = tauxdechange;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    @Override
    public String getTuppleID() {
        return this.getId();
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getIdOrigine() {
        return idOrigine;
    }

    public void setIdOrigine(String idOrigine) {
        this.idOrigine = idOrigine;
    }


    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PRF", "getSEQ_PROFORMA");
        this.setId(makePK(c));
    }


    public ProformaDetails[] getProformaDetails() {
        return proformaDetails;
    }

    public void setProformaDetails(ProformaDetails[] proformaDetails) {
        this.proformaDetails = proformaDetails;
    }

    @Override
    public void controler(Connection c) throws Exception {
        super.controler(c);
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        super.controlerUpdate(c);

    }


    public Client getClient(Connection c) throws Exception{
        Client client = new Client();
        Client[] clients = (Client[]) CGenUtil.rechercher(client,null,null,c, " and id = '"+this.getIdClient()+"'");
        if(clients.length > 0){
            return clients[0];
        }
        throw new Exception("Le client n'existe pas");
    }


    public static Proforma getById(Connection c, String id) throws Exception{
        Proforma vtn = new Proforma();
           try{
            vtn.setId(id);
            vtn = ((Proforma[]) CGenUtil.rechercher(vtn, null, null, c, "")).length > 0 ? (Proforma)((Proforma[]) CGenUtil.rechercher(vtn, null, null, c, ""))[0] : null;
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return vtn;
    }
    
    public ProformaDetails[] getVenteDetailsNonGrp(Connection c) throws Exception{
        ProformaDetails[] venteDetails = null;
           try{
            String awhere = " and IDVENTE = '"+this.getId()+"'";
            venteDetails = (ProformaDetails[]) CGenUtil.rechercher(new ProformaDetails(), null, null, c, awhere);
            this.setProformaDetails(venteDetails);
        }catch(Exception e){
            e.printStackTrace();
            throw e;
        }
        return venteDetails;
    }

     public String getDesignation() {
         return designation;
     }

     public void setDesignation(String designation) {
         this.designation = designation;
     }

    double tva;
    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public vente.BonDeCommandeFille[] genererBondeCommandeDetails(Connection c)throws Exception {
        List<vente.BonDeCommandeFille> retour=new ArrayList<>();
        ProformaDetails[] proformaDetails = this.getProformaDetails(c);
        for (ProformaDetails proformaDetail : proformaDetails) {
            BonDeCommandeFille bcFille = new BonDeCommandeFille();
            bcFille.setProduit(proformaDetail.getIdProduit());
            bcFille.setQuantite(proformaDetail.getQte());
            bcFille.setPu(proformaDetail.getPu());
            bcFille.setTva(proformaDetail.getTva());
            retour.add(bcFille);
        }
        return retour.toArray(new vente.BonDeCommandeFille[]{});
    }

    public ProformaDetails[] getProformaDetails(Connection c) throws Exception{
        ProformaDetails rd = new ProformaDetails();
        rd.setIdProforma(this.getId());
        ProformaDetails [] proformaDetails = (ProformaDetails[]) CGenUtil.rechercher(rd,null,null,c,"");
        return proformaDetails;
    }
}
