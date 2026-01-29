
  ALTER TABLE KOLOTV1203.MOUVEMENTCAISSE
ADD (
     REFERENCE VARCHAR2(255),
    NUMERO    NUMBER(36,2) DEFAULT 0
);

-- KOLOTV1203.MOUVEMENTCAISSECPL source

CREATE OR REPLACE  VIEW MOUVEMENTCAISSECPL AS 
  SELECT m.ID,
       m.DESIGNATION,
       m.IDCAISSE,
       c.VAL   AS IDCAISSELIB,
       m.IDVENTEDETAIL,
       m.IDVIREMENT,
       m.DEBIT,
       m.CREDIT,
       m.DATY,
       m.ETAT,
       m.REFERENCE,
       m.NUMERO,
       CASE
           WHEN m.ETAT = 0
               THEN 'ANNULEE'
           WHEN m.ETAT = 1
               THEN 'CREE'
           WHEN m.ETAT = 11
               THEN 'VALIDEE'
           END AS ETATLIB,
       vd.IDVENTE,
       m.IDORIGINE,
       m.idtiers,
       t.NOM AS tiers,
       m.idPrevision,
       m.idOP,
       m.taux,
 	   m.COMPTE,
 	   m.IDDEVISE
FROM MOUVEMENTCAISSE m
         LEFT JOIN CAISSE c ON c.ID = m.IDCAISSE
         LEFT JOIN VENTE_DETAILS vd ON vd.ID = m.IDVENTEDETAIL
         LEFT JOIN tiers t ON t.ID = m.idtiers
        ;
