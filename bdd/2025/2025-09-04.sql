create or replace view VENTE_DETAILS_CPL as
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
       cast(vd.QTE*vd.PUREVIENT as NUMBER(20,2)) as montantRevient
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE_LIB v ON v.ID = vd.IDVENTE
         LEFT JOIN PRODUIT p ON p.ID = vd.IDPRODUIT;

create or replace view VENTEMONTANT as
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
    CAST(SUM(vd.PUREVIENT * vd.QTE) AS NUMBER(20,2)) AS montantRevient
--     v.IDRESERVATION
FROM
    VENTE_DETAILS vd
        LEFT JOIN
    VENTE v ON v.ID = vd.IDVENTE
GROUP BY
    v.ID, vd.IDDEVISE;

create or replace view VENTE_CPL as
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
       cast(V2.MONTANTTVA as number(30,2)) as MONTANTTVA,
       cast(V2.MONTANTTTC as number(30,2)) as montantttc,
       cast(V2.MONTANTTTCAR as number(30,2)) as MONTANTTTCAR,
       cast(nvl(mv.credit,0)-nvl(ACG.MONTANTPAYE, 0) AS NUMBER(30,2)) AS montantpaye,
       cast(V2.MONTANTTTC-nvl(mv.credit,0)-nvl(ACG.resteapayer_avr, 0) AS NUMBER(30,2)) AS montantreste,
       nvl(ACG.MONTANTTTC_avr, 0)  as avoir,
       v2.tauxDeChange AS tauxDeChange,v2.MONTANTREVIENT,cast((V2.MONTANTTTCAR-v2.MONTANTREVIENT) as number(20,2))  as margeBrute,
       v.IDRESERVATION,
       v.IDORIGINE,
       v.ECHEANCE,
       v.REGLEMENT,
       v.REFERENCE,
       v.REFERENCEBC
FROM VENTE v
         LEFT JOIN CLIENT c ON c.ID = v.IDCLIENT
         LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID
         LEFT JOIN mouvementcaisseGroupeFacture mv ON v.id=mv.IDORIGINE
         LEFT JOIN AVOIRFCLIB_CPL_GRP ACG on ACG.IDVENTE = v.ID;

create or replace view UPDATEVENTEDETAILS as
SELECT
    vd.ID,
    vd.IDVENTE,
    vd.IDPRODUIT,
    p.VAL AS idProduitLib,
    vd.IDORIGINE,
    vd.QTE,
    vd.PU,
    vd.REMISE,
    vd.TVA,
    vd.PUACHAT,
    vd.PUVENTE,
    vd.IDDEVISE,
    vd.TAUXDECHANGE,
    vd.DESIGNATION,
    vd.COMPTE,
    vd.REFERENCE,
    CAST(''as VARCHAR2(255)) uniteRemise
FROM
    VENTE_DETAILS vd
        LEFT JOIN PRODUIT p ON
        p.ID = vd.IDPRODUIT;

create table MODEREMISE(
    ID    VARCHAR2(255) not null
        constraint MODEREMISE_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

INSERT INTO MODEREMISE (ID, VAL, DESCE) VALUES ('1','%','%');
INSERT INTO MODEREMISE (ID, VAL, DESCE) VALUES ('2','-','-');

create or replace view VENTE_DETAILS_SAISIE as
SELECT
    id,
    IDVENTE ,
    IDPRODUIT ,
    DESIGNATION ,
    IDORIGINE ,
    qte,
    pu,
    REMISE ,
    TVA ,
    PUACHAT ,
    PUVENTE ,
    IDDEVISE ,
    TAUXDECHANGE ,
    compte,
    vd.REFERENCE,
    CAST(''as VARCHAR2(255)) uniteRemise
FROM VENTE_DETAILS vd;

create or replace view INSERTIONPROFORMAT as
    SELECT
        p.*,
        CAST(''as VARCHAR2(255)) idSupport
    FROM PROFORMA p;


create or replace view RESERVATIONDETAILSGROUPE as
SELECT
    CAST(NULL AS VARCHAR2(255)) AS idmere,
    CAST(NULL AS VARCHAR2(255)) AS idproduit,
    CAST(NULL AS VARCHAR2(255)) AS idmedia,
    CAST(NULL AS VARCHAR2(255)) AS heure,
    CAST(NULL AS VARCHAR2(255)) AS remarque,
    CAST(NULL AS VARCHAR2(255)) AS source,
    CAST(NULL AS INTEGER) AS duree,
    CAST(NULL AS NUMBER) AS pu,
    CAST(NULL AS DATE) AS datedebut,
    CAST(NULL AS DATE) AS datefin,
    CAST(NULL AS VARCHAR2(255)) AS datediffusion,
    CAST(NULL AS VARCHAR2(255)) AS dateinvalide,
    CAST(NULL AS INTEGER) AS isEntete,
    CAST(NULL AS VARCHAR2(255)) AS ordre,
    CAST(NULL AS INTEGER) AS nbspot
FROM dual
WHERE 1 = 0;

create table ORDREDIFFUSION
(
    ID    VARCHAR2(255) not null
        constraint ORDREDIFFUSION_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

INSERT INTO ORDREDIFFUSION (ID, VAL, DESCE) VALUES ('1','0','Aucun');
INSERT INTO ORDREDIFFUSION (ID, VAL, DESCE) VALUES ('2','1','T&ecirc;te d''&eacute;cran');
INSERT INTO ORDREDIFFUSION (ID, VAL, DESCE) VALUES ('3','-1','Fin d''&eacute;cran');

ALTER TABLE PLATEAU ADD
    dateReserver DATE;

create or replace view PLATEAU_CPL as
SELECT
    p."ID",p."IDCLIENT",p."IDEMISSION",p."REMARQUE",p."ETAT",p."MONTANT",p."DATY",p."HEURE",p."IDRESERVATION",p."SOURCE",p.DATERESERVER,
    CASE
        WHEN p.ETAT = 1 THEN 'CREE'
        WHEN p.ETAT = 11 THEN 'VISEE'
        WHEN p.ETAT = 0 THEN 'ANNULEE'
        END
          AS ETATLIB,
    c.NOM AS idClientLib,
    e.NOM AS idEmissionLib
FROM PLATEAU p
         LEFT JOIN CLIENT c ON p.IDCLIENT = c.ID
         LEFT JOIN EMISSION e ON p.IDEMISSION = e.ID;
