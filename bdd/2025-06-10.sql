ALTER TABLE RESERVATIONDETAILS
    ADD idmedia VARCHAR(55) DEFAULT NULL;

alter table RESERVATIONDETAILS
    add constraint MEDIA_FK
        foreign key (idmedia) references MEDIA (id);

ALTER TABLE RESERVATIONDETAILS
    ADD source VARCHAR(255);


ALTER TABLE MEDIA
    ADD description VARCHAR(255);

alter table MEDIA
    drop constraint MEDIA_TYPE_FK;

alter table MEDIA
    add constraint CATEGORIE_INGREDIENT_FK
        foreign key (IDTYPEMEDIA) references CATEGORIEINGREDIENT (ID) ;

create or replace view MEDIA_CPL as
SELECT
    m."ID",m."DUREE",m."IDTYPEMEDIA",m."IDCLIENT",
    t.val AS IDTYPEMEDIALIB,
    c.NOM AS IDCLIENTLIB
FROM MEDIA m
         LEFT JOIN CATEGORIEINGREDIENT t ON t.id = m.idtypemedia
         LEFT JOIN CLIENT c ON c.id = m.idclient;


create or replace view RESERVATIONDETAILS_DIFFUSION as
SELECT
    r."ID",r."IDMERE",r."QTE",r."DATY",r."IDPRODUIT",r."LIBELLEPRODUIT",r."CATEGORIEPRODUIT",r."PU",r."MONTANT",r."TVA",r."MONTANTTVA",r."MONTANTTTC",r."CATEGORIEPRODUITLIB",r."HEURE",r."DUREE",r."REMISE",r."IDBCFILLE",r."MONTANTREMISE",r."MONTANTFINAL",
    a.ID as IDDIFFUSION,
    a.ETAT,
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
        END AS etatdiffusion,
    r.parrain,
    i.CATEGORIEINGREDIENT as typeService
FROM RESERVATIONDETAILS_LIB r
         LEFT JOIN ACTE_LIB a ON a.IDRESERVATIONFILLE = r.ID
         LEFT JOIN RESERVATION rmere ON rmere.ID = r.IDMERE
         LEFT JOIN RESERVATION_LIB rl ON rl.id=rmere.id
         LEFT JOIN SUPPORT s ON s.ID = rmere.IDSUPPORT
         LEFT JOIN AS_INGREDIENTS i ON i.id = r.IDPRODUIT
WHERE rmere.ETAT >=11 ORDER BY r.HEURE ASC;

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
    p.IDCLIENTLIB AS parrain,
    m.DESCRIPTION AS libellemedia
FROM
    RESERVATIONDETAILS r
        LEFT JOIN AS_INGREDIENTS_LIB ai ON
        ai.id = r.IDPRODUIT
        LEFT JOIN PARRAINAGEEMISSION_CPL p ON r.IDPARRAINAGE =p.id
        LEFT JOIN MEDIA m ON m.id=r.IDMEDIA;

create or replace view RESERVATIONDETAILS_DIFFUSION as
SELECT
    r.*,
    a.ID as IDDIFFUSION,
    a.ETAT,
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

