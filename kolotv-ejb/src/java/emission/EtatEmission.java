package emission;

import bean.CGenUtil;
import duree.DisponibiliteHeure;
import utilitaire.UtilDB;
import utils.CalendarUtil;

import java.sql.Connection;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class EtatEmission {
    String[] joursString = new String[] {"Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"};
    HashMap<String, List<EmissionDetailsLib>> emissions;
    List<LocalTime[]> horaire;
    HashMap<String,Double[]> dureeTotal = new HashMap<>();

    public EtatEmission(String idSupport,String idGenre) throws Exception {
        Connection c=null;
        try {
            c = new UtilDB().GetConn();
            this.setEmissions(idSupport,idGenre,c);
            horaire = CalendarUtil.trierParReference(CalendarUtil.generateTimeIntervalsOfDay(60),LocalTime.now());
            this.setDureeTotal(this.getEmissions());
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(c!=null)c.close();
        }
    }

    public String[] getJoursString() {
        return joursString;
    }

    public void setJoursString(String[] joursString) {
        this.joursString = joursString;
    }

    public HashMap<String, List<EmissionDetailsLib>> getEmissions() {
        return emissions;
    }

    public void setEmissions(String idSupport,String idGenre,Connection c) throws Exception {
        EmissionDetailsLib dms = new EmissionDetailsLib();
        if (idSupport!=null && !idSupport.isEmpty()) {
            dms.setIdSupport(idSupport);
        }
        if (idGenre!=null && !idGenre.isEmpty()) {
            dms.setIdGenre(idGenre);
        }
        this.emissions = new HashMap<>();
        for (String jour : joursString) {
            dms.setJour(jour);
            EmissionDetailsLib [] list = (EmissionDetailsLib[]) CGenUtil.rechercher(dms,null,null,c,"");
            List<EmissionDetailsLib> data = new ArrayList<>();
            data.addAll(Arrays.asList(list));
            this.emissions.put(jour, data);
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

    public void setDureeTotal(HashMap<String, List<EmissionDetailsLib>> list) {
        this.dureeTotal = new HashMap<String,Double[]>();
        for (Map.Entry<String, List<EmissionDetailsLib>> entry : list.entrySet()) {
            String key = entry.getKey();
            List<EmissionDetailsLib> v = entry.getValue();
            double total_duree = 0;
            for (EmissionDetailsLib d : v) {
                LocalTime start = LocalTime.parse(d.getHeureDebut());
                LocalTime end = LocalTime.parse(d.getHeureFin());
                total_duree += CalendarUtil.getDuration(start,end);
            }
            dureeTotal.put(key,new Double[]{total_duree});
        }
    }

    public boolean checkTime (LocalTime time,LocalTime time_min,LocalTime time_max) {
        if (((time.isAfter(time_min) || time.equals(time_min)) && (time.isBefore(time_max)))){
            return true;
        }
        return false;
    }

    public EmissionDetailsLib [] getEmissionDetailsLibByTime(LocalTime [] times,String date) throws Exception {
        List<EmissionDetailsLib> res = new ArrayList<>();
        List<EmissionDetailsLib> listeAChevaucher = new ArrayList<>();
        List<EmissionDetailsLib> emissionFilles = this.getEmissions().get(date);
        for (EmissionDetailsLib d : emissionFilles) {
            LocalTime heure_debut = LocalTime.parse(d.getHeureDebut());
            LocalTime heure_fin = LocalTime.parse(d.getHeureFin());
            if (checkTime(heure_debut,times[0],times[1])) {
                EmissionDetailsLib reste = this.checkReste(d,times);
                if (reste != null) {
                    d.setHeureFin(times[1].format(DateTimeFormatter.ofPattern("HH:mm")));
                    listeAChevaucher.add(reste);
                }
                res.add(d);
            }
        }
        if (listeAChevaucher.size()>0) {
            emissionFilles.addAll(listeAChevaucher);
            this.getEmissions().put(date,emissionFilles);
        }

        return res.toArray(new EmissionDetailsLib[]{});
    }

    public EmissionDetailsLib checkReste (EmissionDetailsLib rd, LocalTime [] times) throws Exception {
        EmissionDetailsLib result = null;
        LocalTime heure = LocalTime.parse(rd.getHeureDebut());
        LocalTime heure_fin = LocalTime.parse(rd.getHeureFin());
        int restDuree = (int) (CalendarUtil.getDuration(heure,heure_fin) - CalendarUtil.getDuration(times[0],times[1]));
        if (heure_fin.isAfter(times[1])){
            result = new EmissionDetailsLib();
            result.setId(rd.getId());
            result.setHeureDebut(times[1].format(DateTimeFormatter.ofPattern("HH:mm")));
            result.setHeureFin(rd.getHeureFin());
            result.setIdSupport(rd.getIdSupport());
            result.setIdGenre(rd.getIdGenre());
            result.setJour(rd.getJour());
            result.setId(rd.getId());
            result.setIdMere(rd.getIdMere());
            result.setIdSupportLib(rd.getIdSupportLib());
            result.setIdGenreLib(rd.getIdGenreLib());
            result.setLibelleemission(rd.getLibelleemission());
        }
        return result;
    }
}
