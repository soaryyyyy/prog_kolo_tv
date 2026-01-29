<%--
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="media.*"%>
<%@page import="annexe.Unite"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Produit"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="produits.CategorieIngredient" %>

<%
    try{
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "media.Media",
                nomtable = "MEDIA",
                apres = "media/media-fiche.jsp",
                titre = "Insertion media";

        Media objet  = new Media();
        objet.setNomTable("MEDIA");
        PageInsert pi = new PageInsert(objet, request, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("duree").setLibelle("Dur&eacute;e");
        pi.getFormu().getChamp("duree").setType("time");
        pi.getFormu().getChamp("duree").setAutre("step=\"1\"");

        affichage.Champ[] liste = new affichage.Champ[1];
        CategorieIngredient typeMed= new CategorieIngredient();
        liste[0] = new Liste("idTypeMedia", typeMed, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idTypeMedia").setLibelle("Type de M&eacute;dia");
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","CLIENT");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        if (request.getParameter("idClient")!=null){
            pi.getFormu().getChamp("idClient").setDefaut(request.getParameter("idClient"));
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
