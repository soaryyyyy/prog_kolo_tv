/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package caisse;

import bean.ClassMAPTable;
import java.sql.Date;
import java.time.LocalDate;

import utilitaire.Utilitaire;
import bean.ResultatEtSomme;
import bean.CGenUtil;
import java.sql.Connection;

/**
 *
 * @author 26134
 */
public class EtatCaisse extends ClassMAPTable{
    String id,idCaisse,idCaisselib,idPoint,idPointlib,idTypeCaisse,idTypeCaisselib;
    Date dateDernierReport;
    double montantDernierReport,credit,debit,reste,solde;

    public EtatCaisse() {
        this.setNomTable("v_Etatcaisse");
    }

    public double getReste() {
        return reste;
    }

    public void setReste(double reste) {
        this.reste = reste;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIdCaisse() {
        return idCaisse;
    }

    public void setIdCaisse(String idCaisse) {
        this.idCaisse = idCaisse;
    }

    public String getIdCaisselib() {
        return idCaisselib;
    }

    public void setIdCaisselib(String idCaisselib) {
        this.idCaisselib = idCaisselib;
    }

    public String getIdPoint() {
        return idPoint;
    }

    public void setIdPoint(String idPoint) {
        this.idPoint = idPoint;
    }

    public String getIdPointlib() {
        return idPointlib;
    }

    public void setIdPointlib(String idPointlib) {
        this.idPointlib = idPointlib;
    }

    public String getIdTypeCaisse() {
        return idTypeCaisse;
    }

    public void setIdTypeCaisse(String idTypeCaisse) {
        this.idTypeCaisse = idTypeCaisse;
    }

    public String getIdTypeCaisselib() {
        return idTypeCaisselib;
    }

    public void setIdTypeCaisselib(String idTypeCaisselib) {
        this.idTypeCaisselib = idTypeCaisselib;
    }

    public Date getDateDernierReport() {
        return dateDernierReport;
    }

    public void setDateDernierReport(Date dateDernierReport) {
        this.dateDernierReport = dateDernierReport;
    }

    public double getMontantDernierReport() {
        return montantDernierReport;
    }

    public void setMontantDernierReport(double montantDernierReport) {
        this.montantDernierReport = montantDernierReport;
    }

    public double getCredit() {
        return credit;
    }

    public void setCredit(double credit) {
        this.credit = credit;
    }

    public double getDebit() {
        return debit;
    }

    public void setDebit(double debit) {
        this.debit = debit;
    }

    public double getSolde() {
        return solde;
    }

    public void setSolde(double solde) {
        this.solde = solde;
    }

    public String getFieldDateName() {
        return "dateDernierReport";
    }
    @Override
    public String getTuppleID() {
        return this.id;
    }

    @Override
    public String getAttributIDName() {
        return "id";
    }
    public String generateQueryCore(Date dateMin, Date dateMax ) {
        LocalDate localDate = LocalDate.now();
        Date dateDuJours = Date.valueOf(localDate);
        dateDuJours = Utilitaire.ajoutJourDate(dateDuJours, -1) ;
        String query ;
        //System.out.println(dateMin+"  date du jour ="+dateDuJours);
        if(dateDuJours.equals(dateMin)){
            query = "SELECT * FROM V_ETATCAISSE_devise_AR";
        }else{
            query="SELECT  r.ID\n" +
                    "     ,r.IDCAISSE\n" +
                    "     ,c.val                                                                    AS idcaisseLib\n" +
                    "     ,c.idtypecaisse\n" +
                    "     ,tc.desce                                                                 AS idtypecaisselib\n" +
                    "     ,c.idpoint\n" +
                    "     ,p.desce                                                                  AS idpointlib\n" +
                    "     ,r.DATY dateDernierReport\n" +
                    "     ,CAST(NVL(((r.MONTANT+nvl(mvtAv.CREDIT-mvtAv.DEBIT,0))*taux.taux),0)                                          AS number(30,2)) montantDernierReport\n" +
                    "     ,CAST(NVL(mvt.debit,0)                                                    AS number(30,2)) debit\n" +
                    "     ,CAST(NVL(mvt.credit,0)                                                   AS number(30,2)) credit\n" +
                    "     ,CAST((NVL(mvt.credit,0) + NVL((r.MONTANT+nvl(mvtAv.CREDIT-mvtAv.DEBIT,0))*taux.taux,0) - NVL(mvt.debit,0)) AS number(30,2)) reste\n" +
                    "     ,'AR'                                                                     AS devise\n" +
                    "FROM REPORTCAISSE_devise r,\n" +
                    "     (\n" +
                    "         SELECT  r.IDCAISSE\n" +
                    "              ,MAX(r.DATY) maxDateReport\n" +
                    "         FROM REPORTCAISSE_devise r\n" +
                    "         WHERE r.ETAT = 11\n" +
                    "           AND r.DATY <='"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "         GROUP BY  r.IDCAISSE\n" +
                    "     ) rm, (\n" +
                    "         SELECT  m.IDCAISSE\n" +
                    "              ,SUM(nvl((m.DEBIT*t.taux),0)) DEBIT\n" +
                    "              ,SUM(nvl((m.CREDIT*t.taux),0)) CREDIT\n" +
                    "         FROM MOUVEMENTCAISSE_VISE m,\n" +
                    "              (\n" +
                    "                  SELECT  r.IDCAISSE\n" +
                    "                       ,MAX(r.DATY) maxDateReport\n" +
                    "                  FROM REPORTCAISSE r\n" +
                    "                  WHERE r.ETAT = 11\n" +
                    "                    AND r.DATY <='"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "                  GROUP BY  r.IDCAISSE\n" +
                    "              ) rm, (\n" +
                    "                  SELECT  ta.*\n" +
                    "                  FROM TAUXDECHANGE ta,\n" +
                    "                       (\n" +
                    "                           SELECT  MAX(daty) AS daty\n" +
                    "                                ,iddevise\n" +
                    "                           FROM TAUXDECHANGE t\n" +
                    "                           WHERE daty <= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "                           GROUP BY  iddevise\n" +
                    "                       ) tmax\n" +
                    "                  WHERE ta.daty = tmax.daty\n" +
                    "                    AND ta.iddevise = tmax.iddevise ) t\n" +
                    "         WHERE m.IDDEVISE = t.iddevise(+)\n" +
                    "           AND m.IDCAISSE = rm.idcaisse(+)\n" +
                    "           AND m.DATY >= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "           AND m.DATY <= '"+ Utilitaire.datetostring(dateMax) + "'\n" +
                    "         GROUP BY  m.IDCAISSE ) mvt\n" +
                    "        ,(\n" +
                    "    SELECT  m.IDCAISSE\n" +
                    "         ,SUM(nvl((m.DEBIT*t.taux),0)) DEBIT\n" +
                    "         ,SUM(nvl((m.CREDIT*t.taux),0)) CREDIT\n" +
                    "    FROM MOUVEMENTCAISSE_VISE m,\n" +
                    "         (\n" +
                    "             SELECT  r.IDCAISSE\n" +
                    "                  ,MAX(r.DATY) maxDateReport\n" +
                    "             FROM REPORTCAISSE r\n" +
                    "             WHERE r.ETAT = 11\n" +
                    "               AND r.DATY <= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "             GROUP BY  r.IDCAISSE\n" +
                    "         ) rm, (\n" +
                    "             SELECT  ta.*\n" +
                    "             FROM TAUXDECHANGE ta,\n" +
                    "                  (\n" +
                    "                      SELECT  MAX(daty) AS daty\n" +
                    "                           ,iddevise\n" +
                    "                      FROM TAUXDECHANGE t\n" +
                    "                      WHERE daty <= '"+ Utilitaire.datetostring(dateMin) + "'\n" +
                    "                      GROUP BY  iddevise\n" +
                    "                  ) tmax\n" +
                    "             WHERE ta.daty = tmax.daty\n" +
                    "               AND ta.iddevise = tmax.iddevise ) t\n" +
                    "    WHERE m.IDDEVISE = t.iddevise(+)\n" +
                    "      AND m.IDCAISSE = rm.idcaisse(+)\n" +
                    "      AND m.DATY >= maxDateReport\n" +
                    "      AND m.DATY < '" +Utilitaire.datetostring(dateMin)  +"'\n" +
                    "    GROUP BY  m.IDCAISSE ) mvtAv\n" +
                    "   ,(\n" +
                    "         SELECT  ta.*\n" +
                    "         FROM TAUXDECHANGE ta,\n" +
                    "              (\n" +
                    "                  SELECT  MAX(daty) AS daty\n" +
                    "                       ,iddevise\n" +
                    "                  FROM TAUXDECHANGE t\n" +
                    "                  WHERE daty <= '" +Utilitaire.datetostring(dateMin)  +"'\n" +
                    "                  GROUP BY  iddevise\n" +
                    "              ) tmax\n" +
                    "         WHERE ta.daty = tmax.daty\n" +
                    "           AND ta.iddevise = tmax.iddevise ) taux, caisse c, typecaisse tc, point p\n" +
                    "WHERE r.DATY = rm.maxDateReport\n" +
                    "  AND r.IDDEVISE = taux.iddevise(+)\n" +
                    "  AND r.ETAT = 11\n" +
                    "  AND r.IDCAISSE = rm.IDCAISSE\n" +
                    "  AND r.IDCAISSE = c.ID(+)\n" +
                    "  AND r.IDCAISSE = mvt.idcaisse(+)\n" +
                    "  AND r.IDCAISSE = mvtAv.idcaisse(+)\n" +
                    "  AND c.IDTYPECAISSE = tc.ID(+)\n" +
                    "  AND c.IDPOINT = p.ID\n";
        }
        //System.out.println("QUERYYY ======"+query);
        return query;
    }
    public ResultatEtSomme rechercherPage(String[] colInt, String[]valInt, int numPage, String apresWhere, String[]nomColSomme, Connection c, int npp) throws Exception {
        String daty=Utilitaire.dateDuJour();
        String daty2=Utilitaire.dateDuJour();
        if(valInt!=null&&valInt.length>1) {
            daty=valInt[0].toString();
            daty2=valInt[1].toString();
        }
        //System.out.println("tonga eto daty ="+daty+" daty2 ="+daty2);
//        String req= "SELECT r.ID,\n" +
//                "       r.IDCAISSE,\n" +
//                "       c.val    AS idcaisseLib,\n" +
//                "       c.idtypecaisse,\n" +
//                "       tc.desce AS idtypecaisselib,\n" +
//                "       c.idpoint,\n" +
//                "       p.desce  AS idpointlib,\n" +
//                "       r.DATY dateDernierReport,\n" +
//                "       NVL(r.MONTANT, 0) montantDernierReport,\n" +
//                "       NVL(mvt.debit, 0) debit,\n" +
//                "       NVL(mvt.credit, 0) credit,\n" +
//                "       NVL(mvt.credit, 0) + NVL(r.MONTANT, 0) - NVL(mvt.debit, 0) reste\n" +
//                "FROM REPORTCAISSE r,\n" +
//                "     (\n" +
//                "         SELECT r.IDCAISSE,\n" +
//                "                MAX(r.DATY) maxDateReport\n" +
//                "         FROM REPORTCAISSE r\n" +
//                "         WHERE r.ETAT = 11\n" +
//                "           AND r.DATY between '"+daty+"' and '"+daty2+"'\n" +
//                "         GROUP BY r.IDCAISSE\n" +
//                "     ) rm,\n" +
//                "     (\n" +
//                "         SELECT m.IDCAISSE,\n" +
//                "                SUM(nvl(m.DEBIT, 0))  DEBIT,\n" +
//                "                SUM(nvl(m.CREDIT, 0)) CREDIT\n" +
//                "         FROM MOUVEMENTCAISSE_VISE m,\n" +
//                "              (\n" +
//                "                  SELECT r.IDCAISSE,\n" +
//                "                         MAX(r.DATY) maxDateReport\n" +
//                "                  FROM REPORTCAISSE r\n" +
//                "                  WHERE r.ETAT = 11\n" +
//                "                    AND r.DATY between '"+daty+"' and '"+daty2+"'\n" +
//                "                  GROUP BY r.IDCAISSE\n" +
//                "              ) rm\n" +
//                "         WHERE m.IDCAISSE = rm.idcaisse(+)\n" +
//                "           AND m.DATY > rm.maxDateReport\n" +
//                "           AND m.DATY between '"+daty+"' and '"+daty2+"'\n" +
//                "         GROUP BY m.IDCAISSE\n" +
//                "     ) mvt,\n" +
//                "     caisse c,\n" +
//                "     typecaisse tc,\n" +
//                "     point p\n" +
//                "WHERE r.DATY = rm.maxDateReport\n" +
//                "  AND r.IDCAISSE = rm.IDCAISSE\n" +
//                "  AND r.IDCAISSE = c.ID(+)\n" +
//                "  AND r.IDCAISSE = mvt.idcaisse(+)\n" +
//                "  AND c.IDTYPECAISSE = tc.ID(+)\n" +
//                "  AND c.IDPOINT = p.ID";
        Date datemin = Utilitaire.stringDate(daty);
        //System.out.println("Date min ====== "+datemin);
        Date datemax = Utilitaire.stringDate(daty2);
        String query = this.generateQueryCore(datemin, datemax);
        return CGenUtil.rechercherPage(this,query,numPage,nomColSomme,apresWhere,c,npp);
    }
}
