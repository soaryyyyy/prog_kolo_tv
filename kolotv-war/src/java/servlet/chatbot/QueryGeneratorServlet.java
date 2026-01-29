package servlet.chatbot;

import chatbot.ChatBot;
import chatbot.StaticQuery;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import faturefournisseur.FactureFournisseurDetails;
import user.UserEJB;
import utils.ConstanteAsync;
import utils.ConstanteStation;
import utils.IAUtils;
import vente.VenteDetails;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/query-generator")
public class QueryGeneratorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String message = req.getParameter("message");
        UserEJB user = (UserEJB)req.getSession().getValue("u");
        boolean log = user != null;

        if (message == null || message.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("Parameter 'message' is required.");
            return;
        }

        String aiResponse = null;
        try {
            if(log){
                aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+"\n"+ IAUtils.queryType+" "+message, ConstanteAsync.API_URL);
                JsonParser parser = new JsonParser();
                JsonObject jsonObject = parser.parse(aiResponse).getAsJsonObject();

                String type = jsonObject.get("type").getAsString();
                System.out.println("TYPA : "+type);
                if(type.equals("saisie")){
                    aiResponse = ChatBot.callGenerativeAI(StaticQuery.querySaisie+" "+message, ConstanteAsync.API_URL);
                } else if (type.equals("lister")) {
                    aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+IAUtils.queryLister+" "+message, ConstanteAsync.API_URL);
                } else if (type.equals("liste") || type.equals("analyse")) {
                    aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+IAUtils.queryDB+" "+message, ConstanteAsync.API_URL);
                } else if (type.equals("prevision")) {
                    aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+StaticQuery.queryPrevi+" "+message, ConstanteAsync.API_URL);
                }
            }
            else aiResponse = ChatBot.callGenerativeAI(StaticQuery.dateToday+" "+StaticQuery.queryLog+" "+message, ConstanteAsync.API_URL);
            System.out.println("IA VALINY : "+aiResponse);
        } catch (Exception e) {
            e.printStackTrace();
            String error = e.getMessage();
            if (e.getCause() != null) {
                error = e.getCause().getMessage();
            }
            ChatBot chat = new ChatBot("error",error);
            Gson json = new Gson();
            String data = json.toJson(chat);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(data);
            return;
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter writer = resp.getWriter();
        writer.write(aiResponse);
        System.out.println("done");
        writer.flush();
    }

    //avadika dynamique
    /*private String getTables(){
        return  "    La structure de ma table de vente VENTE_DETAILS_CPL_2 est comme ceci : ID : string, IDVENTE : string, IDVENTELIB : string, IDPRODUIT : string, IDPRODUITLIB : string, IDORIGINE : string, QTE : decimal, PU : decimal, puTotal : decimal(30,2), puTotalAchat : decimal(30,2), puRevient : decimal(30,2), IDCATEGORIE : string, IDCATEGORIELIB : string, daty : date, IDMAGASIN : string, IDMAGASINLIB : string, IDPOINT : string, IDPOINTLIB : string, IDDEVISE : string, IDDEVISELIB : string.\n" +
                "    La structure de ma table FACTUREFOURNISSEURFILLECPL est comme ceci : ID : string, IDFACTUREFOURNISSEUR : string, IDPRODUIT : string, IDPRODUITLIB : string, QTE : number, PU : number, REMISES : number, IDBCDETAIL : string, TVA : number, IDDEVISE : string, DATY : date, MONTANTHT : number, MONTANTTTC : number, MONTANTTVA : number, MONTANTREMISE : number, MONTANT : number.\n" +
                "    Tu ne peux pas utiliser d'autres colonnes que ce que je t'ai donner car je vais mapper la requete a un objet deja defini donc pas d'alias mais met dans les colonnes existant la reponse des sommes, groupes, counts, etc"+
                "    Pas de FETCH FIRST ROWS ONLY, tu ne peux en aucun cas l'utiliser\n" +
                "    Base de donnee: Oracle 11g\n";
    }
    //avadika dynamique
    private String getClassFilles() throws Exception {
        return "la classe 'VenteDetails':"+ChatBot.removeAllDoubleQuotes(new VenteDetails().toJson())+","+
                "la classe 'FactureFournsisseurDetails':"+ChatBot.removeAllDoubleQuotes(new FactureFournisseurDetails().toJson())
                ;
    }

    private String buildQuery(String message,boolean isLogged) throws Exception {
        if(isLogged){
            return
                    "Je veux que tu traites une requete, 1er etape, savoir le type de requete, 2e etape, analyser la requete, 3e etape me donner la reponse"+
                            "    Ta reponse doit être de cette forme (format JSON) et pas d'autre réponse:\n" +
                            "    {\n" +
                            "        type: string,\n" +
                            "        nomTable: string,\n" +
                            "        nomClasse: string, \n"+
                            "        date1: dd/MM/yyyy,\n" +
                            "        date2: dd/MM/yyyy,\n" +
                            "        requeteSql: string,\n" +
                            "        reponseJson: string\n" +
                            "        reponseIa: string\n" +
                            "        "+
                            "    }\n" +
                            "    - type: Classifie mes requêtes SQL en fonction de leur objectif :'saisie' si la requete veut saisir quelque chose, 'liste' si la requête extrait des données générales comme des totaux, des montants ou des transactions, et 'analyse' si elle identifie des tendances, des éléments les plus fréquents, les plus rentables, ou toute autre donnée nécessitant une comparaison ou une interprétation,'aucun' si aucun n'applique\n" +
                            "    - si le type correspond a 'liste' ou 'analyse' utilise les tables pour creer la requeteSql:'"+getTables()+"'"+
                            "    - si le type correspond a 'saisie' utilise les classes pour mapper la responseJson: '"+getClassFilles()+"'"+
                            "    - nomTable correspond a la table que la requete devrait etre execute\n"+
                            "    - nomClasse correspond a la classe ou la saisie va se faire\n"+
                            "    - date1 et date2 sont facultatifs et remplis uniquement si il y a une intervalle de date dans la requete.\n" +
                            "    - requeteSql: Si le type est 'analyse' ou 'liste' procede ,la requete SQL oracle correspondant a la requete sans ajouter de nouvelles colonnes ou alias qui n'existent pas déjà. La requête doit uniquement utiliser les noms de colonnes existants et n'utilise pas FETCH FIRST ROWS.\n" +
                            "      bien verifier les erreurs dans la requete sql (ne pas utiliser FETCH FIRST ROWS dans la requete sql)\n" +
                            "    - responseJson: Si le type est 'saisie' procede, le json de l'objet correspondent au saisie que ma requete veut effectuer avec par defaut date d'aujourd'hui"+
                            "    - responseIa: Si le type est 'aucun' procede, repond juste a ma requete "+
                            "    Ma requete:\n" + message;
        }
        else return "Dis que l'utilisateur doit etre logged dans l'app avant de pouvoir utiliser le chat"+
                "    Ta reponse doit être de cette forme (format JSON) et pas d'autre réponse:\n" +
                "    {\n" +
                "        type: string,\n" +
                "        reponseIa: string\n" +
                "        "+
                "    }\n"+
                "- reponseIa : ta reponse"+
                "- type: 'noUser'";
    }*/
}
