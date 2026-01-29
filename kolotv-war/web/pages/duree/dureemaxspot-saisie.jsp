<%--
    Document   : dureemaxspot-saisie.jsp
    Created on : 10 mai 2024, 10:22:02
    Author     : CMCM
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="duree.DureeMaxSpot"%>
<%@page import="annexe.Unite"%>
<%@page import="annexe.TypeProduit"%>
<%@page import="annexe.Produit"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="support.Support" %>

<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "duree.DureeMaxSpot",
            nomtable = "DureeMaxSpot",
            apres = "duree/dureemaxspot-fiche.jsp",
            titre = "Insertion de disponibilit&eacute; de diffusion";

    DureeMaxSpot objet  = new DureeMaxSpot();
    objet.setNomTable("DureeMaxSpot");
    PageInsert pi = new PageInsert(objet, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("heureDebut").setLibelle("Heure d&eacute;but");
    pi.getFormu().getChamp("heureFin").setLibelle("Heure de fin");

    pi.getFormu().getChamp("heureDebut").setType("time");
    pi.getFormu().getChamp("heureDebut").setDefaut(utilitaire.Utilitaire.heureCouranteHM());

    pi.getFormu().getChamp("heureFin").setType("time");
    pi.getFormu().getChamp("heureFin").setDefaut(utilitaire.Utilitaire.heureCouranteHM());

    if (request.getParameter("heureDebut")!=null){
        pi.getFormu().getChamp("heureDebut").setDefaut(request.getParameter("heureDebut"));
    }
    if (request.getParameter("heureFin")!=null){
        pi.getFormu().getChamp("heureFin").setDefaut(request.getParameter("heureFin"));
    }

    affichage.Champ[] liste = new affichage.Champ[3];
    Liste jours=new Liste("jour");
    String[] joursString = new String[] {"Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"};
    jours.makeListeString( joursString,  joursString);
    liste[0] = jours;
    Support typeMed= new Support();
    liste[1] = new Liste("idSupport", typeMed, "val", "id");
    TypeObjet catIngr = new TypeObjet();
    catIngr.setNomTable("CATEGORIEINGREDIENT");
    liste[2] = new Liste("idCategorieIngredient", catIngr, "VAL", "id");

    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("max").setLibelle("Dur&eacute;e Maximum");
    pi.getFormu().getChamp("max").setType("time");
    pi.getFormu().getChamp("max").setAutre("step=\"1\"");

    pi.getFormu().getChamp("idSupport").setLibelle("Support");
    pi.getFormu().getChamp("idCategorieIngredient").setLibelle("Cat&eacute;gorie de service");
    pi.getFormu().getChamp("daty").setVisible(false);

    pi.getFormu().setOrdre(new String[]{"idSupport","idCategorieIngredient"});
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
