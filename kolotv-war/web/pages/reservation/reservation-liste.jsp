<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.ReservationLib" %>
<%@ page import="utilisateurstation.UtilisateurStation" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="support.Support" %>
<% try{
    ReservationLib bc = new ReservationLib();
    bc.setNomTable("RESERVATIONLIB_ETAT_FACTURE");
    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));
    String listeCrt[] = {"id", "idclientlib","remarque","daty","etat","etatFacturation","idBc","idSupportLib"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "idclientlib","daty","remarque", "montant","idBc","idSupportLib","etatlib","etatFacturationLib"};
    String libEnteteAffiche[] = {"id","Client","Date de r&eacute;servation","Campagne","Montant","Bon de commande","Support","&Eacute;tat","&Eacute;tat de facturation"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des R&eacute;servations ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("reservation/reservation-liste.jsp");
    String[] colSomme = { "montant" };
    Champ[] liste = new Champ[3];
    Liste listeEtat = new Liste("etat");
    String[] aff = {"TOUS","CR&Eacute;E", "VALID&Eacute;E", "ANNUL&Eacute;E"};
    String[] val = {"%", "1", "11", "0"};
    listeEtat.ajouterValeur(val, aff);
    liste[0] = listeEtat;
    Liste listeEtatFacture = new Liste("etatFacturation");
    String[] aff2 = {"TOUS","Facturer", "Non facturer"};
    String[] val2 = {"%", "1", "0"};
    listeEtatFacture.ajouterValeur(val2, aff2);
    liste[1] = listeEtatFacture;
    Support typeMed= new Support();
    liste[2] = new Liste("idSupportLib", typeMed, "val", "val");
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("remarque").setLibelle("Campagne");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("etat").setLibelle("Etat");
    pr.getFormu().getChamp("etatFacturation").setLibelle("Etat de Facturation");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));

    pr.getFormu().getChamp("idBc").setLibelle("Bon de commande");
    pr.getFormu().getChamp("idSupportLib").setLibelle("Support");
    if (request.getParameter("IAaWhere")!=null){
        pr.setAWhere(request.getParameter("IAaWhere"));
    }
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=reservation/reservation-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?classe=reservation.Reservation&but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
    lienTab.put("Voir fiche",pr.getLien() + "?but=reservation/reservation-fiche.jsp");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("reservation/inc/reservation-details.jsp&id=");
//    pr.getTableau().setModalOnClick(true);
%>
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="reservation" id="reservation">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <a class="btn btn-primary pull-right" href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/inc/reservation-export.jsp&','modalContent')" style="margin-right: 10px">Export Excel</a>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
