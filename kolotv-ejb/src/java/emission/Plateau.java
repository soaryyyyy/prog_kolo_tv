package emission;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import constante.ConstanteEtat;
import reservation.Reservation;
import reservation.ReservationDetails;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.CalendarUtil;
import utils.ConstanteKolo;

import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Plateau extends ClassEtat {
    String id,idClient,idEmission,idReservation,remarque,heure;
    double montant;
    Date daty;
    Date dateReserver;
    String source;

    public Date getDateReserver() {
        return dateReserver;
    }

    public void setDateReserver(Date dateReserver) {
        this.dateReserver = dateReserver;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }
    public Plateau() {
        setNomTable("PLATEAU");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public String getIdEmission() {
        return idEmission;
    }

    public void setIdEmission(String idEmission) {
        this.idEmission = idEmission;
    }

    public String getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(String idReservation) {
        this.idReservation = idReservation;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) throws Exception {
        if (!CalendarUtil.isValidTime(heure)) {
            throw new Exception("L'heure doit etre de format HH:mm:ss");
        }
        this.heure = heure;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PLT", "getseqplateau");
        this.setId(makePK(c));
    }

    public Emission getEmission (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            Emission acte = new Emission();
            acte.setId(this.getIdEmission());
            Emission [] list = (Emission []) CGenUtil.rechercher(acte,null,null,c,"");
            if (list.length>0){
                return list[0];
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

    public EmissionDetails getDiffusionEmission (Connection c) throws Exception {
        EmissionDetails details = new EmissionDetails();
        details.setIdMere(this.getIdEmission());
        details.setHeureDebut(this.getHeure());
        details.setJour(Utilitaire.getJourDate(this.getDateReserver()));
        System.out.println(details.getJour());
        EmissionDetails [] list = (EmissionDetails[]) CGenUtil.rechercher(details,null,null,c,"");
        if (list.length>0){
            System.out.println(list[0].getJour());
            return list[0];
        }
        return null;
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
//        if (this.getDiffusionEmission(c)==null) {
//            throw new Exception("Aucune diffusion d'emission pour la date "+this.getDaty()+" a "+this.getHeure());
//        }
        return super.createObject(u, c);
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        Reservation resa = plannifierReservation(c);
        resa = (Reservation) resa.createObject(u,c);
        this.setIdReservation(resa.getId());
        return super.validerObject(u, c);
    }

    public Reservation plannifierReservation(Connection c) throws Exception {
        Reservation result = new Reservation();
        result.setIdBc(this.getSource());
        result.setSource(this.getId());
        result.setEtat(ConstanteEtat.getEtatValider());
        result.setIdclient(this.getIdClient());
        result.setDaty(this.getDaty());
        Emission emission = this.getEmission(c);
        result.setRemarque("Reservation de plateau pour l'emission "+emission.getNom());
        result.setIdSupport(emission.getIdSupport());
        ReservationDetails res = new ReservationDetails();
        res.setIdproduit(ConstanteKolo.idIngredientPlateau);
        res.setDaty(this.getDateReserver());
        res.setHeure(this.getHeure());
        res.setRemarque("Plateau "+emission.getNom());
        res.setDuree(emission.getDuree());
        res.setRemise(0);
        res.setQte(1);
        res.setPu(this.getMontant());
        res.setOrdre(1);
        result.setFille(new ReservationDetails[]{res});
        return result;
    }


}
