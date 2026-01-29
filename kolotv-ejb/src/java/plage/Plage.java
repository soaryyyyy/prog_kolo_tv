package plage;

import bean.CGenUtil;
import bean.ClassMAPTable;

import java.sql.Connection;
import java.sql.Date;

import java.util.*;
import utilitaire.UtilDB;
import utils.CalendarUtil;

public class Plage extends ClassMAPTable {
    private String id;
    private String heureDebut;
    private String heureFin;
    private Date daty;
    private String jour;
    private String idCategorieHeure;
    private String idSupport;

    public Plage() {
        setNomTable("PLAGE");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("PLA", "GETSEQ_PLAGE");
        this.setId(makePK(c));
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

    public String getHeureDebut() {
        return heureDebut;
    }

    public void setHeureDebut(String heureDebut) throws Exception {
        if (!CalendarUtil.isValidTime(heureDebut)) {
            throw new Exception("La heure debut doit etre de format HH:MM:SS");
        }
        this.heureDebut = heureDebut;
    }

    public String getHeureFin() {
        return heureFin;
    }

    public void setHeureFin(String heureFin) throws Exception {
        if (!CalendarUtil.isValidTime(heureFin)) {
            throw new Exception("La heure fin doit etre de format HH:MM:SS");
        }
        this.heureFin = heureFin;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getJour() {
        return jour;
    }

    public void setJour(String jour) {
        this.jour = jour;
    }

    public String getIdCategorieHeure() {
        return idCategorieHeure;
    }

    public void setIdCategorieHeure(String idCategorieHeure) {
        this.idCategorieHeure = idCategorieHeure;
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public Plage[] dupliquer(String u, String idSupport,String[] lsJours) throws Exception{
        Connection c = null;
        boolean estOuvert = false;
        List<Plage> res = new ArrayList<>();
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            for(String jour:lsJours){
                Plage p = new Plage();
                p.setHeureDebut(this.getHeureDebut());
                p.setHeureFin(this.getHeureFin());
                p.setDaty(this.getDaty());
                p.setIdCategorieHeure(this.getIdCategorieHeure());
                p.setIdSupport(idSupport);
                p.setJour(jour);
                p.createObject(u, c);
                res.add(p);
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
        return res.toArray(new Plage[]{});
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        CalendarUtil.controlerHeureDebutEtFin(this.getHeureDebut(),this.getHeureFin(),null);
        if(this.checkPlage(this.getHeureDebut(),this.getHeureFin(),this.getDaty(),c).length>0){
            throw new Exception("l'heure de la plage interfere avec une plage existante");
        };
        return super.createObject(u, c);
    }

    public Plage [] checkPlage (String heureDebut,String heureFin,Date daty,Connection c) throws Exception {
        String requete = " DATY = TO_DATE('"+daty+"','YYYY-MM-DD') AND\n" +
                "(((TO_DATE('"+heureDebut+"', 'HH24:MI:SS') >= TO_DATE(HEUREDEBUT, 'HH24:MI:SS') AND TO_DATE('"+heureDebut+"', 'HH24:MI:SS') <= TO_DATE(HEUREFIN, 'HH24:MI:SS')) OR (TO_DATE('"+heureFin+"', 'HH24:MI:SS') >= TO_DATE(HEUREDEBUT, 'HH24:MI:SS') AND TO_DATE('"+heureFin+"', 'HH24:MI:SS') <= TO_DATE(HEUREFIN, 'HH24:MI:SS')))\n" +
                "OR\n" +
                "((TO_DATE(HEUREDEBUT, 'HH24:MI:SS') >= TO_DATE('"+heureDebut+"', 'HH24:MI:SS') AND TO_DATE(HEUREDEBUT, 'HH24:MI:SS') <= TO_DATE('"+heureFin+"', 'HH24:MI:SS')) OR (TO_DATE(HEUREFIN, 'HH24:MI:SS') >= TO_DATE('"+heureDebut+"', 'HH24:MI:SS') AND TO_DATE(HEUREFIN, 'HH24:MI:SS') <= TO_DATE('"+heureFin+"', 'HH24:MI:SS'))))";
        Plage p = new Plage();
        p.setIdSupport(this.getIdSupport());
        p.setJour(this.getJour());
        Plage [] plages = (Plage[]) CGenUtil.rechercher(p,null,null,c," AND "+requete);
        System.out.println("Andro : "+p.getJour());
        return plages;
    }

}
