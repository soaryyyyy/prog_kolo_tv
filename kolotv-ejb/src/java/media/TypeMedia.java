/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package media;

import bean.TypeObjet;
import java.sql.Connection;

/**
 *
 * @author Toky20
 */
public class TypeMedia extends TypeObjet{

    public TypeMedia() {
        this.setNomTable("TYPEMEDIA");
    }
    
    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TYP", "GETSEQ_TYPEMEDIA");
        this.setId(makePK(c));
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","val","desce"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
	 String[] valMotCles={"id","val","desce"};
        return valMotCles;
    }
}
