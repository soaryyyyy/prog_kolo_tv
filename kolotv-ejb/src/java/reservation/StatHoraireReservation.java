package reservation;

import bean.ClassMAPTable;
import utilitaire.UtilDB;

import java.sql.*;
import java.sql.Date;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

public class StatHoraireReservation extends ClassMAPTable {
    private String id;
    private String heure;
    private int nbResa;
    private Date daty;
    private String idSupport;
    private String idTypeService;

    public StatHoraireReservation() {
        setNomTable("stat_horaire_reservation");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public int getNbResa() {
        return nbResa;
    }

    public void setNbResa(int nbResa) {
        this.nbResa = nbResa;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public String getIdTypeService() {
        return idTypeService;
    }

    public void setIdTypeService(String idTypeService) {
        this.idTypeService = idTypeService;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public StatHoraireReservation[] getSatistiquePlageHoraire(String heureDebut,String heureFin,String dtDebut, String dtFin, Connection c) throws SQLException {
        List<StatHoraireReservation> satistiquePlageHoraire = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String aWhere = "";
            if (this.getIdSupport()!=null && this.getIdSupport().isEmpty()==false && !this.getIdSupport().equals("%")){
                aWhere += " AND r.IDSUPPORT='"+this.getIdSupport()+"'";
            }
            if (this.getIdTypeService()!=null && this.getIdTypeService().isEmpty()==false && !this.getIdTypeService().equals("%")){
                aWhere += " AND ai.CATEGORIEINGREDIENT='"+this.getIdTypeService()+"'";
            }
            if (dtDebut!=null && !dtDebut.equals("")) {
                aWhere += " AND rd.DATY>=TO_DATE('"+dtDebut+"','dd/mm/YYYY')";
            }
            if (dtFin!=null && !dtFin.equals("")) {
                aWhere += " AND rd.DATY<=TO_DATE('"+dtFin+"','dd/mm/YYYY')";
            }
            if (heureDebut!=null && !heureDebut.equals("")) {
                aWhere += " AND TO_DATE(rd.HEURE, 'HH24:MI')>=TO_DATE('"+heureDebut+"','HH24:MI')";
            }
            if (heureFin!=null && !heureFin.equals("")) {
                aWhere += " AND TO_DATE(rd.HEURE, 'HH24:MI')<=TO_DATE('"+heureFin+"','HH24:MI')";
            }
            satistiquePlageHoraire = new ArrayList<>();
            String request = "SELECT" +
                    "    rd.HEURE," +
                    "    COUNT(rd.ID) as nbResa " +
                    "FROM RESERVATIONDETAILS rd " +
                    "         LEFT JOIN RESERVATION r ON r.ID = rd.IDMERE " +
                    "         LEFT JOIN AS_INGREDIENTS ai ON ai.ID = rd.IDPRODUIT "+
                    " WHERE r.ETAT=11 "+aWhere+" group by rd.HEURE ORDER BY rd.HEURE ASC";
            PreparedStatement ps = c.prepareStatement(request);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                if (count<20){
                    StatHoraireReservation item = new StatHoraireReservation();
                    item.setHeure(rs.getString("HEURE"));
                    item.setNbResa(rs.getInt("nbResa"));
                    satistiquePlageHoraire.add(item);
                }
                count++;
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
        return satistiquePlageHoraire.toArray(new StatHoraireReservation[]{});
    }

    public static Map<String, Double> getDataChart(Map<String, Double> dataChart) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("HH:mm");

        return dataChart.entrySet()
                .stream()
                .sorted(Comparator.comparing(e -> LocalTime.parse(e.getKey(), formatter)))
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new
                ));
    }
}
