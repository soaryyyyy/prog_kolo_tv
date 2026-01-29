<%--
    Document   : configurationprix-saisie.jsp
    Author     : Toky20
--%>


<%@page import="client.Client"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="bean.CGenUtil"%>
<%@page import="affichage.Liste"%>
<%@ page import="prix.ConfigurationPrix" %>
<%@page import="produits.Ingredients"%>

<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "prix.ConfigurationPrix",
            nomtable = "ConfigurationPrix",
            titre = "Saisie de la configuration des prix";

    ConfigurationPrix proc = new ConfigurationPrix();
    PageInsert pi = new PageInsert(proc, request, u);
    pi.setLien((String) session.getValue("lien"));
    String apres="configuration/configurationprix-fiche.jsp";
    pi.getFormu().getChamp("daty").setAutre("readonly");
    pi.getFormu().getChamp("daty").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pi.getFormu().getChamp("idingredient").setLibelle("Service M&eacute;dia");
    pi.getFormu().getChamp("idingredient").setPageAppelComplete("produits.Ingredients","id","AS_INGREDIENTS");
    pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("pv").setLibelle("Prix de vente");
    pi.getFormu().getChamp("pu1").setLibelle("Prix prime time");
    pi.getFormu().getChamp("pu2").setLibelle("Prix heure basse");
    pi.getFormu().getChamp("pu3").setLibelle("PU hors prime time institutionnel");
    pi.getFormu().getChamp("pu4").setLibelle("PU prime time institutionnel");
    pi.getFormu().getChamp("pu5").setLibelle("PU &eacute;mission institutionnel");
    pi.getFormu().getChamp("pu3").setVisible(false);
    pi.getFormu().getChamp("pu4").setVisible(false);
    pi.getFormu().getChamp("pu5").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("daty").setLibelle("Date");

    String id=request.getParameter("id");

    if(id!=null  && !id.equalsIgnoreCase("")){
        Ingredients cfgfille = new Ingredients();
        cfgfille.setNomTable("AS_INGREDIENTS");
        cfgfille.setId(id);
        Ingredients[] cfgArray = null;
        cfgArray = (Ingredients[]) CGenUtil.rechercher(cfgfille,null,null, "");
        if(cfgArray.length>0){
            pi.getFormu().getChamp("idingredient").setDefaut(id);
            pi.getFormu().getChamp("pu").setDefaut(String.valueOf(cfgArray[0].getPu()));
            pi.getFormu().getChamp("pv").setDefaut(String.valueOf(cfgArray[0].getPv()));
            pi.getFormu().getChamp("pu1").setDefaut(String.valueOf(cfgArray[0].getPu1()));
            pi.getFormu().getChamp("pu2").setDefaut(String.valueOf(cfgArray[0].getPu2()));
            pi.getFormu().getChamp("pu3").setDefaut(String.valueOf(cfgArray[0].getPu3()));
            pi.getFormu().getChamp("pu4").setDefaut(String.valueOf(cfgArray[0].getPu4()));
            pi.getFormu().getChamp("pu5").setDefaut(String.valueOf(cfgArray[0].getPu5()));
        }
    }
    pi.preparerDataFormu();

%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
        out.println(pi.getHtmlAddOnPopup());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>
