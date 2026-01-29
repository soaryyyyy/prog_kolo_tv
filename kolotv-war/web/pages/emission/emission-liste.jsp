<%--
    Document   : emission-liste
    Author     : Toky20
--%>

<%@page import="emission.Emission"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="emission.EmissionLib" %>
<%@ page import="support.Support" %>
<%@ page import="emission.TypeEmission" %>
<%@ page import="affichage.Liste" %>

<%
try {
    EmissionLib t = new EmissionLib();
    t.setNomTable("EMISSION_LIB");
    String listeCrt[] = {"id", "nom","idSupport","idGenre"};
    String listeInt[] = {};
    String libEntete[] = {"id", "nom", "tarifplateau", "tarifparainage", "secondeparainage","duree","idSupportLib","idGenreLib"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste d'&eacute;mission");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("emission/emission-liste.jsp");

    affichage.Champ[] liste = new affichage.Champ[2];
    Support typeMed= new Support();
    liste[0] = new Liste("idSupport", typeMed, "val", "id");
    TypeEmission typeEmission= new TypeEmission();
    liste[1] = new Liste("idGenre", typeEmission, "val", "id");
    pr.getFormu().changerEnChamp(liste);

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("idSupport").setLibelle("Support");
    pr.getFormu().getChamp("idGenre").setLibelle("Genre");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=emission/emission-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLienFille("emission/inc/emission-details.jsp&id=");
    String libEnteteAffiche[] = {"ID", "Nom", "Tarif Plateau", "Tarif Parrainage", "Nombre de Spot","Dur&eacute;e","Support","Genre"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%= pr.getFormu().getHtmlEnsemble() %>
        </form>
        <%= pr.getTableauRecap().getHtml() %><br>
        <%= pr.getTableau().getHtml() %>
        <%= pr.getBasPage() %>
    </section>
</div>

<% }
catch(Exception e) {
    e.printStackTrace();
} %>
