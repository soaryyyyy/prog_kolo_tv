package fabrication;

import bean.ClassMere;
import magasin.Magasin;
import pertegain.Tiers;
import produits.Ingredients;
import produits.Recette;
import utilitaire.UtilDB;
import utils.ConstanteProcess;
import bean.CGenUtil;

import java.io.EOFException;
import java.sql.Connection;
import stock.MvtStock;
import stock.MvtStockFille;
import utils.ConstanteStation;
import fabrication.*;
import bean.ClassMAPTable;

public class Fabrication extends Of {
    String idOf;
    public Fabrication() throws Exception {
        super.setNomTable("FABRICATION");
        setLiaisonFille("idmere");
        setNomClasseFille("fabrication.FabricationFille");
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("FAB", "getSeqFab");
        this.setId(makePK(c));
    }

    public  String getNomClasseFille()
    {
        return "fabrication.FabricationFille";
    }
    public Of getOf(String nt,Connection c) throws Exception{
        return null;
    }

    public String getIdOf() {
        return idOf;
    }

    public void setIdOf(String idOf) {
        this.idOf = idOf;
    }


    public Of getOfab(String nt, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            Of of = new Of();
            of.setNomTable(nt);
            of.setId(this.getIdOf());
            Of[] ofs = (Of[]) CGenUtil.rechercher(of, null, null, c, " ");
            if (ofs.length > 0) {
                return ofs[0];
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

    @Override
    public void controler(Connection c) throws Exception {
        super.controler(c);
        OfFilleCpl filles = new OfFilleCpl();
        filles.setNomTable("OfFilleResteLib");
        /*FabricationFille [] ofFilleNew  = (FabricationFille[])this.getFille(null,c,"");
        OfFilleCpl [] ofFille = (OfFilleCpl[]) CGenUtil.rechercher(filles,null,null, " and IDMERE = '" +getIdOf()+ "'");
        
        if(ofFilleNew.length!=ofFille.length){
            throw new EOFException("On ne peut pa ajouter ou supprimer une ingredient si c'est une ordre de fabrication");
        }
        for(int i=0;i<ofFille.length;i++){
            if(ofFille[i].getQteReste()<ofFilleNew[i].getQte() || ofFilleNew[i].getQte()<=0){
                throw new EOFException("On ne peut pas augmenter la qunatité de l'engredient si c'est une ordre de fabrication");
            }
        }*/
    }

    @Override
    public void controlerUpdate(Connection c) throws Exception {
        
    }
    public void modifPuFille(String user,Connection c ) throws Exception {
        FabricationFille[] fille=(FabricationFille[]) this.getFille("fabricationFillePU",c,"");
        this.setFille(fille);
        calculerRevient(c);
        for(FabricationFille f:fille)
        {
            f.setNomTable("FabricationFille");
            f.setPu(f.getPuRevient());
            f.updateToTableWithHisto(user,c);
        }
    }

    @Override
    public Object validerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            // sortie 
            // entree
            this.modifPuFille(u,c);
            this.createEntreeStock(u, c);
            this.createSortieStock(u, c);
            super.validerObject(u, c);
            return this;

        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public void sortieStock(){

    }

    public void entreeStock(){
        
    }

    public Recette[] decomposer(Connection c)throws Exception
    {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients ing = new Ingredients();
            ing.setId(this.getId());
            return ing.decomposerBase("as_recetteFab", c);
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }

    public Object entamerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            //Mettre controle si besoin
            this.setEtat(ConstanteProcess.entame);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public Object bloquerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            //Mettre controle si besoin
            this.setEtat(ConstanteProcess.bloque);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    public Object terminerObject(String u, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
            }
            this.setMode("modif");
            this.setEtat(ConstanteProcess.termine);
            this.updateToTableWithHisto(u, c);
            return this;
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
     public FabricationFille[] getFabricationFille (Connection c) throws Exception {
        if(getFille()!=null)return (FabricationFille[]) getFille();
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            FabricationFille ff = new FabricationFille();
            ff.setIdMere(this.getId());
            FabricationFille[] ffs = (FabricationFille[]) CGenUtil.rechercher(ff, null, null, c, " ");
            if (ffs.length > 0) {
                return ffs;
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
    protected MvtStock createMvtStock(String action,String u,Connection c) throws Exception{
        MvtStock md=new MvtStock();
        md.setDaty(this.getDaty());
        md.setIdMagasin(this.getCible());
        md.setIdPoint(this.getCible());
        if (action.compareToIgnoreCase("entree")==0) {   
            md.setDesignation("Entree de stock relatif : fabrication de : "+ this.getId());
            md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKENTREE);
        }
         if (action.compareToIgnoreCase("sortie")==0) {
            md.setDesignation("Sortie de stock relatif : fabrication de : "+ this.getId());
            md.setIdTypeMvStock(ConstanteStation.TYPEMVTSTOCKSORTIE);
        }
        md.setIdobjet(this.id);
        md.createObject(u, c);
        md.validerObject(u, c);
        return md;
    }
    protected MvtStockFille[] createMvtSockFilleSortie(String u,MvtStock mere,Connection c) throws Exception{
        FabricationFille[] listeFille=this.getFabricationFille(c);
        
        for(FabricationFille fille:listeFille){
            MvtStockFille[] m = fille.createMvtSockFilleSortie(c);
            for (int i = 0; i < m.length; i++) {
                //m[i] = new MvtStockFille();
                m[i].setIdMvtStock(mere.getId());
                m[i].createObject(u,c);
            }
        }
        return null;
    }

    protected MvtStockFille[] createMvtSockFilleEntree(MvtStock mere,Connection c) throws Exception{
        FabricationFille[] ff = this.getFabricationFille(c);
        MvtStockFille[] m = new MvtStockFille[ff.length];
        for (int i = 0; i < ff.length; i++) {
           m[i] = new MvtStockFille();
           m[i].setIdMvtStock(mere.getId());
           m[i].setIdProduit(ff[i].getIdIngredients());
           m[i].setEntree(ff[i].getQte());
           m[i].setPu(ff[i].getPu());
        }
        return m;
    }
    protected void createSortieStock(String u,Connection c) throws Exception{
        MvtStock m=this.createMvtStock("sortie", u ,c);
        this.createMvtSockFilleSortie(u,m, c);
    }
    protected void createEntreeStock(String u,Connection c) throws Exception{
        MvtStock m=this.createMvtStock("entree", u, c);
        MvtStockFille[] filles = this.createMvtSockFilleEntree(m, c);
        for(int i=0;i<filles.length;i++){
            filles[i].createObject(u, c);
        } 
    }
    
     
}
