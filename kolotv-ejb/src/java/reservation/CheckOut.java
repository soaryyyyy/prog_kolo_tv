package reservation;

import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.ConstanteAsync;
import produits.Acte;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.util.ArrayList;

import bean.CGenUtil;

import caisse.CategorieCaisse;

import utilitaire.UtilDB;
import utilitaire.Utilitaire;
public class CheckOut extends Check {
    Check checkIn;
    private String etatlib;

    public Check getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(Check checkIn) {
        this.checkIn = checkIn;
    }

    public String getEtatlib() {
        return this.etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public CheckOut() {
        setNomTable("CHECKOUT");
    }

    public CheckOut(String nT) {
        super(nT);
    }
    public void construirePK(Connection c) throws Exception {
         this.preparePk("COT", "get_seqCheckOut");
        this.setId(makePK(c));
    }
    public Check getCheckIn(String nT, Connection c)throws Exception {
        reservation.Check checkIn = new reservation.Check();
        checkIn.setId(this.getReservation());
        if(nT!=null&&nT.compareToIgnoreCase("")!=0)checkIn.setNomTable(nT);
        Check[] retour=(Check[]) CGenUtil.rechercher(checkIn,null,null,c,"");
        if(retour.length==0){return null;}
        return retour[0];
    }
    public static Acte[] genererActe(String idCheckIn,String datyFin,Connection c) throws Exception
    {
        CheckOut checkOut = new CheckOut("");
        checkOut.setDaty(Utilitaire.string_date("dd/MM/yyyy",datyFin));
        checkOut.setReservation(idCheckIn);
        checkOut.setCheckIn(checkOut.getCheckIn("checkInLibelle",c));
        return checkOut.genererActe(c);
    }
    public Acte[] genererActe(Connection c)throws Exception
    {
        reservation.Check checkIn = this.getCheckIn("checkInLibelle",c);
        int nbJour=Utilitaire.diffJourDaty(this.getDaty(),checkIn.getDaty());
        Acte[] retour=new Acte[nbJour];
        for(int i=0;i<nbJour;i++)
        {
            retour[i]=new Acte();
            retour[i].setIdproduit(checkIn.getIdProduit());
            retour[i].setLibelle(checkIn.getProduitLibelle());
            retour[i].setQte(1);
            retour[i].setPu(checkIn.getPu());
            retour[i].setIdreservation(checkIn.getId());
            retour[i].setDaty(Utilitaire.ajoutJourDate(checkIn.getDaty(),i));
            retour[i].setEtat(ConstanteEtat.getEtatCreer());
            retour[i].setIdclient(checkIn.getIdClient());
            retour[i].setTva(checkIn.getTva());
            retour[i].setCompte_vente(checkIn.getCompteVente());
        }
        return retour;
    }
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            System.out.println("AVANT LE CHECK IN ");
            Check ch = getCheckIn("checkInLibelle", c);
            if(ch.getCheckOut()!=null&&ch.getCheckOut().compareTo(this.getId())!=0) throw new Exception ("Exsistance de check out en doublons");
            this.setCheckIn(ch);
            Acte[] listeActe = genererActe(c);
            for(Acte a:listeActe)
            {
                a.createObject(u,c);
                a.validerObject(u,c);
            }
            if(Utilitaire.comparerHeure(this.getHeure(), ConstanteAsync.heureCheckout)>0) this.setDaty(Utilitaire.ajoutJourDate(this.getDaty(),1));
            Object o=super.validerObject(u, c);
            if(estOuvert==true)c.commit();
            return o;
        }
        catch (Exception e) {
            c.rollback();
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null){c.close();}
        }
    }
    /*public void setDaty(java.sql.Date daty) throws Exception {

        Check in=getCheckIn("Checkin",null);
        if (Utilitaire.compareDaty(daty,in.getDaty())==-1)
        { 
            throw new Exception("La date du Check-Out doit &ecirc;tre sup&eacute;rieur &agrave; la date du Check-In");
        } 
        super.setDaty(daty);
    }*/

    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        Check in=getCheckIn("Checkin",c);
        if (Utilitaire.compareDaty(this.getDaty(),in.getDaty())==-1)
        { 
            throw new Exception("La date du Check-Out doit etre superieur a la date du Check-In");
        } 
        return super.createObject(u, c);
    }
    
}
