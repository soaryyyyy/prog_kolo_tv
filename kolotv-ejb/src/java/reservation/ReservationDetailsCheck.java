package reservation;

public class ReservationDetailsCheck extends ReservationDetails{

    private String idclient;

    public ReservationDetailsCheck() throws Exception {
       setNomTable("RESERVATIONDETSANSCI");
    }

    public String getIdclient() {
        return idclient;
    }

    public void setIdclient(String idclient) {
        this.idclient = idclient;
    }

}
