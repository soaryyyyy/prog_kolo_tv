package reservation;

import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import bean.GenUtil;
import client.Client;
import duree.DisponibiliteHeure;
import historique.Objet;
import magasin.Magasin;
import media.Media;
import mg.cnaps.compta.ecriture.ComptaEcritureFille;
import plage.Plage;
import produits.Acte;
import produits.DisponibiliteChambre;
import produits.Ingredients;
import utilitaire.Constante;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.CalendarUtil;
import utils.ConstanteKolo;
import utils.ConstanteStation;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.time.*;

public class ReservationDetails extends ClassFille {
    String id;
    String idmere;
    String idproduit;
    String remarque;
    String heure;
    double qte, pu;
    Date daty;
    private String duree;
    private double remise;
    private String idBcFille;
    String idparrainage;
    String source;
    String idMedia;
    int isDependant;
    int isEntete;
    int ordre;

    public int getOrdre() {
        return ordre;
    }

    public void setOrdre(int ordre) {
        this.ordre = ordre;
    }

    public int getIsEntete() {
        return isEntete;
    }
    public void setIsEntete(int isEntete) {
        this.isEntete = isEntete;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getIdMedia() {
        return idMedia;
    }

    public void setIdMedia(String idMedia) {
        this.idMedia = idMedia;
    }

    public String getDuree() {
        return duree;
    }


    public void setHeure(String heure) throws Exception {
        if (!CalendarUtil.isValidTime(heure)) {
            throw new Exception("L' heure doit etre de format HH:MM:SS");
        }
        this.heure = heure;
    }

    public void setDuree(String duree) throws Exception {
        if (!CalendarUtil.isValidTime(duree)) {
            this.duree = duree;
        }
        else {
            this.duree = String.valueOf(CalendarUtil.HMSToSecond(duree));
        }
    }

    public double getRemise() {
        return remise;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    public String getIdBcFille() {
        return idBcFille;
    }

    public void setIdBcFille(String idBcFille) {
        this.idBcFille = idBcFille;
    }

    public double getMontantCalcule()
    {
        return this.getQte()*this.getPu();
    }

    public String getId() {
        return id;
    }
    public String getHeure() {
        return heure;
    }


    public void setId(String id) {
        this.id = id;
    }

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduits) {
        this.idproduit = idproduits;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if(this.getMode().equals("modif")){
            if(qte <= 0){
                throw new Exception("Quantité insuffisante pour une ligne");
            }
        }
        this.qte = qte;
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

    public void setPu(double pu) throws Exception {
//        if(this.getMode().equals("modif")){
//            if(pu < 0){
//                throw new Exception("Prix unitaire invalide pour une ligne");
//            }
//        }
        this.pu = pu;
    }

    public ReservationDetails() throws Exception {
        setNomTable("reservationdetails");
        setLiaisonMere("idmere");
        setNomClasseMere("reservation.Reservation");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("RESADET", "GETSEQRESERVATIONDETAILS");
        this.setId(makePK(c));
    }
    public List<ReservationDetails> decomposer() throws Exception {
        List<ReservationDetails> res = new ArrayList<ReservationDetails>();
        for(int i=1;i<=this.getQte();i++) {
            ReservationDetails r = (ReservationDetails) this.dupliquerSansBase();
            r.setQte(1);
            r.setDaty(Utilitaire.ajoutJourDate(this.getDaty(),i-1));
            res.add(r);
        }
        return res;
    }
    public ReservationDetails[] decomposerEnTableau() throws Exception {
        List<ReservationDetails> res=decomposer();
        return res.toArray (new ReservationDetails[res.size()]);
    }

    public Acte genererDiffusionAvecControl(Connection c) throws Exception {
        Acte acte = new Acte();
        Reservation mere = new Reservation();
        mere.setId(this.getIdmere());
        mere = (Reservation) CGenUtil.rechercher(mere,null,null,c,"")[0];
        acte.setIdproduit(this.getIdproduit());
        acte.setLibelle("Diffusion depuis la reservation "+this.getId());
        acte.setIdclient(mere.getIdclient());
        acte.setIdSupport(mere.getIdSupport());
        acte.setHeure(this.getHeure());
        acte.setDuree(String.valueOf(this.getDureeFinal(c)));
        acte.setPu(this.getPu());
        acte.setQte(this.getQte());
        acte.setDaty(this.getDaty());
        acte.setIdReservationFille(this.getId());
        acte.setIdreservation(this.getIdmere());
        acte.setRemise(this.getRemise());
//        acte.controlleDeDiffusion(c);
        return acte;
    }

    public void diffuser(String user,Connection c) throws Exception {
        boolean estOuvert = false;
        if (Utilitaire.compareDaty(Utilitaire.dateDuJourSql(), this.getDaty())==-1) {
            throw new Exception("Pour diffuser cette reservation: sa date doit etre superieure ou egal a la date du jour");
        }
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            if (this.getDiffusion(c)==null) {
                Acte acte = this.genererDiffusionAvecControl(c);
                acte.setEtat(ConstanteEtat.getEtatValider());
                acte = (Acte) acte.createObject(user,c);
                this.updateEtat(ConstanteKolo.etatDiffuser,this.getId(),c);
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

    public ReservationDetails dupliquer() throws Exception {
        ReservationDetails new_fille = new ReservationDetails();
        new_fille.setQte(this.getQte());
        new_fille.setIdproduit(this.getIdproduit());
        new_fille.setDaty(this.getDaty());
        new_fille.setPu(this.getPu());
        new_fille.setDuree(this.getDuree());
        new_fille.setHeure(this.getHeure());
        new_fille.setIdBcFille(this.getIdBcFille());
        new_fille.setRemarque(this.getRemarque());
        new_fille.setRemise(this.getRemise());
        new_fille.setIdMedia(this.getIdMedia());
        new_fille.setIdparrainage(this.getIdparrainage());
        new_fille.setOrdre(this.getOrdre());
        new_fille.setIsEntete(this.getIsEntete());
        new_fille.setSource(this.getSource());
        return new_fille;
    }

    public Acte getDiffusion (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            Acte acte = new Acte();
            acte.setIdReservationFille(this.getId());
            Acte [] list = (Acte[]) CGenUtil.rechercher(acte,null,null,c,"");
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

    public Media getMedia (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            if (this.getIdMedia()!=null){
                Media acte = new Media();
                acte.setId(this.getIdMedia());
                Media [] list = (Media[]) CGenUtil.rechercher(acte,null,null,c,"");
                if (list.length>0){
                    return list[0];
                }
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

    public Reservation getReservationMere(Connection c) throws Exception {
        Reservation search = new Reservation();
        search.setId(this.getIdmere());
        Reservation [] list = (Reservation[]) CGenUtil.rechercher(search,null,null,c,"");
        if (list.length>0){
            return list[0];
        }
        return null;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
//        controlMedia(c);
//        if (this.getIdparrainage()==null || this.getIdparrainage().isEmpty()) {
////            Reservation mere = (Reservation) this.getReservationMere(c);
////            Client client = mere.getClient(c);
//
//            Ingredients service = this.getProduit(c);
////            if (service.getCategorieIngredient().equalsIgnoreCase(ConstanteKolo.categorieIngredientMATRAQUAGE)) {
////                controlleDeDiffusion(c);
////            }
//            System.out.println("servicy");
//            if(!service.getCategorieIngredient().equalsIgnoreCase(ConstanteKolo.categorieIngredientPlateau)){
//                System.out.println("servicy2");
//                this.setPu(service.getPrixFinal(this.getHeure(),this.getDaty(),service.getIdSupport(),c));
//            }
//        }
        return super.createObject(u, c);
    }

    @Override
    public void controler(Connection c) throws Exception{
        controlMedia(c);
        if (this.getIdparrainage()==null || this.getIdparrainage().isEmpty()) {

            Ingredients service = this.getProduit(c);
//            if (service.getCategorieIngredient().equalsIgnoreCase(ConstanteKolo.categorieIngredientMATRAQUAGE)) {
//                controlleDeDiffusion(c);
//            }
            if(!service.getCategorieIngredient().equalsIgnoreCase(ConstanteKolo.categorieIngredientPlateau)){
                this.setPu(service.getPrixFinal(this.getHeure(),this.getDaty(),service.getIdSupport(),c));
            }
        }
    }


    public void controlMedia(Connection c) throws Exception {
        if (this.getIdMedia()!=null && !this.getIdMedia().isEmpty()){
            Media media = this.getMedia(c);
            Ingredients service = this.getProduit(c);
            if (!media.getIdTypeMedia().equals(service.getCategorieIngredient())){
                throw new Exception("le type du media et du service doivent etre egal");
            }
            if (service.getDureeMax()>0){
                if (Integer.parseInt(media.getDuree())>service.getDureeMax()){
                    throw new Exception("la duree du media doit etre inferieur ou egal a "+service.getDureeMax());
                }
            }
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

            // Miverifier duree de diffusion raha ao anaty DureeMaxSpot
            Ingredients service = this.getProduit(c);

            DisponibiliteHeure maxSpot = new DisponibiliteHeure();
            maxSpot.setIdSupport(service.getIdSupport());
            maxSpot.setJour(CalendarUtil.getDayOfWeek(this.getDaty().toLocalDate()));
            maxSpot.setIdCategorieIngredient(service.getCategorieIngredient());
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
                throw new Exception("Impossible d'ajouter la reservation : Aucune heure de diffusion disponible");
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

    public static ReservationDetails[] reporter(String u,String date, String heure,String[] ids) throws Exception{
        Connection c = null;
        boolean estOuvert = false;
        List<ReservationDetails> res = new ArrayList<>();
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            if (!LocalDateTime.of(Date.valueOf(date).toLocalDate(), LocalTime.parse(heure)).isAfter(LocalDateTime.now())) {
                throw new Exception("La date et l'heure doivent etre dans le futur.");
            }

            for(String id:ids){

                ReservationDetails rsvdtls = new ReservationDetails();
                rsvdtls.setId(id);
                rsvdtls = (ReservationDetails) CGenUtil.rechercher(rsvdtls,null,null,c,"")[0];

                rsvdtls.setHeure(heure);
                rsvdtls.setDaty(Date.valueOf(date));
                rsvdtls.updateToTableWithHisto(u, c);
                res.add(rsvdtls);
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
        return res.toArray(new ReservationDetails[]{});
    }

    public static ReservationDetails[] diffuserMultiple(String u,String[] ids) throws Exception{
        Connection c = null;
        boolean estOuvert = false;
        List<ReservationDetails> res = new ArrayList<>();
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            for(String id:ids){
                ReservationDetails rsvdtls = new ReservationDetails();
                rsvdtls.setId(id);
                rsvdtls = (ReservationDetails) CGenUtil.rechercher(rsvdtls,null,null,c,"")[0];
                rsvdtls.diffuser(u, c);
                res.add(rsvdtls);
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
        return res.toArray(new ReservationDetails[]{});
    }
    public String getIdparrainage() {
        return idparrainage;
    }

    public void setIdparrainage(String idparrainage) {
        this.idparrainage = idparrainage;
    }

    public int getIsDependant() {
        return isDependant;
    }

    public void setIsDependant(int isDependant) {
        this.isDependant = isDependant;
    }

    public LocalDate [] getDateReservation(Connection c) throws Exception {
        boolean estOuvert = false;
        List<LocalDate> res = new ArrayList<>();
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String request = "SELECT DATY FROM RESERVATIONDETAILS WHERE IDMERE = ? AND ORDRE = ? ORDER BY DATY ASC";
            PreparedStatement statement = c.prepareStatement(request);
            statement.setString(1, this.getIdmere());
            statement.setInt(2, this.getOrdre());
            ResultSet rs = statement.executeQuery();
            while (rs.next()) {
                res.add(rs.getDate("DATY").toLocalDate());
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
        return res.toArray(new LocalDate[]{});
    }

    public int getDureeFinal (Connection c) throws Exception {
        Media media = this.getMedia(c);
        if (media != null) {
            return Integer.parseInt(media.getDuree());
        }
        else {
            Ingredients ing = this.getProduit(c);
            if (ing != null) {
                return ing.getDuree();
            }
        }
        return 0;
    }

    public void updateAllByOrdre(Connection c) throws Exception {
        boolean estOuvert = false;
        List<LocalDate> res = new ArrayList<>();
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String request = "UPDATE RESERVATIONDETAILS SET IDPRODUIT=?," +
                    "                              IDMEDIA=?," +
                    "                              HEURE=?," +
                    "                              PU=?," +
                    "                              DUREE=?," +
                    "                              REMARQUE=?," +
                    "                              SOURCE=?,ISENTETE=? WHERE IDMERE=? AND ORDRE=?";
            PreparedStatement statement = c.prepareStatement(request);
            statement.setString(1, this.getIdproduit());
            statement.setString(2, this.getIdMedia());
            statement.setString(3, this.getHeure());
            statement.setDouble(4, this.getPu());
            statement.setInt(5, Integer.parseInt(this.getDuree()));
            statement.setString(6, this.getRemarque());
            statement.setString(7, this.getSource());
            statement.setInt(8, this.getIsEntete());
            statement.setString(9, this.getIdmere());
            statement.setInt(10, this.getOrdre());
            statement.executeUpdate();
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

    public ReservationDetails changeEtat(int etat,String u,Connection c) throws Exception {
        if (this.getEtat()<ConstanteKolo.etatDiffuser){
            this.setEtat(etat);
            this.updateToTableWithHisto(u,c);
        }
        return this;
    }
}
