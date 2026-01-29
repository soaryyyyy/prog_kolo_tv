package produits;

import bean.TypeObjet;
import chatbot.AiTabDesc;
import chatbot.ClassIA;

import java.sql.Connection;

@AiTabDesc("Nom : categorieIngredient\n" +
        "\tRegle de gestion :\n" +
        "\t\tUn categorieIngredient peut avoir plusieur as_ingredient")
public class CategorieIngredient extends TypeObjet implements ClassIA {
    String codeCouleur;
    int rang;

    public int getRang() {
        return rang;
    }

    public void setRang(int rang) {
        this.rang = rang;
    }

    public String getCodeCouleur() {
        return codeCouleur;
    }

    public void setCodeCouleur(String codeCouleur) {
        this.codeCouleur = codeCouleur;
    }

    public CategorieIngredient() {
        setNomTable("CATEGORIEINGREDIENT");
    }

    @Override
    public String getNomTableIA() {
        return "CATEGORIEINGREDIENT";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CATING", "GETSEQCATEGING");
        this.setId(makePK(c));
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"id","val"};
        return motCles;
    }
}
