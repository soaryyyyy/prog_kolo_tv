package produits;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import duree.DisponibiliteHeure;
import duree.DureeMaxSpot;
import plage.Plage;
import reservation.ReservationDetails;
import reservation.Reservation;
import reservation.Check;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Calendar;

import com.itextpdf.text.pdf.PdfStructTreeController.returnType;

import utils.CalendarUtil;
import vente.VenteDetails;

//@AiTabDesc("La structure de ma table ACTE est comme ceci : ID : string, IDMEDIA : string, IDSUPPORT : string, REMISE : decimal(30,2), DATY : date, IDPRODUIT : string, LIBELLE : string, QTE : decimal, PU : decimal(30,2), ETAT : string, IDCLIENT : string, IDRESERVATION : string, TVA : decimal(10,2), IDRESERVATIONFILLE : string, HEURE : string, DUREE : string.\n")
@AiTabDesc("Nom : La table acte peut etre appeler Diffusion\n" +
        "\tLiaison avec d'autre table :\n" +
        "\t\telle a une liaison avec la table as_ingredient a partir de la colonne idproduit\n" +
        "\t\telle a une liaison avec la table support a partir de la colonne idSupport\n" +
        "\tRegle de gestion :\n" +
        "\t\tUne diffusion ou acte est diffuser lorsque son etat est superieur ou egal a 11")
public class Acte extends ClassEtat implements ClassIA {
    String id;
    String idproduit;
    String libelle;
    String idclient;
    private String libelleproduit,idclientlib,etatlib, idchambre;
    private String idMedia;
    private String idSupport;
    private double remise;
    String idReservationFille;
    String heure;
    String duree;
    String idemission;

    @Override
    public String getNomTableIA() {
        return "ACTE";
    }
    @Override
    public String getUrlListe() {
        return "/pages/module.jsp?but=acte/acte-liste.jsp&currentMenu=ELM001104003";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
//    @Override
//    public String getUrlSaisie() {
//        return "/pages/module.jsp?but=reservation/reservation-simple-saisie.jsp&currentMenu=ELM001104005";
//    }

    public String getIdReservationFille() {
        return idReservationFille;
    }

    public void setIdReservationFille(String idReservationFille) {
        this.idReservationFille = idReservationFille;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) throws Exception {
        if (!CalendarUtil.isValidTime(heure)) {
            throw new Exception("L'heure doit etre de format HH:MM:SS");
        }
        this.heure = heure;
    }

    public String getDuree() {
        return duree;
    }

    public void setDuree(String duree) throws Exception {
        if (!CalendarUtil.isValidTime(duree)) {
            this.duree = duree;
        }
        else {
            this.duree = String.valueOf(CalendarUtil.HMSToSecond(duree));
        }
    }

    public String getIdMedia() {
        return idMedia;
    }

    public void setIdMedia(String idMedia) {
        this.idMedia = idMedia;
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    public String getLibelleproduit() {
        return libelleproduit;
    }
    public void setLibelleproduit(String libelleproduit) {
        this.libelleproduit = libelleproduit;
    }
    public String getIdclientlib() {
        return idclientlib;
    }
    public void setIdclientlib(String idclientlib) {
        this.idclientlib = idclientlib;
    }
    public String getEtatlib() {
        return etatlib;
    }
    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getIdchambre() {
        return idchambre;
    }

    public void setIdchambre(String idchambre) {
        this.idchambre = idchambre;
    }

    /**
     * id Chekc In no ato anatiny
     */
    String idreservation,compte_vente;
    Date daty;
    double pu, qte,tva;

    public double getMontantCalc()
    {
        return this.getPu()*this.getQte();
    }
    public String getCompte_vente() {
        return compte_vente;
    }

    public void setCompte_vente(String compte_vente) {
        this.compte_vente = compte_vente;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception{
        if(this.getMode().compareToIgnoreCase("modif")==0&&qte<=0) throw new Exception("Quantite non valide");
        this.qte = qte;
    }

    public Acte() {
        setNomTable("acte");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getIdclient() {
        return idclient;
    }

    public void setIdclient(String idclient) {
        this.idclient = idclient;
    }

    public String getIdreservation() {
        return idreservation;
    }

    public void setIdreservation(String idreservation) throws Exception {
//        if(this.getMode().compareToIgnoreCase("modif")==0&&idreservation==null||idreservation.compareToIgnoreCase("")==0) throw new Exception("chambre ou check in obligatoire");
        this.idreservation = idreservation;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("ACT", "GETSEQACTE");
        this.setId(makePK(c));
    }
    @Override
    public String[] getMotCles() {
        String[] motCles={"id","libelle"};
        return motCles;
    }

    /***
     * Ity miova group by am location voiture
     * @return
     * @throws Exception
     */
    public vente.VenteDetails genererVenteDetails()throws Exception{
        VenteDetails retour=new VenteDetails();
        retour.setIdProduit(getIdproduit());
        retour.setIdOrigine(this.getId());
        retour.setQte(getQte());
        retour.setTva(getTva());
        retour.setPu(this.getPu());
        retour.setIdDevise("AR");
        retour.setTauxDeChange(1);
        retour.setDesignation(this.getLibelle());
        retour.setCompte(getCompte_vente());
        return retour;
    }

    public Reservation genererReservation() throws Exception{
        Reservation r= new Reservation();
        r.setIdclient(this.getIdclient());
        r.setDaty(this.getDaty());
        r.setRemarque("Reservation sur place");
        return r;
    }
    public ReservationDetails genererReservationDetails(Reservation r) throws Exception{
        ReservationDetails rd= new ReservationDetails();
        rd.setIdmere(r.getId());
        rd.setDaty(this.getDaty());
        rd.setIdproduit(this.getIdproduit());
        rd.setPu(this.getPu());
        rd.setQte(this.getQte());
        rd.setRemarque(this.getLibelle());
        this.setIdreservation(r.getId());
        return rd;
    }

    public void createReservation(String u, Connection c) throws Exception{
        Reservation r = genererReservation();
        r.createObject(u, c);
        ReservationDetails rd = genererReservationDetails(r);
        rd.createObject(u, c);
        r.validerObject(u,c);
    }

    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            if (this.getIdreservation()==null) {
                createReservation(u,c);
            }
            Object o= super.validerObject(u, c);
            if(estOuvert) {c.commit();}
            return o;
        }
        catch (Exception e) {
            c.rollback();
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null){c.close();}
        }
    }

    public void controlleDeDiffusion (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            int dureeDeDiffusion = Integer.parseInt(this.getDuree());
            LocalTime heure_debut = LocalTime.parse(this.getHeure());
            LocalTime heure_fin = heure_debut.plusSeconds(dureeDeDiffusion);
            Acte acte = new Acte();
            acte.setIdSupport(this.getIdSupport());
            Acte [] liste = (Acte[]) CGenUtil.rechercher(acte,null,null,c," AND ETAT=11 AND DATY=TO_DATE('"+this.getDaty()+"', 'YYYY-MM-DD')");
            // Miverifier raha efa misy Diffusion
            for (Acte a:liste){
                LocalTime [] interval = new LocalTime[2];
                interval[0] = LocalTime.parse(a.getHeure());
                interval[1] = interval[0].plusSeconds(Long.parseLong(a.getDuree()));
                if (CalendarUtil.checkTime(heure_debut,interval[0],interval[1]) || CalendarUtil.checkTime(heure_fin,interval[0],interval[1])){
                    throw new Exception("L'heure de la Diffusion de "+this.getIdproduit()+" est deja prise");
                }

                if (CalendarUtil.checkTime(interval[0],heure_debut,heure_fin) || CalendarUtil.checkTime(interval[1],heure_debut,heure_fin)){
                    throw new Exception("L'heure de la Diffusion de "+this.getIdproduit()+" est deja prise");
                }
            }

            // Miverifier duree de diffusion raha ao anaty DureeMaxSpot
            DisponibiliteHeure maxSpot = new DisponibiliteHeure();
            maxSpot.setIdSupport(this.getIdSupport());
            maxSpot.setJour(CalendarUtil.getDayOfWeek(this.getDaty().toLocalDate()));
            maxSpot.setIdCategorieIngredient(this.getProduit(c).getCategorieIngredient());
            DisponibiliteHeure [] dureeMaxSpots = (DisponibiliteHeure[]) CGenUtil.rechercher(maxSpot,null,null,c,"");
            for (DisponibiliteHeure d:dureeMaxSpots){
                LocalTime [] interval = new LocalTime[2];
                interval[0] = LocalTime.parse(d.getHeureDebut());
                interval[1] = LocalTime.parse(d.getHeureFin());
                if (CalendarUtil.checkTime(heure_debut,interval[0],interval[1]) && CalendarUtil.checkTime(heure_fin,interval[0],interval[1])){
                    if (d.getResteDuree() < dureeDeDiffusion){
                        throw new Exception("La duree de la diffusion ne doit pas depasser "+CalendarUtil.secondToHMS((long) d.getResteDuree()));
                    }
                    dureeDeDiffusion = 0;
                }
                else {
                    if (CalendarUtil.checkTime(heure_debut,interval[0],interval[1])){
                        int portionDuree = (int) CalendarUtil.getDuration(heure_debut,interval[1]);
                        if (d.getResteDuree() < portionDuree){
                            throw new Exception("La duree de la diffusion ne doit pas depasser "+CalendarUtil.secondToHMS((long) d.getResteDuree()));
                        }
                        dureeDeDiffusion -= portionDuree;
                    }
                    if (CalendarUtil.checkTime(heure_fin,interval[0],interval[1])){
                        int portionDuree = (int) CalendarUtil.getDuration(interval[0],heure_fin);
                        if (d.getResteDuree() < CalendarUtil.getDuration(interval[0],heure_fin)){
                            throw new Exception("La duree de la diffusion ne doit pas depasser "+CalendarUtil.secondToHMS((long) d.getResteDuree()));
                        }
                        dureeDeDiffusion -= portionDuree;
                    }
                }
            }

            if (dureeDeDiffusion>0){
                throw new Exception("Impossible d'ajouter la diffusion");
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            c.rollback();
            throw ex;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public Ingredients getProduit (Connection c) throws Exception {
        boolean estOuvert = false;

        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            Ingredients acte = new Ingredients();
            acte.setId(this.getIdproduit());
            Ingredients [] list = (Ingredients[]) CGenUtil.rechercher(acte,null,null,c,"");
            if (list.length>0){
                return list[0];
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            c.rollback();
            throw ex;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return null;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
//        if (this.getPu()<=0){
//            Ingredients service = this.getProduit(c);
//            this.setPu(service.getPrixFinal(this.getHeure(),this.getDaty(),this.getIdSupport(),c)*Integer.parseInt(this.getDuree()));
//        }
        return super.createObject(u, c);
    }

    @Override
    public boolean getEstIndexable() {return true;}

    public String getIdemission() {
        return idemission;
    }

    public void setIdemission(String idemission) {
        this.idemission = idemission;
    }

}
