/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package media;

/**
 *
 * @author Toky20
 */
public class MediaCpl extends Media{

    String idTypeMediaLib;
    String idClientLib;

    public MediaCpl() {
        this.setNomTable("MEDIA_CPL");
    }

    public String getIdClientLib() {
        return idClientLib;
    }

    public String getIdTypeMediaLib() {
        return idTypeMediaLib;
    }
    public void setIdClientLib(String idClientLib) {
        this.idClientLib = idClientLib;
    }

    public void setIdTypeMediaLib(String idTypeMediaLib) {
        this.idTypeMediaLib = idTypeMediaLib;
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","idTypeMediaLib"};
        return motCles;
    }
}
