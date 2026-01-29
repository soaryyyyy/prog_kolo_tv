create or replace view MOUVEMENTCAISSE_VISE as
select "ID",
       "DESIGNATION",
       "IDCAISSE",
       "IDVENTEDETAIL",
       "IDVIREMENT",
       "DEBIT",
       "CREDIT",
       "DATY",
       "ETAT",
       "IDOP",
       "IDORIGINE",
       IDDEVISE
from MOUVEMENTCAISSE
WHERE ETAT = 11;
