<%--
    Document   : emission-saisie.jsp
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="emission.Emission"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="support.Support" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="emission.EmissionDetails" %>
<%@ page import="emission.TypeEmission" %>
<%@ page import="affichage.PageUpdateMultiple" %>
<%@ page import="bean.CGenUtil" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String mapping = "emission.Emission",
                nomtable = "EMISSION",
                apres = "emission/emission-fiche.jsp",
                titre = "Modification d'&eacute;mission";

        Emission mere = new Emission();
        EmissionDetails fille = new EmissionDetails();
        String id = request.getParameter("id");
        fille.setIdMere(id);
        EmissionDetails[] details = (EmissionDetails[]) CGenUtil.rechercher(fille, null, null, "");
        int nombreLigne = 10;
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), 2);
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new affichage.Champ[2];
        Support typeMed= new Support();
        liste[0] = new Liste("idSupport", typeMed, "val", "id");
        TypeEmission typeEmission= new TypeEmission();
        liste[1] = new Liste("idGenre", typeEmission, "val", "id");

        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("nom").setLibelle("Nom");
        pi.getFormu().getChamp("idSupport").setLibelle("Support");
        pi.getFormu().getChamp("idGenre").setLibelle("Genre");
        pi.getFormu().getChamp("tarifplateau").setLibelle("Tarif plateau");
        pi.getFormu().getChamp("tarifparainage").setLibelle("Tarif parrainage");
        pi.getFormu().getChamp("secondeparainage").setLibelle("Nombre de spot");
        pi.getFormu().getChamp("duree").setLibelle("Dur&eacute;e");

        affichage.Champ[] liste2 = new affichage.Champ[1];
        TypeObjet to = new TypeObjet();
        to.setNomTable("JOUR");
        liste2[0] = new Liste("jour", to, "val", "val");
        pi.getFormufle().changerEnChamp(liste2);

        for (int i = 0; i < pi.getNombreLigne(); i++) {
            pi.getFormufle().getChamp("heureDebut_"+i).setType("time");
            pi.getFormufle().getChamp("heureFin_"+i).setType("time");
            pi.getFormufle().getChamp("heureDebutCoupure_"+i).setType("time");
            pi.getFormufle().getChamp("heureFinCoupure_"+i).setType("time");
        }

        pi.getFormufle().getChamp("jour_0").setLibelle("Jour");
        pi.getFormufle().getChamp("heureDebut_0").setLibelle("Heure d&eacute;but");
        pi.getFormufle().getChamp("heureFin_0").setLibelle("Heure de fin");
        pi.getFormufle().getChamp("heureDebutCoupure_0").setLibelle("D&eacute;but coupure");
        pi.getFormufle().getChamp("heureFinCoupure_0").setLibelle("Fin Coupure");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idmere"),false);


        pi.preparerDataFormu();
        //Variables de navigation
        String classeMere = "emission.Emission";
        String classeFille = "emission.EmissionDetails";
        String butApresPost = "emission/emission-fiche.jsp";
        String colonneMere = "idmere";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="acte" value="updateInsert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%out.print(request.getParameter("id"));%>" >
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=pi.getNombreLigne()%>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        </form>
    </div>
</div>

<% } catch (Exception e) {
    e.printStackTrace(); %>
<script language="JavaScript"> alert('<%=e.getMessage()%>'); history.back();</script>
<% } %>
