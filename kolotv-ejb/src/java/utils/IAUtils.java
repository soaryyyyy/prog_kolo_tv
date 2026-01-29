package utils;

import bean.Champ;
import bean.ListeColonneTable;
import chatbot.AiColDesc;
import chatbot.AiTabDesc;
import chatbot.ClassIA;
import chatbot.UtilChatbot;
import utilitaire.UtilDB;

import java.lang.reflect.Field;
import java.sql.Connection;
import java.util.Vector;

public class IAUtils {
    public static String queryType = "Tu es un assistant d'application pour aider l'utilisateur, Classifie ma question en fonction de leur objectif:\n" +
            "definitions de quelques acronymes que l'utilisateur pourra utiliser : BC (bon de commande), OF(ordre de fabrication), FAB (fabrication)  \n" +
            "'saisie' si l'utilisateur demande a saisir quelque chose, ou de creer ou ajouter quelque chose de nouveau, \n'prevision' seulement si la question parle de tresorerie prevu comme tresorerie la plus basse explicitement, pas de prevision recette ni prevision depense \n" +
            "'liste' si elle demande des des prevision de recette du mois,prevision de depenses du mois,fabrications, des produit ou chose specifique par exemple des chiffres d'affaires par produit ,des tendances des Ã©lÃ©ments les plus vendues,les moins achetes,les plus frÃ©quents, les plus rentables, ou toute autre donnÃ©e nÃ©cessitant une comparaison ou une interprÃ©tation,\n" +
            "'liste' si elle demande des disponibilite de chambre,une liste de quelque chose,si elle extrait des donnÃ©es gÃ©nÃ©rales comme des totaux, des montants ou des transactions, par exemple les chiffres d'affaires mais pas ceux par produit,\n" +
            "'liste' si elle demande a lister quelque chose explicitement, SEULEMENT SI la question explicitement commence par 'lister' ou 'donner' sinon 'liste' ,\n" +
            "'aucun' si aucun n'applique\n\nSi aucun n'applique, repond directement a la question\nTa reponse doit Ãªtre de cette forme (format JSON) et pas d'autre rÃ©ponse: \n{ \n    type: string, \n    iaResp: string, \n\n}\n### Ma question :";



    private static String getTables() throws Exception {
        return "    La structure de ma table de vente VENTE_DETAILS_CPL_2_VISEE est comme ceci : ID : string, IDVENTE : string, IDVENTELIB : string, IDPRODUIT : string, IDPRODUITLIB : string, IDORIGINE : string, QTE : decimal, PU : decimal, puTotal : decimal(30,2), puTotalAchat : decimal(30,2), puRevient : decimal(30,2), IDCATEGORIE : string, IDCATEGORIELIB : string, daty : date, IDMAGASIN : string, IDMAGASINLIB : string, IDPOINT : string, IDPOINTLIB : string, IDDEVISE : string, IDDEVISELIB.\n" +
                "La structure de ma table de prÃ©vision, si ma question inclu prevu ou n'importe qui parle de prevision, utilise cette table PREVISION_COMPLET_CPL est comme ceci : ID (string), DESIGNATION (string), IDCAISSE (string), IDCAISSELIB (string), IDVENTEDETAIL (string), IDVENTE (string), IDVENTELIB (string), IDVIREMENT (string), DEBIT (decimal), CREDIT (decimal), DATY (date), ETAT (string), IDOP (string), IDOPLIB (string), IDORIGINE (string), IDDEVISE (string), IDDEVISELIB (string), TAUX (decimal), IDTIERS (string), COMPTE (string), effectifDebit (decimal), effectifCredit (decimal), depenseEcart (decimal), recetteEcart (decimal), idfacture (string).    " +
                "La structure de ma table de RESERVATIONLIB_ETAT_FACTURE est comme ceci : ID : string, IDCLIENTLIB : string, DATY : date, REMARQUE : string, ETAT : int, ETATFACTURATION : int, IDSUPPORTLIB : string, MONTANT : double ." +
                "La table de RESERVATIONLIB_ETAT_FACTURE est utiliser pour stocker les reservation de tout les client. Dans ma table RESERVATIONLIB_ETAT_FACTURE la colonne 'ETATFACTURATION' represente l'etat de facturation de reservation , si la reservation est facturer l'etat de facturation est egal a 1 mais si la reservation n'est pas facturer alors l'etat de facturation est egal a 0 ; la colonne 'IDCLIENTLIB' represente le nom du client qui a reserver et la colonne 'IDSUPPORTLIB' represente le support de diffusion\n    " +
                "La structure de ma table de BONDECOMMANDE_ETAT_GLOBAL est comme ceci : ID : string, IDCLIENTLIB : string, DATY : date, DESIGNATION : string, ETAT : int, ETATFACTURATION : int, ETATPLANNIFICATION : int, IDMAGASINLIB : string." +
                "La table de BONDECOMMANDE_ETAT_GLOBAL est utiliser pour stocker les bons de commandes de tout les client. Dans ma table BONDECOMMANDE_ETAT_GLOBAL la colonne 'ETATFACTURATION' represente l'etat de facturation de bon de commande , si la bon de commande est facturer l'etat de facturation est egal a 1 mais si la bon de commande n'est pas facturer alors l'etat de facturation est egal a 0 ; la colonne 'IDCLIENTLIB' represente le nom du client qui a commander et la colonne 'ETATPLANNIFICATION' represente l'etat de plannification de bon de commande , si le bon de commande n'est pas encore plannifier alors l'etat de plannification est egal a 0 mais si le bon de commande est deja plannifier , l'etat de plannification est egal 1.\n    " +
                "Dans ma table de prÃ©vision, la colonne 'credit' represente la recette prevu et 'debit' le depense prevu.\n    " +
                "Utilise les id_lib si tu veux chercher les noms, par example noms de produits : idproduitlib, noms des magasins : idmagasinlib, etc etc.\n    " +
                "Tu ne peux pas utiliser d'autres colonnes que ce que je t'ai donner car je vais mapper la requete a un objet deja defini donc pas d'alias mais met dans les colonnes existant sauf ID la reponse des sommes, groupes, counts, etc    " +
                "Utilise LOWER si tu veut faire un condition LIKE sur une ou plusieur colonne. Pas de FETCH FIRST ROWS ONLY, tu ne peux en aucun cas l'utiliser\n    Base de donnee: Oracle 11g\n";
    }


    public static String queryLister;
    public static String queryDB;

    static {
        try {
            queryDB = "Tu dois gÃ©nÃ©rer des requÃªtes SQL pour Oracle 11g en respectant ces rÃ¨gles strictes :    Ta reponse doit Ãªtre de cette forme (format JSON) et pas d'autre rÃ©ponse, et une seule reponse\n{\n    type: liste,\n    nomTable: Nom de la table correcte,\n    date1: dd/MM/yyyy,\n    date2: dd/MM/yyyy,\n    requeteSql: RequÃªte SQL correcte\n    grouper : idproduitlib ou idpointlib \n    id : l'id specifique qu'on recherche  \n}    - les fabrications sont par dÃ©fauts 'analyse'    - type: Classifie mes requÃªtes SQL en fonction de leur objectif : 'liste' si la requÃªte extrait des donnÃ©es gÃ©nÃ©rales comme des totaux, des montants ou des transactions et n'implique aucun produit en particulier, et 'analyse' si elle implique une fabrication ou plusieurs fabrications, un produit ou point de vente specifique, si elle identifie des specificites par produits ou points de ventes comme depense ou CA par produit / points de vente, tendances, des Ã©lÃ©ments les plus frÃ©quents, les plus rentables, ou toute autre donnÃ©e nÃ©cessitant une comparaison ou une interprÃ©tation,'aucun' si aucun n'applique\n    - si le type correspond a 'liste' ou 'analyse' utilise les tables pour creer la requeteSql:'" + getTables() + "'    - nomTable correspond a la table que la requete devrait etre execute, si tu a besoin de faire une jointure, met un des tables et la reponse doit etre au format de cette table et utilise JOIN\n    - date1 et date2 sont les intervalle si il y a une intervalle de date sinon met la date d'aujourd'hui dans la requete. Une semaine commence par Lundi et se termine par Dimanche. N'utilises pas SYSDATE dans la requete\n    - requeteSql: la requete SQL correspondant a la requete sans ajouter de nouvelles colonnes ou alias qui n'existent pas dÃ©jÃ , les colonnes calculÃ©s doivent avoir comme alias des colonne existantes. La requÃªte doit uniquement utiliser les noms de colonnes existants et n'utilise pas FETCH FIRST ROWS ni LIMIT.\n    - grouper : si le type est analyse. Il faut dÃ©terminer si c'est a propos de produits ou points de vente qu'on veut analyser.\n    - id : si on recherche par un ID specifique. utilise toujours like ''%id%'.\n      bien verifier les erreurs dans la requete sql (ne pas utiliser FETCH FIRST ROWS, dans la requete sql et utiliser les colonnes existantes pour les ALIAS)\n    - les ORDER BY doivent etre par colonne pas par fonction, si t'as fais sum(nb) as nb et tu veux faire group by sum(nb) tu fais group by nb    Ma requete:\n";
            queryLister = "Tu dois determiner quelle table l'utilisateur veut lister et sur quelle intervalle de date :    les tables disponible:'" + getTables() + "'    date1 et date2 sont les intervalle si il y a une intervalle de date sinon met la date d'aujourd'hui. Une semaine commence par Lundi et se termine par Dimanche\n    Ta reponse doit Ãªtre de cette forme (format JSON) et pas d'autre rÃ©ponse, et une seule reponse\n{\n    type: lister,\n    nomTable: Nom de la table correcte,\n    date1: dd/MM/yyyy,\n    date2: dd/MM/yyyy,\n requeteSql: RequÃªte SQL correcte\n}    La colonne donnees correspond un tableau de JSON par rapport au prompt,met exactement ce que le client a saisie, tu met pas si il y a pas. Met en camelCase les cles: \n    \n    Ma question:\n";
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }



    public static String getTables(Class<? extends ClassIA>[] tables, Connection c) throws Exception{
        StringBuilder tablesString = new StringBuilder();
        boolean estOuvert = false;
        try {
            if (c == null) {
                c = new UtilDB().GetConn();
                estOuvert = true;
            }

            for(Class<? extends ClassIA> tableClass : tables){
                ClassIA table = tableClass.newInstance();
                Vector<Champ> champs = ListeColonneTable.getChampFromTable(table.getNomTableIA(),c);


                tablesString.append("La structure de ma table ").append(table.getNomTableIA()).append(" est comme ceci => ");
                for(Champ champ : champs){
                    Field field = UtilChatbot.getDeclaredFieldIgnoreCase(table.getClass(),champ.getNomColonne());
                    if(field != null){
                        field.setAccessible(true);
                        tablesString.append(" ");
                        tablesString.append(champ.getNomColonne()).append(" ").append(champ.getTypeColonne().toLowerCase());
                        if(field.isAnnotationPresent(AiColDesc.class)){
                            String description = field.getAnnotation(AiColDesc.class).value();
                            tablesString.append(": ");
                            tablesString.append(description);
                        }
                    }
                }
                tablesString.append(") \n");
                tablesString.append("Regle de gestion de ma table ").append(table.getNomTableIA()).append(" => ");
                if(table.getClass().isAnnotationPresent(AiTabDesc.class)){

                    String description = table.getClass().getAnnotation(AiTabDesc.class).value();
                    tablesString.append(description);
                }

            }
//            tablesString.append("Utilise les colonnes *_LIB pour chercher les noms (ex: idproduitlib pour noms produits, idmagasinlib pour noms magasins, etc).\n" +
//                    "  N'utilise pas d'autres colonnes que celles données (mapping strict sur objets définis). \n" +
//                    "  Pas d'alias, mais mets les résultats (sommes, groupes, counts) dans les colonnes existantes sauf ID.\n" +
//                    "  Pas de FETCH FIRST ROWS ONLY — interdit.\n" +
//                    "  Base de données : Oracle 11g.\n");
            tablesString.append("\n");
            System.out.println(tablesString.toString());

        } catch (Exception ex) {
            ex.printStackTrace();
            c.rollback();
            throw ex;
        } finally {
            if (c != null && estOuvert == true) {
                c.close();
            }
        }
        return tablesString.toString();
    }
}
