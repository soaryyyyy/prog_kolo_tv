package fabrication;

import bean.ClassFille;
import bean.ClassMere;
import produits.Ingredients;

import java.sql.Connection;
import java.sql.Date;

public class OfFille extends ClassFille
{
    String id,idIngredients,remarque,libelle, idMere, idunite,libIngredients;
    double qte;
    Date datyBesoin;
    /*Reto manaraka reto tsy atao anaty table*/
    double dureeHeure,qteFabriques,puRevient;

    public double getPuRevient() {
        return puRevient;
    }

    public String getLibIngredients() {
        return libIngredients;
    }

    public void setLibIngredients(String libIngredients) {
        this.libIngredients = libIngredients;
    }

    public void setPuRevient(double puRevient) {
        this.puRevient = puRevient;
    }
    public double getMontantRevient() {
        return getPuRevient()*getQte();
    }
    public void calculerRevient(Connection c) throws Exception {
        if(this.getIdIngredients()==null)setPuRevient(0);
        Ingredients i=(Ingredients)new Ingredients().getById(this.getIdIngredients(),null,c);
        if(i.getCompose()==0)
        {
            this.setPuRevient(i.getPu());
            return;
        }
        double revient=i.calculerRevient(c);
        this.setPuRevient(revient);
    }

    public String getIdMere() {
        return idMere;
    }
    public OfFille() throws Exception {
        super.setNomTable("OfFille");
        setLiaisonMere("idmere");
        setNomClasseMere("fabrication.Of");
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("OFF", "getseqoffille");
        this.setId(makePK(c));
    }

    public double getDureeHeure() {
        return dureeHeure;
    }

    public void setDureeHeure(double dureeHeure) {
        this.dureeHeure = dureeHeure;
    }

    public double getQteFabriques() {
        return qteFabriques;
    }

    public void setQteFabriques(double qteFabriques) {
        this.qteFabriques = qteFabriques;
    }

    public String getIdunite() {
        return idunite;
    }

    public void setIdunite(String idunite) {
        this.idunite = idunite;
    }

    public void setIdMere(String mere) {
        this.idMere = mere;
    }
    @Override
    public String getNomClasseMere()
    {
        return "fabrication.Of";
    }
    @Override
    public String getLiaisonMere()
    {
        return "idMere";
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

    public String getIdIngredients() {
        return idIngredients;
    }

    public void setIdIngredients(String idIngredients)throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0&&(idIngredients==null||idIngredients.compareToIgnoreCase("")==0)) throw new Exception("Composant obligatoire");
        this.idIngredients = idIngredients;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif") == 0&&qte==0) throw new Exception("quantite non valide");
        this.qte = qte;
    }

    public Date getDatyBesoin() {
        return datyBesoin;
    }

    public void setDatyBesoin(Date datyBesoin) {
        this.datyBesoin = datyBesoin;
    }
}
