/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package client;
import bean.ClassMAPTable;
import java.sql.Connection;
import java.sql.Date;
import pertegain.Tiers;
/**
 *
 * @author SAFIDY
 */
public class Client extends Tiers{

    private String telephone;

    private String remarque;
    String type;
    Date daty;

    public Date getDaty() {
        return daty;
    }

    public void setDaty(Date daty) {
        this.daty = daty;
    }

    public Client(){
         this.setNomTable("CLIENT");
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getRemarque() {
        return remarque;
    }

    public void setRemarque(String remarque) {
        this.remarque = remarque;
    }

    public String getType(){
        return type;
    }

    public void setType(String type){
        this.type=type;
    }

    @Override
    public void construirePK(Connection c) throws Exception {
        this.preparePk("CLI", "getSeqClient");
        this.setId(makePK(c));
    }


    @Override
    public String getValColLibelle() {
        return this.getNom();
    }

    @Override
    public String[] getMotCles() {
        String[] motCles={"id","nom","telephone"};
        return motCles;
    }

    @Override
    public String[] getValMotCles() {
        String[] motCles={"nom","telephone"};
        return motCles;
    }

    @Override
    public boolean getEstIndexable() {return true;}

}
