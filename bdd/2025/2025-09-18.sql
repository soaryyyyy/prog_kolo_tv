create or replace view BONDECOMMANDE_ETAT AS
SELECT
    bc.ID,
    bc.DATY,
    bc.ETAT,
    bc.REMARQUE,
    bc.DESIGNATION,
    bc.MODEPAIEMENT,
    m.VAL AS MODEPAIEMENTLIB,
    bc.IDCLIENT,
    c.NOM AS IDCLIENTLIB,
    bc.REFERENCE,
    m2.VAL AS IDMAGASINLIB,
    CASE
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNUL&Eacute;E</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CR&Eacute;E</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALID&Eacute;E</span>'
        END AS ETATLIB,
    CASE
        WHEN bc.ID in (SELECT IDORIGINE FROM VENTE v WHERE v.ETAT = 11)
            THEN 1
        ELSE 0
        END AS etatFacturation,
    CASE
        WHEN bc.ID in (SELECT IDBC FROM RESERVATION r WHERE r.ETAT = 11)
            THEN 1
        ELSE 0
        END AS etatPlannification
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN m2 ON m2.id = bc.IDMAGASIN;

create or replace view BONDECOMMANDE_ETAT_GLOBAL as
SELECT
    bc.*,
    CASE
        WHEN bc.ETATFACTURATION = 1 THEN 'Factur&eacute;e'
        WHEN bc.ETATFACTURATION = 0 THEN 'Non factur&eacute;e'
        END AS etatFacturationLib
FROM BONDECOMMANDE_ETAT bc;

CREATE OR REPLACE VIEW stat_horaire_reservation AS
SELECT
    CAST('' AS VARCHAR2(255)) AS id,
    CAST('' AS VARCHAR2(255)) AS idSupport,
    CAST('' AS VARCHAR2(255)) AS idTypeService,
    CAST('' AS DATE) AS daty,
    rd.HEURE,
    COUNT(rd.ID) as nbResa
FROM RESERVATIONDETAILS rd
         LEFT JOIN RESERVATION r ON r.ID = rd.IDMERE
         LEFT JOIN AS_INGREDIENTS ai ON ai.ID = rd.IDPRODUIT
        WHERE TO_DATE(rd.HEURE, 'HH24:MI')<=TO_DATE('15:00','HH24:MI')
group by rd.HEURE ORDER BY rd.HEURE ASC;

CREATE OR REPLACE VIEW emission_vente AS
SELECT
    e.NOM,
    e.IDSUPPORT,
    nvl(v.MONTANTTTC,0) as MONTANTTTC,
    nvl(v.MONTANTPAYE,0) as MONTANTPAYE,
    nvl(v.MONTANTRESTE,0) as MONTANTRESTE,
    v.DATY,
    nvl(v.IDDEVISE,'AR') as IDDEVISE
FROM EMISSION e
         LEFT JOIN PARRAINAGEEMISSION p ON e.ID = p.IDEMISSION
         LEFT JOIN PLATEAU pl ON e.ID = pl.IDEMISSION
         JOIN RESERVATION r ON pl.ID = r.SOURCE OR p.ID = r.SOURCE
         JOIN VENTE_CPL v ON v.IDORIGINE=r.ID;

CREATE OR REPLACE VIEW emission_activite AS
SELECT
    e.ID,
    e.NOM,
    e.IDSUPPORT,
    COUNT(CASE WHEN p.ID IS NOT NULL THEN 1 END) as nbParrainage,
    CAST(''AS DATE) as daty
FROM EMISSION e
    LEFT JOIN PARRAINAGEEMISSION p ON p.IDEMISSION = e.ID
group by e.ID, e.NOM, e.IDSUPPORT ORDER BY nbParrainage DESC;

create view RESERVATIONLIB_ETAT as
SELECT
    r.id,
    r.idClient,
    c.NOM AS idclientlib,
    r.daty,
    r.remarque,
    r.etat,
    CASE
        WHEN r.etat = 1
            THEN 'CREE'
        WHEN r.etat = 0
            THEN 'ANNULEE'
        WHEN r.etat = 11
            THEN 'VISEE'
        END AS etatlib,
    CASE
        WHEN r.ID in (SELECT IDORIGINE FROM VENTE v WHERE v.ETAT = 11) OR r.IDBC in (SELECT IDORIGINE FROM VENTE v WHERE v.ETAT = 11)
            THEN 1
        ELSE 0
        END AS etatFacturation,
    rm.montant,
    rm.MONTANTTTC,
    rm.MONTANTTVA,
    nvl(mvt.CREDIT,0) as paye,
    cast(rm.MONTANTTTC-nvl(mvt.CREDIT,0) as number(20,2)) as resteAPayer,
    r.idbc,
    sp.VAL AS IDSUPPORTLIB,
    rm.MONTANTREMISE,
    rm.MONTANTFINAL,
    r."SOURCE"
FROM RESERVATION r
         LEFT JOIN CLIENT c ON c.id = r.idClient
         LEFT JOIN reservationmontant rm ON rm.idmere = r.id
         left join MOUVEMENTCAISSEGROUPERESA mvt on mvt.IDORIGINE=r.ID
         LEFT JOIN SUPPORT sp on sp.ID = r.IDSUPPORT;


create or replace view RESERVATIONLIB_ETAT_FACTURE as
SELECT
    r.*,
    CASE
        WHEN r.ETATFACTURATION = 1 THEN 'Factur&eacute;e'
        WHEN r.ETATFACTURATION = 0 THEN 'Non factur&eacute;e'
        END AS etatFacturationLib
FROM RESERVATIONLIB_ETAT r;

create or replace view PARRAINAGEEMISSION_CPL as
SELECT
       pe.*,
       c.NOM AS idclientlib,em.nom AS idemissionlib,
       CASE
           WHEN pe.ETAT = 1 THEN 'CREE'
           WHEN pe.ETAT = 11 THEN 'VISEE'
           WHEN pe.ETAT = 0 THEN 'ANNULEE'
           END
             AS ETATLIB,
       m1.DESCRIPTION as billBoardInLib,
       m2.DESCRIPTION as billBoardOutLib
FROM parrainageEmission PE
         LEFT JOIN CLIENT c ON c.id=pe.idclient
         LEFT JOIN EMISSION em ON em.id=pe.idemission
        LEFT JOIN MEDIA m1 ON m1.ID = pe.BILLIBOARDIN
         LEFT JOIN MEDIA m2 ON m2.ID = pe.BILLIBOARDOUT;

create or replace view VENTE_DETAILS_CPL_2_VISEE as
SELECT vd.ID,
       vd.IDVENTE,
       v.DESIGNATION          AS IDVENTELIB,
       vd.IDPRODUIT ,
       i.LIBELLE                 AS IDPRODUITLIB,
       vd.IDORIGINE,
       vd.QTE,
       nvl(vd.PU, 0)          AS PU,

       CAST(nvl((vd.PU * vd.QTE)-nvl(vd.REMISE,0), 0) +nvl(((vd.PU * vd.QTE)-nvl(vd.REMISE,0)) * (vd.TVA/100), 0) AS number(30,2)) AS puTotal,
       CAST(nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puTotalAchat,
       CAST(nvl(vd.PU * vd.QTE, 0) - nvl(vd.PUACHAT * vd.QTE, 0) AS number(30,2)) AS puRevient,
       c.ID  AS IDCATEGORIE,
       c.VAL AS IDCATEGORIELIB,
       v.DATY AS daty,
       m.ID AS IDMAGASIN,
       m.VAL AS IDMAGASINLIB,
       p1.ID AS IDPOINT,
       p1.VAL AS IDPOINTLIB,
       vd.IDDEVISE,
       vd.IDDEVISE AS IDDEVISELIB,
       cast(nvl((CAST(nvl(vd.PU * vd.QTE*(1-nvl(vd.REMISE,0)/100), 0) +nvl(vd.PU * vd.QTE*(1-nvl(vd.REMISE,0)/100) *(vd.TVA/100), 0) AS number(30,2))-(vd.QTE*vd.PUREVIENT)),0) as number(20,2)) as margeBrute,
       v.IDRESERVATION,
       s.ID AS IDSUPPORT,
       s.VAL AS IDSUPPORTLIB
FROM VENTE_DETAILS vd
         LEFT JOIN VENTE v ON v.ID = vd.IDVENTE
         LEFT JOIN MAGASIN m ON m.ID = v.IDMAGASIN
         LEFT JOIN AS_INGREDIENTS i ON i.ID = vd.IDPRODUIT
         LEFT JOIN POINT p1 ON p1.ID = m.IDPOINT
         LEFT JOIN CATEGORIEINGREDIENT c  ON i.CATEGORIEINGREDIENT  = c.ID
         LEFT JOIN SUPPORT s ON s.ID = i.IDSUPPORT
WHERE v.ETAT >= 11;
