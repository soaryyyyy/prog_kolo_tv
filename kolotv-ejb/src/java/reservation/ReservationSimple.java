package reservation;

import bean.ClassMAPTable;
import chatbot.ClassIA;
import utils.CalendarUtil;

import java.sql.Connection;

public class ReservationSimple extends Reservation implements ClassIA
{
    String idProduit;
    double qte;
    String heureDebut;
    String duree;
    String support;

    @Override
    public String getNomTableIA() {
        return "RESERVATIONSIMPLE";
    }
    @Override
    public String getUrlSaisie() {
        return "/pages/module.jsp?but=reservation/reservation-simple-saisie.jsp&currentMenu=ELM001104005";
    }
    @Override
    public ClassIA getClassSaisie() {
        return this;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }

    public ReservationSimple() throws Exception {
        super();
        setNomTable("RESERVATIONSIMPLE");
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception
    {
        Reservation rs = this.genererReservation(c);
        return rs.createObject(u, c);
    }

    public Reservation genererReservation(Connection c) throws Exception {
        Reservation res = new Reservation();
        produits.Ingredients i = (produits.Ingredients)new produits.Ingredients().getById(this.getIdProduit(),null,c) ;
        if(i==null)throw new Exception("Chambre non existante");
        ReservationDetails[] resDetails = new ReservationDetails[1];
        try
        {
            res.setIdSupport(this.getSupport());
            res.setDaty(this.getDaty());
            res.setIdclient(this.getIdclient());
            res.setRemarque(this.getRemarque());
            resDetails[0] = new ReservationDetails();
            resDetails[0].setIdproduit(this.getIdProduit());
            resDetails[0].setQte(this.getQte());
            resDetails[0].setDaty(this.getDaty());
            resDetails[0].setPu(i.getPu());
            resDetails[0].setHeure(this.getHeureDebut());
            resDetails[0].setDuree(this.getDuree());
            res.setFille(resDetails);
        }
        catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Generer reservation failed");
        }
        return res;
    }

    public String getHeureDebut() {
        return heureDebut;
    }

    public void setHeureDebut(String heureDebut) throws Exception {
        if (!CalendarUtil.isValidTime(duree)) {
            throw new Exception("L'Heure doit etre de format HH:MM:SS");
        }
        this.heureDebut = heureDebut;
    }

    public String getDuree() {
        return duree;
    }

    public void setDuree(String duree) throws Exception {
        if (!CalendarUtil.isValidTime(duree)) {
            throw new Exception("La duree doit etre de format HH:MM:SS");
        }
        controlerDuree();
        this.duree = duree;
    }

    public String getSupport() {
        return support;
    }

    public void setSupport(String support) {
        this.support = support;
    }

    public void controlerDuree() throws Exception {
        int duree = CalendarUtil.HMSToSecond(this.getDuree());
        if (duree<=0){
            throw new Exception("La duree doit etre superieur ou egal a 1 seconde");
        }
    }
}
