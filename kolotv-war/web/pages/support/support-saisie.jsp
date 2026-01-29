<%--
    Document   : support-saisie.jsp
    Created on : 10 mai 2024, 10:22:02
    Author     : CMCM
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="support.Support"%>
<%@page import="annexe.Unite"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Produit"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>

<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "support.Support",
            nomtable = "SUPPORT",
            apres = "support/support-fiche.jsp",
            titre = "Insertion de Support";

    Support  objet  = new Support();
    objet.setNomTable("SUPPORT");
    PageInsert pi = new PageInsert(objet, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("val").setLibelle("libell&eacute;");
    pi.getFormu().getChamp("desce").setLibelle("Description");
    affichage.Champ[] liste = new affichage.Champ[1];
    liste[0] = new Liste("idPoint",new magasin.Magasin(),"val","id");
    pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idPoint").setLibelle("Point");

    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

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

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>
