package emission;

public class EmissionLib extends Emission {
    String idGenreLib;
    String idSupportLib;

    public EmissionLib() throws Exception {
        setNomTable("EMISSION_LIB");
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


    @Override
    public String[] getMotCles() {
        return new String[]{"id","nom","idSupportLib"};
    }

}
