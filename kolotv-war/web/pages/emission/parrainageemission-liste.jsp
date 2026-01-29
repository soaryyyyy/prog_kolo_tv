<%--
    Document   : parrainageemission-liste
    Author     : Toky20
--%>

<%@page import="emission.ParrainageEmissionCpl"%>
<%@page import="affichage.PageRecherche"%>

<%
try {
    ParrainageEmissionCpl t = new ParrainageEmissionCpl();
    t.setNomTable("PARRAINAGEEMISSION_CPL");
    String listeCrt[] = {"id", "idclientlib", "idemissionlib","datedebut"};
    String listeInt[] = {"datedebut"};
    String libEntete[] = {"id", "datedebut", "datefin", "idclientlib", "idemissionlib","source","remise","montant","qte"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste de parrainage d'&eacute;mission");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("emission/parrainageemission-liste.jsp");

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("idemissionlib").setLibelle("&Eacute;mission");

    pr.getFormu().getChamp("datedebut1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datedebut2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datedebut1").setLibelle("Date de debut minimum");
    pr.getFormu().getChamp("datedebut2").setLibelle("Date de debut maximum");

//    pr.getFormu().getChamp("datefin1").setDefaut(utilitaire.Utilitaire.dateDuJour());
//    pr.getFormu().getChamp("datefin2").setDefaut(utilitaire.Utilitaire.dateDuJour());
//    pr.getFormu().getChamp("datefin1").setLibelle("Date de fin Min");
//    pr.getFormu().getChamp("datefin2").setLibelle("Date de fin Max");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=emission/parrainageemission-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"ID", "Date D&eacute;but", "Date de fin", "Client", "&Eacute;mission","Source","Remise","Montant","Quantit&eacute;"};
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

<% } catch(Exception e) { e.printStackTrace(); } %>
