/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package caisse;

import bean.CGenUtil;
import bean.TypeObjet;
import java.sql.Connection;
import utilitaire.UtilDB;

/**
 *
 * @author nouta
 */
public class TypeCaisse extends TypeObjet
{

    public TypeCaisse() {
        super.setNomTable("TYPECAISSE");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TCA", "GETSEQTYPECAISSE");
        this.setId(makePK(c));
    }

    public TypeCaisse[] getAllTypeCaisse(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            TypeCaisse type = new TypeCaisse();
            TypeCaisse[] types = (TypeCaisse[]) CGenUtil.rechercher(type, null, null, c, " ");
            if (types.length > 0) {
                return types;
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
