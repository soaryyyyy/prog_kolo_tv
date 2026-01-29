create or replace view V_ETATCAISSE as
SELECT r.ID,
       r.IDCAISSE,
       c.val    AS                                                idcaisseLib,
       c.idtypecaisse,
       tc.desce AS                                                idtypecaisselib,
       c.idpoint,
       p.desce  AS                                                idpointlib,
       r.DATY                                                     dateDernierReport,
       cast(NVL(r.MONTANT, 0) as number(30, 2)) as                                          montantDernierReport,
       cast(NVL(mvt.debit, 0) as number(30, 2)) as                                          debit,
       cast(NVL(mvt.credit, 0) as number(30, 2)) as                                         credit,
       cast((NVL(mvt.credit, 0) + NVL(r.MONTANT, 0) - NVL(mvt.debit, 0)) as number(30, 2)) as reste
FROM REPORTCAISSE r,
     (
         SELECT r.IDCAISSE,
                MAX(r.DATY) maxDateReport
         FROM REPORTCAISSE r
         WHERE r.ETAT = 11
           AND r.DATY <= SYSDATE
         GROUP BY r.IDCAISSE
     ) rm,
     (
         SELECT m.IDCAISSE,
                SUM(nvl(m.DEBIT, 0))  DEBIT,
                SUM(nvl(m.CREDIT, 0)) CREDIT
         FROM MOUVEMENTCAISSE_VISE m,
              (
                  SELECT r.IDCAISSE,
                         MAX(r.DATY) maxDateReport
                  FROM REPORTCAISSE r
                  WHERE r.ETAT = 11
                    AND r.DATY <= SYSDATE
                  GROUP BY r.IDCAISSE
              ) rm
         WHERE m.IDCAISSE = rm.idcaisse(+)
           AND m.DATY > rm.maxDateReport
           AND m.DATY <= SYSDATE
         GROUP BY m.IDCAISSE
     ) mvt,
     caisse c,
     typecaisse tc,
     point p
WHERE r.DATY = rm.maxDateReport
  AND r.IDCAISSE = rm.IDCAISSE
  AND r.IDCAISSE = c.ID(+)
  AND r.IDCAISSE = mvt.idcaisse(+)
  AND c.IDTYPECAISSE = tc.ID(+)
  AND c.IDPOINT = p.ID
/


update TAUXDECHANGE set TAUX=1 where iddevise='AR';

create or replace view MOUVEMENTCAISSE_VISE as
select * from MOUVEMENTCAISSE
WHERE ETAT=11;