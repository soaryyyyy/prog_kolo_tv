ALTER TABLE VENTE ADD
    REFERENCE VARCHAR2(255);
ALTER TABLE VENTE ADD
    REFERENCEBC VARCHAR2(255);
ALTER TABLE VENTE_DETAILS ADD
    REFERENCE VARCHAR2(255);

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
    vd.REFERENCE
FROM
    VENTE_DETAILS vd
        LEFT JOIN PRODUIT p ON
        p.ID = vd.IDPRODUIT;

create or replace view UPDATEVENTE as
SELECT
    v.ID,
    v.REFERENCE,
    v.DESIGNATION,
    v.IDMAGASIN,
    v.DATY,
    v.REMARQUE,
    v.ETAT,
    v.IDORIGINE,
    v.IDCLIENT,
    c.NOM AS idClientLib,
    v2.IDDEVISE,
    v.IDRESERVATION,
    v.ECHEANCE,
    v.REGLEMENT,
    v.REFERENCEBC,
    CAST('' AS varchar(100)) AS idSupport
FROM VENTE v
         JOIN CLIENT c ON c.ID = v.IDCLIENT
         JOIN VENTEMONTANT v2 ON v2.ID = v.ID;

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
    vd.REFERENCE
FROM VENTE_DETAILS vd;

create or replace view INSERTION_VENTE as
SELECT
    v.ID,
    v.REFERENCE,
    v.DESIGNATION,
    v.IDMAGASIN,
    v.DATY,
    v.REMARQUE,
    v.ETAT,
    v.IDORIGINE,
    v.IDCLIENT,
    CAST(' ' AS varchar(100)) AS iddevise,
    v.ESTPREVU,
    v.DATYPREVU,
    v.IDRESERVATION,
    v.tva,
    v.ECHEANCE,
    v.REGLEMENT,
    v.REFERENCEBC,
    CAST('' AS varchar(100)) AS idSupport
FROM VENTE v;

create or replace view ST_INGREDIENTSAUTOVENTE as
SELECT
    ai."ID",ai."LIBELLE",ai."SEUIL",ai."UNITE",ai."QUANTITEPARPACK",ai."PU",ai."ACTIF",ai."PHOTO",ai."CALORIE",ai."DURRE",ai."COMPOSE",ai."CATEGORIEINGREDIENT",ai."IDFOURNISSEUR",ai."DATY",ai."QTELIMITE",ai."PV",ai."LIBELLEVENTE",ai."SEUILMIN",ai."SEUILMAX",ai."PUACHATUSD",ai."PUACHATEURO",ai."PUACHATAUTREDEVISE",ai."PUVENTEUSD",ai."PUVENTEEURO",ai."PUVENTEAUTREDEVISE",ai."ISVENTE",ai."ISACHAT",ai."COMPTE_VENTE",ai."COMPTE_ACHAT", ai.TVA,
    ai.COMPTE_VENTE AS compte,
    ai.IDSUPPORT
FROM AS_INGREDIENTS ai where ai.pv>0;

create or replace view BC_CLIENT_FORM as
SELECT
    bc.*,
    CAST('' as VARCHAR2(255)) as idSupport
FROM BONDECOMMANDE_CLIENT bc;
