package emission;

import bean.ClassMAPTable;
import reservation.StatHoraireReservation;
import utilitaire.UtilDB;

import java.sql.*;
import java.sql.Date;
import java.util.*;
import java.util.stream.Collectors;

public class StatActiviteEmission extends ClassMAPTable {
    private String id,nom,idSupport;
    private int nbPlateau,nbParrainage;
    private Date daty;
    private double montantpaye;
    private double montantreste;
    private double montantttc;
    private String idDevise;

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public double getMontantpaye() {
        return montantpaye;
    }

    public void setMontantpaye(double montantpaye) {
        this.montantpaye = montantpaye;
    }

    public double getMontantreste() {
        return montantreste;
    }

    public void setMontantreste(double montantreste) {
        this.montantreste = montantreste;
    }

    public double getMontantttc() {
        return montantttc;
    }

    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }

    public StatActiviteEmission() {
        this.setNomTable("emission_activite");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public int getNbPlateau() {
        return nbPlateau;
    }

    public void setNbPlateau(int nbPlateau) {
        this.nbPlateau = nbPlateau;
    }

    public int getNbParrainage() {
        return nbParrainage;
    }

    public void setNbParrainage(int nbParrainage) {
        this.nbParrainage = nbParrainage;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public StatActiviteEmission[] getSatistiqueEmission(String dtDebut, String dtFin,int option, Connection c) throws SQLException {
        List<StatActiviteEmission> result = null;
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String aWhere = "";
            if (this.getIdSupport()!=null && this.getIdSupport().isEmpty()==false && !this.getIdSupport().equals("%")){
                aWhere += " AND e.IDSUPPORT='"+this.getIdSupport()+"'";
            }
            String aWhereParrainage = "";
            String aWherePlateau = "";
            if (dtDebut!=null && !dtDebut.equals("")) {
                aWhereParrainage += " AND p.DATEDEBUT>=TO_DATE('"+dtDebut+"','dd/mm/YYYY')";
                aWherePlateau += " AND pl.DATY>=TO_DATE('"+dtDebut+"','dd/mm/YYYY')";
            }
            if (dtFin!=null && !dtFin.equals("")) {
                aWhereParrainage += " AND p.DATEDEBUT<=TO_DATE('"+dtFin+"','dd/mm/YYYY')";
                aWherePlateau += " AND pl.DATY<=TO_DATE('"+dtFin+"','dd/mm/YYYY')";
            }
            result = new ArrayList<>();
            String request = "";
            if (option==1){
                request = "SELECT" +
                        "    e.ID," +
                        "    e.NOM," +
                        "    COUNT(CASE WHEN pl.ETAT IS NOT NULL AND pl.ETAT=11 "+aWherePlateau+" THEN 1 END) as nbPlateau " +
                        "FROM EMISSION e" +
                        "    LEFT JOIN PLATEAU pl ON pl.IDEMISSION = e.ID" +
                        " WHERE 1=1 "+aWhere+
                        " group by e.ID, e.NOM, e.IDSUPPORT ORDER BY nbPlateau DESC";
            }
            if (option==0){
                request = "SELECT" +
                        "    e.ID," +
                        "    e.NOM," +
                        "    COUNT(CASE WHEN p.ETAT IS NOT NULL AND p.ETAT=11 "+aWhereParrainage+" THEN 1 END) as nbParrainage " +
                        "FROM EMISSION e" +
                        "    LEFT JOIN PARRAINAGEEMISSION p ON p.IDEMISSION = e.ID" +
                        " WHERE 1=1 "+aWhere+
                        " group by e.ID, e.NOM, e.IDSUPPORT ORDER BY nbParrainage DESC";
            }
            PreparedStatement ps = c.prepareStatement(request);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                if (count<10){
                    StatActiviteEmission item = new StatActiviteEmission();
                    item.setNom(rs.getString("NOM"));
                    if (option==1){
                        item.setNbPlateau(rs.getInt("nbPlateau"));
                    }
                    if (option==0){
                        item.setNbParrainage(rs.getInt("nbParrainage"));
                    }
                    result.add(item);
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
        return result.toArray(new StatActiviteEmission[]{});
    }

    public static Map<String, Double> getDataChart(Map<String, Double> dataChart) {
        return dataChart.entrySet()
                .stream()
                .sorted(Map.Entry.<String, Double>comparingByValue().reversed())
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (e1, e2) -> e1,
                        LinkedHashMap::new
                ));
    }
}
