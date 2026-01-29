/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package categorieheure;

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
public class CategorieHeure extends TypeObjet {

    public CategorieHeure() {
        this.setNomTable("CATEGORIEHEURE");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("CTH", "GETSEQ_CATEGORIEHEURE");
        this.setId(makePK(c));
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val","desce"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"id","val","desce"};
        return motCles;
    }

    public CategorieHeure[] getAllCategorieHeure(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            CategorieHeure categorieHeure = new CategorieHeure();
            CategorieHeure[] categorieHeures = (CategorieHeure[]) CGenUtil.rechercher(categorieHeure, null, null, c, " ");
            if (categorieHeures.length > 0) {
                return categorieHeures;
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
}
