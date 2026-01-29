package emission;

import annexe.HistoriqueProduit;
import bean.CGenUtil;
import bean.ClassFille;
import bean.ClassMAPTable;
import historique.MapUtilisateur;
import media.Media;
import produits.Ingredients;
import utils.CalendarUtil;

import java.sql.Connection;
import java.time.LocalTime;

public class EmissionDetails extends ClassFille {
    String id,idMere,jour,heureDebut,heureFin,heureDebutCoupure,heureFinCoupure;

    public String getHeureDebutCoupure() {

        return heureDebutCoupure;
    }

    public void setHeureDebutCoupure(String heureDebutCoupure) throws Exception {
        this.heureDebutCoupure = heureDebutCoupure;
    }

    public String getHeureFinCoupure() {
        return heureFinCoupure;
    }

    public void setHeureFinCoupure(String heureFinCoupure) throws Exception {
        this.heureFinCoupure = heureFinCoupure;
    }

    @Override
    public String getNomClasseMere()
    {
        return "emission.Emission";
    }

    @Override
    public String getLiaisonMere() {
        return "idMere";
    }

    public EmissionDetails() throws Exception {
        setNomTable("EMISSIONDETAILS");
        setLiaisonMere("idMere");
        setNomClasseMere("emission.Emission");
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
        this.preparePk("EDET", "getseqemissiondetails");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdMere() {
        return idMere;
    }

    public void setIdMere(String idMere) {
        this.idMere = idMere;
    }

    public String getJour() {
        return jour;
    }

    public void setJour(String jour) {
        this.jour = jour;
    }

    public String getHeureDebut() {
        return heureDebut;
    }

    public void setHeureDebut(String heureDebut) throws Exception {
        if (!CalendarUtil.isValidTime(heureDebut)) {
            throw new Exception("L' heure doit etre de format HH:MM:SS");
        }
        this.heureDebut = heureDebut;
    }

    public String getHeureFin() {
        return heureFin;
    }

    public void setHeureFin(String heureFin) throws Exception {
        if (!CalendarUtil.isValidTime(heureFin)) {
            throw new Exception("L' heure doit etre de format HH:MM:SS");
        }
        this.heureFin = heureFin;
    }


//    @Override
//    public int updateToTableWithHisto(String u,Connection c)throws Exception{
//        controlHeureDebutEtFin(c);
//        return super.updateToTableWithHisto(u,c);
//    }

    @Override
    public ClassMAPTable createObject(String u, Connection c) throws Exception {
        controlHeureDebutEtFin(c);
        return super.createObject(u, c);
    }

    public void controlHeureDebutEtFin(Connection c) throws Exception {
        LocalTime hDebut = LocalTime.parse(getHeureDebut());
        LocalTime hFin = LocalTime.parse(getHeureFin());
        if (hDebut.isBefore(hFin)) {
            LocalTime hDebutCoupure = LocalTime.parse(this.getHeureDebutCoupure());
            LocalTime hFinCoupure = LocalTime.parse(this.getHeureFinCoupure());
            if (CalendarUtil.checkTime(hDebutCoupure,hDebut,hFin) && CalendarUtil.checkTime(hDebutCoupure,hDebut,hFin)) {
                if (hDebutCoupure.isAfter(hFin)) {
                    throw new Exception("L'heure debut et fin de coupure sont invalide");
                }
            }
            else {
                throw new Exception("L'heure de coupure doit etre entre "+getHeureDebut()+" - "+getHeureFin());
            }
            EmissionDetails em = new EmissionDetails();
            EmissionDetails [] list = (EmissionDetails[]) CGenUtil.rechercher(em,null,null,c,"");
            for (EmissionDetails details : list) {
                if (this.getJour().equalsIgnoreCase(details.getJour())) {
                    LocalTime [] intervales = new LocalTime[2];
                    intervales[0] = LocalTime.parse(details.getHeureDebut());
                    intervales[1] = LocalTime.parse(details.getHeureFin());
                    if (CalendarUtil.checkTime(hDebut,intervales[0],intervales[1]) || CalendarUtil.checkTime(hFin,intervales[0],intervales[1])){
                        throw new Exception("L'heure debut et fin sont indisponible");
                    }

                    if (CalendarUtil.checkTime(intervales[0],hDebut,hFin) || CalendarUtil.checkTime(intervales[1],hDebut,hFin)){
                        throw new Exception("L'heure debut et fin sont indisponible");
                    }
                }
            }
        }
        else {
            throw new Exception("L'heure debut et fin sont invalide");
        }
    }

    @Override
    public String[] getMotCles() {
        return new String[]{"jour","heureDebut","heureFin"};
    }

}
