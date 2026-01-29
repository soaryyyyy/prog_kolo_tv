create table PARRAINAGEEMISSIONDETAILS
(
    ID           VARCHAR2(100) not null,
    IDMERE       VARCHAR2(100),
    IDPRODUIT    VARCHAR2(255),
    REMARQUE     VARCHAR2(255),
    ETAT         NUMBER       default 1,
    IDMEDIA      VARCHAR2(55) default NULL,
    AVANT  int default 0,
    APRES  int default 0,
    PENDANT  int default 0
);

alter table PARRAINAGEEMISSIONDETAILS
    add constraint PARRAINAGEEMISSIONDETAILS_PK
        primary key (ID);
alter table PARRAINAGEEMISSIONDETAILS
    add constraint PARRAINAGEDETAILS_PRODUIT_FK
        foreign key (IDPRODUIT) references AS_INGREDIENTS (id);
alter table PARRAINAGEEMISSIONDETAILS
    add constraint PARRAINAGEDETAILS_MEDIA_FK
        foreign key (idmedia) references MEDIA (id);
alter table PARRAINAGEEMISSIONDETAILS
    add constraint PARRAINAGE_MEREFILLE_FK
        foreign key (IDMERE) references PARRAINAGEEMISSION (id);

CREATE SEQUENCE seqparrainageemissiondetails
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqparrainagedetails
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqparrainageemissiondetails.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;

ALTER TABLE PARRAINAGEEMISSION
    ADD qteAvant INTEGER
    ADD qtePendant INTEGER
    ADD qteApres INTEGER;

ALTER TABLE PARRAINAGEEMISSION
    ADD dureeAvant INTEGER
    ADD dureePendant INTEGER
    ADD dureeApres INTEGER;

ALTER TABLE PARRAINAGEEMISSION
    ADD idreservation VARCHAR2(55);

ALTER TABLE EMISSION
    ADD idGenre VARCHAR2(55);

create table EMISSIONDETAILS (
    ID           VARCHAR2(100) not null,
    IDMERE       VARCHAR2(100),
    JOUR    VARCHAR2(255),
    HEUREDEBUT     VARCHAR2(255),
    HEUREFIN     VARCHAR2(255)
);

CREATE SEQUENCE seqemissiondetails
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqemissiondetails
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqemissiondetails.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;

alter table EMISSIONDETAILS
    add constraint EMISSION_MEREFILLE_FK
        foreign key (IDMERE) references EMISSION (id);

create table TYPEEMISSION
(
    ID    VARCHAR2(255) not null
        constraint TYPEEMISSION_PK
            primary key,
    VAL   VARCHAR2(255),
    DESCE VARCHAR2(255)
);

CREATE SEQUENCE seqtypeemission
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqtypeemission
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqtypeemission.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;

alter table EMISSION
    add constraint GENREEMISSION_FK
        foreign key (idgenre) references TYPEEMISSION (id);

alter table EMISSION
    drop column HEUREDEBUT;

create or replace view EMISSION_LIB AS
    SELECT
        e.*,
        te.VAL as idGenreLib,
        s.VAL as idSupportLib
    FROM EMISSION e
    LEFT JOIN TYPEEMISSION te ON te.ID = e.IDGENRE
    LEFT JOIN SUPPORT s ON s.ID = e.IDSUPPORT;

create or replace view MEDIA_CPL as
SELECT
    m.*,
    t.val AS IDTYPEMEDIALIB,
    c.NOM AS IDCLIENTLIB
FROM MEDIA m
         LEFT JOIN CATEGORIEINGREDIENT t ON t.id = m.idtypemedia
         LEFT JOIN CLIENT c ON c.id = m.idclient;

create or replace view PARRAINAGEEMISSIONDETAILS_LIB AS
SELECT
    pe.*,
    ai.LIBELLE as idProduitLib,
    m.DESCRIPTION as idMediaLib
FROM PARRAINAGEEMISSIONDETAILS pe
         LEFT JOIN AS_INGREDIENTS ai ON ai.ID = pe.IDPRODUIT
         LEFT JOIN MEDIA m ON m.ID = pe.IDMEDIA;

create table PLATEAU
(
    ID           VARCHAR2(100) not null
        constraint PLATEAU_PK
            primary key,
    IDCLIENT       VARCHAR2(100) constraint PLATEAUCLIENT_FK references CLIENT(ID),
    IDEMISSION    VARCHAR2(255) constraint PLATEAUEMISSION_FK references EMISSION(ID),
    REMARQUE     VARCHAR2(255),
    ETAT         NUMBER       default 1,
    MONTANT      NUMERIC(30,5) default 0,
    DATY  DATE,
    HEURE  VARCHAR2(55) default 0
);

ALTER TABLE PLATEAU
    ADD IDRESERVATION VARCHAR2(55) default null;


CREATE SEQUENCE seqplateau
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

create FUNCTION getseqplateau
    RETURN NUMBER
    IS
    retour   NUMBER;
BEGIN
    SELECT seqplateau.NEXTVAL INTO retour FROM DUAL;

    RETURN retour;
END;

CREATE OR REPLACE VIEW PLATEAU_CPL AS
    SELECT
        p.*,
        c.NOM AS idClientLib,
        e.NOM AS idEmissionLib
    FROM PLATEAU p
    LEFT JOIN CLIENT c ON p.IDCLIENT = c.ID
    LEFT JOIN EMISSION e ON p.IDEMISSION = e.ID;


insert into AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, PU1, PU2, PU3, PU4, PU5, IDSUPPORT, DUREE,DUREEMAX)
values ('INGDKLT00081', 'Plateau', 100.00, 'UNT003', 1.00, 200000.00, 0, null, 0.00, null, 0, 'CATING000043', null, DATE '2025-06-16', 0.00, 200000.00, null, null, null, null, null, null, null, null, null, 1, 0, '710010', '610010', 'Service plateau', 20.00, 200000.00, 200000.00, 200000.00, 200000.00, 200000.00, 'SUPP002', 1,2);

CREATE OR REPLACE VIEW EMISSIONDETAILS_LIB AS
    SELECT
        emd.*,
        e.NOM as libelleemission,
        e.IDSUPPORT,
        e.IDGENRE,
        e.idSupportLib,
        e.idGenreLib
    FROM EMISSIONDETAILS emd
    LEFT JOIN EMISSION_LIB e ON e.ID = emd.IDMERE;
