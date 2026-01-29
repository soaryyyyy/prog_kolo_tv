/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prix;

import bean.CGenUtil;
import bean.ClassEtat;
import java.sql.Connection;
import java.sql.Date;
import java.time.LocalDateTime;
import utilitaire.Utilitaire;
import utilitaire.UtilDB;

public class ConfigurationPrixCpl extends ConfigurationPrix{
    
    private String idIngredientLib, etatLib;
    
    public ConfigurationPrixCpl(){
        this.setNomTable("CONFIGURATIONPRIX_CPL");
    }

    public String getEtatLib() {
        return etatLib;
    }

    public String getIdIngredientLib() {
        return idIngredientLib;
    }

    public void setEtatLib(String etatLib) {
        this.etatLib = etatLib;
    }
    
    public void setIdIngredientLib(String idIngredientLib) {
        this.idIngredientLib = idIngredientLib;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
        
}
