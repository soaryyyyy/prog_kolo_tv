package vente;

public class ProformaCpl extends Proforma{
    private String idMagasinLib;
    private String etatLib;
    private double montanttotal;
    private String idDevise;
    private String idClientLib;
    private double montantpaye;
    private double montantreste;
    private double montantttc;
    double montantTtcAr;
    protected double avoir;
    double montanttva;
    public String nif;
    public String stat;
    public String adresse;
    public String contact;

    public ProformaCpl() {
        this.setNomTable("Proforma_CPL");
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getEtatLib() {
        return etatLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }

    public double getMontanttotal() {
        return montanttotal;
    }

    public void setMontanttotal(double montanttotal) {
        this.montanttotal = montanttotal;
    }

    public String getIdDevise() {
        return idDevise;
    }

    public void setIdDevise(String idDevise) {
        this.idDevise = idDevise;
    }

    public String getIdClientLib() {
        return idClientLib;
    }

    public void setIdClientLib(String idClientLib) {
        this.idClientLib = idClientLib;
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

    @Override
    public double getMontantttc() {
        return montantttc;
    }

    @Override
    public void setMontantttc(double montantttc) {
        this.montantttc = montantttc;
    }

    public double getMontantTtcAr() {
        return montantTtcAr;
    }

    public void setMontantTtcAr(double montantTtcAr) {
        this.montantTtcAr = montantTtcAr;
    }

    public double getAvoir() {
        return avoir;
    }

    public void setAvoir(double avoir) {
        this.avoir = avoir;
    }

    @Override
    public double getMontanttva() {
        return montanttva;
    }

    @Override
    public void setMontanttva(double montanttva) {
        this.montanttva = montanttva;
    }

    public String getNif() {
        return nif;
    }

    public void setNif(String nif) {
        this.nif = nif;
    }

    public String getStat() {
        return stat;
    }

    public void setStat(String stat) {
        this.stat = stat;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }
}
