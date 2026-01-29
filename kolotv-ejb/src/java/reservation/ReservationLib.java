package reservation;

public class ReservationLib extends Reservation
{
    String idclientlib;
    String etatlib;
    double montant, montantTva,montantTTC,paye,resteAPayer,montantFinal, montantRemise;
    String idSupportLib;
    int etatFacturation;
    String etatFacturationLib;

    public int getEtatFacturation() {
        return etatFacturation;
    }

    public void setEtatFacturation(int etatFacturation) {
        this.etatFacturation = etatFacturation;
    }

    public String getEtatFacturationLib() {
        return etatFacturationLib;
    }

    public void setEtatFacturationLib(String etatFacturationLib) {
        this.etatFacturationLib = etatFacturationLib;
    }

    public String getIdSupportLib() {
        return idSupportLib;
    }

    public void setIdSupportLib(String idSupportLib) {
        this.idSupportLib = idSupportLib;
    }

    public double getPaye() {
        return paye;
    }

    public void setPaye(double paye) {
        this.paye = paye;
    }

    public double getResteAPayer() {
        return resteAPayer;
    }

    public void setResteAPayer(double resteAPayer) {
        this.resteAPayer = resteAPayer;
    }

    public double getMontantTva() {
        return montantTva;
    }

    public double getMontantTTC() {
        return montantTTC;
    }

    public void setMontantTTC(double montantTTC) {
        this.montantTTC = montantTTC;
    }

    public void setMontantTva(double montantTva) {
        this.montantTva = montantTva;
    }

    public String getIdclientlib() {
        return idclientlib;
    }

    public void setIdclientlib(String idclientlib) {
        this.idclientlib = idclientlib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public double getMontantFinal() {
        return montantFinal;
    }

    public void setMontantFinal(double montantFinal) {
        this.montantFinal = montantFinal;
    }

    public ReservationLib() throws Exception {
        super();
        setNomTable("RESERVATION_LIB");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","idclientlib","daty","etatlib"};
        return motCles;
    }

    public double getMontantRemise() {
        return montantRemise;
    }

    public void setMontantRemise(double montantRemise) {
        this.montantRemise = montantRemise;
    }
}
