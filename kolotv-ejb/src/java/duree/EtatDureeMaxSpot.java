package duree;

import bean.AdminGen;
import bean.CGenUtil;
import org.joda.time.LocalDate;
import reservation.EtatReservation;
import reservation.ReservationDetailsAvecDiffusion;
import utilitaire.UtilDB;
import utils.CalendarUtil;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class EtatDureeMaxSpot {
    String[] joursString = new String[] {"Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"};
    HashMap<String,List<DisponibiliteHeure>> dureeMaxSpots;
    List<LocalTime[]> horaire;
    HashMap<String,Double[]> dureeTotal = new HashMap<>();

    public EtatDureeMaxSpot(String idSupport) throws Exception {
        Connection c=null;
        try {
            c = new UtilDB().GetConn();
            this.setDureeMaxSpots(c,idSupport);
            horaire = CalendarUtil.trierParReference(CalendarUtil.generateTimeIntervalsOfDay(30),LocalTime.now());
            this.setDureeTotal(this.getDureeMaxSpots());
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(c!=null)c.close();
        }

    }

    public HashMap<String, List<DisponibiliteHeure>> getDureeMaxSpots() {
        return dureeMaxSpots;
    }

    public void setDureeMaxSpots(Connection c,String idSupport) throws Exception {
        DisponibiliteHeure dms = new DisponibiliteHeure();
        if (idSupport!=null && !idSupport.isEmpty()) {
            dms.setIdSupport(idSupport);
        }
        this.dureeMaxSpots = new HashMap<>();
        for (String jour : joursString) {
            dms.setJour(jour);
            DisponibiliteHeure [] list = (DisponibiliteHeure[]) CGenUtil.rechercher(dms,null,null,c,"");
//            System.out.println("taille : "+list.length);
            List<DisponibiliteHeure> data = new ArrayList<>();
            data.addAll(Arrays.asList(list));
            this.dureeMaxSpots.put(jour, data);
        }
    }

    public List<LocalTime[]> getHoraire() {
        return horaire;
    }

    public void setHoraire(List<LocalTime[]> horaire) {
        this.horaire = horaire;
    }

    public HashMap<String, Double[]> getDureeTotal() {
        return dureeTotal;
    }

    public void setDureeTotal(HashMap<String, List<DisponibiliteHeure>> list) {
        this.dureeTotal = new HashMap<String,Double[]>();
        for (Map.Entry<String, List<DisponibiliteHeure>> entry : list.entrySet()) {
            String key = entry.getKey();
            List<DisponibiliteHeure> v = entry.getValue();
            double total_max = 0;
            double total_diffusion = 0;
            for (DisponibiliteHeure d : v) {
                total_max += Double.parseDouble(d.getMax());
                total_diffusion += d.getDuree_diffusion();
            }
            double reste = total_max - total_diffusion;
            dureeTotal.put(key,new Double[]{total_max,total_diffusion,reste});
        }
    }

    public String[] getJoursString() {
        return joursString;
    }

    public void setJoursString(String[] joursString) {
        this.joursString = joursString;
    }

    public boolean checkTime (LocalTime time,LocalTime time_min,LocalTime time_max) {
        if (((time.isAfter(time_min) || time.equals(time_min)) && (time.isBefore(time_max)))){
            return true;
        }
        return false;
    }
    public DisponibiliteHeure [] getDisponibiliteHeuresByTime(LocalTime [] times,String date) throws Exception {
        List<DisponibiliteHeure> res = new ArrayList<>();
        List<DisponibiliteHeure> listeAChevaucher = new ArrayList<>();
        List<DisponibiliteHeure> disponibiliteHeures = this.getDureeMaxSpots().get(date);
        for (DisponibiliteHeure d : disponibiliteHeures) {
            LocalTime heure_debut = LocalTime.parse(d.getHeureDebut());
            LocalTime heure_fin = LocalTime.parse(d.getHeureFin());
            if (checkTime(heure_debut,times[0],times[1])) {
                res.add(d);
            }
        }

        return res.toArray(new DisponibiliteHeure[]{});
    }

    public DisponibiliteHeure checkReste (DisponibiliteHeure rd, LocalTime [] times) throws Exception {
        DisponibiliteHeure result = null;
        LocalTime heure = LocalTime.parse(rd.getHeureDebut());
        LocalTime heure_fin = LocalTime.parse(rd.getHeureFin());
        int restDuree = (int) (CalendarUtil.getDuration(heure,heure_fin) - CalendarUtil.getDuration(times[0],times[1]));
        if (restDuree>0){
            result = new DisponibiliteHeure();
            result.setId(rd.getId());
            result.setHeureDebut(rd.getHeureFin());
            result.setHeureFin(heure_fin.plusSeconds(restDuree).format(DateTimeFormatter.ofPattern("HH:mm:ss")));
            result.setIdSupport(rd.getIdSupport());
            result.setJour(rd.getJour());
            result.setDuree_diffusion(rd.getDuree_diffusion());
            result.setMax(rd.getMax());
        }
        return result;
    }
}
