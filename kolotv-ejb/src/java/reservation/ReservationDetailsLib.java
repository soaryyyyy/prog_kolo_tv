package reservation;

import chatbot.ClassIA;

public class ReservationDetailsLib extends ReservationDetails implements ClassIA
{
    String libelleproduit;
    String libellemedia;
    String categorieproduit;
    double montant;
    String categorieproduitlib;
    String libelleClient;
    double tva;
    double montantTva;
    double montantTtc;
    double montantRemise;
    double montantFinal;
    String codeCouleur;

    public String getCodeCouleur() {
        return codeCouleur;
    }

    public void setCodeCouleur(String codeCouleur) {
        this.codeCouleur = codeCouleur;
    }

    public String getLibellemedia() {
        return libellemedia;
    }

    public void setLibellemedia(String libellemedia) {
        this.libellemedia = libellemedia;
    }

    @Override
    public String getNomTableIA() {
        return "RESERVATIONDETAILS_LIB";
    }
    @Override
    public String getUrlListe() {
        return "/pages/module.jsp?but=reservation/reservation-liste.jsp&currentMenu=ELM001104006";
    }
    @Override
    public String getUrlSaisie() {
        return "/pages/module.jsp?but=reservation/reservation-simple-saisie.jsp&currentMenu=ELM001104005";
    }
    @Override
    public ClassIA getClassListe() {
        return this;
    }
    @Override
    public ClassIA getClassSaisie() {
        try {
            return new ReservationSimple();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public double getMontantTva() {
        return montantTva;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
    }

    public double getMontantTtc() {
        return montantTtc;
    }

    public void setMontantTtc(double montantTtc) {
        this.montantTtc = montantTtc;
    }

    public double getMontantRemise() {
        return montantRemise;
    }

    public void setMontantRemise(double montantRemise) {
        this.montantRemise = montantRemise;
    }

    public double getMontantFinal() {
        return montantFinal;
    }

    public void setMontantFinal(double montantFinal) {
        this.montantFinal = montantFinal;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public String getLibelleClient() {
        return libelleClient;
    }

    public void setLibelleClient(String libelleClient) {
        this.libelleClient = libelleClient;
    }

    public String getCategorieproduitlib() {
        return categorieproduitlib;
    }

    public void setCategorieproduitlib(String categorieproduitlib) {
        this.categorieproduitlib = categorieproduitlib;
    }

    public String getLibelleproduit() {
        return libelleproduit;
    }

    public void setLibelleproduit(String libelleproduit) {
        this.libelleproduit = libelleproduit;
    }

    public String getCategorieproduit() {
        return categorieproduit;
    }

    public void setCategorieproduit(String categorieproduit) {
        this.categorieproduit = categorieproduit;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public String getLibelleStatus() {
        String ret="disponible";
        if(this.getEtat()>=11) ret="occupe";
        if(this.getEtat()<11) ret="en-attente";
        return ret;
    }

    public ReservationDetailsLib() throws Exception {
        super();
        setNomTable("RESERVATIONDETAILS_LIB");
    }
}
