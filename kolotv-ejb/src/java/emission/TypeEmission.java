package emission;

import bean.TypeObjet;

import java.sql.Connection;

public class TypeEmission extends TypeObjet {

    public TypeEmission() {
        this.setNomTable("TYPEEMISSION");
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("TEM", "getseqtypeemission");
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
