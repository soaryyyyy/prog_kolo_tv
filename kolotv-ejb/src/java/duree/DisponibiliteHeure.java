package duree;

import utilitaire.Utilitaire;

import java.time.Duration;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

public class DisponibiliteHeure extends DureeMaxSpotCpl{
    double duree_diffusion;
    String idCategorieIngredientLib;

    public DisponibiliteHeure() {
        this.setNomTable("DISPONIBILITE_HEURE");
    }

    public double getDuree_diffusion() {
        return duree_diffusion;
    }

    public void setDuree_diffusion(double duree_diffusion) {
        this.duree_diffusion = duree_diffusion;
    }

    public double getResteDuree (){
        return Double.valueOf(this.getMax())-this.getDuree_diffusion();
    }

    public String getLibelleStatus(){
        if (this.getResteDuree()<=0){
            return "rgb(232, 151, 64)";
        }
        return "rgb(47, 127, 61)";
    }

    public String getIdCategorieIngredientLib() {
        return idCategorieIngredientLib;
    }

    public void setIdCategorieIngredientLib(String idCategorieIngredientLib) {
        this.idCategorieIngredientLib = idCategorieIngredientLib;
    }
}
