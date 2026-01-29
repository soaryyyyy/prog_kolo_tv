/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package support;

import bean.CGenUtil;
import bean.ClassMAPTable;
import bean.TypeObjet;
import java.sql.Connection;
import utilitaire.UtilDB;

/**
 *
 * @author Toky20
 */
public class SupportCpl extends Support {

    String idPointLib;

    public String getIdPointLib() {
        return idPointLib;
    }

    public void setIdPointLib(String idPointLib) {
        this.idPointLib = idPointLib;
    }

    public SupportCpl() {
        this.setNomTable("SUPPORT_CPL");
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val","desce","idPoint","idPointLib"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"id","val","desce","idPoint","idPointLib"};
        return motCles;
    }

}
