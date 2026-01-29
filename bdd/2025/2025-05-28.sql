ALTER TABLE EMISSIONDETAILS
    ADD HEUREDEBUTCOUPURE VARCHAR2(30);
ALTER TABLE EMISSIONDETAILS
    ADD HEUREFINCOUPURE VARCHAR2(30);
alter table EMISSIONDETAILS
    drop column COUPURE;

alter table EMISSION
    drop column COUPURE;

create or replace view EMISSIONDETAILS_LIB as
SELECT
    emd.*,
    e.NOM as libelleemission,
    e.IDSUPPORT,
    e.IDGENRE,
    e.idSupportLib,
    e.idGenreLib
FROM EMISSIONDETAILS emd
         LEFT JOIN EMISSION_LIB e ON e.ID = emd.IDMERE;

create or replace view EMISSION_LIB as
SELECT
    e.*,
    te.VAL as idGenreLib,
    s.VAL as idSupportLib
FROM EMISSION e
         LEFT JOIN TYPEEMISSION te ON te.ID = e.IDGENRE
         LEFT JOIN SUPPORT s ON s.ID = e.IDSUPPORT;

create or replace view PARRAINAGEEMISSION_CPL as
SELECT pe.*,
       c.NOM AS idclientlib,
       em.nom AS idemissionlib,
       CASE
           WHEN pe.ETAT = 1 THEN 'CREE'
           WHEN pe.ETAT = 11 THEN 'VISEE'
           WHEN pe.ETAT = 0 THEN 'ANNULEE'
           END
             AS ETATLIB
FROM parrainageEmission PE
         LEFT JOIN CLIENT c ON c.id=pe.idclient
         LEFT JOIN EMISSION em ON em.id=pe.idemission;

create or replace view PLATEAU_CPL as
SELECT
    p.*,
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
    cat.CODECOULEUR
FROM
    RESERVATIONDETAILS r
        LEFT JOIN AS_INGREDIENTS_LIB ai ON
        ai.id = r.IDPRODUIT
        LEFT JOIN MEDIA m ON m.id=r.IDMEDIA
        LEFT JOIN CATEGORIEINGREDIENT cat ON cat.ID = ai.IDCATEGORIEINGREDIENT;

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN0018040011','Utilisateur','fa fa-users','',3,2,'MNDT1505001340021');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN0018040012','Création','fa fa-plus','module.jsp?but=utilisateur/utilisateur-saisie.jsp',1,3,'MNDN0018040011');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN0018040013','Liste','fa fa-list','module.jsp?but=utilisateur/utilisateur-liste.jsp',2,3,'MNDN0018040011');

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN0018040014','Grille de diffusion','fa fa-calendar','module.jsp?but=reservation/planning-diffuseur.jsp',4,2,'MENUDYN02105001');

INSERT INTO USERMENU (ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT) VALUES
   ('USRMEN041',NULL,'MNDN0018040014','dg',NULL,NULL,1);

INSERT INTO USERMENU (ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT) VALUES
    ('USRMEN042',NULL,'MNDN0018040014','front',NULL,NULL,1);

INSERT INTO USERMENU (ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT) VALUES
    ('USRMEN043',NULL,'MNDN0018040014','gestionnaire',NULL,NULL,1);

INSERT INTO USERMENU (ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT) VALUES
    ('USRMEN044',NULL,'MNDN0018040014','caisse',NULL,NULL,1);

INSERT INTO USERMENU (ID, REFUSER, IDMENU, IDROLE, CODESERVICE, CODEDIR, INTERDIT) VALUES
    ('USRMEN045',NULL,'ELMD001104005','diffuseur',NULL,NULL,1);
