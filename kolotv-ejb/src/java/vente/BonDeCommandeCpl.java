package vente;

import chatbot.ClassIA;

public class BonDeCommandeCpl extends BonDeCommande {
    private String idclientlib , modepaiementlib, etatlib ,idMagasinLib;
    int etatFacturation;
    int etatPlannification;
    String etatFacturationLib;

    public int getEtatPlannification() {
        return etatPlannification;
    }

    public void setEtatPlannification(int etatPlannification) {
        this.etatPlannification = etatPlannification;
    }

    public int getEtatFacturation() {
        return etatFacturation;
    }

    public void setEtatFacturation(int etatFacturation) {
        this.etatFacturation = etatFacturation;
    }

    public String getEtatFacturationLib() {
        return etatFacturationLib;
    }

    public void setEtatFacturationLib(String etatFacturationLib) {
        this.etatFacturationLib = etatFacturationLib;
    }

    public BonDeCommandeCpl() {
        this.setNomTable("BONDECOMMANDE_CLIENT_CPL");
    }

    public String getIdMagasinLib() {
        return idMagasinLib;
    }

    public void setIdMagasinLib(String idMagasinLib) {
        this.idMagasinLib = idMagasinLib;
    }

    public String getIdclientlib() {
        return idclientlib;
    }

    public void setIdclientlib(String idclientlib) {
        this.idclientlib = idclientlib;
    }

    public String getModepaiementlib() {
        return modepaiementlib;
    }

    public void setModepaiementlib(String modepaiementlib) {
        this.modepaiementlib = modepaiementlib;
    }
    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }
}
