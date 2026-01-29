-- KOLOTV.PROFORMAMONTANT source

CREATE OR REPLACE FORCE VIEW PROFORMAMONTANT AS 
SELECT 
  v.ID,
  CAST(SUM((NVL(vd.QTE, 0) * NVL(vd.PU, 0)) - NVL(vd.remise, 0)) AS NUMBER(30,2)) AS montanttotal,
  CAST(SUM(NVL(vd.QTE, 0) * NVL(vd.PuAchat, 0)) AS NUMBER(30,2)) AS montanttotalachat,
  CAST(SUM(((NVL(vd.QTE, 0) * NVL(vd.PU, 0)) - NVL(vd.remise, 0)) * NVL(vd.TVA, 0) / 100) AS NUMBER(30,2)) AS montantTVA,
  CAST(
    SUM(((NVL(vd.QTE, 0) * NVL(vd.PU, 0)) - NVL(vd.remise, 0)) * NVL(vd.TVA, 0) / 100) +
    SUM((NVL(vd.QTE, 0) * NVL(vd.PU, 0)) - NVL(vd.remise, 0))
  AS NUMBER(30,2)) AS montantTTC,
  NVL(vd.IDDEVISE, 'AR') AS IDDEVISE,
  NVL(AVG(vd.tauxDeChange), 1) AS tauxDeChange,
  CAST(
    SUM((((NVL(vd.QTE, 0) * NVL(vd.PU, 0)) - NVL(vd.remise, 0)) * NVL(VD.TAUXDECHANGE,1)) * NVL(VD.TVA, 0) / 100) +
    SUM(((NVL(vd.QTE, 0) * NVL(vd.PU, 0)) - NVL(vd.remise, 0)) * NVL(VD.TAUXDECHANGE,1))
  AS NUMBER(30,2)) AS montantTTCAR,
  CAST(SUM(vd.PUREVIENT * vd.QTE) AS NUMBER(20,2)) AS montantRevient,
  v.IDRESERVATION
FROM 
  PROFORMA_DETAILS vd
LEFT JOIN 
  PROFORMA v ON v.ID = vd.IDPROFORMA 
GROUP BY 
  v.ID, vd.IDDEVISE, v.IDRESERVATION;





-- KOLOTV.PROFORMA_CPL source

CREATE OR REPLACE VIEW PROFORMA_CPL AS
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
     FROM PROFORMA v
          LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
          LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
          JOIN PROFORMAMONTANT v2 ON v2.ID = v.ID
          LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
          LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;
          
CREATE OR REPLACE VIEW ProformaDetails_CPL
AS
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
       vd.DESIGNATION
FROM PROFORMA_DETAILS vd
         LEFT JOIN PROFORMA v ON v.ID = vd.IDPROFORMA
         LEFT JOIN PRODUIT p ON p.ID = vd.IDPRODUIT;
