<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="reservation.CheckOut" %>
<%@ page import="reservation.Check" %>
<%@ page import="reservation.Reservation" %>  


<%
  try{
    CheckOut t = new CheckOut();
    t.setNomTable("checkoutlib");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id","daty","heure","remarque","etatlib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    if(request.getParameter("id") != null){
      pr.setApres("check/checkout-fiche.jsp&id="+request.getParameter("id"));
      pr.setAWhere(" and reservation='"+request.getParameter("id")+"'");
  }
  pr.creerObjetPage(libEntete, colSomme); 
  
  Reservation resa=new Reservation();
  resa.setId(request.getParameter("id"));
  pr.getTableau().setData(resa.getListeCheckOut(null,null));
  pr.getTableau().transformerDataString();
  int nombreLigne = pr.getTableau().getData().length;

  String monId="";
  if(pr.getTableau().getData().length>0)
    monId=((Check)(pr.getTableau().getData()[0])).getId();
  
  Map<String,String> lienTab=new HashMap();
//  lienTab.put("Modifier",pr.getLien() + "?but=check/checkin-modif.jsp");
//    lienTab.put("Valider",pr.getLien() + "?classe=reservation.CheckOut&but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&tab=inc/liste-checkout&acte=valider");
//  lienTab.put("Annuler",pr.getLien() + "?but=apresTarif.jsp&bute=reservation/reservation-fiche.jsp&tab=inc/liste-checkout&classe=reservation.Check&acte=annuler&id="+monId);
  lienTab.put("Facturer",pr.getLien() + "?but=vente/vente-saisie.jsp&id=" + request.getParameter("id")+"");  
  pr.getTableau().setLienClicDroite(lienTab);
  pr.getTableau().setModalOnClick(true);
   
%>

<div class="box-body">
  <%
    String libEnteteAffiche[] =  {"ID","Date","Heure","Remarque", "Etat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp",pr.getLien() + "?but=check/checkout-fiche.jsp"};
    String colonneLien[] = {"reservation","id"};
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