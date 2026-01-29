/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package reservation;

import java.sql.Date;

/**
 *
 * @author bruel
 */
public class ReservationLibAvecDateMax extends ReservationLib{
    Date datyfinpotentiel;
    
    public ReservationLibAvecDateMax() throws Exception {
        super();
        setNomTable("reservation_lib_avecmaxdate");
    }
    
    public Date getDatyfinpotentiel() {
        return datyfinpotentiel;
    }

    public void setDatyfinpotentiel(Date datefinpotentiel) {
        this.datyfinpotentiel = datefinpotentiel;
    }
}
