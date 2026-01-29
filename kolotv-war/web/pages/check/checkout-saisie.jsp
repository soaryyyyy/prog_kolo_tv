<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="reservation.*" %>
<%
  try {
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Reservation mere = new Reservation();
    CheckOut fille = new CheckOut("CHECKOUT");
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    String idreservation = request.getParameter("idresa");
    Check[] res = null;
    if(idreservation!=null){
        mere.setId(idreservation);
        res = mere.getListeCheckIn("CHECKINSANSCHEKOUT",null);
    }
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setVisible(false);
    pi.getFormu().getChamp("daty").setVisible(false);
    pi.getFormu().getChamp("idclient").setVisible(false);
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("reservation_0").setLibelle("Check-in");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date check-out");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure check-out");
    pi.getFormufle().getChampMulitple("etat").setVisible(false);
    for(int i = 0; i < nombreLigne; i++){
      pi.getFormufle().getChamp("daty_"+i).setType("date");
      pi.getFormufle().getChamp("daty_"+i).setDefaut(utilitaire.Utilitaire.dateDuJour());
      pi.getFormufle().getChamp("heure_"+i).setDefaut(utilitaire.Utilitaire.heureCouranteHM());
    }
    if(idreservation!=null&&res.length>0){
        for (int i = 0; i < res.length; i++)
        {
            pi.getFormufle().getChamp("reservation_"+i).setDefaut(res[i].getId());
        }
    }
    
    pi.preparerDataFormu();
    String[] order = {"reservation","remarque", "daty","heure"};
    pi.getFormufle().setColOrdre(order);

    //Variables de navigation
    String classeMere = "reservation.Reservation";
    String classeFille = "reservation.CheckOut";
    String butApresPost = "reservation/reservation-fiche.jsp&id="+idreservation+"&tab=inc/liste-checkout";
    String colonneMere = "";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
  <h1>Enregistrement Check-out</h1>
  <div class="box-body">
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
      <%
        out.println(pi.getFormufle().getHtmlTableauInsert());
      %>
      <input name="acte" type="hidden" id="nature" value="insertFilleSeul">
      <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
      <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
      <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
      <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
      <input name="nomtable" type="hidden" id="nomtable" value="CHECKOUT">
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
