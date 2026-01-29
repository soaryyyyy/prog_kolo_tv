package utils;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.*;

import utilitaire.UtilitaireDate;

public class CalendarUtil {

    public static String[] getDebutEtFinDeSemaine(String dateStr) {
        String[] debutEtFinDeSemaine = new String[4];
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        // Conversion de la chaîne vers LocalDate
        LocalDate date = LocalDate.parse(dateStr, formatter);

        // Début et fin de la semaine courante
        LocalDate debutSemaine = date.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate finSemaine = date.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

        // Dernier jour de la semaine précédente (dimanche avant lundi courant)
        LocalDate dernierJourSemainePrecedente = debutSemaine.minusDays(1);

        // Premier jour de la semaine suivante (lundi après dimanche courant)
        LocalDate premierJourSemaineSuivante = finSemaine.plusDays(1);

        // Remplissage du tableau
        debutEtFinDeSemaine[0] = debutSemaine.format(formatter);
        debutEtFinDeSemaine[1] = finSemaine.format(formatter);
        debutEtFinDeSemaine[2] = dernierJourSemainePrecedente.format(formatter);
        debutEtFinDeSemaine[3] = premierJourSemaineSuivante.format(formatter);

        return debutEtFinDeSemaine;
    }

    public static List<LocalTime[]> generateTimeIntervalsOfDay(int interval) {
        List<LocalTime[]> result = new ArrayList<>();
        LocalTime start = LocalTime.MIDNIGHT;
        LocalTime end = start.plusMinutes(interval);
//        System.out.println(start + " - " + end);
        result.add(new LocalTime[]{start, end});
        start = end.plusMinutes(0);
//        while (true) {
//            LocalTime next = start.plusMinutes(interval);
//            if (next.equals(end)){
//                break;
//            }
////            System.out.println(start + " - " + next);
//            result.add(new LocalTime[]{start, next});
//            start = next;
//        }


        while (true) {
            LocalTime next = start.plusMinutes(interval);

            // Si le prochain dépasse 23:59, on s'arrête à 23:59
            if (next.equals(LocalTime.MIDNIGHT)) {
                result.add(new LocalTime[]{start, LocalTime.of(23, 59)});
                break;
            } else {
                result.add(new LocalTime[]{start, next});
                start = next;
            }
        }

        return result;
    }

    public static String printTimeIntervals(LocalTime[] timeIntervals,DateTimeFormatter timeFormatter) {
        if (timeFormatter==null){
            timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
        }
        return timeIntervals[0].format(timeFormatter) + " - " + timeIntervals[1].format(timeFormatter);
    }

    public static String secondToHMS(long seconds){
        Duration duration = Duration.ofSeconds(seconds);
        long hours = duration.toHours();
        long minutes = duration.toMinutes() % 60;
        long secs = duration.getSeconds() % 60;

        return String.format("%02d:%02d:%02d", hours, minutes, secs);
    }

    public static int HMSToSecond(String heure){
        if (heure!=null){
            heure = formatTimeToHMS(heure);
            LocalTime time = LocalTime.parse(heure);
            return time.toSecondOfDay();
        }
        return 0;
    }

    public static String ajoutSecond(String heure,long duree,DateTimeFormatter timeFormatter){
        if (timeFormatter==null){
            timeFormatter = DateTimeFormatter.ofPattern("HH:mm:ss");
        }
        LocalTime heure_debut = LocalTime.parse(heure);
        return heure_debut.plusSeconds(duree).format(timeFormatter);
    }

    public static String castDateToFormat(String date,DateTimeFormatter inputFormatter,DateTimeFormatter outputFormatter){
        if (inputFormatter!=null && outputFormatter!=null){
            LocalDate localDate = LocalDate.parse(date,inputFormatter);
            return localDate.format(outputFormatter);
        }
        return date;
    }

    public static long getDuration(LocalTime start,LocalTime end){
        return Duration.between(start, end).getSeconds();
    }

    public static List<LocalTime[]> trierParReference(List<LocalTime[]> timesIntervals,LocalTime reference){
        List<LocalTime[]> result = new ArrayList<>(timesIntervals);
        result.sort(Comparator.comparingInt((slot)->{
            LocalTime start = slot[0];
            LocalTime end = slot[1];

            if (!reference.isBefore(start) && reference.isBefore(end)){
                return 0;
            }
            int diff = start.toSecondOfDay() - reference.toSecondOfDay();
            return diff>=0 ? diff : diff + 24 * 3600;
        }));
        return result;
    }

    public static String getDayOfWeek (LocalDate date){
        // Obtenir le jour de la semaine
        DayOfWeek dayOfWeek = date.getDayOfWeek();

        String dayName = dayOfWeek.getDisplayName(java.time.format.TextStyle.FULL, java.util.Locale.FRENCH);
//        System.out.println(dayName);
        return dayName;
    }

    public static boolean checkTime (LocalTime time,LocalTime time_min,LocalTime time_max) {
        if (((time.isAfter(time_min) || time.equals(time_min)) && (time.isBefore(time_max) || time.equals(time_max)))){
            return true;
        }
        return false;
    }

     public static boolean isValidTime(String time) {
        time = formatTimeToHMS(time);
        // Expression régulière pour le format HH:MM:SS
        String regex = "^([01]\\d|2[0-3]):[0-5]\\d:[0-5]\\d$";
        return time != null && time.matches(regex);
    }

    public static String formatTimeToHMS(String time) {
        // Expression régulière pour le format HH:MM:SS
        if (time!=null){
            String [] tab = time.split(":");
            String regex = "^([01]\\d|2[0-3]):[0-5]\\d";
            if (time != null && time.matches(regex)) {
                if (tab.length == 2){
                    time += ":00";
                }
            }
        }
        return time;
    }

    public static void controlerHeureDebutEtFin(String heureDebutHMS,String heureFinHMS,String dureeHMS) throws Exception {
        LocalTime heureDebut = LocalTime.parse(heureDebutHMS);
        LocalTime heureFin = LocalTime.parse(heureFinHMS);
        if (heureDebut.equals(heureFin)){
            throw new Exception("L'heure debut et l'heure fin doit etre different");
        }
        if (heureDebut.isAfter(heureFin)) {
            throw new Exception("L'heure debut doit etre avant l'heure fin");
        }
        if (dureeHMS!=null) {
            int duree = CalendarUtil.HMSToSecond(dureeHMS);
            LocalTime heureFinTheorique = heureDebut.plusSeconds(duree);
            if (heureFin.isBefore(heureFinTheorique)) {
                long seconde = CalendarUtil.getDuration(heureDebut,heureFin);
                throw new Exception("La duree doit etre inferieure ou egale a: "+ seconde +" s");
                // throw new Exception("L'heure de fin doit etre superieur ou egal a "+heureFinTheorique.format(DateTimeFormatter.ofPattern("HH:mm:ss")));
            }
        }
    }

    public static boolean ckeckMinute(String time,String minute) {
        // Expression régulière pour HH:00:SS ou HH:30:SS
        String regex = "^([01]\\d|2[0-3]):("+minute+"):[0-5]\\d$";
        return time != null && time.matches(regex);
    }

    public static LocalTime getHalfTime(LocalTime start,LocalTime end) {
        return start.plusSeconds((getDuration(start, end)/2));
    }

    public static List<LocalDate> getAllDate (LocalDate start,LocalDate end) {
        List<LocalDate> result = new ArrayList<>();
        while (!start.isAfter(end)) {
            result.add(start);
            start = start.plusDays(1);
        }
        return result;
    }

    public static int[] toMinSec(int dureeSec){
        int minutes = dureeSec / 60;
        int secondes = dureeSec % 60;
        return new int[]{minutes,secondes};
    }

    public static String formatDateEnLettre(LocalDate date) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("EEEE dd MMM", Locale.FRENCH);
        String result = date.format(formatter);
        return result.toUpperCase();
    }
}

