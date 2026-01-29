<%--
    Document   : participantemission-liste
    Author     : Toky20
--%>

<%@page import="emission.ParticipantEmissionCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="emission.PlateauCpl" %>

<%
  try {
    PlateauCpl t = new PlateauCpl();
    t.setNomTable("PLATEAU_CPL");
    String listeCrt[] = {"id", "idClientLib", "idEmissionLib", "daty","dateReserver", "remarque"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "idEmissionLib", "idClientLib", "source","remarque","montant", "daty", "dateReserver","heure"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des plateaux");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("emission/plateau-liste.jsp");

    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("idEmissionLib").setLibelle("&Eacute;mission");
    pr.getFormu().getChamp("daty1").setLibelle("Date d&eacute;but");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");

    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());

    String[] colSomme = {"montant"};
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=emission/plateau-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"ID", "Emission", "Client","Source", "Remarque", "Montant", "Date","Date Reserver","Heure"};
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
