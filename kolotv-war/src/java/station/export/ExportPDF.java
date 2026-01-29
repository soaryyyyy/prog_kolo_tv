
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package station.export;

import bean.AdminGen;
import bean.CGenUtil;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import net.sf.jasperreports.engine.JRException;
import reporting.ReportingCdn;
import utilitaire.ChiffreLettre;
import utilitaire.UtilDB;
import utils.ConstanteKolo;
import web.mg.cnaps.servlet.etat.UtilitaireImpression;
import encaissement.*;
import java.util.Arrays;
import org.xhtmlrenderer.css.style.derived.StringValue;
import prelevement.PrelevementPompiste;
import utilitaire.Utilitaire;
import vente.*;
import faturefournisseur.*;
import client.Client;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ExportPDF", urlPatterns = { "/ExportPDF" })
public class ExportPDF extends HttpServlet {
    String nomJasper = "";
    ReportingCdn.Fonctionnalite fonctionnalite = ReportingCdn.Fonctionnalite.RECETTE;

    public String getReportPath() throws IOException {
        return getServletContext().getRealPath(File.separator + "report" + File.separator + getNomJasper() + ".jasper");
    }

    public String getNomJasper() {
        return nomJasper;
    }

    public void setNomJasper(String nomJasper) {
        this.nomJasper = nomJasper;
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String action = request.getParameter("action");
        if (action.equalsIgnoreCase("fiche_encaissement"))
            impressionEncaissement(request, response);
        if (action.equalsIgnoreCase("fiche_encaissement_pompiste"))
            impressionEncaissementPompist(request, response);
        if (action.equalsIgnoreCase("fiche_vente"))
            fiche_vente(request, response);
        if (action.equalsIgnoreCase("fiche_bc"))
            fiche_bc(request, response);
        if (action.equalsIgnoreCase("fiche_bl"))
            fiche_bl(request, response);
        if (action.equalsIgnoreCase("fiche_vente_kprod"))
            fiche_vente_kprod(request, response);
        if (action.equalsIgnoreCase("impression_proforma"))
            impression_proforma(request,response);
        if (action.equalsIgnoreCase("impression_bc"))
            impression_bc(request,response);
    }

    private void fiche_bc(HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        As_BonDeCommandeCpl v = new As_BonDeCommandeCpl();
        v.setNomTable("As_BonDeCommande_MERECPL");
        As_BonDeCommandeCpl[] enc_mere = (As_BonDeCommandeCpl[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");

        if (enc_mere.length > 0) {
            param.put("designation", enc_mere[0].getDesignation());
            param.put("ref", enc_mere[0].getReference());
            param.put("daty", enc_mere[0].getDaty());
            param.put("remarque", enc_mere[0].getRemarque());
            param.put("fournisseur", enc_mere[0].getFournisseurlib());
            param.put("modeP", enc_mere[0].getModepaiementlib());
            param.put("num", id);
            param.put("iddevise", enc_mere[0].getIdDevise());
            param.put("montantHT", enc_mere[0].getMontantHT());
            param.put("montantTVA", enc_mere[0].getMontantTVA());
            param.put("montantTTC", enc_mere[0].getMontantTTC());
            param.put("devise", enc_mere[0].getIdDeviselib());
        }

        As_BonDeCommande_Fille_CPL vf = new As_BonDeCommande_Fille_CPL();
        vf.setNomTable("AS_BONDECOMMANDE_CPL");
        As_BonDeCommande_Fille_CPL[] v_fille = (As_BonDeCommande_Fille_CPL[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idbc = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        setNomJasper("BonDeCommande");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    private void fiche_bl(HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        As_BondeLivraisonClient_Cpl v = new As_BondeLivraisonClient_Cpl();
        v.setNomTable("AS_BONDELIVRAISON_CLIENT_CPL");
        As_BondeLivraisonClient_Cpl[] enc_mere = (As_BondeLivraisonClient_Cpl[]) CGenUtil.rechercher(v, null, null,
                null,
                " AND id = '" + id + "'");
        if (enc_mere.length > 0) {
            param.put("designation", enc_mere[0].getDesignation());
            param.put("daty", enc_mere[0].getDaty());
            param.put("remarque", enc_mere[0].getRemarque());
            param.put("magasin", enc_mere[0].getMagasin());
            param.put("num", id);
        }
        As_BondeLivraisonClientFille_Cpl vf = new As_BondeLivraisonClientFille_Cpl();
        vf.setNomTable("AS_BONLIVRFILLE_CLIENT_CPL");
        As_BondeLivraisonClientFille_Cpl[] v_fille = (As_BondeLivraisonClientFille_Cpl[]) CGenUtil.rechercher(vf, null,
                null, null,
                " AND numbl = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        setNomJasper("BonDeLivraison");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    private void fiche_vente(HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String sans = request.getParameter("sans");
        VenteClient_Lib v = new VenteClient_Lib();
        VenteClient_Lib[] enc_mere = (VenteClient_Lib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
            param.put("daty", enc_mere[0].getDaty());

            long number = Long.parseLong(id.replaceAll("\\D+", ""));
            String annee = Utilitaire.dateDuJour().substring(Utilitaire.dateDuJour().length() - 4);
            String ref = "FACT "+String.valueOf(number)+"/"+annee;

            if (enc_mere[0].getReference() != null && !enc_mere[0].getReference().isEmpty()) {
                ref = enc_mere[0].getReference();
            }
            param.put("numFact", ref);
            param.put("client", enc_mere[0].getIdClientLib());
            param.put("nif",Utilitaire.champNull(enc_mere[0].getNif()));
            param.put("stat", Utilitaire.champNull(enc_mere[0].getStat()));
            param.put("adresse", Utilitaire.champNull(enc_mere[0].getAdresse()));
            param.put("contact", Utilitaire.champNull(enc_mere[0].getContact()));
            param.put("designation", Utilitaire.champNull(enc_mere[0].getRemarque()));
            param.put("montantHT", enc_mere[0].getMontanttotal());
            param.put("montantTVA", enc_mere[0].getMontanttva());
            param.put("montantTTC", enc_mere[0].getMontantTtcAr());
            param.put("echeance", Utilitaire.champNull(enc_mere[0].getEcheance()));
            param.put("reglement", Utilitaire.champNull(enc_mere[0].getReglement()));
            param.put("numBc",  Utilitaire.champNull(enc_mere[0].getReferenceBc()));
            param.put("montantEnLettre","Arr&ecirc;t&eacute;e la pr&eacute;sente facture &agrave; la somme de " + ChiffreLettre.convertRealToString(enc_mere[0].getMontantTtcAr()) + " Ariary");
        }

        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_CPL");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idVente = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        double totalTva = 0;
        double remise = 0; 
        int count = v_fille.length;
        for (VenteDetailsLib vdf : v_fille) {
            if (vdf.getDesignation() != null) {
                String designation = vdf.getDesignation();
                String phraseFormatee = designation.substring(0, 1).toUpperCase() + designation.substring(1);
                vdf.setDesignation(phraseFormatee);
             }

            remise = remise + vdf.getMontantRemise();
            totalTva += vdf.getTva();
        }
         double montantRemise = 0;
         montantRemise = enc_mere[0].getMontanttotal() - remise;
        double moyenneTva = (count > 0) ? totalTva / count : 0;
        param.put("tva", moyenneTva);
        param.put("titre", ConstanteKolo.titre);
        param.put("capital", ConstanteKolo.capital);
        param.put("siege", ConstanteKolo.siege);
        param.put("bp", ConstanteKolo.bp);
        param.put("telephone", ConstanteKolo.telephone);
        param.put("mail", ConstanteKolo.mail);
        param.put("siteweb", ConstanteKolo.siteweb);
        param.put("dg", ConstanteKolo.dg);
        param.put("ville", ConstanteKolo.ville);
        param.put("logoGauche", ConstanteKolo.logoGauche);
        param.put("logoDroite", ConstanteKolo.logoDroite);
        param.put("filigrane", ConstanteKolo.filigrane);
        param.put("filigrane1", ConstanteKolo.filigrane1);
        param.put("rcs",ConstanteKolo.rcs);
        param.put("cif",ConstanteKolo.cif);
        param.put("compteBancaire",ConstanteKolo.compteBancaire);
        param.put("nifKolo",ConstanteKolo.nif);
        param.put("statKolo",ConstanteKolo.stat);
        if (sans.equalsIgnoreCase("true")){
            setNomJasper("factureclient-sans");
            if(remise > 0){
                param.put("totalremise", remise);
                param.put("montantRemise", montantRemise);
                param.put("montantTTC", enc_mere[0].getMontanttva() + montantRemise);
                setNomJasper("factureclient-sans-avec-remise");
            }

        }
        else {
            String currentAppPath = request.getServletContext().getRealPath("/");
            File currentAppDir = new File(currentAppPath);
            File deploymentsDir = currentAppDir.getParentFile();
            String deploymentsPath = deploymentsDir.getAbsolutePath();
            String targetWar = "dossier.war";
            String appRelativePath = "/report";
            String filename = "signature.png";
            String fullPathToSignature = deploymentsPath + File.separator + targetWar + appRelativePath + File.separator + filename;
            File sigFile = new File(fullPathToSignature);
            if (sigFile.exists()) {
                param.put("signature", fullPathToSignature);
            } else {
                // Optionnel : mettre une image par défaut ou laisser vide
                param.put("signature", null);
                System.out.println("Attention : La signature n'a pas été trouvée à : " + fullPathToSignature);
            }
            setNomJasper("factureclient");
            if(remise > 0){
                param.put("totalremise", remise);
                param.put("montantRemise", montantRemise);
                param.put("montantTTC", enc_mere[0].getMontanttva() + montantRemise);
                setNomJasper("factureclient-avec-remise");
             }
            
        }
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    private void impression_proforma (HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String type= request.getParameter("type");
        String sans= request.getParameter("sans");

        ProformaCpl p = new ProformaCpl();
        p.setNomTable("Proforma_CPL");
        ProformaCpl[] enc_mere = (ProformaCpl[]) CGenUtil.rechercher(p, null, null, null,
                " AND ID = '" + id + "'");
        System.out.println("ID = " + id);
        System.out.println("Taille = " + enc_mere.length);
        if (enc_mere.length > 0) {
            param.put("daty", enc_mere[0].getDaty());
            param.put("numFact", enc_mere[0].getDesignation());
            param.put("client", enc_mere[0].getIdClientLib());
            param.put("nif", enc_mere[0].getNif());
            param.put("stat", enc_mere[0].getStat());
            param.put("adresse", enc_mere[0].getAdresse());
            param.put("contact", enc_mere[0].getContact());
            param.put("designation", enc_mere[0].getRemarque());
            if(enc_mere[0].getEcheance()!=null){
                param.put("echeance", enc_mere[0].getEcheance());
            }
            else{
                param.put("echeance", "");
            }
            if(enc_mere[0].getReglement()!=null){
                param.put("reglement", enc_mere[0].getReglement());
            }
            else{
                param.put("reglement", "");
            }
            String idOrigine = enc_mere[0].getIdOrigine();
            if (idOrigine != null && idOrigine.startsWith("FCBC")) {
                param.put("numBc", idOrigine);
            } else {
                param.put("numBc", "");
            }

            if (type.equalsIgnoreCase("smpc")){
                param.put("montantHT", enc_mere[0].getMontanttotal());
                param.put("montantTVA", enc_mere[0].getMontanttva());
            }
            param.put("montantHT", enc_mere[0].getMontanttotal());
            param.put("montantTTC", enc_mere[0].getMontantTtcAr());
            param.put("montantEnLettre","Arr&ecirc;t&eacute; le pr&eacute;sent devis &agrave; la somme de " + ChiffreLettre.convertRealToString(enc_mere[0].getMontantTtcAr()) + " Ariary");

            if (enc_mere[0].getIdOrigine()!= null && enc_mere[0].getIdOrigine().startsWith("FCBC")){
                BonDeCommande b = new BonDeCommande();
                BonDeCommande[] bs = (BonDeCommande[]) CGenUtil.rechercher(b, null, null, null,
                        " AND id = '" + enc_mere[0].getIdOrigine() + "'");

                if (bs.length > 0){
                    param.put("numBc",bs[0].getReference());
                }
            }
        }
        ProformaDetailsCpl pd = new ProformaDetailsCpl();
        pd.setNomTable("ProformaDetails_CPL");
        ProformaDetailsCpl[] p_fille = (ProformaDetailsCpl[]) CGenUtil.rechercher(pd, null, null, null,
                " AND IDPROFORMA = '" + id + "'");
        dataSource.addAll(Arrays.asList(p_fille));
        double remise = 0;
        for (ProformaDetailsCpl vdf : p_fille) {
            remise = remise + vdf.getMontantRemise();
        }
        param.put("totalremise", remise);
        double montantRemise = 0;
        montantRemise = enc_mere[0].getMontanttotal() - remise;
        if (type.equalsIgnoreCase("smpc")){
            double totalTva = 0;
            int count = p_fille.length;
            for (ProformaDetailsCpl pcpl : p_fille) {
                totalTva += pcpl.getTva();
            }

            double moyenneTva = (count > 0) ? totalTva / count : 0;
            param.put("tva", moyenneTva);
            param.put("titre", ConstanteKolo.titre);
            param.put("capital", ConstanteKolo.capital);
            param.put("siege", ConstanteKolo.siege);
            param.put("bp", ConstanteKolo.bp);
            param.put("telephone", ConstanteKolo.telephone);
            param.put("mail", ConstanteKolo.mail);
            param.put("siteweb", ConstanteKolo.siteweb);
            param.put("dg", ConstanteKolo.dg);
            param.put("ville", ConstanteKolo.ville);
            param.put("logoGauche", ConstanteKolo.logoGauche);
            param.put("logoDroite", ConstanteKolo.logoDroite);
            param.put("filigrane", ConstanteKolo.filigrane);
            param.put("filigrane1", ConstanteKolo.filigrane1);
            param.put("rcs",ConstanteKolo.rcs);
            param.put("cif",ConstanteKolo.cif);
            param.put("compteBancaire",ConstanteKolo.compteBancaire);
            param.put("nifKolo",ConstanteKolo.nif);
            param.put("statKolo",ConstanteKolo.stat);

            if (sans.equalsIgnoreCase("true")){
                setNomJasper("proforma-smpc-sans");
                if(remise > 0){
                    param.put("totalremise", remise);
                    param.put("montantRemise", montantRemise);
                    param.put("montantTTC", enc_mere[0].getMontanttva() + montantRemise);
                    setNomJasper("proformasmpc-sans-avec-remise");
                }
            }
            else {
                setNomJasper("proforma-smpc");
                if(remise > 0){
                    param.put("totalremise", remise);
                    param.put("montantRemise", montantRemise);
                    param.put("montantTTC", enc_mere[0].getMontanttva() + montantRemise);
                    setNomJasper("proformasmpc-avec-remise");
                }
            }
        } else if (type.equalsIgnoreCase("kprod")) {
            param.put("titre", ConstanteKolo.titrekprod);
            param.put("capital", ConstanteKolo.capitalkprod);
            param.put("siege", ConstanteKolo.siege);
            param.put("bp", ConstanteKolo.bp);
            param.put("mail", ConstanteKolo.mailkprod);
            param.put("siteweb", ConstanteKolo.siteweb);
            param.put("dg", ConstanteKolo.dgkprod);
            param.put("ville", ConstanteKolo.ville);
            param.put("logoGauche", ConstanteKolo.logoGaucheKprod);
            param.put("filigrane", ConstanteKolo.filigraneKprod);
            param.put("filigrane1", ConstanteKolo.filigrane1);
            param.put("compteBancairekprod",ConstanteKolo.compteBancairekprod);
            param.put("nifkprod",ConstanteKolo.nifkprod);
            param.put("statkprod",ConstanteKolo.statkprod);
            param.put("rcskprod",ConstanteKolo.rcskprod);
            param.put("cifkprod",ConstanteKolo.cifkprod);
            if (sans.equalsIgnoreCase("true")){
                setNomJasper("proforma-kprod-sans");
                if(remise > 0){
                    param.put("totalremise", remise);
                    param.put("montantRemise", montantRemise);
                    //param.put("montantTTC", enc_mere[0].getMontanttva() + montantRemise);
                    setNomJasper("proformaKprod-sans-avec-remise");
                }
            }
            else {
                setNomJasper("proforma-kprod");
                    if(remise > 0){
                    param.put("totalremise", remise);
                    param.put("montantRemise", montantRemise);
                    //param.put("montantTTC", enc_mere[0].getMontanttva() + montantRemise);
                    setNomJasper("proformakprod-avec-remise");
                }
            }
        }

        System.out.println("type="+type);
        System.out.println(param);

        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }
    private void impression_bc (HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String type= request.getParameter("type");
        String sans= request.getParameter("sans");

        BonDeCommandeCpl p = new BonDeCommandeCpl();
        p.setNomTable("BONDECOMMANDE_CLIENT_CPL");
        BonDeCommandeCpl[] enc_mere = (BonDeCommandeCpl[]) CGenUtil.rechercher(p, null, null, null,
                " AND ID = '" + id + "'");
        Client cl = new Client();
        cl.setNomTable("client");
        Client[] client = (Client[]) CGenUtil.rechercher(cl, null, null, null,
                " AND ID = '" + enc_mere[0].getIdClient() + "'");
        BonDeCommandeFIlleCpl pd = new BonDeCommandeFIlleCpl();
            pd.setNomTable("BC_CLIENT_FILLE_CPL_LIB2");
            BonDeCommandeFIlleCpl[] p_fille = (BonDeCommandeFIlleCpl[]) CGenUtil.rechercher(pd, null, null, null,
                    " AND idbc = '" + id + "'");
        double remise = 0;
        double montantHT = 0;
        if (enc_mere.length > 0) {
            param.put("daty", enc_mere[0].getDaty());
            param.put("numFact", enc_mere[0].getReference());
            param.put("client", enc_mere[0].getIdclientlib());
            param.put("nif", client[0].getNif());
            param.put("stat", client[0].getStat());
            param.put("adresse", client[0].getAdresse());
            param.put("contact", client[0].getTelephone());
            param.put("designation", enc_mere[0].getRemarque());
            
            if(enc_mere[0].getEcheance()!=null){
                param.put("echeance", enc_mere[0].getEcheance());
            }
            else{
                param.put("echeance", "");
            }
            if(enc_mere[0].getModereglement()!=null){
                param.put("reglement", enc_mere[0].getModereglement());
            }
            else{
                param.put("reglement", "");
            }
            /*String idOrigine = enc_mere[0].getIdOrigine();
            if (idOrigine != null && idOrigine.startsWith("FCBC")) {
                param.put("numBc", idOrigine);
            } else {
                param.put("numBc", "");
            }*/
            
            dataSource.addAll(Arrays.asList(p_fille));
            
            double montantTVA = 0;
            double montantTTC = 0;
            
        
             for (BonDeCommandeFIlleCpl f : p_fille) {
                montantHT += f.getMontantHt();
                montantTVA += f.getMontantTva();
                montantTTC += f.getMontantTtc();
                remise = remise + f.getRemise();
            }
            if (type.equalsIgnoreCase("smpc")){
           
                param.put("montantHT", montantHT);
                param.put("montantTVA", montantTVA);
                
            }
            param.put("montantTTC", montantTTC);
            param.put("montantEnLettre","Arr&ecirc;t&eacute; le pr&eacute;sent devis &agrave; la somme de " + ChiffreLettre.convertRealToString(montantTTC) + " Ariary");

            /*if (enc_mere[0].getIdOrigine()!= null && enc_mere[0].getIdOrigine().startsWith("FCBC")){
                BonDeCommande b = new BonDeCommande();
                BonDeCommande[] bs = (BonDeCommande[]) CGenUtil.rechercher(b, null, null, null,
                        " AND id = '" + enc_mere[0].getIdOrigine() + "'");

                if (bs.length > 0){
                    param.put("numBc",bs[0].getReference());
                }
            }*/
        }

      
        if (type.equalsIgnoreCase("smpc")){
            double totalTva = 0;
            int count = p_fille.length;
            for (BonDeCommandeFIlleCpl pcpl : p_fille) {
                totalTva += pcpl.getTva();
            }

            double moyenneTva = (count > 0) ? totalTva / count : 0;
            param.put("tva", moyenneTva);
            param.put("titre", ConstanteKolo.titre);
            param.put("capital", ConstanteKolo.capital);
            param.put("siege", ConstanteKolo.siege);
            param.put("bp", ConstanteKolo.bp);
            param.put("telephone", ConstanteKolo.telephone);
            param.put("mail", ConstanteKolo.mail);
            param.put("siteweb", ConstanteKolo.siteweb);
            param.put("dg", ConstanteKolo.dg);
            param.put("ville", ConstanteKolo.ville);
            param.put("logoGauche", ConstanteKolo.logoGauche);
            param.put("logoDroite", ConstanteKolo.logoDroite);
            param.put("filigrane", ConstanteKolo.filigrane);
            param.put("filigrane1", ConstanteKolo.filigrane1);
            param.put("rcs",ConstanteKolo.rcs);
            param.put("cif",ConstanteKolo.cif);
            param.put("compteBancaire",ConstanteKolo.compteBancaire);
            param.put("nifKolo",ConstanteKolo.nif);
            param.put("statKolo",ConstanteKolo.stat);

            if (sans.equalsIgnoreCase("true")){
                setNomJasper("bc-smpc-sans");
                 if(remise > 0){
                param.put("totalremise", remise);
                param.put("montantRemise", montantHT - remise);
                setNomJasper("bcsmpc-sans-avec-remise");
            }
            }
            else {
                String currentAppPath = request.getServletContext().getRealPath("/");
                File currentAppDir = new File(currentAppPath);
                File deploymentsDir = currentAppDir.getParentFile();
                String deploymentsPath = deploymentsDir.getAbsolutePath();
                String targetWar = "dossier.war";
                String appRelativePath = "/report";
                String filename = "signature.png";
                String fullPathToSignature = deploymentsPath + File.separator + targetWar + appRelativePath + File.separator + filename;
                File sigFile = new File(fullPathToSignature);
                if (sigFile.exists()) {
                    param.put("signature", fullPathToSignature);
                } else {
                    // Optionnel : mettre une image par défaut ou laisser vide
                    param.put("signature", null);
                    System.out.println("Attention : La signature n'a pas été trouvée à : " + fullPathToSignature);
                }
                setNomJasper("bc-smpc");
                 if(remise > 0){
                    param.put("totalremise", remise);
                    param.put("montantRemise", montantHT - remise);
                    setNomJasper("bcsmpc-avec-remise");
                }
            }
        } else if (type.equalsIgnoreCase("kprod")) {
            param.put("titre", ConstanteKolo.titrekprod);
            param.put("capital", ConstanteKolo.capitalkprod);
            param.put("siege", ConstanteKolo.siege);
            param.put("bp", ConstanteKolo.bp);
            param.put("mail", ConstanteKolo.mailkprod);
            param.put("siteweb", ConstanteKolo.siteweb);
            param.put("dg", ConstanteKolo.dgkprod);
            param.put("ville", ConstanteKolo.ville);
            param.put("logoGauche", ConstanteKolo.logoGaucheKprod);
            param.put("filigrane", ConstanteKolo.filigraneKprod);
            param.put("filigrane1", ConstanteKolo.filigrane1);
            param.put("compteBancairekprod",ConstanteKolo.compteBancairekprod);
            param.put("nifkprod",ConstanteKolo.nifkprod);
            param.put("statkprod",ConstanteKolo.statkprod);
            param.put("rcskprod",ConstanteKolo.rcskprod);
            param.put("cifkprod",ConstanteKolo.cifkprod);
            if (sans.equalsIgnoreCase("true")){
                setNomJasper("bc-kprod-sans");
                 if(remise > 0){
                    param.put("totalremise", remise);
                    param.put("montantRemise", montantHT - remise);
                    param.put("montantHT", montantHT);
                    setNomJasper("bcKprod-sans-avec-remise");
                }
            }
            else {
                String currentAppPath = request.getServletContext().getRealPath("/");
                File currentAppDir = new File(currentAppPath);
                File deploymentsDir = currentAppDir.getParentFile();
                String deploymentsPath = deploymentsDir.getAbsolutePath();
                String targetWar = "dossier.war";
                String appRelativePath = "/report";
                String filename = "signature.png";
                String fullPathToSignature = deploymentsPath + File.separator + targetWar + appRelativePath + File.separator + filename;
                File sigFile = new File(fullPathToSignature);
                if (sigFile.exists()) {
                    param.put("signature", fullPathToSignature);
                } else {
                    // Optionnel : mettre une image par défaut ou laisser vide
                    param.put("signature", null);
                    System.out.println("Attention : La signature n'a pas été trouvée à : " + fullPathToSignature);
                }
                setNomJasper("bc-kprod");
                 if(remise > 0){
                    param.put("totalremise", remise);
                    param.put("montantRemise", montantHT - remise);
                    param.put("montantHT", montantHT);
                    setNomJasper("bckprod-avec-remise");
                }
            }
        }

        System.out.println("type="+type);
        System.out.println(param);

        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }


    private void impressionEncaissement(HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        EncaissementLib eM = new EncaissementLib();
        eM.setNomTable("ENCAISSEMENT_LIB");
        EncaissementLib[] enc_mere = (EncaissementLib[]) CGenUtil.rechercher(eM, null, null, null,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
            param.put("carburants", Utilitaire.formaterAr(enc_mere[0].getVenteCarburant()));
            param.put("lubrifiants", Utilitaire.formaterAr(enc_mere[0].getVenteLubrifiant()));
            param.put("totalrecette", Utilitaire.formaterAr(enc_mere[0].getTotalRecette()));
            param.put("depense", Utilitaire.formaterAr(enc_mere[0].getDepense()));
            param.put("montantecart", Utilitaire.formaterAr(enc_mere[0].getEcart()));
            param.put("versement", Utilitaire.formaterAr(enc_mere[0].getTotalVersement()));

        }
        EncaissementDetailsLib eF = new EncaissementDetailsLib();
        eF.setNomTable("Encaissement_Details_Lib");
        EncaissementDetailsLib[] enc_fille = (EncaissementDetailsLib[]) CGenUtil.rechercher(eF, null, null, null,
                " AND idEncaissement = '" + id + "'");
        dataSource.addAll(Arrays.asList(enc_fille));
        setNomJasper("encaissement");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    private void impressionEncaissementPompist(HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        EncaissementFichePdf eM = new EncaissementFichePdf();

        EncaissementFichePdf[] enc_mere = (EncaissementFichePdf[]) CGenUtil.rechercher(eM, null, null, null,
                " AND ID = '" + id + "'");

        EncaissementReport er = new EncaissementReport();
        er.setId(id);
        er.init(c);

        if (enc_mere.length > 0) {
            param.put("date", enc_mere[0].getDaty());
            param.put("nom", enc_mere[0].getIdPompisteLib());
            param.put("ecart", enc_mere[0].getEcart());
            param.put("versement", enc_mere[0].getTotalVersement());
            param.put("espece", enc_mere[0].getTotalEspece());
            param.put("om", enc_mere[0].getTotalOrangeMoney());
        }

        dataSource.add(er);

        setNomJasper("encaissementPompiste");
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    private void fiche_vente_kprod(HttpServletRequest request, HttpServletResponse response)
            throws IOException, JRException, Exception {
        Connection c = null;
        Map param = new HashMap();
        List dataSource = new ArrayList();
        String id = request.getParameter("id");
        String sans = request.getParameter("sans");
        VenteClient_Lib v = new VenteClient_Lib();
        VenteClient_Lib[] enc_mere = (VenteClient_Lib[]) CGenUtil.rechercher(v, null, null, null,
                " AND ID = '" + id + "'");
        if (enc_mere.length > 0) {
            param.put("daty", enc_mere[0].getDaty());
            long number = Long.parseLong(id.replaceAll("\\D+", ""));
            String annee = Utilitaire.dateDuJour().substring(Utilitaire.dateDuJour().length() - 4);
            String ref = "FACT "+String.valueOf(number)+"/"+annee;

            if (enc_mere[0].getReference() != null && !enc_mere[0].getReference().isEmpty()) {
                ref = enc_mere[0].getReference();
            }
            param.put("numFact", ref);
            param.put("nif", enc_mere[0].getNif());
            param.put("stat", enc_mere[0].getStat());
            param.put("client", enc_mere[0].getIdClientLib());
            param.put("adresse", Utilitaire.champNull(enc_mere[0].getAdresse()));
            param.put("contact", Utilitaire.champNull(enc_mere[0].getContact()));
            param.put("designation", Utilitaire.champNull(enc_mere[0].getRemarque()));
            param.put("montantHT", enc_mere[0].getMontanttotal());
            param.put("montantTTC", enc_mere[0].getMontantTtcAr());
            param.put("echeance", Utilitaire.champNull(enc_mere[0].getEcheance()));
            param.put("reglement", Utilitaire.champNull(enc_mere[0].getReglement()));
             param.put("montantEnLettre","Arr&ecirc;t&eacute;e la pr&eacute;sente facture &agrave; la somme de " + ChiffreLettre.convertRealToString(enc_mere[0].getMontantTtcAr()) + " Ariary");
        }

        VenteDetailsLib vf = new VenteDetailsLib();
        vf.setNomTable("VENTE_DETAILS_CPL");
        VenteDetailsLib[] v_fille = (VenteDetailsLib[]) CGenUtil.rechercher(vf, null, null, null,
                " AND idVente = '" + id + "'");
        dataSource.addAll(Arrays.asList(v_fille));
        double remise = 0;
        for (VenteDetailsLib vdf : v_fille) {
             if (vdf.getDesignation() != null) {
                String designation = vdf.getDesignation();
                String phraseFormatee = designation.substring(0, 1).toUpperCase() + designation.substring(1);
                vdf.setDesignation(phraseFormatee);
             
             }
            remise = remise + vdf.getMontantRemise();
        }
        param.put("totalremise", remise);
        double montantRemise = 0;
        montantRemise = enc_mere[0].getMontanttotal() - remise;

        param.put("titre", ConstanteKolo.titrekprod);
        param.put("capital", ConstanteKolo.capitalkprod);
        param.put("siege", ConstanteKolo.siege);
        param.put("bp", ConstanteKolo.bp);
        param.put("mail", ConstanteKolo.mailkprod);
        param.put("siteweb", ConstanteKolo.siteweb);
        param.put("dg", ConstanteKolo.dgkprod);
        param.put("ville", ConstanteKolo.ville);
        param.put("logoGauche", ConstanteKolo.logoGaucheKprod);
        param.put("filigrane", ConstanteKolo.filigraneKprod);
        param.put("filigrane1", ConstanteKolo.filigrane1);
        param.put("compteBancairekprod",ConstanteKolo.compteBancairekprod);
        param.put("nifkprod",ConstanteKolo.nifkprod);
        param.put("statkprod",ConstanteKolo.statkprod);
        param.put("rcskprod",ConstanteKolo.rcskprod);
        param.put("cifkprod",ConstanteKolo.cifkprod);
        param.put("telephone",ConstanteKolo.telephone);
        if (sans.equalsIgnoreCase("true")){
            setNomJasper("factureKprod-sans");
            if(remise > 0){
                param.put("totalremise", remise);
                param.put("montantRemise", montantRemise);
                //param.put("montantTTC", enc_mere[0].getMontanttva() + montantRemise);
                setNomJasper("factureKprod-sans-avec-remise");
            }

        }
        else {
            String currentAppPath = request.getServletContext().getRealPath("/");
            File currentAppDir = new File(currentAppPath);
            File deploymentsDir = currentAppDir.getParentFile();
            String deploymentsPath = deploymentsDir.getAbsolutePath();
            String targetWar = "dossier.war";
            String appRelativePath = "/report";
            String filename = "signature.png";
            String fullPathToSignature = deploymentsPath + File.separator + targetWar + appRelativePath + File.separator + filename;
            File sigFile = new File(fullPathToSignature);
            if (sigFile.exists()) {
                param.put("signature", fullPathToSignature);
            } else {
                // Optionnel : mettre une image par défaut ou laisser vide
                param.put("signature", null);
                System.out.println("Attention : La signature n'a pas été trouvée à : " + fullPathToSignature);
            }
            setNomJasper("factureKprod");
            if(remise > 0){
                param.put("totalremise", remise);
                param.put("montantRemise", montantRemise);
                //param.put("montantTTC", enc_mere[0].getMontanttva() + montantRemise);
                setNomJasper("factureKprod-avec-remise");
             }
            
        }
        UtilitaireImpression.imprimer(request, response, getNomJasper(), param, dataSource, getReportPath());
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the
    // + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ExportPDF.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request  servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException      if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(ExportPDF.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
