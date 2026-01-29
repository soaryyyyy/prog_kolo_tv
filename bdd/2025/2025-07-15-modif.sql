ALTER TABLE KOLOTV.AS_INGREDIENTS
    MODIFY DUREEMAX NUMBER;

ALTER TABLE PARRAINAGEEMISSION
    ADD BILLIBOARDIN VARCHAR2(255) CONSTRAINT PARRAINAGEEMISSIONBIN_FK REFERENCES MEDIA(ID);
ALTER TABLE PARRAINAGEEMISSION
    ADD BILLIBOARDOUT VARCHAR2(255) CONSTRAINT PARRAINAGEEMISSIONBOUT_FK REFERENCES MEDIA(ID);

create or replace view PARRAINAGEEMISSION_CPL as
SELECT pe.id,pe.idclient,
       pe.idemission,pe.datedebut,pe.datefin,
       c.NOM AS idclientlib,em.nom AS idemissionlib,
       pe.remise,pe.montant,pe.qte,pe.etat,
       CASE
           WHEN pe.ETAT = 1 THEN 'CREE'
           WHEN pe.ETAT = 11 THEN 'VISEE'
           WHEN pe.ETAT = 0 THEN 'ANNULEE'
           END
             AS ETATLIB,
       pe.IDRESERVATION,
       pe.BILLIBOARDIN,
       pe.BILLIBOARDOUT,
       pe.SOURCE
FROM parrainageEmission PE
         LEFT JOIN CLIENT c ON c.id=pe.idclient
         LEFT JOIN EMISSION em ON em.id=pe.idemission;


create or replace view RESERVATIONDETAILS_LIB as
SELECT
    r.ID,
    r.IDMERE,
    r.QTE,
    r.DATY,
    r.IDPRODUIT,
    r.IDMEDIA,
    r.SOURCE,
    r.REMARQUE,
    ai.LIBELLE AS libelleproduit,
    ai.idCATEGORIEINGREDIENT AS categorieproduit,
    r.PU,
    r.QTE * r.PU AS montant,
    ai.tva AS tva,
    CAST(r.qte*r.pu*(nvl(ai.tva, 0)/ 100) AS NUMBER(20,2)) AS montantTva,
    CAST((r.QTE * r.PU)+(r.qte*r.pu*(nvl(ai.tva, 0)/ 100)) AS NUMBER(20,2)) AS montantttc,
    ai.CATEGORIEINGREDIENT AS categorieproduitlib,
    r.heure AS heure,
    r.duree,
    r.remise,
    r.idbcfille,
    CAST(nvl(r.REMISE, 0) AS NUMBER(20,2)) AS montantremise,
    CAST(((r.QTE * r.PU)+(r.qte*r.pu*(nvl(ai.tva, 0)/ 100))) - nvl(r.REMISE, 0) AS NUMBER(20,2)) AS montantfinal,
    r.IDPARRAINAGE,
    m.DESCRIPTION AS libellemedia,
    CASE
        WHEN r.IDPARRAINAGE IS NOT NULL AND cat_parrainage.CODECOULEUR is not null AND cat.VAL != 'Billboard' THEN cat_parrainage.CODECOULEUR
        ELSE cat.CODECOULEUR
        END AS CODECOULEUR,
    r.ISENTETE,
    r.ORDRE,
    r.ETAT
FROM
    RESERVATIONDETAILS r
        LEFT JOIN AS_INGREDIENTS_LIB ai ON
        ai.id = r.IDPRODUIT
        LEFT JOIN MEDIA m ON m.id=r.IDMEDIA
        LEFT JOIN CATEGORIEINGREDIENT cat ON cat.ID = ai.IDCATEGORIEINGREDIENT
        LEFT JOIN (
        SELECT CODECOULEUR
        FROM CATEGORIEINGREDIENT
        WHERE VAL LIKE '%Parrainage%'
          AND ROWNUM = 1
        ) cat_parrainage ON 1 = 1;

ALTER TABLE BONDECOMMANDE_CLIENT_FILLE
    ADD REMARQUE VARCHAR2(255);

create or replace view AS_INGREDIENTS_LIB as
SELECT ing.id,
       ing.LIBELLE,
       ing.SEUIL,
       au.VAL AS unite,
       ing.QUANTITEPARPACK,
       ing.pu,
       ing.ACTIF,
       ing.PHOTO,
       ing.CALORIE,
       ing.DURRE,
       ing.COMPOSE,
       cating.id AS IDCATEGORIEINGREDIENT ,
       catIng.VAL AS CATEGORIEINGREDIENT,
       ing.CATEGORIEINGREDIENT AS idcategorie,
       ing.idfournisseur,
       ing.daty,
       catIng.desce as bienOuServ,
       CASE WHEN ing.id IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'INDISPONIBLE'
            WHEN ing.id NOT IN (SELECT idproduit FROM INDISPONIBILITE i )
                THEN 'DISPONIBLE'
           END AS etatlib,
       ing.COMPTE_VENTE,
       ing.COMPTE_ACHAT,
       ing.pv,
       ing.tva,
       ing.IDSUPPORT,
       sup.IDPOINT,
       sup.VAL AS IDSUPPORTLIB
FROM as_ingredients ing
         JOIN AS_UNITE AU ON ing.UNITE = AU.ID
         JOIN CATEGORIEINGREDIENTLIB catIng
              ON catIng.id = ing.CATEGORIEINGREDIENT
         JOIN SUPPORT sup ON sup.id =ing.IDSUPPORT;

create or replace view BC_CLIENT_FILLE_CPL_LIB as
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
    bcf.REMARQUE
FROM
    bondecommande_client_fille bcf
        JOIN as_ingredients i ON
        i.id = bcf.PRODUIT;

DELETE FROM REPORTCAISSE r WHERE 1=1;
DELETE FROM MVTCAISSEPREVISION WHERE 1=1;
DELETE FROM PREVISION WHERE 1=1;
DELETE FROM ENCAISSEMENT WHERE 1=1;
DELETE FROM MOUVEMENTCAISSE WHERE 1=1;
DELETE FROM CAISSE WHERE 1=1;

ALTER TABLE CATEGORIEINGREDIENT
    ADD RANG INTEGER DEFAULT 0;

ALTER TABLE RESERVATIONDETAILS
    ADD ISENTETE INTEGER DEFAULT 0;

create or replace view RESERVATIONDETAILS_DIFFUSION as
SELECT
    r.*,
    a.ID as IDDIFFUSION,
    a.HEURE as HEUREDIFFUSION,
    a.DUREE as DUREEDIFFUSION,
    a.ETATLIB,
    a.idmedialib,
    rmere.IDSUPPORT,
    s.VAL AS IDSUPPORTLIB,
    rmere.ETAT as ETATMERE,
    rl.IDCLIENTLIB AS client,
    CASE
        WHEN a.id IS null THEN 'Non diffus&eacute;'
        ELSE 'Diffus&eacute;'
        END AS etatdiffusion
FROM RESERVATIONDETAILS_LIB r
         LEFT JOIN ACTE_LIB a ON a.IDRESERVATIONFILLE = r.ID
         LEFT JOIN RESERVATION rmere ON rmere.ID = r.IDMERE
         LEFT JOIN RESERVATION_LIB rl ON rl.id=rmere.id
         LEFT JOIN SUPPORT s ON s.ID = rmere.IDSUPPORT
WHERE rmere.ETAT >=11 ORDER BY r.HEURE ASC;

ALTER TABLE BONDECOMMANDE_CLIENT_FILLE
    ADD REMARQUE VARCHAR2(255);

create or replace view BC_CLIENT_FILLE_CPL_LIB as
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
    bcf.REMARQUE
FROM
    bondecommande_client_fille bcf
        JOIN as_ingredients i ON
        i.id = bcf.PRODUIT;


create FUNCTION getseqnotification
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT SEQ_NOTIFICATION.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;

ALTER TABLE RESERVATIONDETAILS
    ADD ORDRE INTEGER DEFAULT 0;
