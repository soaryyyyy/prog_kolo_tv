/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package duree;

/**
 *
 * @author 26134
 */
public class DureeMaxSpotCpl extends DureeMaxSpot{

    String idSupportLib;
    String idCategorieIngredientLib;

    public String getIdSupportLib() {
        return idSupportLib;
    }

    public void setIdSupportLib(String idSupportLib) {
        this.idSupportLib = idSupportLib;
    }

    public DureeMaxSpotCpl() {
        this.setNomTable("DureeMaxSpot_Cpl");
    }

    public String getIdCategorieIngredientLib() {
        return idCategorieIngredientLib;
    }

    public void setIdCategorieIngredientLib(String idCategorieIngredientLib) {
        this.idCategorieIngredientLib = idCategorieIngredientLib;
    }

}
