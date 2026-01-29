package reservation;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import org.apache.poi.ss.excelant.ExcelAntPrecision;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;
import produits.Ingredients;
import utils.ConstanteAsync;

public class EtatReservation {



     String[] listeDate;
     String[] listeChambre;
    String[] listeIdChambre;
    HashMap<String, Vector> listeReservation;
    Ingredients[] listeChb;
    HashMap<String, Double> listeMontant;

    public HashMap<String, Double> getListeMontant() {
        return listeMontant;
    }

    public String[] getListeIdChambre() {
        return listeIdChambre;
    }

    public Ingredients[] getListeChb() {
        return listeChb;
    }

    public String[] getListeDate() {
        return listeDate;
    }

    public String[] getListeChambre() {
        return listeChambre;
    }

    public HashMap<String, Vector> getListeReservation() {
        return listeReservation;
    }
    public EtatReservation(String nTChambre,String nTResa,String dtMin, String dMax) throws Exception {
        Connection c=null;
        this.setListeDate(dtMin, dMax);
        try {
            c = new UtilDB().GetConn();
            setListeChambre(nTChambre, c);
            this.setListeReservation(nTResa,c,dtMin,dMax);
            this.setListeMontant();
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(c!=null)c.close();
        }
    }
    public void setListeDate(String dtMin, String dMax) throws Exception {
        //if(Utilitaire.compareDaty(dMax,dtMin)<0) throw new Exception("Date sup inferieur a date Inf");
        if(Utilitaire.diffJourDaty(dMax,dtMin)<0)throw new Exception("Date sup inferieur a date Inf");
        int day = Utilitaire.diffJourDaty(dMax, dtMin);
        String liste[]=new String[day];
        for (int i = 0; i < day; i++) {
            liste[i]=Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(dtMin,i))  ;
        }
        this.listeDate = liste;
    }
    public void setListeChambre(String nT,Connection c) throws Exception {
        Ingredients crt=new Ingredients();
        if(nT!=null)crt.setNomTable(nT);
        crt.setCategorieIngredient(ConstanteAsync.categorieChambre);
        Ingredients[] liste=(Ingredients[]) CGenUtil.rechercher(crt,null,null,c," order by libelle asc");
        String[] ret=new String[liste.length];
        String[] retId=new String[liste.length];
        this.listeChb=liste;
        for(int i=0;i<liste.length;i++){
            ret[i]=liste[i].getLibelle();
            retId[i]=liste[i].getId();
        }
        listeChambre=ret;
        listeIdChambre=retId;
    }
    public void setListeReservation(String nTResa,Connection c,String dMin,String dMax) throws Exception {
        reservation.ReservationDetailsLib res=new reservation.ReservationDetailsLib();
        if(nTResa!=null)res.setNomTable(nTResa);
        if(dMin==null||dMin.compareToIgnoreCase("")==0)dMin=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
        String[] colInt={"daty"};
        String[] valInt={dMin,dMax};
        HashMap<String,Vector> valiny=CGenUtil.rechercher2D(res,colInt,valInt,"daty",c,"");
        listeReservation=valiny;
    }
    public void setListeMontant() throws Exception {
        HashMap<String, Double> montant=new HashMap<>();
        for (Map.Entry<String, Vector> entry : listeReservation.entrySet()) {
            String key = entry.getKey();
            Vector v = entry.getValue();
            reservation.ReservationDetailsLib[] listeR=new reservation.ReservationDetailsLib[v.size()];
            v.copyInto(listeR);
            montant.put(key,new Double(AdminGen.calculSommeDouble(listeR,"montantCalcule")));
        }
        listeMontant=montant;
    }
    public double getSommeBydate(String daty) throws Exception {
        Double l=listeMontant.get(daty);
        if(l==null)return 0;
        return listeMontant.get(daty).doubleValue();
    }
    public String[] getValeur(String daty,String chambre) throws Exception
    {
        Vector v=listeReservation.get(daty);
        if(v==null)return null;
        String[] attrEt={"libelleproduit"};
        String[] valEt={chambre};
        reservation.ReservationDetailsLib[] r= (reservation.ReservationDetailsLib[]) AdminGen.find(v,attrEt,valEt);
        if(r==null)return null;
        String[] ret=new String[r.length];
        for(int i=0;i<r.length;i++)
            ret[i]= Utilitaire.remplacerNull(r[i].getLibelleClient());
        return ret;
    }


    public String[] getValeurById(String daty,String idChambre) throws Exception
    {
        String[] retour={""};
        Vector v=listeReservation.get(daty);
        if(v==null)return retour;
        String[] attrEt={"idproduit"};
        String[] valEt={idChambre};
        reservation.ReservationDetailsLib[] r= (reservation.ReservationDetailsLib[]) AdminGen.find(v,attrEt,valEt);
        if(r==null)return retour;
        String[] ret=new String[r.length];
        for(int i=0;i<r.length;i++)
            ret[i]= Utilitaire.remplacerNull(r[i].getLibelleClient());
        return ret;
    }
    public  reservation.ReservationDetailsLib[] getResaById(String daty,String idChambre) throws Exception
    {
        Vector v=listeReservation.get(daty);
        if(v==null)return null;
        String[] attrEt={"idproduit"};
        String[] valEt={idChambre};
        reservation.ReservationDetailsLib[] r= (reservation.ReservationDetailsLib[]) AdminGen.find(v,attrEt,valEt);
        return r;
    }
}
