<%--
    Document   : liste-participantemission
    Author     : Toky20
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="emission.ParticipantEmissionCpl"%>
<%@ page import="reservation.Reservation" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.AdminGen"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="java.util.*" %>
<%
    try{
        ParticipantEmissionCpl t = new ParticipantEmissionCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "nom", "contact", "adresse", "datedenaissance"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
             pr.setAWhere(" and idemission='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=emission/participantemission-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
%>
<div class="box-body">
    <%
    String libEnteteAffiche[] = {"ID", "Nom", "Contact", "Adresse", "Date de Naissance"};
      pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());
        out.println(pr.getBasPageOnglet());
      }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donnee trouvee</h4></center><%
    }
  
  %>
        
            
        
  </div>
  <%
    } catch (Exception e) {
      e.printStackTrace();
    }%>















