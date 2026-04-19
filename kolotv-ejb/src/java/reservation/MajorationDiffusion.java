package reservation;

import bean.CGenUtil;
import bean.ClassMAPTable;
import utils.CalendarUtil;

import java.sql.Connection;
import java.time.DayOfWeek;
import java.time.Duration;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class MajorationDiffusion extends ClassMAPTable {
    public static final String[] JOURS_SEMAINE = new String[]{
            "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"
    };

    private String id;
    private String jour;
    private String heureDebut;
    private String heureFin;
    private double tauxMajoration;

    public MajorationDiffusion() {
        this.setNomTable("MAJORATION_DIFFUSION");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("MAJ", "GETSEQ_MAJORATION_DIFFUSION");
        this.setId(makePK(c));
    }

    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void controler(Connection c) throws Exception {
        this.controlerDonnees(c);
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        this.controlerDonnees(c);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getJour() {
        return jour;
    }

    public void setJour(String jour) throws Exception {
        String valeur = normaliserJour(jour);
        if (valeur == null || valeur.trim().isEmpty()) {
            throw new Exception("Le jour est obligatoire");
        }
        if (!isJourValide(valeur)) {
            throw new Exception("Jour invalide");
        }
        this.jour = valeur;
    }

    public String getHeureDebut() {
        return heureDebut;
    }

    public void setHeureDebut(String heureDebut) throws Exception {
        String heure = CalendarUtil.formatTimeToHMS(heureDebut);
        if (!CalendarUtil.isValidTime(heure)) {
            throw new Exception("L'heure debut doit etre au format HH:MM:SS");
        }
        this.heureDebut = heure;
    }

    public String getHeureFin() {
        return heureFin;
    }

    public void setHeureFin(String heureFin) throws Exception {
        String heure = CalendarUtil.formatTimeToHMS(heureFin);
        if (!CalendarUtil.isValidTime(heure)) {
            throw new Exception("L'heure fin doit etre au format HH:MM:SS");
        }
        this.heureFin = heure;
    }

    public double getTauxMajoration() {
        return tauxMajoration;
    }

    public void setTauxMajoration(double tauxMajoration) throws Exception {
        if (tauxMajoration < -100) {
            throw new Exception("Le taux de variation doit etre superieur ou egal a -100");
        }
        this.tauxMajoration = tauxMajoration;
    }

    public LocalTime getHeureDebutLocalTime() {
        return LocalTime.parse(this.getHeureDebut());
    }

    public LocalTime getHeureFinLocalTime() {
        return LocalTime.parse(this.getHeureFin());
    }

    public static String normaliserJour(String jour) {
        if (jour == null) {
            return null;
        }
        String valeur = jour.trim();
        for (String jourSemaine : JOURS_SEMAINE) {
            if (jourSemaine.equalsIgnoreCase(valeur)) {
                return jourSemaine;
            }
        }

        if (valeur.isEmpty()) {
            return valeur;
        }
        return valeur.substring(0, 1).toUpperCase(Locale.ROOT) + valeur.substring(1).toLowerCase(Locale.ROOT);
    }

    public static boolean isJourValide(String jour) {
        if (jour == null) {
            return false;
        }
        for (String jourSemaine : JOURS_SEMAINE) {
            if (jourSemaine.equalsIgnoreCase(jour.trim())) {
                return true;
            }
        }
        return false;
    }

    public static String getJourFromDayOfWeek(DayOfWeek dayOfWeek) {
        if (dayOfWeek == null) {
            return null;
        }
        switch (dayOfWeek) {
            case MONDAY:
                return "Lundi";
            case TUESDAY:
                return "Mardi";
            case WEDNESDAY:
                return "Mercredi";
            case THURSDAY:
                return "Jeudi";
            case FRIDAY:
                return "Vendredi";
            case SATURDAY:
                return "Samedi";
            case SUNDAY:
                return "Dimanche";
            default:
                return null;
        }
    }

    public static Map<String, List<MajorationDiffusion>> grouperParJour(MajorationDiffusion[] majorations) {
        Map<String, List<MajorationDiffusion>> result = new HashMap<String, List<MajorationDiffusion>>();
        if (majorations == null) {
            return result;
        }
        for (MajorationDiffusion majoration : majorations) {
            if (majoration == null || majoration.getJour() == null) {
                continue;
            }
            String jour = normaliserJour(majoration.getJour());
            if (jour == null || !isJourValide(jour)) {
                continue;
            }
            List<MajorationDiffusion> list = result.get(jour);
            if (list == null) {
                list = new ArrayList<MajorationDiffusion>();
                result.put(jour, list);
            }
            list.add(majoration);
        }

        for (Map.Entry<String, List<MajorationDiffusion>> entry : result.entrySet()) {
            entry.getValue().sort((a, b) -> a.getHeureDebutLocalTime().compareTo(b.getHeureDebutLocalTime()));
        }
        return result;
    }

    public static double appliquerMajoration(
            double montantBase,
            LocalTime debutIntervalle,
            LocalTime finIntervalle,
            List<MajorationDiffusion> majorationsJour
    ) {
        if (montantBase <= 0 || debutIntervalle == null || finIntervalle == null) {
            return montantBase;
        }
        long totalSecondes = Duration.between(debutIntervalle, finIntervalle).getSeconds();
        if (totalSecondes <= 0 || majorationsJour == null || majorationsJour.isEmpty()) {
            return montantBase;
        }

        double montantParSeconde = montantBase / (double) totalSecondes;
        double montantMajoration = 0;

        for (MajorationDiffusion majoration : majorationsJour) {
            if (majoration == null) {
                continue;
            }
            long secondesChevauchees = getSecondesChevauchees(
                    debutIntervalle,
                    finIntervalle,
                    majoration.getHeureDebutLocalTime(),
                    majoration.getHeureFinLocalTime()
            );
            if (secondesChevauchees <= 0) {
                continue;
            }
            montantMajoration += montantParSeconde * secondesChevauchees * (majoration.getTauxMajoration() / 100d);
        }

        return montantBase + montantMajoration;
    }

    private void controlerDonnees(Connection c) throws Exception {
        if (this.getJour() == null || !isJourValide(this.getJour())) {
            throw new Exception("Jour invalide");
        }
        if (this.getHeureDebut() == null || this.getHeureFin() == null) {
            throw new Exception("Heure debut et heure fin obligatoires");
        }
        CalendarUtil.controlerHeureDebutEtFin(this.getHeureDebut(), this.getHeureFin(), null);
        if (this.getTauxMajoration() < -100) {
            throw new Exception("Le taux de variation doit etre superieur ou egal a -100");
        }
        if (this.hasChevauchement(c)) {
            throw new Exception("Une majoration existe deja sur une plage horaire qui chevauche cet intervalle");
        }
    }

    private boolean hasChevauchement(Connection c) throws Exception {
        StringBuilder condition = new StringBuilder();
        condition.append(" AND JOUR='").append(escapeSql(this.getJour())).append("'");
        condition.append(" AND TO_DATE('").append(escapeSql(this.getHeureDebut())).append("','HH24:MI:SS') < TO_DATE(HEUREFIN,'HH24:MI:SS')");
        condition.append(" AND TO_DATE('").append(escapeSql(this.getHeureFin())).append("','HH24:MI:SS') > TO_DATE(HEUREDEBUT,'HH24:MI:SS')");
        if (this.getId() != null && this.getId().trim().length() > 0) {
            condition.append(" AND ID <> '").append(escapeSql(this.getId())).append("'");
        }

        MajorationDiffusion filtre = new MajorationDiffusion();
        MajorationDiffusion[] list = (MajorationDiffusion[]) CGenUtil.rechercher(filtre, null, null, c, condition.toString());
        return list != null && list.length > 0;
    }

    private static long getSecondesChevauchees(
            LocalTime debutA,
            LocalTime finA,
            LocalTime debutB,
            LocalTime finB
    ) {
        LocalTime debutChevauchement = debutA.isAfter(debutB) ? debutA : debutB;
        LocalTime finChevauchement = finA.isBefore(finB) ? finA : finB;
        long secondes = Duration.between(debutChevauchement, finChevauchement).getSeconds();
        return Math.max(secondes, 0);
    }

    private String escapeSql(String valeur) {
        if (valeur == null) {
            return "";
        }
        return valeur.replace("'", "''");
    }
}
