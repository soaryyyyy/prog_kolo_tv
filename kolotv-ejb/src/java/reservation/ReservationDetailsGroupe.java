package reservation;

import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import emission.Emission;
import emission.ParrainageEmission;
import produits.Acte;
import produits.Ingredients;
import stock.MvtStock;
import stock.MvtStockFille;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.CalendarUtil;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class ReservationDetailsGroupe extends ClassFille {
    String idmere,idproduit,idmedia,heure,remarque,source;
    String duree;
    double pu;
    Date datedebut;
    Date datefin;
    String dateDiffusion;
    int isEntete;
    int ordre;
    int nbspot;
    String dateInvalide;

    public String getDateInvalide() {
        return dateInvalide;
    }

    public void setDateInvalide(String dateInvalide) {
        this.dateInvalide = dateInvalide;
    }

    public int getNbspot() {
        return nbspot;
    }

    public void setNbspot(int nbspot) {
        this.nbspot = nbspot;
    }

    public int getIsEntete() {
        return isEntete;
    }

    public void setIsEntete(int isEntete) {
        this.isEntete = isEntete;
    }

    public int getOrdre() {
        return ordre;
    }

    public void setOrdre(int ordre) {
        this.ordre = ordre;
    }

    @Override
    public String getTuppleID() {
        return "";
    }

    @Override
    public String getAttributIDName() {
        return "";
    }

    public ReservationDetailsGroupe() {
        super();
        this.setNomTable("RESERVATIONDETAILSGROUPE");
    }

    public String getIdmedia() {
        return idmedia;
    }

    public void setIdmedia(String idmedia) {
        this.idmedia = idmedia;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getDuree() {
        return duree;
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

    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
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

    public String getHeure() {
        return heure;
    }

    public String getDateDiffusion() {
        return dateDiffusion;
    }

    public void setDateDiffusion(String dateDiffusion) {
        this.dateDiffusion = dateDiffusion;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
        this.setLiaisonMere("idmere");
        setClassMere("reservation.Reservation");
    }

    public ReservationDetails [] genererReservationDetails() throws Exception {
        List<ReservationDetails> reservationDetails = new ArrayList<ReservationDetails>();
        String [] listDate = this.getDateDiffusion().split(";");
        for (String d : listDate){
            ReservationDetails res = new ReservationDetails();
            res.setIdproduit(this.getIdproduit());
            res.setIdMedia(this.getIdmedia());
            res.setHeure(this.getHeure());
            res.setDaty(Date.valueOf(LocalDate.parse(d, DateTimeFormatter.ofPattern("dd/MM/yyyy"))));
            res.setRemarque(this.getRemarque());
            res.setSource(this.getSource());
            res.setDuree(this.getDuree());
            res.setPu(this.getPu());
            res.setQte(1);
            res.setIsEntete(this.getIsEntete());
            res.setOrdre(this.getOrdre());
            reservationDetails.add(res);
        }
        return reservationDetails.toArray(new ReservationDetails[]{});
    }

    public ReservationDetails [] genererReservationDetailsPourModif(Connection c) throws Exception {
        ReservationDetails search = new ReservationDetails();
        search.setIdmere(this.getIdmere());
        search.setOrdre(this.getOrdre());
        search.setIdproduit(this.getIdproduit());
        search.setHeure(this.getHeure());
        search.setPu(this.getPu());
        search.setDuree(this.getDuree().isEmpty()==false ? this.getDuree() : "0");
        search.setRemarque(this.getRemarque());
        search.setSource(this.getSource());
        search.setIdMedia(this.getIdmedia());
        search.setIsEntete(this.getIsEntete());
        search.updateAllByOrdre(c);

        List<ReservationDetails> reservationDetails = new ArrayList<ReservationDetails>();
        String [] listDate = this.getDateDiffusion().split(";");
        String [] listDateInvalide = this.getDateInvalide().split(";");
        Map<String,Boolean> dtInvalide = new HashMap<>();
        for (String d:listDateInvalide){
            dtInvalide.put(d,true);
        }
        for (String d : listDate){
            if (dtInvalide.get(d)==null){
                ReservationDetails res = new ReservationDetails();
                res.setIdmere(this.getIdmere());
                res.setIdproduit(this.getIdproduit());
                res.setIdMedia(this.getIdmedia());
                res.setHeure(this.getHeure());
                res.setDaty(Date.valueOf(LocalDate.parse(d, DateTimeFormatter.ofPattern("dd/MM/yyyy"))));
                res.setRemarque(this.getRemarque());
                res.setSource(this.getSource());
                res.setDuree(this.getDuree());
                res.setPu(this.getPu());
                res.setQte(1);
                res.setIsEntete(this.getIsEntete());
                res.setOrdre(this.getOrdre());
                reservationDetails.add(res);
            }
        }
        return reservationDetails.toArray(new ReservationDetails[]{});
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            ReservationDetails [] reservationDetails = genererReservationDetails();
            for (ReservationDetails reservationDetail : reservationDetails) {
                reservationDetail.createObject(u,c);
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

    public void setHeure(String heure) throws Exception {
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

    public Reservation genererReservationApresSaisieMultiple(HttpServletRequest request) throws Exception {
        Reservation reservation = new Reservation();
        if (request.getParameter("idBc")!=null && request.getParameter("idBc").isEmpty()==false) {
            reservation.setIdBc(request.getParameter("idBc"));
        }
        reservation.setIdSupport(request.getParameter("idSupport"));
        reservation.setIdclient(request.getParameter("idclient"));
        reservation.setDaty(Date.valueOf(request.getParameter("daty")));
        reservation.setRemarque(request.getParameter("remarque"));
        String [] list = request.getParameterValues("ids");
        List<ReservationDetails> filles = new ArrayList<>();
        int ordre = 0;
        for (String id : list) {
            int isEntete = Integer.parseInt(request.getParameter("isEntete_"+id));
            String idproduit = request.getParameter("idproduit_"+id);
            String heure_debut = request.getParameter("heure_"+id);
            String remarque = request.getParameter("remarque_"+id);
            String source = request.getParameter("source_"+id);
            String idmedia = request.getParameter("idmedia_"+id);
            String duree = request.getParameter("duree_"+id);
            double pu = 0;
            if (request.getParameter("pu_"+id)!=null && request.getParameter("pu_"+id).isEmpty()==false){
                pu = Double.parseDouble(request.getParameter("pu_"+id));
            }
            String champDate = request.getParameter("listDate_"+id);
            if (champDate!=null && champDate.isEmpty()==false) {
                String [] listDate = champDate.split(";");
                for (String d : listDate){
                    System.out.println(isEntete);
                    if (d!=null && d.isEmpty()==false) {
                        Date date = Utilitaire.stringDate(d);
                        ReservationDetails reservationDetails = new ReservationDetails();
                        reservationDetails.setIdproduit(idproduit);
                        reservationDetails.setIdMedia(idmedia);
                        reservationDetails.setDaty(date);
                        reservationDetails.setHeure(heure_debut);
                        reservationDetails.setPu(pu);
                        reservationDetails.setRemarque(remarque);
                        reservationDetails.setSource(source);
                        reservationDetails.setQte(1);
                        reservationDetails.setDuree(duree);
                        reservationDetails.setIsEntete(isEntete);
                        reservationDetails.setOrdre(ordre);
                        filles.add(reservationDetails);
                    }
                }
            }
            ordre++;
        }
        reservation.setFille(filles.toArray(new ReservationDetails[]{}));
        return reservation;
    }

    public Reservation genererReservationApresSaisieMultipleAmeliorer(HttpServletRequest request) throws Exception {
        Reservation reservation = new Reservation();
        if (request.getParameter("idBc")!=null && request.getParameter("idBc").isEmpty()==false) {
            reservation.setIdBc(request.getParameter("idBc"));
        }
        reservation.setIdSupport(request.getParameter("idSupport"));
        reservation.setIdclient(request.getParameter("idclient"));
        reservation.setDaty(Date.valueOf(request.getParameter("daty")));
        reservation.setRemarque(request.getParameter("remarque"));
        String [] list = request.getParameterValues("ids");
        List<ReservationDetails> filles = new ArrayList<>();
        int ordre = 0;
        for (String id : list) {
            int isEntete = Integer.parseInt(request.getParameter("isEntete_"+id));
            String idproduit = request.getParameter("idproduit_"+id);
            String heure_debut = request.getParameter("heure_"+id);
            String remarque = request.getParameter("remarque_"+id);
            String source = request.getParameter("source_"+id);
            String idmedia = request.getParameter("idmedia_"+id);
            String duree = request.getParameter("duree_"+id);
            double pu = 0;
            if (request.getParameter("pu_"+id)!=null && request.getParameter("pu_"+id).isEmpty()==false) {
                pu = Double.parseDouble(request.getParameter("pu_"+id));
            }
            LocalDate dateDebut = null;
            LocalDate dateFin = null;
            if (request.getParameter("dateDebut_"+id)!=null && request.getParameter("dateDebut_"+id).isEmpty()==false &&
            request.getParameter("dateFin_"+id)!=null && request.getParameter("dateFin_"+id).isEmpty()==false) {
                dateDebut = Date.valueOf(request.getParameter("dateDebut_"+id)).toLocalDate();
                dateFin = Date.valueOf(request.getParameter("dateFin_"+id)).toLocalDate();
            }else {
                throw new Exception("La date debut et fin sont requise pour la ligne "+id);
            }
            String [] jours = request.getParameterValues("jours_"+id);
            String [] dateInvalides = request.getParameter("dateInvalide_"+id).split(";");
            Map<String,Boolean> dtInterdite = new HashMap<>();
            for (String j : dateInvalides) {
                dtInterdite.put(j,false);
            }
            Map<String,Boolean> jourValide = new HashMap<>();
            for (String j : jours) {
                jourValide.put(j,true);
            }

            while (!dateDebut.isAfter(dateFin)) {
                if (dtInterdite.get(dateDebut.format(DateTimeFormatter.ofPattern("dd/MM/yyyy")))==null) {
                    if (jourValide.get(CalendarUtil.getDayOfWeek(dateDebut))!=null){
                        ReservationDetails reservationDetails = new ReservationDetails();
                        reservationDetails.setIdproduit(idproduit);
                        reservationDetails.setIdMedia(idmedia);
                        reservationDetails.setDaty(Date.valueOf(dateDebut));
                        reservationDetails.setHeure(heure_debut);
                        reservationDetails.setPu(pu);
                        reservationDetails.setRemarque(remarque);
                        reservationDetails.setSource(source);
                        reservationDetails.setQte(1);
                        reservationDetails.setDuree(duree);
                        reservationDetails.setIsEntete(isEntete);
                        reservationDetails.setOrdre(ordre);
                        filles.add(reservationDetails);
                    }
                }
                dateDebut = dateDebut.plusDays(1);
            }
            ordre++;
        }
        reservation.setFille(filles.toArray(new ReservationDetails[]{}));
        return reservation;
    }

    public Reservation genererReservationApresSaisieMultiplePourEmission(HttpServletRequest request,Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Reservation reservation = new Reservation();
            reservation.setIdSupport(request.getParameter("idSupport"));
            reservation.setDaty(Date.valueOf(request.getParameter("daty")));
            reservation.setRemarque(request.getParameter("remarque"));
            String [] list = request.getParameterValues("ids");
            int nbJour = Integer.parseInt(request.getParameter("nbJours"));
            List<ReservationDetails> filles = new ArrayList<>();
            for (String id : list) {
                String serviceMedia = request.getParameter("idproduit_"+id);
                Emission emission = new Emission();
                emission.setId(serviceMedia);
                emission = (Emission) CGenUtil.rechercher(emission,null,null,c,"")[0];
                String heure_debut = request.getParameter("heure_"+id);
                String duree = request.getParameter("duree_"+id);
                double remise = 0;
                double pu = 0;
                for (int i = 0; i < nbJour; i++) {
                    String champDate = "date_"+id+"_"+i;
                    int quantite = Integer.parseInt(request.getParameter(champDate+"_quantite"));
                    Date date = Utilitaire.stringDate(request.getParameter(champDate+"_date"));
                    for (int j = 0; j < quantite; j++) {
                        ReservationDetails reservationDetails = new ReservationDetails();
                        reservationDetails.setIdproduit(serviceMedia);
                        reservationDetails.setDaty(date);
                        reservationDetails.setHeure(heure_debut);
                        reservationDetails.setPu(pu);
                        reservationDetails.setRemise(remise);
                        reservationDetails.setQte(1);
                        reservationDetails.setDuree(duree);
                        filles.add(reservationDetails);

                        ReservationDetails [] resaParainnage = emission.genererReservationPourSponsors(date,heure_debut,c);
                        if (resaParainnage.length > 0) {
                            filles.addAll(Arrays.asList(resaParainnage));
                        }
                    }
                }
            }
            reservation.setFille(filles.toArray(new ReservationDetails[]{}));
            return reservation;
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

    public Reservation genererReservationApresModif(HttpServletRequest request,Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Reservation reservation = new Reservation();
            reservation.setId(request.getParameter("idResa"));
            reservation = (Reservation) CGenUtil.rechercher(reservation,null,null,c,"")[0];
            if (request.getParameter("idBc")!=null && request.getParameter("idBc").isEmpty()==false) {
                reservation.setIdBc(request.getParameter("idBc"));
            }
            reservation.setIdSupport(request.getParameter("idSupport"));
            reservation.setIdclient(request.getParameter("idclient"));
            reservation.setDaty(Date.valueOf(request.getParameter("daty")));
            reservation.setRemarque(request.getParameter("remarque"));
            String idParrainage = null;
            if (reservation.getSource()!=null && reservation.getSource().startsWith("PRE")){
                idParrainage = reservation.getSource();
            }
            String [] list = request.getParameterValues("ids");
            List<ReservationDetails> filles = new ArrayList<>();
            if (list!=null) {
                for (String id : list) {
                    int isEntete = Integer.parseInt(request.getParameter("isEntete_"+id));
                    String idproduit = request.getParameter("idproduit_"+id);
                    String heure_debut = request.getParameter("heure_"+id);
                    String remarque = request.getParameter("remarque_"+id);
                    String source = request.getParameter("source_"+id);
                    String idmedia = request.getParameter("idmedia_"+id);
                    String duree = request.getParameter("duree_"+id);
                    double pu = 0;
                    if (request.getParameter("pu_"+id)!=null && request.getParameter("pu_"+id).isEmpty()==false){
                        pu = Double.parseDouble(request.getParameter("pu_"+id));
                    }
                    int ordre = Integer.parseInt(request.getParameter("ordre_"+id));
                    ReservationDetails search = new ReservationDetails();
                    search.setIdmere(reservation.getId());
                    search.setOrdre(ordre);
                    search.setIdproduit(idproduit);
                    search.setHeure(heure_debut);
                    search.setPu(pu);
                    search.setDuree(duree);
                    search.setRemarque(remarque);
                    search.setSource(source);
                    search.setIdMedia(idmedia);
                    search.setIsEntete(isEntete);
                    search.updateAllByOrdre(c);
                    String champDate = request.getParameter("listDate_"+id);
                    if (champDate!=null && champDate.isEmpty()==false) {
                        String [] listDate = champDate.split(";");
                        for (String d : listDate){
                            System.out.println(isEntete);
                            if (d!=null && d.isEmpty()==false) {
                                Date date = Utilitaire.stringDate(d);
                                ReservationDetails reservationDetails = new ReservationDetails();
                                reservationDetails.setIdmere(reservation.getId());
                                reservationDetails.setIdproduit(idproduit);
                                reservationDetails.setIdMedia(idmedia);
                                reservationDetails.setDaty(date);
                                reservationDetails.setHeure(heure_debut);
                                reservationDetails.setPu(pu);
                                reservationDetails.setRemarque(remarque);
                                reservationDetails.setSource(source);
                                reservationDetails.setQte(1);
                                reservationDetails.setDuree(duree);
                                reservationDetails.setIsEntete(isEntete);
                                reservationDetails.setOrdre(ordre);
                                reservationDetails.setIdparrainage(idParrainage);
                                filles.add(reservationDetails);
                            }
                        }
                    }
                }
            }
            reservation.setFille(filles.toArray(new ReservationDetails[]{}));
            return reservation;
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

}
