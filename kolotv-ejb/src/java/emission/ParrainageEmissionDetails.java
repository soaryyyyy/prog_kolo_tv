package emission;

import bean.CGenUtil;
import bean.ClassFille;
import media.Media;
import produits.Ingredients;
import reservation.ReservationDetails;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;

public class ParrainageEmissionDetails extends ClassFille {
    String id,idmere,idproduit,remarque,idmedia;
    int avant,pendant,apres;


    public ParrainageEmissionDetails() throws Exception {
        setNomTable("PARRAINAGEEMISSIONDETAILS");
        setLiaisonMere("idmere");
        setNomClasseMere("emission.ParrainageEmission");
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PREDET", "getseqparrainagedetails");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdmere() {
        return idmere;
    }

    public void setIdmere(String idmere) {
        this.idmere = idmere;
    }

    public String getIdproduit() {
        return idproduit;
    }

    public void setIdproduit(String idproduit) {
        this.idproduit = idproduit;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getIdmedia() {
        return idmedia;
    }

    public void setIdmedia(String idmedia) {
        this.idmedia = idmedia;
    }

    public int getAvant() {
        return avant;
    }

    public void setAvant(int avant) {
        this.avant = avant;
    }

    public int getPendant() {
        return pendant;
    }

    public void setPendant(int pendant) {
        this.pendant = pendant;
    }

    public int getApres() {
        return apres;
    }

    public void setApres(int apres) {
        this.apres = apres;
    }

    public Ingredients getProduit (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            Ingredients acte = new Ingredients();
            acte.setId(this.getIdproduit());
            Ingredients [] list = (Ingredients[]) CGenUtil.rechercher(acte,null,null,c,"");
            if (list.length>0){
                return list[0];
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
        return null;
    }

    public Media getMedia (Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            if (this.getIdmedia()!=null){
                Media acte = new Media();
                acte.setId(this.getIdmedia());
                Media [] list = (Media[]) CGenUtil.rechercher(acte,null,null,c,"");
                if (list.length>0){
                    return list[0];
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
        return null;
    }

    public int getDureeFinal (Connection c) throws Exception {
        Media media = this.getMedia(c);
        if (media != null) {
            return Integer.parseInt(media.getDuree());
        }
        else {
            Ingredients ing = this.getProduit(c);
            if (ing != null) {
                return ing.getDuree();
            }
        }
        return 0;
    }

    public ReservationDetails genererResaDetails(Date date,String heure,String remarque,String duree,int ordre) throws Exception {
        ReservationDetails res = new ReservationDetails();
        res.setIdproduit(this.getIdproduit());
        res.setIdMedia(this.getIdmedia());
        res.setDaty(date);
        res.setHeure(heure);
        res.setRemarque(remarque);
        res.setDuree(duree);
        res.setRemise(0);
        res.setQte(1);
        res.setIdparrainage(this.getIdmere());
        res.setOrdre(ordre);
        return res;
    }
}
