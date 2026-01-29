<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetailsCheck" %>
<%@ page import="reservation.Check" %>
<%
  try {
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Reservation mere = new Reservation();
    Check fille = new Check();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    String idreservation = request.getParameter("idresa");
    ReservationDetailsCheck[] res = null;
    String butApresPost = "reservation/reservation-fiche.jsp&tab=inc/liste-checkin";
    if(idreservation!=null){
        mere.setId(idreservation);
        res = mere.getListeSansCheckIn("RESERVATIONDETSANSCIGROUP",null);
    }
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormu().getChamp("daty").setVisible(false);
    pi.getFormu().getChamp("idclient").setVisible(false);
    pi.getFormufle().getChamp("idproduit_0").setLibelle("Services");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"produits.IngredientsLib","id","AS_INGREDIENTS_LIB","pv","pu");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date check-in");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure check-in");
    pi.getFormufle().getChamp("idClient_0").setLibelle("Client");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idClient"),"client.Client","id","Client");
    for(int i = 0; i < nombreLigne; i++){
      pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
      pi.getFormufle().getChamp("daty_"+i).setType("date");
      
      pi.getFormufle().getChamp("daty_"+i).setDefaut(utilitaire.Utilitaire.dateDuJour());
            pi.getFormufle().getChamp("heure_"+i).setDefaut(utilitaire.Utilitaire.heureCouranteHM());
    }
    if(idreservation!=null&&res.length>0){
      butApresPost = "reservation/reservation-fiche.jsp&id="+idreservation+"&tab=inc/liste-checkin";
        for (int i = 0; i < res.length; i++){
            pi.getFormufle().getChamp("idproduit_"+i).setDefaut(res[i].getIdproduit());
            pi.getFormufle().getChamp("idClient_"+i).setDefaut(res[i].getIdclient());
        }
    }
    
    pi.preparerDataFormu();
    String[] order = {"idproduit","remarque", "daty","heure","idClient","qte"};
    pi.getFormufle().setColOrdre(order);

    //Variables de navigation
    String classeMere = "reservation.Reservation";
    String classeFille = "reservation.Check";
    String colonneMere = "reservation";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
  <h1>Enregistrement Check-in</h1>
  <div class="box-body">
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
      <%
        out.println(pi.getFormufle().getHtmlTableauInsert());
      %>
      <input name="acte" type="hidden" id="nature" value="insertFille">
      <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
      <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
      <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
      <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
      <input name="idMere" type="hidden" id="idMere" value="<%= idreservation %>">
      <input name="nomtable" type="hidden" id="nomtable" value="CHECKIN">
    </form>
  </div>
</div>
<%
} catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript">
  alert('<%=e.getMessage()%>');
  history.back();
</script>
<% }%>
