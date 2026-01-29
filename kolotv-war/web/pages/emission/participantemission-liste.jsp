<%--
    Document   : participantemission-liste
    Author     : Toky20
--%>

<%@page import="emission.ParticipantEmissionCpl"%>
<%@page import="affichage.PageRecherche"%>

<%
try {
    ParticipantEmissionCpl t = new ParticipantEmissionCpl();
    t.setNomTable("PARTICIPANTEMISSION_CPL");
    String listeCrt[] = {"id", "nom", "contact", "adresse", "datedenaissance",  "idemissionlib"};
    String listeInt[] = {"datedenaissance"};
    String libEntete[] = {"id", "nom", "contact", "adresse", "datedenaissance", "idemissionlib"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste de participants emission");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("emission/participantemission-liste.jsp");

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("nom").setLibelle("Nom");
    pr.getFormu().getChamp("contact").setLibelle("Contact");
    pr.getFormu().getChamp("adresse").setLibelle("Adresse");
    pr.getFormu().getChamp("idemissionlib").setLibelle("Emission");

    pr.getFormu().getChamp("datedenaissance1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datedenaissance2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("datedenaissance1").setLibelle("Date de naissance Min");
    pr.getFormu().getChamp("datedenaissance2").setLibelle("Date de naissance Max");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=emission/participantemission-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"ID", "Nom", "Contact", "Adresse", "Date de Naissance", "Emission"};
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
