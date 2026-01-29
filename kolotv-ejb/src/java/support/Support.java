/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package support;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.TypeObjet;
import caisse.CategorieCaisse;
import caisse.Caisse;
import java.sql.Connection;
import magasin.Magasin;
import utilitaire.UtilDB;
import utils.ConstanteStation;

/**
 *
 * @author Toky20
 */
public class Support extends TypeObjet {

    public Support() {
        this.setNomTable("Support");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("SUP", "GETSEQ_SUPPORT");
        this.setId(makePK(c));
    }

    public Support[] getAllSupport(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Support support = new Support();
            Support[] supports = (Support[]) CGenUtil.rechercher(support, null, null, c, " ");
            if (supports.length > 0) {
                return supports;
            }
            return null;
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    String idPoint;

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }
    
    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val","desce","idPoint"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"id","val","desce","idPoint"};
        return motCles;
    }
}
