ALTER TABLE PROFORMA_DETAILS 
ADD reference VARCHAR2(255);
-----------------------------------
CREATE OR REPLACE FORCE VIEW "INSERTION_PROFORMA_DETAILS" ("ID", "IDPROFORMA", "IDPRODUIT", "IDORIGINE", "QTE", "PU", "REMISE", "TVA", "PUACHAT", "PUVENTE", "IDDEVISE", "TAUXDECHANGE", "COMPTE", "PUREVIENT", "DESIGNATION", "REFERENCE", "UNITEREMISE") AS 
  SELECT p."ID",p."IDPROFORMA",p."IDPRODUIT",p."IDORIGINE",p."QTE",p."PU",p."REMISE",p."TVA",p."PUACHAT",p."PUVENTE",p."IDDEVISE",p."TAUXDECHANGE",p."COMPTE",p."PUREVIENT",p."DESIGNATION",p.reference,
       '' AS uniteRemise
FROM PROFORMA_DETAILS p
;
-----------------------------------
-- KOLOTV1203.PROFORMA_CPL source

CREATE OR REPLACE FORCE VIEW "PROFORMA_CPL" ("ID", "DESIGNATION", "IDMAGASIN", "IDMAGASINLIB", "DATY", "REMARQUE", "ETAT", "ETATLIB", "MONTANTTOTAL", "IDDEVISE", "IDCLIENT", "IDCLIENTLIB", "NIF", "STAT", "ADRESSE", "CONTACT", "MONTANTTVA", "MONTANTTTC", "MONTANTTTCAR", "MONTANTPAYE", "MONTANTRESTE", "AVOIR", "TAUXDECHANGE", "MONTANTREVIENT", "MARGEBRUTE", "IDRESERVATION", "IDORIGINE","ECHEANCE","REGLEMENT") AS 
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
          v.IDORIGINE,
          v.ECHEANCE ,
          v.REGLEMENT 
     FROM PROFORMA v
          LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
          LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
          JOIN PROFORMAMONTANT v2 ON v2.ID = v.ID
          LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
          LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;
----------------------------------
CREATE OR REPLACE FORCE VIEW "PROFORMADETAILS_CPL" ("ID", "IDPROFORMA", "IDPROFORMALIB", "IDPRODUIT", "IDPRODUITLIB", "IDORIGINE", "QTE", "PU", "PUTOTAL", "PUACHAT", "IDRESERVATION", "DESIGNATION","REFERENCE") AS 
  SELECT vd.ID,
       vd.IDPROFORMA,
       v.DESIGNATION    AS IDPROFORMALIB,
       vd.IDPRODUIT,
       p.VAL            AS IDPRODUITLIB,
       vd.IDORIGINE,
       vd.QTE,
       vd.PU,
       cast((vd.QTE * vd.PU) as NUMBER(30,2)) AS puTotal,
       vd.PuAchat AS PUACHAT,
       v.IDRESERVATION,
       vd.DESIGNATION,
       vd.REFERENCE 
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN PRODUIT p ON p.ID = vd.IDPRODUIT;