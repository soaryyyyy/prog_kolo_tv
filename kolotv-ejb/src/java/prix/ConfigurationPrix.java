/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prix;

import annexe.Produit;
import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDateTime;
import utilitaire.Utilitaire;
import produits.Ingredients;
import utilitaire.UtilDB;

public class ConfigurationPrix extends ClassEtat{
    
    String id, idingredient,remarque;
    double pu,pv,pu1,pu2,pu3,pu4,pu5;
    Date daty;
    
    public ConfigurationPrix(){
        this.setNomTable("ConfigurationPrix");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Date getDaty() {
        return daty;
    }
    public double getPu() {
        return pu;
    }

    public double getPu1() {
        return pu1;
    }
    public double getPu2() {
        return pu2;
    }
    public double getPu3() {
        return pu3;
    }
    public double getPu4() {
        return pu4;
    }
    public double getPu5() {
        return pu5;
    }
    public double getPv() {
        return pv;
    }
    public String getRemarque() {
        return remarque;
    }
    public void setDaty(Date daty) {
        this.daty = daty;
    }
    public void setPu(double pu) {
        this.pu = pu;
    }
    public void setPu1(double pu1) {
        this.pu1 = pu1;
    }
    public void setPu2(double pu2) {
        this.pu2 = pu2;
    }
    public void setPu3(double pu3) {
        this.pu3 = pu3;
    }
    public void setPu4(double pu4) {
        this.pu4 = pu4;
    }
    public void setPu5(double pu5) {
        this.pu5 = pu5;
    }
    public void setPv(double pv) {
        this.pv = pv;
    }
    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdingredient() {
        return idingredient;
    }

    public void setIdingredient(String idingredient) {
        this.idingredient = idingredient;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CFP", "GETSEQ_CONFIGURATIONPRIX");
        this.setId(makePK(c));
    }

    public Ingredients getIngredient(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients[] lsing = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), null, null, c, " and id = '" + this.getIdingredient() + "'");
            if (lsing == null || lsing.length == 0) {
                throw new Exception("ingredient introuvable");
            }
            return lsing[0];
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            Ingredients i = this.getIngredient(c);
            i.setPu(this.getPu());
            i.setPv(this.getPv());
            i.setPu1(this.getPu1());
            i.setPu2(this.getPu2());
            i.setPu3(this.getPu3());
            i.setPu4(this.getPu4());
            i.setPu5(this.getPu5());
            i.updateToTableWithHisto(u, c);
            super.validerObject(u, c);
            if(estOuvert==true)c.commit();
            return this;

        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
}
