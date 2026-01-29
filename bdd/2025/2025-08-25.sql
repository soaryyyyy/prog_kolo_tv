create or replace view RESERVATIONDETAILS_DIFFUSION as
SELECT
    r."ID",r."IDMERE",r."QTE",r."DATY",r."IDPRODUIT",r."IDMEDIA",r."SOURCE",r."REMARQUE",r."LIBELLEPRODUIT",r."CATEGORIEPRODUIT",r."PU",r."MONTANT",r."TVA",r."MONTANTTVA",r."MONTANTTTC",r."CATEGORIEPRODUITLIB",r."HEURE",r."DUREE",r."REMISE",r."IDBCFILLE",r."MONTANTREMISE",r."MONTANTFINAL",r."IDPARRAINAGE",r."LIBELLEMEDIA",r."CODECOULEUR",r."ISENTETE",r."ORDRE",r."ETAT",
    a.ID as IDDIFFUSION,
    a.HEURE as HEUREDIFFUSION,
    a.DUREE as DUREEDIFFUSION,
    a.ETATLIB,
    a.idmedialib,
    rmere.IDSUPPORT,
    s.VAL AS IDSUPPORTLIB,
    rmere.ETAT as ETATMERE,
    c.NOM AS client,
    CASE
        WHEN a.id IS null THEN 'Non diffus&eacute;'
        ELSE 'Diffus&eacute;'
        END AS etatdiffusion
FROM RESERVATIONDETAILS_LIB r
         LEFT JOIN ACTE_LIB a ON a.IDRESERVATIONFILLE = r.ID
         LEFT JOIN RESERVATION rmere ON rmere.ID = r.IDMERE
         LEFT JOIN CLIENT c ON c.id=rmere.IDCLIENT
         LEFT JOIN SUPPORT s ON s.ID = rmere.IDSUPPORT
WHERE rmere.ETAT >=11 ORDER BY r.HEURE ASC;

create or replace view RESERVATIONDETAILS_SANSETAT as
SELECT
    r."ID",r."IDMERE",r."QTE",r."DATY",r."IDPRODUIT",r."IDMEDIA",r."SOURCE",r."REMARQUE",r."LIBELLEPRODUIT",r."CATEGORIEPRODUIT",r."PU",r."MONTANT",r."TVA",r."MONTANTTVA",r."MONTANTTTC",r."CATEGORIEPRODUITLIB",r."HEURE",r."DUREE",r."REMISE",r."IDBCFILLE",r."MONTANTREMISE",r."MONTANTFINAL",r."IDPARRAINAGE",r."LIBELLEMEDIA",r."CODECOULEUR",r."ISENTETE",r."ORDRE",r."ETAT",
    a.ID as IDDIFFUSION,
    a.HEURE as HEUREDIFFUSION,
    a.DUREE as DUREEDIFFUSION,
    a.ETATLIB,
    a.idmedialib,
    rmere.IDSUPPORT,
    s.VAL AS IDSUPPORTLIB,
    rmere.ETAT as ETATMERE,
    c.NOM AS client,
    CASE
        WHEN a.id IS null THEN 'Non diffus&eacute;'
        ELSE 'Diffus&eacute;'
        END AS etatdiffusion
FROM RESERVATIONDETAILS_LIB r
         LEFT JOIN ACTE_LIB a ON a.IDRESERVATIONFILLE = r.ID
         LEFT JOIN RESERVATION rmere ON rmere.ID = r.IDMERE
         LEFT JOIN CLIENT c ON c.id=rmere.IDCLIENT
         LEFT JOIN SUPPORT s ON s.ID = rmere.IDSUPPORT ORDER BY r.HEURE ASC;


create or replace view BC_CLIENT_FILLE_CPL_LIB2 as
SELECT
    bcf.ID,
    bcf.PRODUIT,
    bcf.IDBC,
    bcf.QUANTITE,
    bcf.PU,
    bcf.MONTANT,
    bcf.TVA,
    bcf.REMISE,
    bcf.IDDEVISE,
    bcf.UNITE,
    i.LIBELLE AS PRODUITlib,
    i.COMPTE_VENTE AS Compte,
    bcf.REMARQUE,
    bcf.PU*bcf.QUANTITE as MontantHt,
    (bcf.PU*bcf.QUANTITE)*(bcf.TVA/100) as MontantTva,
    ((bcf.PU*bcf.QUANTITE)*(bcf.TVA/100))+((bcf.PU*bcf.QUANTITE)) as MontantTtc
FROM
    bondecommande_client_fille bcf
        JOIN as_ingredients i ON
        i.id = bcf.PRODUIT;




create view RESERVATIONLIB_ETAT_FACTURE as
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
    CASE
        WHEN r.ID in (SELECT IDORIGINE FROM VENTE v WHERE v.ETAT = 11) OR r.IDBC in (SELECT IDORIGINE FROM VENTE v WHERE v.ETAT = 11)
            THEN 'Factur&eacute;e'
        ELSE 'Non factur&eacute;e'
        END AS etatFacturationLib,
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

create view BONDECOMMANDE_ETAT_GLOBAL as
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
        WHEN bc.ETAT = 0 THEN '<span style=color: green;>ANNULEE</span>'
        WHEN bc.ETAT = 1 THEN '<span style=color: green;>CREE</span>'
        WHEN bc.ETAT = 11 THEN '<span style=color: green;>VALIDEE</span>'
        END AS ETATLIB,
    CASE
        WHEN bc.ID in (SELECT IDORIGINE FROM VENTE v WHERE v.ETAT = 11)
            THEN 1
        ELSE 0
        END AS etatFacturation,
    CASE
        WHEN bc.ID in (SELECT IDORIGINE FROM VENTE v WHERE v.ETAT = 11)
            THEN 'Factur&eacute;e'
        ELSE 'Non factur&eacute;e'
        END AS etatFacturationLib,
    CASE
        WHEN bc.ID in (SELECT IDBC FROM RESERVATION r WHERE r.ETAT = 11)
            THEN 1
        ELSE 0
        END AS etatPlannification
FROM BONDECOMMANDE_CLIENT bc
         LEFT JOIN CLIENT c ON c.id = bc.IDCLIENT
         LEFT JOIN MODEPAIEMENT m ON m.id = bc.MODEPAIEMENT
         LEFT JOIN MAGASIN m2 ON m2.id = bc.IDMAGASIN;

