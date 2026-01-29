<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 15/04/2025
  Time: 11:36
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="reservation.ReservationSimple" %>
<%@ page import="support.Support" %>
<%@ page import="affichage.Liste" %>

<%
  try{
    String daty = request.getParameter("daty");
    String idproduit = request.getParameter("idproduit");
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "reservation.ReservationSimple",
            nomtable = "RESERVATIONSIMPLE",
            apres = "reservation/reservation-fiche.jsp",
            titre = "Nouvelle R&eacute;servation";
    ReservationSimple t = new ReservationSimple();
    PageInsert pi = new PageInsert(t, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelCompleteInsert("client.Client", "id", "CLIENT", "client/client-saisie.jsp", "id;nom");
    pi.getFormu().getChamp("idproduit").setLibelle("Service M&eacute;dia");
    pi.getFormu().getChamp("idproduit").setPageAppelComplete("annexe.ProduitLib", "id", "produit_vente_lib");
    pi.getFormu().getChamp("daty").setLibelle("Date de d&eacute;but");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("qte").setDefaut("1");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("support").setLibelle("Support");
//    pi.getFormu().getChamp("support").setPageAppelComplete("support.Support","id","SUPPORT");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idbc").setVisible(false);

    pi.getFormu().getChamp("heureDebut").setType("time");
    pi.getFormu().getChamp("heureDebut").setAutre("step=\"1\"");
    pi.getFormu().getChamp("heureDebut").setDefaut(utilitaire.Utilitaire.heureCouranteHMS());

    pi.getFormu().getChamp("duree").setType("time");
    pi.getFormu().getChamp("duree").setAutre("step=\"1\"");

    affichage.Champ[] liste = new affichage.Champ[1];
    Support typeMed= new Support();
    liste[0] = new Liste("support", typeMed, "val", "id");
    pi.getFormu().changerEnChamp(liste);
    if(session.getAttribute("saisirIA")!=null){
      ReservationSimple reservationSimple = (ReservationSimple) session.getAttribute("saisirIA");
      pi.getFormu().getChamp("idproduit").setDefaut(reservationSimple.getIdProduit());
      pi.getFormu().getChamp("qte").setDefaut(String.valueOf(reservationSimple.getQte()));
    }
    if (daty != null && !daty.equalsIgnoreCase(""))
    {
      pi.getFormu().getChamp("daty").setDefaut(daty);
    }
    if (idproduit != null && !idproduit.equalsIgnoreCase(""))
    {
      pi.getFormu().getChamp("idproduit").setDefaut(idproduit);
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
