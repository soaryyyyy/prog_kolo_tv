package emission;

public class ParrainageEmissionCpl extends ParrainageEmission {

    String idclientlib;
    String idemissionlib;
    String etatlib;
    String billBoardInLib;
    String billBoardOutLib;

    public String getBillBoardInLib() {
        return billBoardInLib;
    }

    public void setBillBoardInLib(String billBoardInLib) {
        this.billBoardInLib = billBoardInLib;
    }

    public String getBillBoardOutLib() {
        return billBoardOutLib;
    }

    public void setBillBoardOutLib(String billBoardOutLib) {
        this.billBoardOutLib = billBoardOutLib;
    }

    public ParrainageEmissionCpl() throws Exception{
        this.setNomTable("PARRAINAGEEMISSION_CPL");
    }

    public String getIdclientlib() {
        return idclientlib;
    }

    public void setIdclientlib(String idclientlib) {
        this.idclientlib = idclientlib;
    }

    public String getIdemissionlib() {
        return idemissionlib;
    }

    public void setIdemissionlib(String idemissionlib) {
        this.idemissionlib = idemissionlib;
    }

    public String getEtatlib() {
        return etatlib;
    }

    public void setEtatlib(String etatlib) {
        this.etatlib = etatlib;
    }
}
