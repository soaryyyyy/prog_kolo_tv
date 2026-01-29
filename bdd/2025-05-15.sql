create or replace view ACTE_LIB as
SELECT
    a.ID,
    a.DATY,
    a.IDPRODUIT,
    ai.LIBELLE AS libelleproduit,
    a.QTE,
    a.PU,
    a.PU * a.QTE AS montant,
    nvl(a.LIBELLE,ai.LIBELLE) as libelle,
    a.IDCLIENT,
    c.NOM AS idclientlib,
    a.IDRESERVATION,
    a.ETAT,
    CASE
        WHEN a.ETAT = 0
            THEN 'ANNULEE'
        WHEN a.ETAT = 1
            THEN 'CREE'
        WHEN a.ETAT = 11
            THEN 'VISEE'
        END AS ETATLIB,
    ai.COMPTE_VENTE,
    ai.COMPTE_ACHAT,
    a.IDPRODUIT as IDCHAMBRE,
    ai.LIBELLE as chambre,
    cc.CHECKOUT,
    a.TVA,
    m.IDTYPEMEDIALIB || ' ' || m.DUREE as idmedialib,
    s.VAL as idsupportlib,
    a.IDRESERVATIONFILLE,
    a.HEURE,
    a.DUREE
FROM ACTE a
         LEFT JOIN AS_INGREDIENTS ai  ON ai.id = a.IDPRODUIT
         LEFT JOIN CLIENT c ON c.id = a.IDCLIENT
         left join CHECKINAVECCHEKOUT cc on cc.id=a.IDRESERVATION
         LEFT JOIN MEDIA_CPL m on m.ID = a.IDMEDIA
         LEFT JOIN SUPPORT s on s.ID = a.IDSUPPORT;

ALTER TABLE ACTE
    ADD IDRESERVATIONFILLE VARCHAR2(50)
    ADD heure VARCHAR2(50)
    ADD duree NUMBER;

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN0000023','Saisie Reservation Grouper','fa fa-plus','module.jsp?but=reservation/reservation-groupe-saisie.jsp',5,2,'ELM001104004');



CREATE OR REPLACE VIEW DISPONIBILITE_HEURE AS
SELECT
    dr.ID,
    dr.HEUREDEBUT,
    dr.HEUREFIN,
    dr.JOUR,
    dr.MAX,
    dr.IDCATEGORIEINGREDIENTLIB,
    dr.IDSUPPORT,
    dr.IDSUPPORTLIB,
    SUM(
            CASE
                WHEN
                    TO_DATE(a.HEURE, 'HH24:MI:SS') >= TO_DATE(dr.HEUREDEBUT, 'HH24:MI:SS')
                    AND TO_DATE(a.HEURE, 'HH24:MI:SS') <= TO_DATE(dr.HEUREFIN, 'HH24:MI:SS')
                THEN TO_NUMBER(a.DUREE)
                ELSE 0
            END
    ) AS duree_diffusion
FROM DUREEMAXSPOT_CPL dr
         LEFT JOIN ACTE a ON dr.IDSUPPORT = a.IDSUPPORT
GROUP BY
    dr.IDSUPPORTLIB,
    dr.HEUREDEBUT,
    dr.HEUREFIN,
    dr.JOUR,
    dr.MAX,
    dr.IDCATEGORIEINGREDIENTLIB,
    dr.IDSUPPORT,
    dr.ID;

CREATE OR REPLACE VIEW RESERVATIONDETAILS_DIFFUSION AS
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
    rmere.ETAT as ETATMERE
FROM RESERVATIONDETAILS_LIB r
    LEFT JOIN ACTE_LIB a ON a.IDRESERVATIONFILLE = r.ID
    LEFT JOIN RESERVATION rmere ON rmere.ID = r.IDMERE
    LEFT JOIN SUPPORT s ON s.ID = rmere.IDSUPPORT
    WHERE rmere.ETAT >= 11;

INSERT INTO MENUDYNAMIQUE (ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE) VALUES
    ('MNDN0000024','Planning','fa fa-calendar','module.jsp?but=duree/dureemaxspot-calendrier.jsp',3,3,'MNDT150500134008');

create or replace view PRODUIT_VENTE_LIB as
SELECT p.ID,
       p.LIBELLE as val,
       p.LIBELLE as DESCE,
       '-' as IDTYPEPRODUIT,
       '-' AS IDTYPEPRODUITLIB,
       p.PU as PUACHAT,
       p.pv as PUVENTE,
       p.UNITE as idunite,
       u.VAL  AS IDUNITELIB,
       p.CATEGORIEINGREDIENT as IDCATEGORIE,
       c.VAL  AS IDCATEGORIELIB,
       '-'  AS IDSOUSCATEGORIELIB,
       p.seuilmin,
       p.seuilmax,
       p.puAchatUsd,
       p.puAchatEuro,
       p.puAchatAutreDevise,
       p.puVenteUsd,
       p.puVenteEuro,
       p.puVenteAutreDevise,
       p.isvente,
       p.isachat,
       p.compte_vente,
       p.compte_achat,
       p.IDSUPPORT,
       (CASE
            WHEN
                p.DUREE is not null AND p.DUREE > 0
                THEN p.DUREE*p.pv
            ELSE 0
       END) AS montant,
        p.DUREE
FROM AS_INGREDIENTS p
         LEFT JOIN CATEGORIEINGREDIENT c ON c.ID = p.CATEGORIEINGREDIENT
         LEFT JOIN as_UNITE u ON u.ID = p.unite
WHERE p.isvente = 1  OR p.pv!=0;

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
    rmere.ETAT as ETATMERE
FROM RESERVATIONDETAILS_LIB r
         LEFT JOIN ACTE_LIB a ON a.IDRESERVATIONFILLE = r.ID
         LEFT JOIN RESERVATION rmere ON rmere.ID = r.IDMERE
         LEFT JOIN SUPPORT s ON s.ID = rmere.IDSUPPORT
WHERE rmere.ETAT >=11 ORDER BY r.HEURE ASC;

SELECT * FROM RESERVATIONDETAILS;

SELECT * FROM RESERVATIONDETAILS_LIB
WHERE DATY = TO_DATE('29/05/2025','DD/MM/YYYY')
AND TO_DATE(HEURE,'HH24:MI:SS') >= TO_DATE('14:30','HH24:MI:SS')
  AND TO_DATE(HEURE,'HH24:MI:SS') <= TO_DATE('16:16','HH24:MI:SS');

ALTER TABLE EMISSION
    ADD idSupport VARCHAR2(55);


