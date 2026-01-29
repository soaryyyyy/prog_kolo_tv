package reservation;

import produits.Acte;

import java.sql.Date;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class ReservationDetailsAvecDiffusion extends ReservationDetailsLib{
    String idDiffusion;
    String heureDiffusion;
    String dureeDiffusion;
    String etatLib;
    String idMediaLib;
    String idSupport;
    String idSupportLib;
    int etatMere;
    String client;
    String etatDiffusion;
    String typeService;
    String campagne;
    Date dateMere;

    public String getTypeService() {
        return typeService;
    }

    public void setTypeService(String typeService) {
        this.typeService = typeService;
    }

    public String getEtatDiffusion() {
        return etatDiffusion;
    }

    public void setEtatDiffusion(String etatDiffusion) {
        this.etatDiffusion = etatDiffusion;
    }

    public String getClient() {
        return client;
    }

    public void setClient(String client) {
        this.client = client;
    }

    public ReservationDetailsAvecDiffusion() throws Exception {
        this.setNomTable("RESERVATIONDETAILS_DIFFUSION");
    }

    public String getIdDiffusion() {
        return idDiffusion;
    }

    public void setIdDiffusion(String idDiffusion) {
        this.idDiffusion = idDiffusion;
    }

    public String getHeureDiffusion() {
        return heureDiffusion;
    }

    public void setHeureDiffusion(String heureDiffusion) {
        this.heureDiffusion = heureDiffusion;
    }

    public String getDureeDiffusion() {
        return dureeDiffusion;
    }

    public void setDureeDiffusion(String dureeDiffusion) {
        this.dureeDiffusion = dureeDiffusion;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public String getIdMediaLib() {
        return idMediaLib;
    }

    public void setIdMediaLib(String idMediaLib) {
        this.idMediaLib = idMediaLib;
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public String getIdSupportLib() {
        return idSupportLib;
    }

    public void setIdSupportLib(String idSupportLib) {
        this.idSupportLib = idSupportLib;
    }

    public String getLibelleEtat(){
        if (this.getEtatLib() != null){
            if (this.getEtatLib().equals("CREE")){
                return "en-attente";
            }
            if (this.getEtatLib().equals("VISEE")){
                return "occupe";
            }
        }
        return "en-attente";
    }

    public String getBackGround(){
        String result = "";
        result = "#FFFFFF";
        if (this.getCodeCouleur() != null){
            result = this.getCodeCouleur();
        }
        return result;
    }

    public int getEtatMere() {
        return etatMere;
    }

    public void setEtatMere(int etatMere) {
        this.etatMere = etatMere;
    }

    public String getCampagne() {
        return campagne;
    }

    public void setCampagne(String campagne) {
        this.campagne = campagne;
    }

    public static Map<Integer, List<ReservationDetailsAvecDiffusion>> groupByOrdre(ReservationDetailsAvecDiffusion[] detailsArray) {
        if (detailsArray == null) {
            return null;
        }

        return Arrays.stream(detailsArray)
                .sorted(Comparator
                        .comparing(ReservationDetailsAvecDiffusion::getOrdre)
                        .thenComparing(ReservationDetailsAvecDiffusion::getDaty)   // tri par date
                        .thenComparing(ReservationDetailsAvecDiffusion::getHeure) // tri par heure
                )
                .collect(Collectors.groupingBy(
                        ReservationDetailsAvecDiffusion::getOrdre,
                        LinkedHashMap::new,
                        Collectors.toList()
                ));
    }

    public LocalDate getLocalDate() {
        return this.getDaty().toLocalDate();
    }

    public Date getDateMere() {
        return dateMere;
    }

    public void setDateMere(Date dateMere) {
        this.dateMere = dateMere;
    }

    public LocalDate getLocalDateMere() {
        return this.getDateMere().toLocalDate();
    }
}
