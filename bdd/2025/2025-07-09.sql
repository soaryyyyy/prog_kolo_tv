ALTER TABLE PARRAINAGEEMISSION
    ADD SOURCE VARCHAR2(255);
ALTER TABLE PLATEAU
    ADD SOURCE VARCHAR2(255);


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
       pe.SOURCE
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

create view RESERVATION_LIB as
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

insert into AS_INGREDIENTS (ID, LIBELLE, SEUIL, UNITE, QUANTITEPARPACK, PU, ACTIF, PHOTO, CALORIE, DURRE, COMPOSE, CATEGORIEINGREDIENT, IDFOURNISSEUR, DATY, QTELIMITE, PV, LIBELLEVENTE, SEUILMIN, SEUILMAX, PUACHATUSD, PUACHATEURO, PUACHATAUTREDEVISE, PUVENTEUSD, PUVENTEEURO, PUVENTEAUTREDEVISE, ISVENTE, ISACHAT, COMPTE_VENTE, COMPTE_ACHAT, LIBELLEEXTACTE, TVA, PU1, PU2, PU3, PU4, PU5, IDSUPPORT, DUREE,DUREEMAX)
values ('INGDKLT00081', 'Plateau', 100.00, 'UNT003', 1.00, 200000.00, 0, null, 0.00, null, 0, 'CATING000042', null, DATE '2025-06-16', 0.00, 200000.00, null, null, null, null, null, null, null, null, null, 1, 0, '710010', '610010', 'Service plateau', 20.00, 200000.00, 200000.00, 200000.00, 200000.00, 200000.00, 'SUPP002', 1,2);

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN0018040015','Saisie Reservation Multiple','fa fa-plus','module.jsp?but=reservation/reservation-saisie-multiple-ameliorer.jsp',7,2,'ELM001104004');
