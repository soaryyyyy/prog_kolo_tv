package mg.cnaps.compta;
import com.google.gson.Gson;
import utilitaire.Utilitaire;

import bean.AdminGen;
import bean.CGenUtil;
import utilitaire.UtilDB;
import utilitaire.Utilitaire;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Balance {
 
    private BalanceDetails[] balanceDetails;
    private BalanceDetails total;
    private int moisDebut;
    private int moisFin;
    private int exercice;
    private String debutCompte;
    private String finCompte;
    private String typeCompte;

    public BalanceDetails[] getBalanceDetails(String date1, String date2, String typeCompte, String compteDebut, String compteFin, String exercice) {
        BalanceDetails[] res = null;
        Connection c = null;
        boolean isAnalytique = false;
        if(date1.length()==1) date1= "0"+date1;
        date1 = exercice+"-"+date1+"-01";
        date2 = Utilitaire.getLastDayOfDate("01/"+date2+"/"+exercice);
        try {
            if(c==null) {
                c = new UtilDB().GetConn();
            }

            BalanceDetails bd = new BalanceDetails();
            String[] idCompte = null;
            if(compteDebut == null && compteFin == null || (compteDebut.compareToIgnoreCase("")==0 && compteFin.compareToIgnoreCase("")==0)) {
                idCompte = new String[2];
                idCompte[0] = "1";
                idCompte[1] = "99";
            }else if(compteDebut != null && compteFin == null || (compteDebut.compareToIgnoreCase("")!=0 && compteFin.compareToIgnoreCase("")==0)) {

                idCompte[0] = compteDebut;
                idCompte[1] = "99";
            } else if(compteDebut == null && compteFin != null || (compteDebut.compareToIgnoreCase("")==0 && compteFin.compareToIgnoreCase("")!=0)) {

                idCompte[0] = "1";
                idCompte[1] = compteFin;
            } else {
                idCompte[0] = compteDebut;
                idCompte[1] = compteFin;
            }

            bd.setNomTable("v_balance_details");
            if(typeCompte != null && typeCompte.compareToIgnoreCase("3")==0) {
                bd.setNomTable("v_balance_details_analytique");
                isAnalytique = true;
            }


            res = (mg.cnaps.compta.BalanceDetails[])CGenUtil.rechercher(bd,generateQueryBalance(date1,date2,idCompte,isAnalytique));
            Gson gson = new Gson();
            /*for (BalanceDetails bedd : res){
                System.out.println("dteaillsss "+gson.toJson(bedd));
            }*/

        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    public String generateQueryBalance(String date1, String date2, String[] compte, boolean isAnalytique) {
        String query = "WITH latest_entry AS (\n" +
                "SELECT compte, debit, credit, datecomptable as max_daty\n" +
                "FROM (\n" +
                "         SELECT\n" +
                "             cs.compte,\n" +
                "             cs.debit,\n" +
                "             cs.credit,\n" +
                "             ce.datecomptable,\n" +
                "             ROW_NUMBER() OVER (PARTITION BY cs.compte ORDER BY ce.datecomptable DESC) AS rn\n" +
                "         FROM compta_sous_ecriture cs\n" +
                "                  JOIN compta_ecriture ce ON ce.id = cs.idmere\n" +
                "         WHERE ce.journal = '" + ConstanteCompta.journalReport + "'\n" +
                "           AND ce.etat >= 11\n" +
                "           AND ce.datecomptable < DATE '" + date1 + "'\n" +
                "     ) sub\n" +
                "WHERE rn = 1" +
                "),\n" +
                "     im AS (\n" +
                "         SELECT\n" +
                "             c.compte,\n" +
                "             NVL(le.max_daty, DATE '2001-01-01') AS maxDaty,\n" +
                "             NVL(le.debit, 0) AS debit,\n" +
                "             NVL(le.credit, 0) AS credit\n" +
                "         FROM compta_compte c\n" +
                "                  LEFT JOIN latest_entry le ON le.compte = c.compte\n" +
                "     ),\n" +
                "     ce_filtered AS (\n" +
                "         SELECT ce.id, datecomptable, cse.debit, cse.credit\n" +
                "         FROM compta_ecriture ce\n" +
                "         join compta_sous_ecriture cse on cse.idmere = ce.id\n" +
                "         WHERE ce.etat >= 11\n" +
                "           AND datecomptable < DATE '" + date1 + "'\n" +
                "     ),\n" +
                "     em AS (\n" +
                "         SELECT\n" +
                "             CAST(cse.compte AS VARCHAR2(100)) AS compte,\n" +
                "             SUM(cse.debit) AS debit,\n" +
                "             SUM(cse.credit) AS credit\n" +
                "         FROM\n" +
                "             compta_sous_ecriture cse\n" +
                "                 JOIN compta_ecriture ce ON ce.id = cse.idmere\n" +
                "         WHERE\n" +
                "             ce.datecomptable >= DATE '" + date1 + "' and ce.datecomptable <= DATE '" + date2 + "'\n" +
                "           AND ce.etat >= 11\n" +
                "           AND ce.journal != '" + ConstanteCompta.journalReport + "'\n" +
                "         GROUP BY\n" +
                "             cse.compte\n" +
                "     )\n" +
                "SELECT\n" +
                "    c.compte,\n" +
                "    c.libelle as libelleCompte,\n" +
                "    sum(ce.credit) as currentCred,\n" +
                "    avg(im.credit) as imCred,\n" +
                "    NVL(SUM(ce.debit), 0) + NVL(avg(im.debit), 0) AS cumulDebit,\n" +
                "    NVL(SUM(ce.credit), 0) + NVL(avg(im.credit), 0) AS cumulCredit,\n" +
                "    NVL(avg(em.debit), 0) as debit,\n" +
                "    NVL(avg(em.credit), 0) as credit,\n" +
                "    TO_NUMBER(SUBSTR(c.compte, 1, 3)) AS compte3, \n" +
                "    TO_NUMBER(SUBSTR(c.compte, 1, 2)) AS compte2 \n" +
                "FROM compta_compte c \n" +
                "         LEFT JOIN em on em.compte = c.compte\n" +
                "         LEFT JOIN im ON im.compte = c.compte\n" +
                "         LEFT JOIN compta_sous_ecriture cse ON cse.compte = c.compte\n" +
                "         LEFT JOIN ce_filtered ce ON ce.id = cse.idmere AND ce.datecomptable > im.maxDaty\n" +
                " WHERE c.compte >= '" + compte[0] + "' and c.compte <= '" + compte[1] + "'\n";
        if (isAnalytique) query += " and c.typecompte = '" + ConstanteCompta.type_compte_analytique + "'\n";
        query += " GROUP BY c.compte, c.libelle \n" +
                "order by c.compte asc";


        System.out.println(query);
        return query;
    }

    public Balance(String exercice, String typeCompte, String moisDebut, String moisFin, String compteDebut, String compteFin) throws Exception {
        setExercice(exercice);
        setTypeCompte(typeCompte);
        setMoisDebut(moisDebut);
        setMoisFin(moisFin);
        setDebutCompte(compteDebut);
        setFinCompte(compteFin);
        this.setBalanceDetails(getBalanceDetails(moisDebut, moisFin, typeCompte, compteDebut, compteFin, exercice));
        calculerTotal();
        calculerSousTotal();
    }

    //
    public void calculerTotal() throws Exception {
        setTotal(new BalanceDetails());
        getTotal().setCumulDebit(AdminGen.calculSommeDouble(this.getBalanceDetails(), "cumulDebit"));
        getTotal().setCumulCredit(AdminGen.calculSommeDouble(this.getBalanceDetails(), "cumulCredit"));
        getTotal().setCredit(AdminGen.calculSommeDouble(this.getBalanceDetails(), "credit"));
        getTotal().setDebit(AdminGen.calculSommeDouble(this.getBalanceDetails(), "debit"));
        calculerTotalSD();
        calculerTotalSC();
    }
    public void calculerTotalSD() throws Exception {
        double sd = 0;
        for (BalanceDetails bd : balanceDetails) {
            sd += bd.getSoldeDebit();
        }
        getTotal().setSoldeDebit(sd);
    }
    public void calculerTotalSC() throws Exception {
        double sc = 0;
        for (BalanceDetails bd : balanceDetails) {
            sc += bd.getSoldeCredit();
        }
        getTotal().setSoldeCredit(sc);
    }

    public void calculerSousTotal() throws Exception {
//        parcourir anle balacedetails atao anaty list
//        rehefa miparcour ka miova le compte3 : tys mitovy le compte 3 sy 3-1 dia stockena ilay teo aloha
//        a chaque tour de boucle micreer variable roa :
//            total2 dia total1 atomboka 0
//        isaky ny misy iray tsy mitovy ilay 3 dia stockena ilay precedent
//        raha vao samihafa le precedent sy izy dia mamorona balancedetails vaovao dia ny valeur totalanle valeur dia le compte compte3 na compte2
        List<BalanceDetails> list = new ArrayList<>();
        BalanceDetails bd = getBalanceDetails()[0];

        BalanceDetails bd3 = new BalanceDetails(bd.getCredit(),bd.getDebit(),"SOUS TOTAUX "+bd.getCompte3(),bd.getCumulCredit(),bd.getCumulDebit(),bd.getCompte2(),bd.getCompte3());
        BalanceDetails bd2 = new BalanceDetails(bd.getCredit(),bd.getDebit(),"SOUS TOTAUX "+bd.getCompte2(),bd.getCumulCredit(),bd.getCumulDebit(),bd.getCompte2(),bd.getCompte3());
        int index = 0;
        for (int i = 1;i < getBalanceDetails().length; i++) {
            BalanceDetails details = getBalanceDetails()[i];
            list.add(details);
            index++;
            if (details.getCompte3()==bd3.getCompte3()) {
                bd3.updateDetails(details.getCredit(),details.getDebit(),details.getCumulCredit(),details.getCumulDebit());
            }
            else {
                list.add(index-1,bd3);
                index++;
                bd = details;
                bd3 = new BalanceDetails(bd.getCredit(),bd.getDebit(),"SOUS TOTAUX "+bd.getCompte3(),bd.getCumulCredit(),bd.getCumulDebit(),bd.getCompte2(),bd.getCompte3());
            }
            if (details.getCompte2()==bd2.getCompte2()) {
                bd2.updateDetails(details.getCredit(),details.getDebit(),details.getCumulCredit(),details.getCumulDebit());
            }
            else {
                list.add(index-1,bd2);
                index++;
                bd = details;
                bd2 = new BalanceDetails(bd.getCredit(),bd.getDebit(),"SOUS TOTAUX "+bd.getCompte2(),bd.getCumulCredit(),bd.getCumulDebit(),bd.getCompte2(),bd.getCompte3());
            }
        }
        setBalanceDetails(list.toArray(new BalanceDetails[0]));
    }

    public BalanceDetails[] getBalanceDetails() {
        return balanceDetails;
    }
    
    public void setBalanceDetails(BalanceDetails[] balanceDetails) {
        this.balanceDetails = balanceDetails;
    }

    public BalanceDetails getTotal() {
        return total;
    }
    
    public void setTotal(BalanceDetails total) {
        this.total = total;
    }

    public String getDateDebut() {
        return "01/" + Utilitaire.completerInt(2, getMoisDebut()) + "/" + getExercice();
    }
    public String getDateFin() {
        return Utilitaire.formatterDaty(Utilitaire.getLastDayOfDate("01/" + Utilitaire.completerInt(2, getMoisFin()) + "/" + getExercice()));
    }


    public int getMoisDebut() {
        return moisDebut;
    }

    public void setMoisDebut(int moisDebut) {
        this.moisDebut = moisDebut;
    }
    public void setMoisDebut(String moisDebut) throws Exception {
        int deb = Integer.parseInt(moisDebut);
        setMoisDebut(deb);
    }
    public void setMoisFin(String moisFin) throws Exception {
        int fin = Integer.parseInt(moisFin);
        setMoisFin(fin);
    }

    public int getMoisFin() {
        return moisFin;
    }

    public void setMoisFin(int moisFin){
        this.moisFin = moisFin;
    }

    public int getExercice() {
        return exercice;
    }

    public void setExercice(int exercice) {
        this.exercice = exercice;
    }
    public void setExercice(String exercice) throws Exception {
        int ex = Integer.parseInt(exercice);
        setExercice(ex);
    }

    public String getDebutCompte() {
        return debutCompte;
    }

    public void setDebutCompte(String debutCompte) {
        this.debutCompte = debutCompte;
    }

    public String getFinCompte() {
        return finCompte;
    }

    public void setFinCompte(String finCompte) {
        this.finCompte = finCompte;
    }

    public String getTypeCompte() {
        return typeCompte;
    }

    public void setTypeCompte(String typeCompte) {
        this.typeCompte = typeCompte;
    }
}
