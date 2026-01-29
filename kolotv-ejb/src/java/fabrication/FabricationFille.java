package fabrication;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMere;
import chatbot.ClassIA;
import produits.Ingredients;
import produits.Recette;
import stock.MvtStockFille;

import java.sql.Connection;

public class FabricationFille extends OfFille implements ClassIA {
    double pu;

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) {
        this.pu = pu;
    }
    public FabricationFille() throws Exception {
        super.setNomTable("FABRICATIONFILLE");
        setLiaisonMere("idmere");
        setNomClasseMere("fabrication.Fabrication");
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FABF", "getSeqFabF");
        this.setId(makePK(c));
    }
    @Override
    public String getNomClasseMere()
    {
        return "fabrication.Fabrication";
    }

    @Override
    public String getUrlSaisie() {
        return "/station/pages/module.jsp?but=fabrication/fabrication-saisie.jsp&currentMenu=MENUDYN0304008";
    }

    @Override
    public void controler(Connection c) throws Exception {

        /*Fabrication mere = (Fabrication) this.findMere(null,c);

        OfFilleCpl [] ofFille = (OfFilleCpl[]) CGenUtil.rechercher(new OfFilleCpl(),null,null, " and IDMERE = '" +mere.getIdOf()+ "'");
        if(AdminGen.estDedans(ofFille,new String[]{"idIngredients"},new String[]{this.getIdIngredients()})) {
            OfFilleCpl of = (OfFilleCpl) AdminGen.findUnique(ofFille,new String[]{"idIngredients"},new String[]{this.getIdIngredients()});
            if(of.getQteReste()<this.getQte()){
                throw new Exception("La quantité de fabrication dépasse la quantite de l'ordre de Fabrication");
            }
        }
        else throw new Exception("Cette fabrication ne corréspond pas a l'ordre de Fabrication");*/
    }
    public MvtStockFille[] createMvtSockFilleSortie(Connection c) throws Exception{
        Ingredients ing = new Ingredients();
        ing.setId(this.getIdIngredients());
        Recette[] rct = ing.decomposerBase(c);
        MvtStockFille[] m=null;
        if (rct.length > 0) {
            m = new MvtStockFille[rct.length];
            for (int i = 0; i < rct.length; i++) {
                m[i] = new MvtStockFille();
                //m[i].setIdMvtStock(mere.getId());
                m[i].setIdProduit(rct[i].getIdingredients());
                m[i].setSortie(rct[i].getQuantite()*this.getQte());
                m[i].setPu(rct[i].getQteav());
            }
        }
        else {
            m=new MvtStockFille[1];
            m[0] = new MvtStockFille();
            ing=(Ingredients) new Ingredients().getById(ing.getId(),null,c);
            //m[i].setIdMvtStock(mere.getId());
            m[0].setIdProduit(ing.getId());
            m[0].setSortie(this.getQte());
            m[0].setPu(ing.getPu());
        }
        return m;
    }

}
