<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationDetailsLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>


<%
  try{
    ReservationDetailsLib t = new ReservationDetailsLib();
    t.setNomTable("RESERVATIONDETAILS_LIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idproduit","libelleproduit","libellemedia","remarque","daty","heure","duree","categorieproduitlib","pu","source"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    if(request.getParameter("id") != null){
      pr.setApres("reservation/reservation-fiche.jsp&id="+request.getParameter("id"));
      pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
    }
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
    pr.getTableau().setLienFille("reservation/inc/reservation-fille-details.jsp&id=");

%>

<div class="box-body">
  <%
    Map<String,String> lienTab=new HashMap();
    lienTab.put("Diffuser",pr.getLien() + "?but=apresReservation.jsp&acte=diffuserFille&&bute=reservation/reservation-details-fiche.jsp&classe=reservation.ReservationDetails&nomtable=RESERVATIONDETAILS");
    pr.getTableau().setLienClicDroite(lienTab);
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"idproduit"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setAttLien(new String[]{"id"});
    String libEnteteAffiche[] =  {"ID", "ID Service","Service","M&eacute;dia","Remarque","Date de R&eacute;servation","Heure", "Dur&eacute;e","Type de service","Montant HT","Source"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    if(pr.getTableau().getHtml() != null){
    out.println(pr.getTableauRecap().getHtml());
    out.println("<br>");
      out.println(pr.getTableau().getHtml());
      out.println(pr.getBasPageOnglet());
    }if(pr.getTableau().getHtml() == null)
  {
  %><center><h4>Aucune donne trouvee</h4></center><%
  }


%>



</div>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>
