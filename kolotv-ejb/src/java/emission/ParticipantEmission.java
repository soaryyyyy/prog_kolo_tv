package emission;

import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;

public class ParticipantEmission extends ClassMAPTable {

    String id;
    String nom;
    String contact;
    String adresse;
    Date datedenaissance;
    String idemission;

    public ParticipantEmission() {
        this.setNomTable("PARTICIPANTEMISSION");
    }

    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("PTE", "GETSEQ_PARTICIPANTEMISSION");
        this.setId(makePK(c));
    }

    // Getters et Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public Date getDatedenaissance() {
        return datedenaissance;
    }

    public void setDatedenaissance(Date datedenaissance) {
        this.datedenaissance = datedenaissance;
    }

    public String getIdemission() {
        return idemission;
    }

    public void setIdemission(String idemission) {
        this.idemission = idemission;
    }
}
