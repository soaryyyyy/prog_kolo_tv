CREATE OR REPLACE VIEW VENTE_DETAILS_CPL AS
SELECT vd.ID,
   vd.IDVENTE,
   v.DESIGNATION AS IDVENTELIB,
   vd.IDPRODUIT,
   p.VAL AS IDPRODUITLIB,
   vd.IDORIGINE,
   vd.QTE,
   VD.pu AS PU,
   nvl(vd.remise,0) AS montantRemise,
   CAST(((vd.QTE * vd.PU)-nvl(vd.remise,0)) AS NUMBER(30,2)) AS montant,
   CAST((((vd.QTE * vd.PU)-nvl(vd.remise,0))*nvl(vd.TVA/100,0)) AS NUMBER(30,2)) AS montantTva,
   CAST((((vd.QTE * vd.PU)-nvl(vd.remise,0))+(((vd.QTE * vd.PU)-nvl(vd.remise,0))*nvl(vd.TVA/100,0))) AS NUMBER(30,2)) AS montantTtc,
   vd.iddevise AS iddevise,
   vd.tauxDeChange AS tauxDeChange,
   vd.tva AS tva,
   v.idclient,
   v.idclientlib,
   vd.designation,
   vd.PUREVIENT,
   cast(vd.QTE*vd.PUREVIENT as NUMBER(20,2)) as montantRevient,
   vd.reference
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE_LIB v ON v.ID = vd.IDVENTE
         LEFT JOIN PRODUIT p ON p.ID = vd.IDPRODUIT;