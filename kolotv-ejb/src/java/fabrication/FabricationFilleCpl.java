package fabrication;

public class FabricationFilleCpl extends FabricationFille {
    String idingredientsLib;
    String idingredientslibexacte;


    
    public FabricationFilleCpl() throws Exception {
        super.setNomTable("FABRICATIONFILLECPL");
    }

    public String getIdingredientsLib(){
        return this.idingredientsLib;
    }

    public void setIdingredientsLib(String idingredientsLib){
        this.idingredientsLib = idingredientsLib;
    }

    public String getIdingredientslibexacte() {
        return idingredientslibexacte;
    }

    public void setIdingredientslibexacte(String idingredientslibexacte) {
        this.idingredientslibexacte = idingredientslibexacte;
    }

    

    

}
