INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDNAN001', 'Proforma', 'fa fa-book', NULL, 0, 3, 'MNDN000000001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDNAN002', 'Création', 'fa fa-plus', 'module.jsp?but=vente/proforma/proforma-saisie.jsp', 1, 4, 'MNDNAN001');

INSERT INTO MENUDYNAMIQUE
(ID, LIBELLE, ICONE, HREF, RANG, NIVEAU, ID_PERE)
VALUES('MNDNAN003', 'Liste', 'fa fa-list', 'module.jsp?but=vente/proforma/proforma-liste.jsp', 2, 4, 'MNDNAN001');