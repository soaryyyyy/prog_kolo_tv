<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="reservation.Check" %>
<%@ page import="reservation.Reservation" %>  


<%
  try{
    Check t = new Check();
    t.setNomTable("checkinlibelle");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","produitLibelle","daty","heure","etatlib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    if(request.getParameter("id") != null){
      pr.setApres("check/checkin-fiche.jsp&id="+request.getParameter("id"));
      pr.setAWhere(" and reservation='"+request.getParameter("id")+"'");
  }
    pr.creerObjetPage(libEntete, colSomme); 
    
    Map<String,String> lienTab=new HashMap();
//    lienTab.put("Modifier",pr.getLien() + "?but=check/checkin-modif.jsp");
//    lienTab.put("Valider",pr.getLien() + "?classe=reservation.Check&but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&tab=inc/liste-checkin&acte=valider");
//    lienTab.put("Annuler",pr.getLien() + "?but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&tab=inc/liste-checkin&classe=reservation.Check&acte=annuler");
    lienTab.put("CheckOut",pr.getLien() + "?but=check/checkout-saisie.jsp&idresa=" + request.getParameter("id")+"");  
    pr.getTableau().setLienClicDroite(lienTab);
    pr.getTableau().setModalOnClick(true);

    Reservation resa=new Reservation();
    resa.setId(request.getParameter("id"));
    pr.getTableau().setData(resa.getListeCheckIn("CHECKINLIBELLE",null));
    pr.getTableau().transformerDataString();
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
  <%
    String libEnteteAffiche[] =  {"ID", "Chambre","Date de d&eacute;but","Heure", "Etat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=check/checkin-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    if(pr.getTableau().getHtml() != null){
      out.println(pr.getTableau().getHtml());
      out.println(pr.getBasPageOnglet());
    }if(pr.getTableau().getHtml() == null)
  {
  %><center><h4>Aucune donne trouvee</h4></center><%
  }


%>
        
</div>
<%=pr.getModalHtml("modalContent")%>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>