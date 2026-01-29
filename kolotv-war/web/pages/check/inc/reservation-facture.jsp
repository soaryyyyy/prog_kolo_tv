<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.Vente" %>
<%@ page import="reservation.Reservation" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.AdminGen"%>
<%@page import="bean.CGenUtil"%>
<%
    try{

        Vente t = new Vente();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"designation","montantttc","remarque","daty"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("idreservation") != null){
          //pr.setAWhere(" and idreservation='"+request.getParameter("idreservation")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        Reservation resa=new Reservation();
        resa.setId(request.getParameter("idreservation"));
        pr.getTableau().setData(resa.getFactureClient("vente_cpl",null));
        pr.getTableau().transformerDataString();
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
      String libEnteteAffiche[] = {"Designation","Montant","Remarque","Date"};
      pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());
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