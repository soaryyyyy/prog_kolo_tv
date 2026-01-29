package reservation;

import bean.CGenUtil;
import bean.ClassEtat;
import bean.ClassMAPTable;
import org.joda.time.DateTime;


import java.sql.Connection;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import produits.Acte;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

public class Check extends bean.ClassEtat {
    private String id;
    /**
     * Mivadika ho idChekIn ity rehefa checkOut
     */
    private String reservation,idClient;
    private java.sql.Date daty;
    private String heure,checkOut,compteVente;
    private String remarque,idProduit,produitLibelle, client,etatlib;
    double pu,tva,qte;


    public String getEtatlib() {
        return this.etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }
    
    public String getClient() {
        return client;
    }

    public void setClient(String client) {
        this.client = client;
    }

    public String getCompteVente() {
        return compteVente;
    }

    public void setCompteVente(String compteVente) {
        this.compteVente = compteVente;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public String getIdClient() {
        return idClient;
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public String getProduitLibelle() {
        return produitLibelle;
    }

    public void setProduitLibelle(String produitLibelle) {
        this.produitLibelle = produitLibelle;
    }

    public String getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(String checkOut) {
        this.checkOut = checkOut;
    }

    public String getIdProduit() {
        return idProduit;
    }

    public void setIdProduit(String idProduit) {
        this.idProduit = idProduit;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if(this.getMode().equals("modif")){
            if(pu < 0){
                throw new Exception("Prix unitaire invalide pour une ligne");
            }
        }
        this.pu = pu;
    }

    public Check(String nT) {
        super.setNomTable(nT);
    }
    public Check() {
        super.setNomTable("checkIn");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getReservation() {
        return reservation;
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("CIN", "get_seqChekIn");
        if(this.getNomTable().compareTo("checkOut") == 0) this.preparePk("COT", "get_seqCheckOut");
        this.setId(makePK(c));
    }

    public void setReservation(String reservation) {
        this.reservation = reservation;
    }

    public java.sql.Date getDaty() {
        return daty;
    }

    public void setDaty(java.sql.Date daty) throws Exception {
        if (this.getMode().compareTo("modif") == 0) {
            if (daty == null) {
                daty = utilitaire.Utilitaire.dateDuJourSql();
            }
        }
        this.daty = daty;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    public reservation.Reservation[] getReservations(String nT,Connection c)throws Exception {
        return null;
    }
    public Object validerObject(String u, Connection c) throws Exception {
        return super.validerObject(u, c);
    }

    public Reservation createReservation(String u, Connection c) throws Exception{
        Reservation r= new Reservation();
        r.setIdclient(this.getIdClient());
        r.setDaty(this.getDaty());
        r.setRemarque("Reservation sur place");
        produits.Ingredients i = (produits.Ingredients)new produits.Ingredients().getById(this.getIdProduit(),null,c) ;
        if(i==null)throw new Exception("Chambre non existante");
        ReservationDetails [] rd= new ReservationDetails[1];
        rd[0] = new ReservationDetails();
        rd[0].setDaty(this.getDaty());
        // rd[0].setHeure(this.getHeure());
        rd[0].setIdproduit(this.getIdProduit());
        rd[0].setRemarque(this.getProduitLibelle());
        rd[0].setQte(this.getQte());
        rd[0].setPu(i.getPu());
        r.setFille(rd);
        r.createObject(u, c);
        this.setReservation(r.getId());
        return r;
    }

    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        Reservation retour = null;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            if (this.getReservation().isEmpty() || this.getReservation().equalsIgnoreCase("null") || this.getReservation()==null) {
                retour = createReservation(u, c);
            }
            ClassMAPTable i = super.createObject(u, c);
            if (estOuvert) {
                c.commit();
            }
            return retour;
        }
        catch (Exception e) {
            c.rollback();
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null){c.close();}
        }
    }

    public vente.VenteDetails[] genereVenteDetails(String nTableActe,Connection c)throws Exception {
        Acte[] listeActe=getActe(nTableActe,c);
        vente.VenteDetails[] retour=new vente.VenteDetails[listeActe.length];
        for(int i=0;i<listeActe.length;i++)
        {
            retour[i]=listeActe[i].genererVenteDetails();
        }
        return retour;
    }
    public reservation.CheckOut getCheckOut(String nT, Connection c)throws Exception {
        reservation.CheckOut checkOut = new reservation.CheckOut();
        checkOut.setReservation (this.getId());
        if(nT!=null&&nT.compareToIgnoreCase("")!=0)checkOut.setNomTable(nT);
        CheckOut[] retour=(CheckOut[]) CGenUtil.rechercher(checkOut,null,null,c,"");
        if(retour.length==0){return null;}
        return retour[0];
    }
    public Acte[] getActeAvecSimulation(String nTActe,Connection c)throws Exception {
        reservation.CheckOut listeCheckOut=getCheckOut(null,c);
        String dateMax=Utilitaire.dateDuJour();
        Acte[] listeGen=null;
        if(listeCheckOut==null) {
            listeGen= CheckOut.genererActe(this.getId(), dateMax,c);
        }
        Acte[] listeInsere=this.getActe(nTActe,c);
        List<Acte> retour=new ArrayList<>();
        if(listeGen!=null) retour.addAll(Arrays.asList(listeGen));
        retour.addAll(Arrays.asList(listeInsere));
        return retour.toArray(new Acte[retour.size()]);

    }
    public produits.Acte[] getActe(String nT, Connection c) throws Exception
    {
        boolean estOuvert = false;
        try {
            if(c==null)
            {
                c=new UtilDB().GetConn();
                estOuvert = true;
            }
            Acte crt = new Acte();
            if (nT != null && nT.compareTo("") != 0) crt.setNomTable(nT);
            crt.setIdreservation(this.getId());
            return (Acte[]) CGenUtil.rechercher(crt,null,null,c,"");
        }
        catch(Exception e){
            throw e;
        }
        finally {
            if(estOuvert==true && c!=null) c.close();
        }
    }

    public double getQte() {
        return qte;
    }

    public void setQte(double qte) {
        this.qte = qte;
    }
}
