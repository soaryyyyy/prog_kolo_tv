CREATE OR REPLACE VIEW VENTE_CLIENT_CPL AS
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
          v.REGLEMENT,
          v.REFERENCE,
          v.REFERENCEBC,
          V.ECHEANCE
     FROM VENTE v
          LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
          LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
          JOIN VENTEMONTANT v2 ON v2.ID = v.ID
          LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
		  LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;



CREATE OR REPLACE VIEW VENTE_DETAILS_CPL AS
  SELECT vd.ID,
          vd.IDVENTE,
          v.DESIGNATION AS IDVENTELIB,
          vd.IDPRODUIT,
          p.VAL AS IDPRODUITLIB,
          vd.IDORIGINE,
          vd.QTE,
          VD.pu
             AS PU,
         	CAST((nvl(vd.remise/100,0))*(vd.QTE * vd.PU) AS NUMBER(30,2)) AS montantRemise,
            CAST((1-nvl(vd.remise/100,0))*(vd.QTE * vd.PU) AS NUMBER(30,2)) AS montant,
          vd.iddevise AS iddevise,
          vd.tauxDeChange AS tauxDeChange,
          vd.tva AS tva,
          v.idclient,
          v.idclientlib,
          vd.designation,
          vd.PUREVIENT,
          cast(vd.QTE*vd.PUREVIENT as NUMBER(20,2)) as montantRevient,
          vd.REFERENCE
     FROM VENTE_DETAILS vd
          LEFT JOIN VENTE_LIB v ON v.ID = vd.IDVENTE
          LEFT JOIN PRODUIT p ON p.ID = vd.IDPRODUIT;