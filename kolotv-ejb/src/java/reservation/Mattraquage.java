package reservation;

import bean.CGenUtil;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import utils.CalendarUtil;
import utils.ExcelUtil;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class Mattraquage {
    LocalDate date;
    String intervenant,societe,recu,facture;
    int periode;
    LocalDate dateDebut;
    LocalDate dateFin;
    String okMatin;
    String titreMatin;
    int minuteMatin;
    int secondeMatin;
    String okMidi;
    String titreMidi;
    int minuteMidi;
    int secondeMidi;
    String okSoir;
    String titreSoir;
    int minuteSoir;
    int secondeSoir;

    public Mattraquage() {
    }

    public String getIntervenant() {
        return intervenant;
    }

    public void setIntervenant(String intervenant) {
        this.intervenant = intervenant;
    }

    public String getSociete() {
        return societe;
    }

    public void setSociete(String societe) {
        this.societe = societe;
    }

    public String getRecu() {
        return recu;
    }

    public void setRecu(String recu) {
        this.recu = recu;
    }

    public String getFacture() {
        return facture;
    }

    public void setFacture(String facture) {
        this.facture = facture;
    }

    public int getPeriode() {
        return periode;
    }

    public void setPeriode(int periode) {
        this.periode = periode;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    public String getOkMatin() {
        return okMatin;
    }

    public void setOkMatin(String okMatin) {
        this.okMatin = okMatin;
    }

    public String getTitreMatin() {
        return titreMatin;
    }

    public void setTitreMatin(String titreMatin) {
        this.titreMatin = titreMatin;
    }

    public int getMinuteMatin() {
        return minuteMatin;
    }

    public void setMinuteMatin(int minuteMatin) {
        this.minuteMatin = minuteMatin;
    }

    public int getSecondeMatin() {
        return secondeMatin;
    }

    public void setSecondeMatin(int secondeMatin) {
        this.secondeMatin = secondeMatin;
    }

    public String getOkMidi() {
        return okMidi;
    }

    public void setOkMidi(String okMidi) {
        this.okMidi = okMidi;
    }

    public String getTitreMidi() {
        return titreMidi;
    }

    public void setTitreMidi(String titreMidi) {
        this.titreMidi = titreMidi;
    }

    public int getMinuteMidi() {
        return minuteMidi;
    }

    public void setMinuteMidi(int minuteMidi) {
        this.minuteMidi = minuteMidi;
    }

    public int getSecondeMidi() {
        return secondeMidi;
    }

    public void setSecondeMidi(int secondeMidi) {
        this.secondeMidi = secondeMidi;
    }

    public String getOkSoir() {
        return okSoir;
    }

    public void setOkSoir(String okSoir) {
        this.okSoir = okSoir;
    }

    public String getTitreSoir() {
        return titreSoir;
    }

    public void setTitreSoir(String titreSoir) {
        this.titreSoir = titreSoir;
    }

    public int getMinuteSoir() {
        return minuteSoir;
    }

    public void setMinuteSoir(int minuteSoir) {
        this.minuteSoir = minuteSoir;
    }

    public int getSecondeSoir() {
        return secondeSoir;
    }

    public void setSecondeSoir(int secondeSoir) {
        this.secondeSoir = secondeSoir;
    }

    public void setInfoPeriodique (LocalTime [][] intervales,LocalTime heure,String titre,int duree){
        int [] dureeMinSec = CalendarUtil.toMinSec(duree);
        if (CalendarUtil.checkTime(heure,intervales[0][0],intervales[0][1])){
            this.setPeriode(1);
            this.setOkMatin("OK");
            this.setTitreMatin(titre);
            this.setMinuteMatin(dureeMinSec[0]);
            this.setSecondeMatin(dureeMinSec[1]);
        }
        else if (CalendarUtil.checkTime(heure,intervales[1][0],intervales[1][1])){
            this.setPeriode(2);
            this.setOkMidi("OK");
            this.setTitreMidi(titre);
            this.setMinuteMidi(dureeMinSec[0]);
            this.setSecondeMidi(dureeMinSec[1]);
        }
        else if (CalendarUtil.checkTime(heure,intervales[2][0],intervales[2][1])){
            this.setPeriode(3);
            this.setOkSoir("OK");
            this.setTitreSoir(titre);
            this.setMinuteSoir(dureeMinSec[0]);
            this.setSecondeSoir(dureeMinSec[1]);
        }
    }

    public List<Mattraquage> transformResaToMattraquage(List<ReservationDetailsAvecDiffusion> reservationDetails, Connection c) {
        LocalTime [][] intervales = new LocalTime[3][2];
        intervales[0][0] = LocalTime.parse("04:00");
        intervales[0][1] = LocalTime.parse("10:30");
        intervales[1][0] = LocalTime.parse("10:30");
        intervales[1][1] = LocalTime.parse("14:30");
        intervales[2][0] = LocalTime.parse("14:30");
        intervales[2][1] = LocalTime.parse("20:00");
        List<Mattraquage> mattraquages = new ArrayList<>();
        Map<String, Map<String, Map<String, List<ReservationDetailsAvecDiffusion>>>> resaParMedia = this.extractMediaHeureBlocDate(reservationDetails);
        for (Map.Entry<String, Map<String, Map<String, List<ReservationDetailsAvecDiffusion>>>> entry : resaParMedia.entrySet()) {
            String media = entry.getKey();
            Map<String, Map<String, List<ReservationDetailsAvecDiffusion>>> resaParHeure = entry.getValue();

            for (Map.Entry<String, Map<String, List<ReservationDetailsAvecDiffusion>>> entry2 : resaParHeure.entrySet()) {
                String heure = entry2.getKey();
                Map<String, List<ReservationDetailsAvecDiffusion>> resaParBlocDate = entry2.getValue();
                for (Map.Entry<String, List<ReservationDetailsAvecDiffusion>> entry3 : resaParBlocDate.entrySet()) {
                    String blockDate = entry3.getKey();
                    LocalDate dtDebut = LocalDate.parse(blockDate.split(":")[0]);
                    LocalDate dtFin = LocalDate.parse(blockDate.split(":")[1]);
                    List<ReservationDetailsAvecDiffusion> listResa = entry3.getValue();
                    ReservationDetailsAvecDiffusion resa = listResa.get(0);
                    Mattraquage mattraquage = new Mattraquage();
                    mattraquage.setDate(resa.getLocalDateMere());
                    mattraquage.setIntervenant("KOLO");
                    mattraquage.setSociete(resa.getClient());
                    mattraquage.setDateDebut(dtDebut);
                    mattraquage.setDateFin(dtFin);
                    mattraquage.setRecu(resa.getSource());
                    mattraquage.setFacture("");
                    mattraquage.setInfoPeriodique(intervales,LocalTime.parse(heure),media+" "+resa.getRemarque(), Integer.parseInt(resa.getDuree()));
                    mattraquages.add(mattraquage);
                }
            }

        }

        List<Mattraquage> sorted = mattraquages.stream()
                .sorted(
                        Comparator.comparing(Mattraquage::getDateDebut)
                                .thenComparing(Mattraquage::getDateFin)
                )
                .collect(Collectors.toList());
        return sorted;
    }

    public Map<String,List<ReservationDetailsAvecDiffusion>> extractParBlocDate (List<ReservationDetailsAvecDiffusion> reservationDetails) {
        List<ReservationDetailsAvecDiffusion> sorted = reservationDetails.stream()
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(ReservationDetailsAvecDiffusion::getLocalDate))
                .collect(Collectors.toList());

        Map<String, List<ReservationDetailsAvecDiffusion>> resultat = new LinkedHashMap<>();

        LocalDate debut = null;
        LocalDate fin = null;
        String currentKey = null;
        List<ReservationDetailsAvecDiffusion> currentList = null;

        for (ReservationDetailsAvecDiffusion r : sorted) {
            LocalDate d = r.getLocalDate();

            if (debut == null) {
                // Premier intervalle
                debut = d;
                fin = d;
                currentKey = debut + ":" + fin;
                currentList = new ArrayList<>();
                currentList.add(r);
                resultat.put(currentKey, currentList);
            } else if (d.equals(fin.plusDays(1))) {
                // Même intervalle (date suivante)
                fin = d;

                // Mettre à jour la clé
                resultat.remove(currentKey);
                currentKey = debut + ":" + fin;

                resultat.put(currentKey, currentList);
                currentList.add(r);

            } else {
                // Nouveau intervalle
                debut = d;
                fin = d;
                currentKey = debut + ":" + fin;
                currentList = new ArrayList<>();
                currentList.add(r);
                resultat.put(currentKey, currentList);
            }
        }

        return resultat;
    }

    public Map<String, Map<String, Map<String, List<ReservationDetailsAvecDiffusion>>>> extractMediaHeureBlocDate(List<ReservationDetailsAvecDiffusion> reservations) {

        // 1. Grouper par media
        Map<String, List<ReservationDetailsAvecDiffusion>> parMedia =
                reservations.stream()
                        .collect(Collectors.groupingBy(ReservationDetailsAvecDiffusion::getRemarque));

        // 2. Pour chaque media → grouper par heure
        Map<String, Map<String, Map<String, List<ReservationDetailsAvecDiffusion>>>> resultat = new LinkedHashMap<>();

        for (Map.Entry<String, List<ReservationDetailsAvecDiffusion>> mediaEntry : parMedia.entrySet()) {
            String media = mediaEntry.getKey();
            List<ReservationDetailsAvecDiffusion> listMedia = mediaEntry.getValue();

            Map<String, List<ReservationDetailsAvecDiffusion>> parHeure =
                    listMedia.stream()
                            .collect(Collectors.groupingBy(ReservationDetailsAvecDiffusion::getHeure));

            Map<String, Map<String, List<ReservationDetailsAvecDiffusion>>> mapHeure = new LinkedHashMap<>();

            // 3. Pour chaque heure → grouper en blocs de dates contiguës
            for (Map.Entry<String, List<ReservationDetailsAvecDiffusion>> heureEntry : parHeure.entrySet()) {
                String heure = heureEntry.getKey();
                List<ReservationDetailsAvecDiffusion> listHeure = heureEntry.getValue();

                Map<String, List<ReservationDetailsAvecDiffusion>> blocs =
                        extractParBlocDate(listHeure);

                mapHeure.put(heure, blocs);
            }

            resultat.put(media, mapHeure);
        }

        return resultat;
    }

    public void imprimerExcel(XSSFWorkbook workbook, String idReservation, Connection c) throws Exception {
        Sheet sheet = workbook.createSheet("A traiter");
        int rowIndex = 0;

        Reservation search = new Reservation();
        if (idReservation != null && !idReservation.isEmpty()) {
            search.setId(idReservation);
        }

        String aWhere = "";

        Reservation[] list = (Reservation[]) CGenUtil.rechercher(search, null,null, c, aWhere);

        if (list.length>0) {
            Reservation reservation = list[0];
            if (rowIndex > 0){
                sheet.createRow(rowIndex++);
            }

            LocalDate[] dt = reservation.getDateInterval(c);
            List<LocalDate> periodes = CalendarUtil.getAllDate(dt[0], dt[1]);

            // Créer les headers dynamiques
            String[] headers = new String[]{"DATE", "INTERVENANT", "SOCIETE", "DATE DEBUT", "DATE FIN","REC","FACT","MATIN","TITRE","MIN","SEC","MIDI","TITRE","MIN","SEC","SOIR","TITRE","MIN","SEC"};

            // Écrire les en-têtes
            Row headerRow = sheet.createRow(rowIndex++);
            XSSFCellStyle headerStyle = ExcelUtil.getHeaderStyle(workbook);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellStyle(headerStyle);
                cell.setCellValue(headers[i]);
                sheet.autoSizeColumn(i);
            }

            ReservationDetailsAvecDiffusion resafille = new ReservationDetailsAvecDiffusion();
            resafille.setNomTable("RESERVATIONDETAILS_SANSETAT");
            resafille.setIdmere(reservation.getId());
            ReservationDetailsAvecDiffusion [] details = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(resafille,null,null,c, "");
            Map<Integer,List<ReservationDetailsAvecDiffusion>> filles = ReservationDetailsAvecDiffusion.groupByOrdre(details);
            List<Mattraquage> mattraquages = this.transformResaToMattraquage(Arrays.asList(details),c);
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            for (Mattraquage mattraquage : mattraquages) {

                String [] colonneValue = new String[headers.length];
                colonneValue[0] = mattraquage.getDate().format(formatter);
                colonneValue[1] = mattraquage.getIntervenant();
                colonneValue[2] = mattraquage.getSociete();
                colonneValue[3] = mattraquage.getDateDebut().format(formatter);
                colonneValue[4] = mattraquage.getDateFin().format(formatter);
                colonneValue[5] = mattraquage.getRecu();
                colonneValue[6] = mattraquage.getFacture();
                colonneValue[7] = mattraquage.getOkMatin();
                colonneValue[8] = mattraquage.getTitreMatin();
                colonneValue[9] = String.valueOf(mattraquage.getMinuteMatin());
                colonneValue[10] = String.valueOf(mattraquage.getSecondeMatin());
                colonneValue[11] = mattraquage.getOkMidi();
                colonneValue[12] = mattraquage.getTitreMidi();
                colonneValue[13] = String.valueOf(mattraquage.getMinuteMidi());
                colonneValue[14] = String.valueOf(mattraquage.getSecondeMidi());
                colonneValue[15] = mattraquage.getOkSoir();
                colonneValue[16] = mattraquage.getTitreSoir();
                colonneValue[17] = String.valueOf(mattraquage.getMinuteSoir());
                colonneValue[18] = String.valueOf(mattraquage.getSecondeSoir());

                // Créer la ligne Excel
                Row row = sheet.createRow(rowIndex++);
                for (int i = 0; i < colonneValue.length; i++) {
                    Cell colonne = row.createCell(i);
                    colonne.setCellValue(colonneValue[i]);
//                    if (!codeCouleur.equalsIgnoreCase("#FFFFFF")){
//                        colonne.setCellStyle(styleCache.get(codeCouleur));
//                    }
                }

            }

            for (int i = 0; i <headers.length ; i++) {
                sheet.autoSizeColumn(i);
            }

            String[] titre = new String[]{"DATE", "INTERVENANT", "SOCIETE", "DATE DEBUT", "DATE FIN","REC","FACT","MATIN","TITRE","MIN","SEC"};
            for (LocalDate date : periodes){
                String [] periode = new String[]{"MATIN","MIDI","SOIR"};
                for (String p : periode) {
                    titre[7] = p;
                    rowIndex = 0;
                    Sheet new_sheet = workbook.createSheet(CalendarUtil.formatDateEnLettre(date)+" "+p);
                    for (Mattraquage mattraquage : mattraquages) {
                        boolean inside = !date.isBefore(mattraquage.getDateDebut()) && !date.isAfter(mattraquage.getDateFin());
                        if (p.equals("MATIN") && mattraquage.getPeriode()==1 && inside==true){
                            Row headRow = new_sheet.createRow(rowIndex++);
                            for (int i = 0; i < titre.length; i++) {
                                Cell cell = headRow.createCell(i);
                                cell.setCellValue(titre[i]);
                            }

                            String [] colonneValue = new String[titre.length];
                            colonneValue[0] = mattraquage.getDate().format(formatter);
                            colonneValue[1] = mattraquage.getIntervenant();
                            colonneValue[2] = mattraquage.getSociete();
                            colonneValue[3] = mattraquage.getDateDebut().format(formatter);
                            colonneValue[4] = mattraquage.getDateFin().format(formatter);
                            colonneValue[5] = mattraquage.getRecu();
                            colonneValue[6] = mattraquage.getFacture();
                            colonneValue[7] = mattraquage.getOkMatin();
                            colonneValue[8] = mattraquage.getTitreMatin();
                            colonneValue[9] = String.valueOf(mattraquage.getMinuteMatin());
                            colonneValue[10] = String.valueOf(mattraquage.getSecondeMatin());

                            // Créer la ligne Excel
                            Row row = new_sheet.createRow(rowIndex++);
                            for (int i = 0; i < colonneValue.length; i++) {
                                Cell colonne = row.createCell(i);
                                colonne.setCellValue(colonneValue[i]);
                            }
                        }
                        if (p.equals("MIDI") && mattraquage.getPeriode()==2 && inside==true){
                            Row headRow = new_sheet.createRow(rowIndex++);
                            for (int i = 0; i < titre.length; i++) {
                                Cell cell = headRow.createCell(i);
                                cell.setCellValue(titre[i]);
                            }
                            String [] colonneValue = new String[titre.length];
                            colonneValue[0] = mattraquage.getDate().format(formatter);
                            colonneValue[1] = mattraquage.getIntervenant();
                            colonneValue[2] = mattraquage.getSociete();
                            colonneValue[3] = mattraquage.getDateDebut().format(formatter);
                            colonneValue[4] = mattraquage.getDateFin().format(formatter);
                            colonneValue[5] = mattraquage.getRecu();
                            colonneValue[6] = mattraquage.getFacture();
                            colonneValue[7] = mattraquage.getOkMidi();
                            colonneValue[8] = mattraquage.getTitreMidi();
                            colonneValue[9] = String.valueOf(mattraquage.getMinuteMidi());
                            colonneValue[10] = String.valueOf(mattraquage.getSecondeMidi());

                            // Créer la ligne Excel
                            Row row = new_sheet.createRow(rowIndex++);
                            for (int i = 0; i < colonneValue.length; i++) {
                                Cell colonne = row.createCell(i);
                                colonne.setCellValue(colonneValue[i]);
                            }
                        }

                        if (p.equals("SOIR") && mattraquage.getPeriode()==3 && inside==true){
                            Row headRow = new_sheet.createRow(rowIndex++);
                            for (int i = 0; i < titre.length; i++) {
                                Cell cell = headRow.createCell(i);
                                cell.setCellValue(titre[i]);
                            }
                            String [] colonneValue = new String[titre.length];
                            colonneValue[0] = mattraquage.getDate().format(formatter);
                            colonneValue[1] = mattraquage.getIntervenant();
                            colonneValue[2] = mattraquage.getSociete();
                            colonneValue[3] = mattraquage.getDateDebut().format(formatter);
                            colonneValue[4] = mattraquage.getDateFin().format(formatter);
                            colonneValue[5] = mattraquage.getRecu();
                            colonneValue[6] = mattraquage.getFacture();
                            colonneValue[7] = mattraquage.getOkSoir();
                            colonneValue[8] = mattraquage.getTitreSoir();
                            colonneValue[9] = String.valueOf(mattraquage.getMinuteSoir());
                            colonneValue[10] = String.valueOf(mattraquage.getSecondeSoir());

                            // Créer la ligne Excel
                            Row row = new_sheet.createRow(rowIndex++);
                            for (int i = 0; i < colonneValue.length; i++) {
                                Cell colonne = row.createCell(i);
                                colonne.setCellValue(colonneValue[i]);
                            }
                        }

                    }
                }
            }
        }

    }

    public static void main(String[] args) throws Exception {
        Reservation reservation = (Reservation) new Reservation().getById("RESS000301","",null);
        ReservationDetailsAvecDiffusion resafille = new ReservationDetailsAvecDiffusion();
        resafille.setNomTable("RESERVATIONDETAILS_SANSETAT");
        resafille.setIdmere(reservation.getId());
        ReservationDetailsAvecDiffusion [] details = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(resafille,null,null,null, "");
        List<Mattraquage> mattraquages = new Mattraquage().transformResaToMattraquage(Arrays.asList(details),null);
        System.out.println(mattraquages.size());
    }
}
