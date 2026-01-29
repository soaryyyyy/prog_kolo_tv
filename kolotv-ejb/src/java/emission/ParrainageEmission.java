package emission;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import constante.ConstanteEtat;
import media.Media;
import produits.Ingredients;
import reservation.Reservation;
import reservation.ReservationDetails;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.CalendarUtil;
import utils.ConstanteKolo;
import utils.ConstanteStation;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ParrainageEmission extends ClassMere {

    String id;
    String idclient;
    String idemission;
    Date datedebut;
    Date datefin;
    double remise;
    double montant;
    double qte;
    int qteAvant;
    String dureeAvant;
    int qtePendant;
    String dureePendant;
    int qteApres;
    String dureeApres;
    String idreservation;
    String source;
    String billiboardIn;
    String billiboardOut;

    public String getBilliboardIn() {
        return billiboardIn;
    }

    public void setBilliboardIn(String billiboardIn) {
        this.billiboardIn = billiboardIn;
    }

    public String getBilliboardOut() {
        return billiboardOut;
    }

    public void setBilliboardOut(String billiboardOut) {
        this.billiboardOut = billiboardOut;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getIdreservation() {
        return idreservation;
    }

    public void setIdreservation(String idreservation) {
        this.idreservation = idreservation;
    }

    public int getQteAvant() {
        return qteAvant;
    }

    public void setQteAvant(int qteAvant) {
        this.qteAvant = qteAvant;
    }

    public String getDureeAvant() {
        return dureeAvant;
    }

    public void setDureeAvant(String dureeAvant) {
        if (!CalendarUtil.isValidTime(dureeAvant)) {
            this.dureeAvant = dureeAvant;
        }
        else {
            this.dureeAvant = String.valueOf(CalendarUtil.HMSToSecond(dureeAvant));
        }
    }
    public int getQtePendant() {
        return qtePendant;
    }

    public void setQtePendant(int qtePendant) {
        this.qtePendant = qtePendant;
    }

    public String getDureePendant() {
        return dureePendant;
    }

    public void setDureePendant(String dureePendant) {
        if (!CalendarUtil.isValidTime(dureePendant)) {
            this.dureePendant = dureePendant;
        }
        else {
            this.dureePendant = String.valueOf(CalendarUtil.HMSToSecond(dureePendant));
        }
    }

    public int getQteApres() {
        return qteApres;
    }

    public void setQteApres(int qteApres) {
        this.qteApres = qteApres;
    }

    public String getDureeApres() {
        return dureeApres;
    }

    public void setDureeApres(String dureeApres) {
        if (!CalendarUtil.isValidTime(dureeApres)) {
            this.dureeApres = dureeApres;
        }
        else {
            this.dureeApres = String.valueOf(CalendarUtil.HMSToSecond(dureeApres));
        }
    }

    public ParrainageEmission() throws Exception {
        this.setNomTable("PARRAINAGEEMISSION");
        setLiaisonFille("idmere");
        setNomClasseFille("emission.ParrainageEmissionDetails");
    }

    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PRE", "GETSEQ_PARRAINAGE");
        this.setId(makePK(c));
    }

    // Getters et Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdclient() {
        return idclient;
    }

    public void setIdclient(String idclient) {
        this.idclient = idclient;
    }

    public String getIdemission() {
        return idemission;
    }

    public void setIdemission(String idemission) {
        this.idemission = idemission;
    }

    public Date getDatedebut() {
        return datedebut;
    }

    public void setDatedebut(Date datedebut) {
        this.datedebut = datedebut;
    }

    public Date getDatefin() {
        return datefin;
    }

    public void setDatefin(Date datefin) {
        this.datefin = datefin;
    }

    public double getRemise() {
        return remise;
    }

    public double getMontant() {
        return montant;
    }

    public double getQte() {
        return qte;
    }

    public void setRemise(double remise) {
        this.remise = remise;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Media bIn = this.getMediaBilliboardIN(c);
        Media bOut = this.getMediaBilliboardOUT(c);
        if (bIn!=null && !bIn.getIdTypeMedia().equals(ConstanteKolo.categorieIngredientBillBoard)) {
            throw new Exception("Le media billboard In doit etre de type billboard");
        }
        if (bOut!=null && !bOut.getIdTypeMedia().equals(ConstanteKolo.categorieIngredientBillBoard)) {
            throw new Exception("Le media billboard Out doit etre de type billboard");
        }
        if (this.getDatedebut().after(this.getDatefin())) {
            throw new Exception("Date debut doit etre inferieur a la date fin");
        }
        controlSpot(c);
        ParrainageEmission parrainageEmission = (ParrainageEmission) super.createObject(u, c);
        Reservation resa = parrainageEmission.plannifierReservation(c);
//        Emission emission = this.getEmission(c);
//        Reservation resa = new Reservation();
//        resa.setIdclient(parrainageEmission.getIdclient());
//        resa.setDaty(parrainageEmission.getDatedebut());
//        resa.setRemarque("Parrainage d'emission "+emission.getNom());
//        resa.setIdSupport(emission.getIdSupport());
//        resa.setSource(parrainageEmission.getId());
//        resa.setIdBc(parrainageEmission.getSource());
        resa = (Reservation) resa.createObject(u,c);
        parrainageEmission.setIdreservation(resa.getId());
        parrainageEmission.setQte(resa.getFille().length);
        parrainageEmission.updateToTableWithHisto(u,c);
        return parrainageEmission;
    }

    public void controlSpot(Connection c) throws Exception {
        ParrainageEmissionDetails [] parrainageEmissionDetails = (ParrainageEmissionDetails[]) this.getFille();
        int qte_avant = 0;
        int qte_pendant = 0;
        int qte_apres = 0;
        for (ParrainageEmissionDetails p : parrainageEmissionDetails) {
            if (p.getAvant()>0 && this.getDureeAvant()!=null && !this.getDureeAvant().isEmpty()){
                if (p.getDureeFinal(c)>Integer.parseInt(this.getDureeAvant())){
                    throw new Exception("La duree ne doit pas depasser "+this.getDureeAvant()+" s");
                }
            }
            if (p.getPendant()>0 && this.getDureePendant()!=null && !this.getDureePendant().isEmpty()){
                if (p.getDureeFinal(c)>Integer.parseInt(this.getDureePendant())){
                    throw new Exception("La duree ne doit pas depasser "+this.getDureePendant()+" s");
                }
            }
            if (p.getApres()>0 && this.getDureeApres()!=null && !this.getDureeApres().isEmpty()){
                if (p.getDureeFinal(c)>Integer.parseInt(this.getDureeApres())){
                    throw new Exception("La duree ne doit pas depasser "+this.getDureeApres()+" s");
                }
            }
            qte_avant += p.getAvant();
            qte_apres += p.getApres();
            qte_pendant += p.getPendant();
        }
        if (this.getQteAvant()<qte_avant){
            throw new Exception("La quantite avant doit etre infierieur ou egal a "+this.getQteAvant());
        }
        if (this.getQtePendant()<qte_pendant){
            throw new Exception("La quantite pendant doit etre infierieur ou egal a "+this.getQtePendant());
        }
        if (this.getQteApres()<qte_apres){
            throw new Exception("La quantite apres doit etre infierieur ou egal a "+this.getQteApres());
        }
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        Reservation resa = this.getReservation(c);
        if (resa!=null && resa.getEtat()<ConstanteEtat.getEtatValider()) {
            resa.validerObject(u,c);
        }
        return super.validerObject(u, c);
    }

    public Reservation plannifierReservation(Connection c) throws Exception {
        boolean estOuvert = false;
        Reservation result = null;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            result = new Reservation();

            List<ReservationDetails> fille = new ArrayList<>();
            result.setIdBc(this.getSource());
            result.setSource(this.getId());
            result.setIdclient(this.getIdclient());
            result.setDaty(Utilitaire.dateDuJourSql());
            Emission emission = this.getEmission(c);
            result.setRemarque("Reservation de parrainage d'emission "+emission.getNom());
            result.setIdSupport(emission.getIdSupport());
            EmissionDetails [] emissionDetails = emission.getEmissionDetails(c);
            LocalDate datDebut = this.getDatedebut().toLocalDate();
            LocalDate datFin = this.getDatefin().toLocalDate();
            ParrainageEmissionDetails [] parrainageEmissionDetails = this.getParrainageEmissionDetails(c);
            Map<String,Integer> mapOrdre = new HashMap<>();
            int surOrdre = 1;
            while (!datDebut.isAfter(datFin)) {
                String jour = CalendarUtil.getDayOfWeek(datDebut);
                for (EmissionDetails em : emissionDetails) {
                    if (mapOrdre.get(em.getHeureDebut()+"-"+em.getHeureFin())==null){
                        mapOrdre.put(em.getHeureDebut()+"-"+em.getHeureFin(),surOrdre);
                        surOrdre++;
                    }
                    if (em.getJour().equalsIgnoreCase(jour)) {
                        fille.add(this.genererResaPourBillboard(Date.valueOf(datDebut),em.getHeureDebut(),"Billboard In "+emission.getNom(),this.getBilliboardIn(), Integer.parseInt(mapOrdre.get(em.getHeureDebut()+"-"+em.getHeureFin())+""+1)));
                        LocalTime heureDebut = LocalTime.parse(em.getHeureDebut());
                        LocalTime heureFin = LocalTime.parse(em.getHeureFin());
                        int ordre = Integer.parseInt(mapOrdre.get(em.getHeureDebut()+"-"+em.getHeureFin())+""+1);
                        for (ParrainageEmissionDetails p : parrainageEmissionDetails) {
                            String duree = String.valueOf(p.getDureeFinal(c));
                            String halfTime = em.getHeureDebutCoupure();
                            if (halfTime==null){
                                halfTime = CalendarUtil.getHalfTime(heureDebut,heureFin).format(DateTimeFormatter.ofPattern("HH:mm"));
                            }
//                            if (p.getIdmedia()==null){
//                                throw new Exception("Media Manquant pour le spot "+p.getId());
//                            }

                            for (int i = 0; i < p.getAvant(); i++) {
                                fille.add(p.genererResaDetails(Date.valueOf(datDebut),em.getHeureDebut(),"AVANT "+emission.getNom()+" - "+p.getRemarque(),duree, Integer.parseInt(ordre+"0"+i)));
                            }
                            for (int i = 0; i < p.getPendant(); i++) {
                                fille.add(p.genererResaDetails(Date.valueOf(datDebut),halfTime,"PENDANT "+emission.getNom()+" - "+p.getRemarque(),duree,Integer.parseInt(ordre+"1"+i)));
                            }
                            for (int i = 0; i < p.getApres(); i++) {
                                fille.add(p.genererResaDetails(Date.valueOf(datDebut),em.getHeureFin(),"APRES "+emission.getNom()+" - "+p.getRemarque(),duree,Integer.parseInt(ordre+"2"+i)));
                            }
                            ordre++;
                        }
                        fille.add(this.genererResaPourBillboard(Date.valueOf(datDebut),em.getHeureFin(),"Billboard Out "+emission.getNom(),this.getBilliboardOut(), Integer.parseInt(mapOrdre.get(em.getHeureDebut()+"-"+em.getHeureFin())+""+2)));
                    }
                }
                datDebut = datDebut.plusDays(1);
            }
            if (fille.size()>0){
                double montant = this.getMontant()/fille.size();
                for (ReservationDetails res : fille) {
                    res.setPu(montant);
                }
            }
            result.setFille(fille.toArray(new ReservationDetails[]{}));
        } catch (Exception ex) {
            ex.printStackTrace();
            c.rollback();
            throw ex;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return result;
    }

    public ReservationDetails genererResaPourBillboard(Date date,String heure,String remarque,String idMedia,int ordre) throws Exception {
        ReservationDetails resBillboard = new ReservationDetails();
        resBillboard.setIdproduit(ConstanteKolo.idIngredientBillboard);
        resBillboard.setIdMedia(idMedia);
        resBillboard.setDaty(date);
        resBillboard.setHeure(heure);
        resBillboard.setRemarque(remarque);
        resBillboard.setRemise(0);
        resBillboard.setQte(1);
        resBillboard.setDuree("5");
        resBillboard.setIsEntete(1);
        resBillboard.setOrdre(ordre);
        resBillboard.setIdparrainage(this.getId());
        return resBillboard;
    }

    public Emission getEmission (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            Emission acte = new Emission();
            acte.setId(this.getIdemission());
            Emission [] list = (Emission []) CGenUtil.rechercher(acte,null,null,c,"");
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

    public ParrainageEmissionDetails [] getParrainageEmissionDetails (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            ParrainageEmissionDetails acte = new ParrainageEmissionDetails();
            acte.setIdmere(this.getId());
            ParrainageEmissionDetails [] list = (ParrainageEmissionDetails []) CGenUtil.rechercher(acte,null,null,c,"");
            return list;

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

    public Reservation getReservation (Connection c) throws Exception {
        Reservation reservation = new Reservation();
        reservation.setId(this.getIdreservation());
        Reservation [] list = (Reservation[]) CGenUtil.rechercher(reservation,null,null,c,"");
        if (list.length>0){
            return list[0];
        }
        return null;
    }
    public Media getMediaBilliboardIN (Connection c) throws Exception {
        if (this.getBilliboardIn()!=null && this.getBilliboardIn().isEmpty()==false) {
            Media item = new Media();
            item.setId(this.getBilliboardIn());
            Media [] list = (Media[]) CGenUtil.rechercher(item,null,null,c,"");
            if (list.length>0){

                return list[0];
            }
        }
        return null;
    }
    public Media getMediaBilliboardOUT (Connection c) throws Exception {
        if (this.getBilliboardOut()!=null && this.getBilliboardOut().isEmpty()==false) {
            Media item = new Media();
            item.setId(this.getBilliboardOut());
            Media [] list = (Media[]) CGenUtil.rechercher(item,null,null,c,"");
            if (list.length>0){
                return list[0];
            }
        }
        return null;
    }
}

