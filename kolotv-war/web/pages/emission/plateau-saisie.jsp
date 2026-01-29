<%--
    Document   : participantemission-saisie.jsp
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="emission.ParticipantEmission"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="emission.Plateau" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String mapping = "emission.Plateau",
                nomtable = "PLATEAU",
                apres = "emission/plateau-fiche.jsp",
                titre = "Saisie d'intervention plateau";

        Plateau objet = new Plateau();
        objet.setNomTable("PLATEAU");
        PageInsert pi = new PageInsert(objet, request, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("idReservation").setVisible(false);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        pi.getFormu().getChamp("idEmission").setLibelle("&Eacute;mission");
        pi.getFormu().getChamp("idEmission").setPageAppelComplete("emission.EmissionLib", "id","EMISSION_LIB","tarifplateau","montant");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("dateReserver").setLibelle("Date R&eacute;serv&eacute;e");
//        pi.getFormu().getChamp("heure").setPageAppelComplete("emission.EmissionDetails","heureDebut","EmissionDetails");
        pi.getFormu().getChamp("heure").setType("time");
        if (request.getParameter("idEmission")!=null){
            pi.getFormu().getChamp("idEmission").setDefaut(request.getParameter("idEmission"));
        }
        if (request.getParameter("idClient")!=null){
            pi.getFormu().getChamp("idClient").setDefaut(request.getParameter("idClient"));
        }
        pi.getFormu().getChamp("source").setLibelle("Source");
        if(request.getParameter("idBC")!=null){
            pi.getFormu().getChamp("source").setDefaut(request.getParameter("idBC"));
            pi.getFormu().getChamp("source").setAutre("readonly");
        }else {
            pi.getFormu().getChamp("source").setPageAppelComplete("vente.BonDeCommande","id","BONDECOMMANDE_CLIENT");
        }

//        String ac_affiche_val = "null";
//        String ac_valeur_val = "heureDebut";
//        String ac_colFiltre_val = "null";
//        String ac_nomTable_val = "EmissionDetails";
//        String ac_classe_val = "emission.EmissionDetails";
//        String ac_useMotcle_val = "true";
//        String ac_champRetour_val = "";
//        String dependentFieldsToMap_str_val = "";
//
//        String onChangeParam = "dynamicAutocompleteDependantForChampSimple(\"idEmission\", " +
//                "\"IDMERE\", " +
//                "\"LIKE\", " +
//                "\"heure\", " +
//                "\"" + ac_affiche_val + "\", " +
//                "\"" + ac_valeur_val + "\", " +
//                "\"" + ac_colFiltre_val + "\", " +
//                "\"" + ac_nomTable_val + "\", " +
//                "\"" + ac_classe_val + "\", " +
//                "\"" + ac_useMotcle_val + "\", " +
//                "\"" + ac_champRetour_val + "\", " +
//                "\"" + dependentFieldsToMap_str_val + "\"," + // Last parameter
//                "\"" + "\"" + // Last parameter
//                ")";
//
//        pi.getFormu().getChamp("idEmission").setAutre("onChange='"+onChangeParam+"'");


        String[] colOrdre = {"daty","idClient","idEmission","remarque","montant","heure","dateReserver","source"};
        pi.getFormu().setOrdre(colOrdre);
        pi.preparerDataFormu();

%>
<div class="content-wrapper">
    <h1> <%=titre%> </h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%--<%if (request.getParameter("idEmission")!=null){%>--%>

<%--<script>--%>
<%--    document.addEventListener("DOMContentLoaded", function () {--%>
<%--        <%=onChangeParam%>--%>
<%--    });--%>
<%--</script>--%>
<%--<%}%>--%>

<% } catch (Exception e) {
    e.printStackTrace(); %>
<script language="JavaScript"> alert('<%=e.getMessage()%>'); history.back();</script>
<% } %>
