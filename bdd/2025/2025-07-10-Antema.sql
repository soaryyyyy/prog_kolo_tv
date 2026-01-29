ALTER TABLE CLIENT
ADD (
   NIF  VARCHAR2(255),
   STAT VARCHAR2(255)
);

CREATE OR REPLACE FORCE VIEW VENTE_CLIENT_CPL AS 
  SELECT v.ID,
          v.DESIGNATION,
          v.IDMAGASIN,
          m.VAL AS IDMAGASINLIB,
          v.DATY,
          v.REMARQUE,
          v.ETAT,
          CASE
             WHEN v.ETAT = 1 THEN 'CREE'
             WHEN v.ETAT = 11 THEN 'VISEE'
             WHEN v.ETAT = 0 THEN 'ANNULEE'
          END
             AS ETATLIB,
          v2.MONTANTTOTAL,
          v2.IDDEVISE,
          v.IDCLIENT,
          c.NOM AS IDCLIENTLIB,
          c.NIF,
          c.STAT,
          c.ADRESSE,
          c.TELEPHONE AS CONTACT,
          cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
          cast(V2.MONTANTTTC as number(30,2)) as montantttc,
          cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
          cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
          cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
          nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
          v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
          v.IDRESERVATION,
          v.IDORIGINE
     FROM VENTE v
          LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
          LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
          JOIN VENTEMONTANT v2 ON v2.ID = v.ID
          LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
		  LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;
