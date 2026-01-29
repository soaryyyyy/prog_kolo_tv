/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package duree;

import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalTime;
import java.util.*;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.CalendarUtil;

/**
 *
 * @author Toky20
 */
public class DureeMaxSpot extends ClassMAPTable{

    String id;
    String heureDebut;
    String heureFin;
    String jour;
    String max;
    String idSupport;
    Date daty;
    String idCategorieIngredient;

    public DureeMaxSpot() {
        this.setNomTable("DUREEMAXSPOT");
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

    public String getJour() {
        return jour;
    }

    public void setJour(String jour) {
        this.jour = jour;
    }

    public String getMax() {
        return max;
    }

    public void setMax(String max) throws Exception {
        if (!CalendarUtil.isValidTime(max)) {
            this.max = max;
        }
        else {
            this.max = String.valueOf(CalendarUtil.HMSToSecond(max));
        }
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("DUR", "GETSEQ_DUREEMAXSPOT");
        this.setId(makePK(c));
    }

    public DureeMaxSpot[] dupliquer(String u, String idSupport,String[] lsJours) throws Exception{
        Connection c = null;
        boolean estOuvert = false;
        List<DureeMaxSpot> res = new ArrayList<>();
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            Set<String> dayInserted = new HashSet<>();

            DureeMaxSpot dms1 = new DureeMaxSpot();
            dms1.setHeureDebut(this.getHeureDebut());
            dms1.setHeureFin(this.getHeureFin());
            dms1.setIdSupport(idSupport);
            dms1.setJour(this.getJour());
            dms1.setMax(this.getMax());
            dms1.createObject(u, c);
            res.add(dms1);
            dayInserted.add(this.getJour());

            for(String jour:lsJours){
                if(jour.toLowerCase().equals(this.getJour().toLowerCase())) continue;
                if (dayInserted.contains(jour)) {
                    continue;
                }

                DureeMaxSpot dms = new DureeMaxSpot();
                dms.setHeureDebut(this.getHeureDebut());
                dms.setHeureFin(this.getHeureFin());
                dms.setIdSupport(this.getIdSupport());
                dms.setJour(jour);
                dms.setMax(this.getMax());
                dms.setIdCategorieIngredient(this.getIdCategorieIngredient());
                dms.createObject(u, c);
                res.add(dms);

                DureeMaxSpot dms2 = new DureeMaxSpot();
                dms2.setHeureDebut(this.getHeureDebut());
                dms2.setHeureFin(this.getHeureFin());
                dms2.setIdSupport(idSupport);
                dms2.setJour(jour);
                dms2.setMax(this.getMax());
                dms2.setIdCategorieIngredient(this.getIdCategorieIngredient());
                dms2.createObject(u, c);
                res.add(dms2);

                dayInserted.add(jour);
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
        return res.toArray(new DureeMaxSpot[]{});
    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        this.setDaty(Utilitaire.dateDuJourSql());
        return super.createObject(u, c);
    }

    public void controlerHeureDebutEtFin() throws Exception {
        CalendarUtil.controlerHeureDebutEtFin(this.getHeureDebut(),this.getHeureFin(),CalendarUtil.secondToHMS(Long.parseLong(this.getMax())));
        int duree = (int) CalendarUtil.getDuration(LocalTime.parse(this.getHeureDebut()), LocalTime.parse(this.getHeureFin()));
        if (duree==1800){
            if ((CalendarUtil.ckeckMinute(this.getHeureDebut(),"00") && CalendarUtil.ckeckMinute(this.getHeureFin(),"30")) || (CalendarUtil.ckeckMinute(this.getHeureDebut(),"30") && CalendarUtil.ckeckMinute(this.getHeureFin(),"00"))){
            }
            else {
                throw new Exception("heure invalide");
            }
        }
        else {
            throw new Exception("l'heure debut et fin doivent avoir une intervalle de 30 minutes");
        }
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public String getIdCategorieIngredient() {
        return idCategorieIngredient;
    }

    public void setIdCategorieIngredient(String idCategorieIngredient) {
        this.idCategorieIngredient = idCategorieIngredient;
    }
}
