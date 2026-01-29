/*
 * To change this license header, choose License Headers in Project Prhistoerties.
 * To change this template file, choose Tools | Templates
 * and histoen the template in the editor.
 */
package produits;

import bean.AdminGen;
import bean.CGenUtil;
import bean.ClassMAPTable;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import historique.MapHistorique;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLOutput;
import java.time.LocalTime;

import plage.Plage;
import utilitaire.ConstanteEtat;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;
import utils.CalendarUtil;
import utils.ConstanteKolo;
import utils.ConstanteStation;

/**
 *
 * @author Joe
 */

@AiTabDesc("Nom : La table as_ingredient peut etre appeller service media , \n" +
        "\tLiaison avec d'autre table :\n" +
        "\t\telle a une liaison avec la table categorie a partir de la colonne\n" +
        "\t\tcategorieingredient .")
public class Ingredients extends ClassMAPTable implements ClassIA {
    private String id;
    private String libelle;
    private double seuil;
    private String unite;
    private double quantiteParPack;
    private double pu; // Prix unitaire
    private int actif;
    private String photo;
    private double calorie;
    private int duree;
    private int dureeMax;
    private int compose;
    private String categorieIngredient;
    private String idFournisseur;
    private Date daty;
    private double qteLimite;
    private double pv; // Prix de vente
    private String libelleVente;
    String bienOuServ;
    double revient;
    String compte_vente;
    String compte_achat;
    String etatlib;
    double ancienPu;
    double ancienPV;
    double tva;
    private int isAchat;
    private int isVente;
    private String libelleextacte;
    private String idSupport;
    private double pu1;
    private double pv2;
    private double pu2;
    private double pu3;
    private double pu4;
    private double pu5;

    @Override
    public String getNomTableIA() {
        return "AS_INGREDIENTS";
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public double getPu1() {
        return pu1;
    }

    public void setPu1(double pu1) {
        this.pu1 = pu1;
    }

    public double getPv2() {
        return pv2;
    }

    public void setPv2(double pv2) {
        this.pv2 = pv2;
    }

    public String getLibelleextacte() {
        return libelleextacte;
    }

    public void setLibelleextacte(String libelleextacte) {
        this.libelleextacte = libelleextacte;
    }

    public int getIsAchat() {
        return isAchat;
    }

    public void setIsAchat(int isAchat) {
        this.isAchat = isAchat;
    }

    public int getIsVente() {
        return isVente;
    }

    public void setIsVente(int isVente) {
        this.isVente = isVente;
    }

    public double getTva() {
        return tva;
    }

    public void setTva(double tva) {
        this.tva = tva;
    }

    public double getAncienPu() {
        return ancienPu;
    }

    public void setAncienPu(double ancienPu) {
        this.ancienPu = ancienPu;
    }

    public double getAncienPV() {
        return ancienPV;
    }

    public void setAncienPV(double ancienPV) {
        this.ancienPV = ancienPV;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }

    public String getCompte_vente() {
        return compte_vente;
    }

    public void setCompte_vente(String compte_vente) {
        this.compte_vente = compte_vente;
    }

    public String getCompte_achat() {
        return compte_achat;
    }

    public void setCompte_achat(String compte_achat) {
        this.compte_achat = compte_achat;
    }

    public double getRevient() {
        if(this.revient == 0)return this.getPu();
        return revient;
    }

    public int getDureeMax() {
        return dureeMax;
    }

    public void setDureeMax(int dureeMax) {
        this.dureeMax = dureeMax;
    }

    public void setRevient(double revient) {
        this.revient = revient;
    }

    public String getBienOuServ() {
        return bienOuServ;
    }

    public void setBienOuServ(String bienOuServ) {
        this.bienOuServ = bienOuServ;
    }

    public Ingredients(String id) {
        this.setNomTable("as_ingredients");
        this.setId(id);
    }



    public Ingredients() {
        this.setNomTable("AS_INGREDIENTS");
    }


    public void construirePK(Connection c) throws Exception {
        this.preparePk("INGDKLT", "getSeqIngredients");
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

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public double getSeuil() {
        return seuil;
    }

    public void setSeuil(double seuil) {
        this.seuil = seuil;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public double getQuantiteParPack() {
        return quantiteParPack;
    }

    public void setQuantiteParPack(double quantiteParPack) {
        this.quantiteParPack = quantiteParPack;
    }

    public double getPu() {
        return pu;
    }

    public void setPu(double pu) throws Exception {
        if(this.getMode().compareToIgnoreCase("modif")==0&&pu==0) throw new Exception("PU non valide");
        if(this.getMode().compareToIgnoreCase("modif")==0&&(this.getPu()>0||this.getTuppleID()!=null||this.getTuppleID().compareToIgnoreCase("")!=0))this.setAncienPu(this.getPu());
        this.pu = pu;
    }

    public int getActif() {
        return actif;
    }

    public void setActif(int actif) {
        this.actif = actif;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public double getCalorie() {
        return calorie;
    }

    public void setCalorie(double calorie) {
        this.calorie = calorie;
    }

    public int getDuree() {
        return duree;
    }

    public void setDuree(int duree) {
        this.duree = duree;
    }

    public int getCompose() {
        return compose;
    }

    public void setCompose(int compose) {
        this.compose = compose;
    }

    public String getCategorieIngredient() {
        return categorieIngredient;
    }

    public void setCategorieIngredient(String categorieIngredient) {
        this.categorieIngredient = categorieIngredient;
    }

    public String getIdFournisseur() {
        return idFournisseur;
    }

    public void setIdFournisseur(String idFournisseur) {
        this.idFournisseur = idFournisseur;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public double getQteLimite() {
        return qteLimite;
    }

    public void setQteLimite(double qteLimite) {
        this.qteLimite = qteLimite;
    }

    public double getPv() {
        return pv;
    }

    public void setPv(double pv) {
        if(this.getMode().compareToIgnoreCase("modif")==0&&(this.getPv()>0||this.getTuppleID()!=null||this.getTuppleID().compareToIgnoreCase("")!=0))this.setAncienPV(this.getPv());
        this.pv = pv;
    }

    public String getLibelleVente() {
        return libelleVente;
    }

    public void setLibelleVente(String libelleVente) {
        this.libelleVente = libelleVente;
    }
    public int updateToTableWithHisto(String refUser, Connection c) throws Exception {
        Ingredients ing=new Ingredients();
        ing=(Ingredients) new Ingredients().getById(this.getId(),null,c);
        System.out.println("Pv AVY ANY ANATY BASE "+ing.getPv()+" pv modifie "+this.getPv());
        if(ing.getPu()!=this.getPu())
        {
            HistoriquePrixIng hp=new HistoriquePrixIng();
            hp.setPu(ing.getPu());
            hp.setIdIngredients(this.getId());
            hp.setDaty(Utilitaire.dateDuJourSql());
            hp.insertToTableWithHisto(refUser,c);
        }
        if(ing.getPv()!=this.getPv())
        {
            HistoriquePrixIng hp=new HistoriquePrixIng();
            hp.setNomTable("HISTORIQUEPVING");
            hp.setPu(ing.getPv());
            hp.setIdIngredients(this.getId());
            hp.setDaty(Utilitaire.dateDuJourSql());
            hp.insertToTableWithHisto(refUser,c);
        }
        return super.updateToTableWithHisto(refUser,c);
    }
    public String[] getMotCles() {
        return new String[]{"id","libelle"};
    }

    /**
     * Fonction utilisée pour decomposer plusieurs ligne au cas ou
     * @param nTRecette
     * @param c
     * @return
     * @throws Exception
     */
    public Recette[] decomposerBase(String nTRecette,Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            /*String req = "select ing.pu as qteav,cast(0 as number(10,2)) as qtetotal ,ing.unite as idproduits, ing.LIBELLE as idingredients,sum(rec.quantite*cast (nvl(to_number(SUBSTR((SUBSTR(SYS_CONNECT_BY_PATH(quantite, '/'),0, (INSTR(SYS_CONNECT_BY_PATH(quantite, '/'), '/',-1)-1))),"
                    +
                    "(INSTR(SUBSTR(SYS_CONNECT_BY_PATH(quantite, '/'),0, (INSTR(SYS_CONNECT_BY_PATH(quantite, '/'), '/',-1)-1)), '/', -1))+1)),1) as number(10,2))) as quantite"
                    +
                    " from "+nTRecette +" rec,AS_INGREDIENTS_LIB ing  where rec.compose=0 and rec.IDINGREDIENTS=ing.id"
                    +
                    "  start with idproduits ='" + this.getId() + "'" +
                    "  connect by prior idingredients = idproduits and prior rec.compose = 1" +
                    "  group by ing.unite, ing.libelle,ing.pu";*/
            String req="SELECT\n" +
                    "    ing.pu AS qteAv,\n" +
                    "    CAST(0 AS NUMBER(10,2)) AS qteTotal,\n" +
                    "    ing.unite AS unite,\n" +
                    "    ing.libelle AS libIngredients,ing.id as idIngredients,\n" +
                    "    cast(SUM(\n" +
                    "        (\n" +
                    "            SELECT\n" +
                    "                EXP(SUM(LN(ROUND(TO_NUMBER(REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL)),2))))\n" +
                    "            FROM\n" +
                    "                dual\n" +
                    "            CONNECT BY\n" +
                    "                REGEXP_SUBSTR(path, '[^/]+', 1, LEVEL) IS NOT NULL\n" +
                    "                AND PRIOR dbms_random.value IS NOT NULL\n" +
                    "        )\n" +
                    "    ) as number(20,2)) AS quantite\n" +
                    "FROM (\n" +
                    "    SELECT\n" +
                    "        rec.*,\n" +
                    "        SYS_CONNECT_BY_PATH(quantite, '/') AS path\n" +
                    "    FROM\n" +
                    "        "+nTRecette +" rec\n" +
                    "    START WITH\n" +
                    "        idproduits = '"+this.getId()+"'\n" +
                    "    CONNECT BY\n" +
                    "        PRIOR idingredients = idproduits\n" +
                    "        AND PRIOR rec.compose = 1\n" +
                    ") rec\n" +
                    "JOIN AS_INGREDIENTS_LIB ing\n" +
                    "    ON rec.idingredients = ing.id\n" +
                    "WHERE rec.compose = 0\n" +
                    "GROUP BY\n" +
                    "    ing.unite,\n" +
                    "    ing.libelle,\n" +
                    "    ing.pu,ing.id";

            Recette rec = new Recette();
            rec.setNomTable("recettemontant");
            return (Recette[]) CGenUtil.rechercher(rec, req, c);

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (estOuvert == true && c != null)
                c.close();
        }
    }
    public double calculerRevient(Connection c) throws Exception
    {
        Recette [] liste=this.decomposerBase(c);
        this.setRevient(AdminGen.calculSommeDouble(liste,"revient"));
        return this.getRevient();
    }
    public Recette[] decomposerBase(Connection c) throws Exception {
        return decomposerBase("as_recettecompose",c);
    }
    public RecetteLib[] getRecette(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0)
                crt.setNomTable(table);
            crt.setIdproduits (this.getId());
            return (RecetteLib[]) CGenUtil.rechercher(crt, null, null, c,
                    "");
        } catch (Exception e) {
            if (c != null) {
                c.rollback();
            }
            throw e;
        } finally {
            if (c != null && estOuvert == true)
                c.close();
        }
    }
    public RecetteLib[] getRecetteIngredient(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0) {
                crt.setNomTable(table);
            }
            crt.setIdingredients(this.getId());
            return (RecetteLib[]) CGenUtil.rechercher(crt, null, null, c, "");
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }
    /*

    public Ingredients[] decomposer(Connection c) throws Exception {
        Ingredients[] retour = null;
        int verif = 0;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                verif = 1;
            }
            if (this.getCompose() == 0) {
                return retour;
            } else {
                Recette recette = new Recette();
                recette.setIdingredients(this.getId());
                Recette[] listef = (Recette[]) CGenUtil.rechercher(recette, null, null, "");
                String[] tab = new String[listef.length];
                for (int i = 0; i < listef.length; i++) {
                    tab[i] = listef[i].getIdproduits();
                }
                retour = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), " select * from ingredients where id in(" + Utilitaire.tabToString(tab, "'", ",") + ")", c);

                return retour;
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && verif == 1) {
                c.close();
            }
        }
    }

    public RecetteLib[] getRecette(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0) {
                crt.setNomTable(table);
            }
            return (RecetteLib[]) CGenUtil.rechercher(new RecetteLib(), null, null, c, " and idproduits = '" + this.getId() + "'");
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public RecetteLib[] getRecetteIngredient(String table, Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            RecetteLib crt = new RecetteLib();
            if (table != null && table.compareToIgnoreCase("") != 0) {
                crt.setNomTable(table);
            }
            return (RecetteLib[]) CGenUtil.rechercher(new RecetteLib(), null, null, c, " and IDINGREDIENTS = '" + this.getId() + "'");
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }*/

    public Ingredients getIngredient(Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients[] lsing = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), null, null, c, " and id = '" + this.getId() + "'");
            if (lsing == null || lsing.length == 0) {
                throw new Exception("ingredient introuvable");
            }
            return lsing[0];
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
    }

    public String genererCompte(Connection c) throws Exception {
        boolean estOuvert = false;
        String valiny = "";
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            Ingredients[] liste = (Ingredients[]) CGenUtil.rechercher(new Ingredients(), "select * from as_ingredients where photo=(select max(photo) from as_ingredients where categorieingredient='" + this.getCategorieIngredient() + "')", c);
            if (liste.length > 0) {
                int compte = 0;//Utilitaire.stringToInt(liste[0].getPhoto()) + 1;
                valiny = "" + compte;
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert) {
                c.close();
            }
        }
        return valiny;
    }

    public void produitDisponible(String idProduit, String isDispo, String refUser) throws Exception {
        Connection c = null;
        try {
            c = new UtilDB().GetConn();
            c.setAutoCommit(false);
            String point=ConstanteStation.point_par_defaut;
            Indisponibilite indisp = new Indisponibilite(idProduit, point);
            Indisponibilite[] indispo = (Indisponibilite[]) CGenUtil.rechercher(indisp, null, null, c, " and idproduit like '" + idProduit + "' and idpoint like '" + point + "'");
            if (isDispo.compareToIgnoreCase("false") == 0) {
                //manao insert anaty indisponibilite
                if (indispo.length == 0) {
                    indisp.insertToTableWithHisto("" + refUser, c);
                }
            } else {
                // delete
                if (indispo.length != 0) {
                    indispo[0].deleteToTableWithHisto("" + refUser, c);
                }

            }
            c.commit();
        } catch (Exception e) {
            e.printStackTrace();
            if (c != null) {
                c.rollback();
            }
            throw new Exception(e.getMessage());
        } finally {
            if (c != null) {
                c.close();
            }
        }
    }

    public HistoriquePrixIng[] getHistoriquePu(Connection c, String typepu,String nT) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            HistoriquePrixIng histo = new HistoriquePrixIng();
            if(nT!=null&& nT.compareToIgnoreCase("")!=0) histo.setNomTable(nT);
            else if (typepu.compareToIgnoreCase("pv")==0) {
                histo.setNomTable("HISTORIQUEPVING");
            }

            histo.setIdIngredients(this.getId());
            HistoriquePrixIng[] histos = (HistoriquePrixIng[]) CGenUtil.rechercher(histo, null, null, c, " ");
            if (histos.length > 0) {
                return histos;
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

    public double getPu2() {
        return pu2;
    }

    public void setPu2(double pu2) {
        this.pu2 = pu2;
    }

    public double getPu3() {
        return pu3;
    }

    public double getPu4() {
        return pu4;
    }

    public double getPu5() {
        return pu5;
    }

    public void setPu3(double pu3) {
        this.pu3 = pu3;
    }

    public void setPu4(double pu4) {
        this.pu4 = pu4;
    }

    public void setPu5(double pu5) {
        this.pu5 = pu5;
    }

    public double getPuByCategorieHeure(String idCategorieHeure){
        if (idCategorieHeure.equals(ConstanteKolo.categorieHeurePrimeTime)){
            return this.getPu1();
        }
        if (idCategorieHeure.equals(ConstanteKolo.categorieHeureHeureBassee)){
            return this.getPu2();
        }
        return this.getPv();
    }

    public double getPrixFinal (String heuredebut,Date daty,String idSupport,Connection c) throws Exception {
        boolean estOuvert = false;
        double result = this.getPv();

        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }
            String jour = CalendarUtil.getDayOfWeek(daty.toLocalDate());
            LocalTime heure_debut = LocalTime.parse(heuredebut);
            Plage plage = new Plage();
            plage.setIdSupport(idSupport);
            plage.setJour(jour);
            Plage [] listPlage = (Plage[]) CGenUtil.rechercher(plage,null,null,c,"");
            for (Plage p:listPlage) {
                LocalTime[] interval = new LocalTime[2];
                interval[0] = LocalTime.parse(p.getHeureDebut());
                interval[1] = LocalTime.parse(p.getHeureFin());

                if (CalendarUtil.checkTime(heure_debut,interval[0],interval[1])){
                    result = this.getPuByCategorieHeure(p.getIdCategorieHeure());
                    break;
                }
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            c.rollback();
            throw ex;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return result;
    }


}
