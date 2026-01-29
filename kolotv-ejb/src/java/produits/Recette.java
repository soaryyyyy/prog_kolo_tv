/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package produits;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import historique.MapUtilisateur;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import utilitaire.Constante;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

/**
 *
 * @author Joe
 */
public class Recette extends ClassMAPTable {

    private String id, idproduits, unite, idingredients,libIngredients;
    private double quantite, qteav, qtetotal,pu;

    public String getLibIngredients() {
        return libIngredients;
    }

    public void setLibIngredients(String libIngredients) {
        this.libIngredients = libIngredients;
    }

    public void setPu(double pu){
        this.pu=pu;
    }
    public double getPu(){
        return this.pu;
    }
    public void setQtetotal(double qtetotal) {
        this.qtetotal = qtetotal;
    }

    public double getQteav() {
        return qteav;
    }

    public void setQteav(double qteav) {
        this.qteav = qteav;
    }

    public double getMontant() {
        return this.getQuantite() * this.getQteav();
    }

    public double getQtetotal() {
        return this.getQuantite() * this.getQteav();
    }

    int compose;

    public int getCompose() {
        return compose;
    }

    public void setCompose(int compose) {
        this.compose = compose;
    }

    public double getRevient()
    {
        return getQtetotal();
    }

    public static List<Recette> decompose(String idIngr, double qte, List<Recette> listeInitiale) throws Exception {
        Recette rec = new Recette();
        rec.setIdingredients(idIngr);
        rec.setQuantite(qte);
        rec.setCompose(0);
        String[] attrFind = {"idingredients"};
        String[] valFind = {rec.getIdingredients()};
        Recette[] listeRecetteEnCours = (Recette[]) AdminGen.findCast(listeInitiale, attrFind, valFind);
        if (listeRecetteEnCours.length > 0) {
            rec.setCompose(listeRecetteEnCours[0].getCompose());
        }
        return rec.decompose(listeInitiale);
    }

    public List<Recette> decompose(List<Recette> listeInitiale) throws Exception {
        String[] attrFind = {"idproduits"};
        String[] valFind = {this.getIdingredients()};
        List<Recette> finale = new ArrayList();
        if (compose > 0) {

            Recette[] listeRecetteEnCours = (Recette[]) AdminGen.findCast(listeInitiale, attrFind, valFind);
            for (int i = 0; i < listeRecetteEnCours.length; i++) {
                listeRecetteEnCours[i].setQuantite(listeRecetteEnCours[i].getQuantite() * this.getQuantite());
                finale.addAll(listeRecetteEnCours[i].decompose(listeInitiale));
            }
        } else {
            finale.add(this);
        }
        return finale;
    }

    public Recette[] decomposerBase(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients p = new Ingredients();
            p.setId(this.getIdproduits());
            return p.decomposerBase(c);
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (estOuvert == true && c != null) {
                c.close();
            }
        }
    }

    public Recette(String idproduits, String unite, String idingredients, double quantite) {
        this.setNomTable("AS_RECETTE");
        this.setIdproduits(idproduits);
        this.setUnite(unite);
        this.setIdingredients(idingredients);
        this.setQuantite(quantite);
    }

    public Recette() {
        this.setNomTable("AS_RECETTE");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("RTT", "GETSEQRECETTE");
        this.setId(makePK(c));
    }

    public String getTuppleID() {
        return id;
    }

    public String getAttributIDName() {
        return "id";
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdproduits() {
        return idproduits;
    }

    public void setIdproduits(String idproduits) {
        this.idproduits = idproduits;
    }

    public String getIdingredients() {
        return idingredients;
    }

    public void setIdingredients(String idingredients) {
        this.idingredients = idingredients;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public double getQuantite() {
        return quantite;
    }

    public void setQuantite(double quantite) {
        this.quantite = quantite;
    }
    public Ingredients getIngredientsProduit(String nt,Connection c) throws Exception {
        Ingredients i = new Ingredients();
        if(nt!=null&&nt.compareToIgnoreCase("")!=0) i.setNomTable(nt);
        i.setId(this.getIdproduits());
        Ingredients[]li=(Ingredients[]) CGenUtil.rechercher(i,null,null,c,"");
        if(li!=null) return li[0];
        return null;
    }
    public Ingredients getIngredients(String nt,Connection c) throws Exception {
        Ingredients i = new Ingredients();
        if(nt!=null&&nt.compareToIgnoreCase("")!=0) i.setNomTable(nt);
        i.setId(this.getIdingredients());
        Ingredients[]li=(Ingredients[]) CGenUtil.rechercher(i,null,null,c,"");
        if(li!=null) return li[0];
        return null;
    }

    @Override
    public void controler(Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }
            if (this.getIdproduits().compareToIgnoreCase(this.getIdingredients()) == 0) {
                throw new Exception("Risque de cycle infinie. Objet compose et composant identiques");
            }
            Ingredients prod = getIngredientsProduit(null, c);
            if(prod.getCompose()==0)throw new Exception("Composition d'un composant de base impossible");
            if (indice == 1) {
                c.commit();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(ex.getMessage());
        } finally {
            if (indice == 1 && c != null) {
                c.close();
            }
        }
    }

    public void modifQte(String refuser,String[] id, String[] remarque, Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }

            if (id == null) {
                throw new Exception("Aucune recette selectionee");
            }
            String[] listeIndice = new String[id.length];
            for (int j = 0; j < id.length; j++) {
                String[] id_indice = Utilitaire.split(id[j], "_");
                id[j] = id_indice[0];
                listeIndice[j] = id_indice[1];
            }

            String tid = Utilitaire.tabToString(id, "'", ",");
            Recette[] cmds = (Recette[]) CGenUtil.rechercher(new Recette(), null, null, c, " and ID in (" + tid + ") order by id asc");
            if (cmds.length == 0) {
                throw new Exception("Recette introuvable");
            }

            for (int i = 0; i < id.length; i++) {
                //cmds[i].setQuantite(Double.valueOf(remarque[indices.get(cmds[i].getId())]));
                int indRemarque = Integer.parseInt(listeIndice[i]);
                cmds[i].setQuantite(Double.valueOf(remarque[indRemarque]));
                cmds[i].updateToTableWithHisto(refuser,c);
            }
            if (indice == 1) {
                c.commit();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(ex.getMessage());
        } finally {
            if (indice == 1 && c != null) {
                c.close();
            }
        }
    }

    public void suppressionMultiple(String[] id, String user, Connection c) throws Exception {
        int indice = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }
            if (id == null) {
                throw new Exception("Aucune recette � supprimer selectione");
            }
            for (int i = 0; i < id.length; i++) {
                Recette tmp = new Recette();
                tmp.setId(Utilitaire.split(id[i], "_")[0]);
                tmp.deleteToTableWithHisto(user, c);
            }

            if (indice == 1) {
                c.commit();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(ex.getMessage());
        } finally {
            if (indice == 1) {
                c.close();
            }
        }
    }

    public void inserer(String user, Connection c) throws Exception {
        int indice = 0;
        try { 
            MapUtilisateur[] utilisateur =  (MapUtilisateur[]) CGenUtil.rechercher(new MapUtilisateur(), null, null, c, " and refuser='"+user+"'");
            if (!utilisateur[0].getLoginuser().equalsIgnoreCase("narindra"))         
            {
                throw new Exception ("Modification non autoris\\351"); 
            }   
            if (c == null) {
                c = new UtilDB().GetConn();
                c.setAutoCommit(false);
                indice = 1;
            }
            this.controler(c);
            Ingredients ing = new Ingredients();
            ing.setId(this.getIdingredients());
            RecetteLib[] lsrec = ing.getRecette("recette", c);
            if (lsrec != null && lsrec.length >= 1) {
                ing = ing.getIngredient(c);
                if (ing.getCompose() == 0) {
                    ing.setCompose(1);
                    ing.updateToTableWithHisto(user, c);
                }
            }
            this.insertToTableWithHisto(user, c);
            if (indice == 1) {
                c.commit();
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw ex;
        } finally {
            if (indice == 1 && c != null) {
                c.close();
            }
        }
    }
   @Override
    public int updateToTableWithHisto(String u,Connection c)throws Exception{   
        MapUtilisateur[] utilisateur =  (MapUtilisateur[]) CGenUtil.rechercher(new MapUtilisateur(), null, null, c, " and refuser='"+u+"'");
//        if (!utilisateur[0].getLoginuser().equalsIgnoreCase("narindra"))
//        {
//            throw new Exception ("Modification non autoris\\351");
//        }
        return super.updateToTableWithHisto(u,c);
    }

}
