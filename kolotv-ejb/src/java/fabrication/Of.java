package fabrication;
import java.sql.Connection;
import java.sql.Date;
import bean.ClassMere;
import produits.Ingredients;
import produits.Recette;
import utilitaire.UtilDB;
import utils.ConstanteProcess;

public class Of extends ClassMere {
    String id,lancePar,cible,remarque,libelle;
    Date besoin,daty;

    public Of() throws Exception
    {
        super.setNomTable("Ofab");
        setLiaisonFille("idmere");
        setNomClasseFille("fabrication.OfFille");
    }
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("OF", "getseqofab");
        this.setId(makePK(c));
    }
    @Override
    public String getTuppleID() {
        return id;
    }

    public  String getNomClasseFille()
    {
        return "fabrication.ofFille";
    }
    public String getLiaisonFille() {
        return "idMere";
    }
    @Override
    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLancePar() {
        return lancePar;
    }

    public void setLancePar(String lancePar) {
        this.lancePar = lancePar;
    }

    public String getCible() {
        return cible;
    }

    public void setCible(String cible) {
        this.cible = cible;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public Date getBesoin() {
        return besoin;
    }

    public void setBesoin(Date besoin) {
        this.besoin = besoin;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }
    public Fabrication[] getFabrication(String nT,Connection c) throws Exception{
        return null;
    }
    public Recette[] decomposer(Connection c)throws Exception
    {
        return decomposer("as_recetteOf",c);
    }
    public Recette[] decomposer(String nT,Connection c)throws Exception
    {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients ing = new Ingredients();
            ing.setId(this.getId());
            return ing.decomposerBase(nT, c);
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
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
    public void calculerRevient(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            OfFille[] liste=(OfFille[]) this.getFille();
            if(liste==null) liste = (OfFille[]) this.getFille(null, c, "");
            for (OfFille f : liste) {
                f.calculerRevient(c);
            }
        }
        catch (Exception e) {
            throw e;
        }
        finally {
            if(estOuvert==true&&c!=null)c.close();
        }
    }
    public String chaineEtat() {
        if(this.getEtat()==1) return "CREE";
        if(this.getEtat()==11) return "VALIDEE";
        if(this.getEtat()==21) return "ENTAME";
        if(this.getEtat()==31) return "BLOQUE";
        if(this.getEtat()==41) return "TERMINE";
        return "CREE";
    }

    
    @Override
    public String[] getMotCles() {
        return new String[]{"id","libelle"};
    }

    @Override
    public String[] getValMotCles() {
        return new String[]{"id","libelle"};
    }

}
