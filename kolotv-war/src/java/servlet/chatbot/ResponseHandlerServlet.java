package servlet.chatbot;

import bean.ClassMAPTable;
import chatbot.ChatBot;
import chatbot.ClassIA;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import fabrication.Fabrication;
import fabrication.FabricationFille;
import fabrication.FabricationFilleCpl2;
import prevision.AdminPrevision;
import produits.Ingredients;
import reservation.ReservationDetailsLib;
import reservation.ReservationSimple;
import user.UserEJB;
import utils.ConstanteAsync;
import utils.ConstanteStation;
import utils.DateFormat;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.swing.text.DateFormatter;
import java.io.IOException;
import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/response-generator")
public class ResponseHandlerServlet extends HttpServlet {

    public static String replaceAliasWithArg(String sql) {
        // Regex pattern to find aggregated functions with aliases
        String regex = "(SUM|AVG|COUNT|MIN|MAX|ROUND)\\((\\w+)\\)\\s+AS\\s+(\\w+)";
        Pattern pattern = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(sql);

        StringBuffer result = new StringBuffer();
        while (matcher.find()) {
            String function = matcher.group(1); // Aggregation function (SUM, AVG, etc.)
            String arg = matcher.group(2);      // Argument inside function
            matcher.appendReplacement(result, function + "(" + arg + ") AS " + arg);
        }
        matcher.appendTail(result);

        return result.toString().split(" LIMIT")[0];
    }
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        try {String nomTable = req.getParameter("nomTable");
            UserEJB user = (UserEJB)req.getSession().getValue("u");
            String query = req.getParameter("requeteSql");
            if(query!=null){
                query = replaceAliasWithArg(query);
                if(query.contains("FETCH")){
                    query = query.split("FETCH")[0];
                }
                if(query.contains("LIMIT")){
                    query = query.split("LIMIT")[1];
                }
            }
            System.out.println("queryyyy "+query);
            String type = req.getParameter("type");
            ClassMAPTable[] maptables = null;
            String lien = "";
            String dateDebut = req.getParameter("dateDebut");
            String dateFin = req.getParameter("dateFin");
            String jsonResp = req.getParameter("jsonResp");
            String datyFiltre = req.getParameter("datyFiltre");
            String deb = req.getParameter("deb");
            String fin = req.getParameter("fin");
            String grouper = req.getParameter("grouper");
            String dataSaisie = req.getParameter("dataSaisie");
            String baseUrl = req.getParameter("baseUrl");


            System.out.println("typee "+type);
            if(type.equals("noUser") || type.equals("aucun")) {
                ChatBot bot = new ChatBot(req.getParameter("iaResp"),null);
                Gson json = new Gson();
                String data = json.toJson(bot);

                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write(data);
                return;
            }
            else{
                if (type.equals("prevision")) {

                    SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd");
                    Date dateF = inputFormat.parse(datyFiltre);
                    Date dateDeb = inputFormat.parse(deb);
                    Date dateFi = inputFormat.parse(fin);
                    SimpleDateFormat oracleDateFormat = new SimpleDateFormat("dd/MM/yyyy");
                    datyFiltre = oracleDateFormat.format(dateF);
                    deb = oracleDateFormat.format(dateDeb);
                    fin = oracleDateFormat.format(dateFi);

                    AdminPrevision adminPrevision = new AdminPrevision();
                    adminPrevision.getPrevision(datyFiltre,deb,fin,grouper);

                    lien+="/pages/module.jsp?but=prevision/resultat-prevision.jsp&currentMenu=MENUDYN0020003&datyFiltre="+datyFiltre+"&datyDebut="+deb+"&datyFin="+fin+"&grouper="+grouper;

                    DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.FRANCE);
                    symbols.setGroupingSeparator(' ');
                    symbols.setDecimalSeparator(',');

                    DecimalFormat decimalFormat = new DecimalFormat("#,##0.00", symbols);

                    String formattedNumber = decimalFormat.format(adminPrevision.getMinimum().getSoldeFinale());


                    ChatBot chat = new ChatBot("La tresorerie la plus basse etait le "+adminPrevision.getMinimum().getDaty().toString()+" avec un montant de "+formattedNumber,lien);
                    System.out.println(chat.getValue());
                    Gson json = new Gson();
                    String data = json.toJson(chat);

                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(data);
                    return;

                }
                if(type.equals("liste")) {
                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);
                    ClassMAPTable mapTable =(ClassMAPTable) ia.getClass().newInstance();
                    String table = mapTable.getNomTable();
                    mapTable.setNomTable(nomTable);
                    maptables = user.getDataPage(mapTable,query,null);
                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlListe");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(ia);
                    if(dateDebut!=null && !dateDebut.isEmpty()){
                        lien+="&daty1="+DateFormat.formatDate(dateDebut,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if(dateFin!=null && !dateFin.isEmpty()){
                        lien+="&daty2="+DateFormat.formatDate(dateFin,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if (query!=null){
                        String [] requestPart = query.split("WHERE");
                        if (requestPart.length>=2){
                            String condition = " and "+requestPart[1];
                            lien+="&IAaWhere="+ URLEncoder.encode(condition, StandardCharsets.UTF_8.toString());
                        }
                    }
                    mapTable.setNomTable(table);

                }
                else if(type.equals("analyse")) {

                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);
                    ClassMAPTable mapTable =(ClassMAPTable) ia.getClass().newInstance();
                    String table = mapTable.getNomTable();
                    mapTable.setNomTable(nomTable);
                    maptables = user.getDataPage(mapTable,query,null);
                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlAnalyse");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(ia);
                    if(dateDebut!=null && !dateDebut.isEmpty()){
                        lien+="&daty1="+DateFormat.formatDate(dateDebut,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if(dateFin!=null && !dateFin.isEmpty()){
                        lien+="&daty2="+DateFormat.formatDate(dateFin,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if (query!=null){
                        String [] requestPart = query.split("WHERE");
                        if (requestPart.length>=2){
                            String condition = " and "+requestPart[1];
                            lien+="&IAaWhere="+ URLEncoder.encode(condition, StandardCharsets.UTF_8.toString());
                        }
                    }
//                    lien+="&order=order%20by%20qte%20desc";
//                    if(!grouper.isEmpty()){
//                        lien+="&grouper="+grouper;
//                    }
                    mapTable.setNomTable(table);
                }
                else if(type.equals("lister")) {
                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);
                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlListe");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(ia);
                    if(dateDebut!=null && !dateDebut.isEmpty()){
                        lien+="&daty1="+DateFormat.formatDate(dateDebut,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if(dateFin!=null && !dateFin.isEmpty()){
                        lien+="&daty2="+DateFormat.formatDate(dateFin,"dd/MM/yyyy","dd/MM/yyyy");
                    }
                    if (query!=null){
                        String [] requestPart = query.split("WHERE");
                        if (requestPart.length>=2){
                            String condition = " and "+requestPart[1];
                            lien+="&IAaWhere="+ URLEncoder.encode(condition, StandardCharsets.UTF_8.toString());
                        }
                    }

                    ChatBot chat = new ChatBot("action",lien);
                    Gson json = new Gson();
                    String data = json.toJson(chat);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(data);
                    return;
                }
                else if(type.equals("saisie")) {
                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);

                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlSaisie");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(ia);

                    if(dataSaisie.compareToIgnoreCase("[]")!=0){
                        Gson gson = new Gson();

                        if(ia instanceof FabricationFille){
                            Type typaa = new TypeToken<FabricationFilleCpl2[]>() {}.getType();
                            FabricationFilleCpl2[] saisieIA = gson.fromJson(dataSaisie,typaa);
                            FabricationFille[] fabricationFilles = new FabricationFille[saisieIA.length];
                            for (int i = 0; i < saisieIA.length; i++) {
                                fabricationFilles[i] = new FabricationFille();

                                Ingredients ing = new Ingredients();
                                ing.setLibelle(saisieIA[i].getLibelle());
                                Ingredients[] ingredients = (Ingredients[]) user.getData(ing,null,null,null,"");
                                fabricationFilles[i].setQte(saisieIA[i].getQte());
                                fabricationFilles[i].setRemarque(ingredients[0].getLibelle());
                                fabricationFilles[i].setIdIngredients(ingredients[0].getId());
                            }
                            req.setAttribute("fillesIA", fabricationFilles);
                            req.getSession().setAttribute("fillesIA", fabricationFilles);

                            /*try {
                                String path = baseUrl + lien;
                                RequestDispatcher dispatcher = req.getRequestDispatcher(path);
                                dispatcher.forward(req, resp);
                                return;
                            } catch (Exception e) {
                                System.out.println("Error occurred while forwarding to JSP.");
                                e.printStackTrace();
                            }*/

                        } else if (ia instanceof ReservationSimple) {
                            Type resaType = new TypeToken<ReservationDetailsLib[]>() {}.getType();
                            ReservationDetailsLib[] dataResa = gson.fromJson(dataSaisie,resaType);
                            Ingredients[] ingredients = (Ingredients[]) user.getData(new Ingredients(),null,null,null," and upper(libelle) like '%"+dataResa[0].getLibelleproduit().toUpperCase()+"%'");
                            ReservationSimple saisieResa = new ReservationSimple();
                            saisieResa.setIdProduit(ingredients[0].getId());
                            saisieResa.setQte(dataResa[0].getQte());
                            req.getSession().setAttribute("saisirIA", saisieResa);
                        }
                    }
                    ChatBot chat = new ChatBot("action",lien);
                    Gson json = new Gson();
                    String data = json.toJson(chat);
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(data);
                    return;
                }
                /*else if(type.equals("saisie")) {
                    ClassIA ia = ClassIA.getCorrespondingClass(ConstanteAsync.iaClasses,nomTable,type);
                    ClassMAPTable obj = (ClassMAPTable) ia.getClass().newInstance();
                    obj.fromJson(jsonResp);
                    Method staticMethod = ia.getClass().getDeclaredMethod("getUrlSaisie");
                    staticMethod.setAccessible(true);
                    lien = (String) staticMethod.invoke(null);
                    req.getSession().setAttribute("objIa", obj);
                    resp.sendRedirect(lien);
                }*/
            }
            String json = ClassMAPTable.toJson(maptables);
            req.setAttribute("lien", lien);
            req.setAttribute("maptables", json);
            RequestDispatcher dispatcher = req.getRequestDispatcher("response-formattor");
            dispatcher.forward(req, resp);

        }
        catch (Exception e) {
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
        }
    }
}
