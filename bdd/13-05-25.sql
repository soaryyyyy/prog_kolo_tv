-- id Menu Vente = MNDN000000001
-- creation = MNDN000000006
-- liste = = MNDN000000007

INSERT INTO menudynamique (id, libelle, icone, rang, niveau, ID_PERE)
VALUES ('MNDN000000100', 'Facture', 'fas fa-arrow-right', 1, 2, 'MNDN000000001');

UPDATE menudynamique set niveau = 3 , id_pere = 'MNDN000000100' where id = 'MNDN000000006';
UPDATE menudynamique set niveau = 3 , id_pere = 'MNDN000000100' where id = 'MNDN000000007';

INSERT INTO menudynamique (id, libelle, icone, rang, niveau, ID_PERE)
VALUES ('MNDN000000101', 'Bon de Commande', 'fas fa-arrow-right', 2, 2, 'MNDN000000001');

INSERT INTO menudynamique (id, libelle, icone, rang, niveau, ID_PERE, href)
VALUES ('MNDN000000102', 'Creation', 'fas fa-arrow-right', 1, 3, 'MNDN000000101', 'module.jsp?but=vente/bondecommande/bondecommande-saisie.jsp');

INSERT INTO menudynamique (id, libelle, icone, rang, niveau, ID_PERE, href)
VALUES ('MNDN000000103', 'Liste', 'fas fa-arrow-right', 2, 3, 'MNDN000000101', 'module.jsp?but=vente/bondecommande/bondecommande-liste.jsp');