package notification;

import bean.CGenUtil;
import bean.ClassEtat;
import historique.MapUtilisateur;
import support.Support;
import utilitaire.UtilDB;

import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

public class Notification extends ClassEtat {
    String id,objet,message,idUser,direction,service,destinataire,idObjet,lien,idUser_Recevant,prestation,heure;
    Date daty;
    int priorite,classe;

    public Notification() {
        this.setNomTable("NOTIFICATION");
    }

    public void construirePK(Connection c) throws Exception {
        this.preparePk("NOTIF", "getseqnotification");
        this.setId(makePK(c));
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getObjet() {
        return objet;
    }

    public void setObjet(String objet) {
        this.objet = objet;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getIdUser() {
        return idUser;
    }

    public void setIdUser(String idUser) {
        this.idUser = idUser;
    }

    @Override
    public String getDirection() {
        return direction;
    }

    @Override
    public void setDirection(String direction) {
        this.direction = direction;
    }

    @Override
    public String getService() {
        return service;
    }

    @Override
    public void setService(String service) {
        this.service = service;
    }

    public String getDestinataire() {
        return destinataire;
    }

    public void setDestinataire(String destinataire) {
        this.destinataire = destinataire;
    }

    public String getIdObjet() {
        return idObjet;
    }

    public void setIdObjet(String idObjet) {
        this.idObjet = idObjet;
    }

    public String getLien() {
        return lien;
    }

    public void setLien(String lien) {
        this.lien = lien;
    }

    public String getIdUser_Recevant() {
        return idUser_Recevant;
    }

    public void setIdUser_Recevant(String idUser_Recevant) {
        this.idUser_Recevant = idUser_Recevant;
    }

    public String getPrestation() {
        return prestation;
    }

    public void setPrestation(String prestation) {
        this.prestation = prestation;
    }

    public String getHeure() {
        return heure;
    }

    public void setHeure(String heure) {
        this.heure = heure;
    }

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public int getPriorite() {
        return priorite;
    }

    public void setPriorite(int priorite) {
        this.priorite = priorite;
    }

    public int getClasse() {
        return classe;
    }

    public void setClasse(int classe) {
        this.classe = classe;
    }

    @Override
    public String getTuppleID() {
        return id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }

    public Notification [] dupliquerNotification(MapUtilisateur[] userRecevants) {
        Notification [] notifications = new Notification[userRecevants.length];
        for(int i=0;i<notifications.length;i++){
            notifications[i] = new Notification();
            notifications[i].setIdUser(this.getIdUser());
            notifications[i].setIdObjet(this.getIdObjet());
            notifications[i].setObjet(this.getObjet());
            notifications[i].setMessage(this.getMessage());
            notifications[i].setLien(this.getLien());
            notifications[i].setDaty(this.getDaty());
            notifications[i].setHeure(this.getHeure());
            notifications[i].setPriorite(this.getPriorite());
            notifications[i].setClasse(this.getClasse());
            notifications[i].setIdUser_Recevant(String.valueOf(userRecevants[i].getRefuser()));
        }
        return notifications;
    }

    public static Notification [] saveAll(Notification [] notifications,String u,Connection c) throws Exception {
        boolean estOuvert = false;
        try {
            if (c == null) {
                estOuvert = true;
                c = new UtilDB().GetConn();
            }
            for (Notification notif :notifications){
                notif.createObject(u,c);
            }
        } catch (Exception e) {
            throw e;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return notifications;
    }

    public static Notification [] getNotificationNonLu(String idUser,Connection c) throws Exception {
        Notification search = new Notification();
        search.setIdUser_Recevant(idUser);
        Notification [] notifications = (Notification[]) CGenUtil.rechercher(search,null,null,c," AND ETAT=1 ORDER BY DATY,HEURE DESC");
        return notifications;
    }
}
