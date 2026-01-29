/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package media;

import bean.ClassMAPTable;
import utils.CalendarUtil;

import java.sql.Connection;

/**
 *
 * @author Toky20
 */
public class Media extends ClassMAPTable{

    String id;
    String duree;
    String idTypeMedia;
    String idClient;
    String description;

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Media() {
        this.setNomTable("MEDIA");
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getDuree() {
        return duree;
    }

    public String getIdClient() {
        return idClient;
    }

    public String getIdTypeMedia() {
        return idTypeMedia;
    }

    public void setDuree(String duree) throws Exception {
        if (!CalendarUtil.isValidTime(duree)) {
            this.duree = duree;
        }
        else {
            this.duree = String.valueOf(CalendarUtil.HMSToSecond(duree));
        }
    }

    public void setIdClient(String idClient) {
        this.idClient = idClient;
    }

    public void setIdTypeMedia(String idTypeMedia) {
        this.idTypeMedia = idTypeMedia;
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
        this.preparePk("MED", "GETSEQ_MEDIA");
        this.setId(makePK(c));
    }


    @Override
    public String[] getMotCles() {
        return new String[]{"id","description","duree"};
    }

}
