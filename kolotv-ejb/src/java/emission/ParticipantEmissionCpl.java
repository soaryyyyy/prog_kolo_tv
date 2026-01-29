package emission;

public class ParticipantEmissionCpl extends ParticipantEmission {

    String idemissionlib;

    public ParticipantEmissionCpl() {
        this.setNomTable("PARTICIPANTEMISSION_CPL");
    }

    public String getIdemissionlib() {
        return idemissionlib;
    }

    public void setIdemissionlib(String idemissionlib) {
        this.idemissionlib = idemissionlib;
    }
}
