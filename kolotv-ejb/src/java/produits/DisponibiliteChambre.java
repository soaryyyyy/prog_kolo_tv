package produits;

import bean.ClassMAPTable;
import chatbot.ClassIA;
import fabrication.FabricationFille;

import java.sql.Date;

public class DisponibiliteChambre extends ClassMAPTable implements ClassIA {
    private Date daty;
    private String idChambre;
    private String nomChambre;
    private int qte;
    private String idReservation;
    private int etat;
    private boolean estDisponible;
    private String idreservationdetails;

    @Override
    public String getNomTableIA() {
        return "V_DISPONIBILTE_CHAMBRE";
    }
    @Override
    public String getUrlListe() {
        return "/pages/module.jsp?but=accueil.jsp";
    }
    @Override
    public String getUrlAnalyse() {
        return "/pages/module.jsp?but=accueil.jsp";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassAnalyse() {
        return this;
    }

    public DisponibiliteChambre() {
        this.setNomTable("V_DISPONIBILTE_CHAMBRE");
    }

    @Override
    public String getTuppleID() {
        return idReservation;
    }

    @Override
    public String getAttributIDName() {
        return "idReservation";
    }

    public DisponibiliteChambre(Date daty, String idChambre, String nomChambre, int qte, String idReservation, int etat) {
        this.setNomTable("V_DISPONIBILTE_CHAMBRE");
        setDaty(daty);
        setIdChambre(idChambre);
        setNomChambre(nomChambre);
        setQte(qte);
        setIdReservation(idReservation);
        setEtat(etat);
        setEstDisponible();
    }

    public boolean getEstDisponible() {
        return estDisponible;
    }

    public void setEstDisponible() {
        this.estDisponible = getIdReservation() == null || getIdReservation().isEmpty();
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdChambre() {
        return idChambre;
    }

    public void setIdChambre(String idChambre) {
        this.idChambre = idChambre;
    }

    public String getNomChambre() {
        return nomChambre;
    }

    public void setNomChambre(String nomChambre) {
        this.nomChambre = nomChambre;
    }

    public int getQte() {
        return qte;
    }

    public void setQte(int qte) {
        this.qte = qte;
    }

    public String getIdReservation() {
        return idReservation;
    }

    public void setIdReservation(String idReservation) {
        this.idReservation = idReservation;
    }

    public int getEtat() {
        return etat;
    }

    public void setEtat(int etat) {
        this.etat = etat;
    }
    public void setEstDisponible(boolean estDisponible) {
        this.estDisponible = estDisponible;
    }
    public String getIdreservationdetails() {
        return idreservationdetails;
    }
    public void setIdreservationdetails(String idreservationdetails) {
        this.idreservationdetails = idreservationdetails;
    }
}
