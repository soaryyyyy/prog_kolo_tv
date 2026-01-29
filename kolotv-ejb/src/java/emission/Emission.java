package emission;

import annexe.ProduitLib;
import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.ClassMere;
import reservation.ReservationDetails;
import utilitaire.UtilDB;
import utils.CalendarUtil;

import java.sql.Connection;
import java.sql.Date;
import java.util.*;

public class Emission extends ClassMere {

    String id;
    String idSupport;
    String nom;
    double tarifplateau;
    double tarifparainage;
    int secondeparainage;
    String duree;
    String idGenre;

    public String getIdGenre() {
        return idGenre;
    }

    public void setIdGenre(String idGenre) {
        this.idGenre = idGenre;
    }

    public Emission() throws Exception {
        this.setNomTable("EMISSION");
        setLiaisonFille("idMere");
        setNomClasseFille("emission.EmissionDetails");
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
        this.preparePk("EMI", "GETSEQ_EMISSION");
        this.setId(makePK(c));
    }

    // Getters et Setters
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

    public double getTarifplateau() {
        return tarifplateau;
    }

    public void setTarifplateau(double tarifplateau) {
        this.tarifplateau = tarifplateau;
    }

    public double getTarifparainage() {
        return tarifparainage;
    }

    public void setTarifparainage(double tarifparainage) {
        this.tarifparainage = tarifparainage;
    }

    public int getSecondeparainage() {
        return secondeparainage;
    }

    public void setSecondeparainage(int secondeparainage) {
        this.secondeparainage = secondeparainage;
    }


    public void setDuree(String duree) throws Exception {
        if (!CalendarUtil.isValidTime(duree)) {
            this.duree = duree;
        }
        else {
            this.duree = String.valueOf(CalendarUtil.HMSToSecond(duree));
        }
    }

    public String getDuree() {
        return duree;
    }


    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"id","nom"};
    }

    public ReservationDetails[] genererReservationPourSponsors(Date date, String heure, Connection c) throws Exception {
        List<ReservationDetails> result = new ArrayList<>();

        ProduitLib ing = new ProduitLib();
        ing.setNomTable("PRODUIT_VENTE_LIB");
        ing.setId("INGDKLT00037");
        ProduitLib [] list = (ProduitLib[]) CGenUtil.rechercher(ing,null,null,c,"");
        if (list.length>0){
            ing = list[0];
        }
        ParrainageEmission search = new ParrainageEmission();
        search.setIdemission(this.getId());
        ParrainageEmission [] sponsors = (ParrainageEmission[]) CGenUtil.rechercher(search,null,null,c,"");
        for (ParrainageEmission sponsor : sponsors) {
            for (int i = 0; i < 3; i++) {
                ReservationDetails reservationDetails = new ReservationDetails();
                reservationDetails.setIdparrainage(sponsor.getId());
                reservationDetails.setIdproduit(ing.getId());
                reservationDetails.setDaty(date);
                reservationDetails.setHeure(heure);
                reservationDetails.setPu(0);
                reservationDetails.setRemise(0);
                reservationDetails.setQte(1);
                reservationDetails.setDuree(String.valueOf(ing.getDuree()));
                result.add(reservationDetails);
            }
        }
        return result.toArray(new ReservationDetails[]{});
    }

    public EmissionDetails [] getEmissionDetails (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            EmissionDetails acte = new EmissionDetails();
            acte.setIdMere(this.getId());
            EmissionDetails [] list = (EmissionDetails []) CGenUtil.rechercher(acte,null,null,c,"");
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
}
