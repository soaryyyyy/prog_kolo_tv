package emission;

public class EmissionDetailsLib extends EmissionDetails {
    String libelleemission;
    String idSupport;
    String idGenre;
    String idGenreLib;
    String idSupportLib;

    public EmissionDetailsLib() throws Exception {
        setNomTable("EMISSIONDETAILS_LIB");
    }

    public String getLibelleemission() {
        return libelleemission;
    }

    public void setLibelleemission(String libelleemission) {
        this.libelleemission = libelleemission;
    }

    public String getIdSupport() {
        return idSupport;
    }

    public void setIdSupport(String idSupport) {
        this.idSupport = idSupport;
    }

    public String getIdGenre() {
        return idGenre;
    }

    public void setIdGenre(String idGenre) {
        this.idGenre = idGenre;
    }

    public String getIdGenreLib() {
        return idGenreLib;
    }

    public void setIdGenreLib(String idGenreLib) {
        this.idGenreLib = idGenreLib;
    }

    public String getIdSupportLib() {
        return idSupportLib;
    }

    public void setIdSupportLib(String idSupportLib) {
        this.idSupportLib = idSupportLib;
    }
}
