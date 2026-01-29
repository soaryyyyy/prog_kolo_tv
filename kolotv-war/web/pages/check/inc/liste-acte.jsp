<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.ActeLib" %>
<%@ page import="produits.Acte" %>
<%@ page import="reservation.Reservation" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.AdminGen"%>
<%@page import="bean.CGenUtil"%>
<%
    try{
        ActeLib t = new ActeLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "libelleproduit","idreservation","daty","qte","pu","idclientlib","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
             pr.setAWhere(" and CHECKOUT='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        Reservation resa=new Reservation();
        int nombreLigne = pr.getTableau().getData().length;
%>
<div class="box-body">
    <%
    String libEnteteAffiche[] = {"id", "d&eacute;signation","reservation","date","quantit&eacute;","prix unitaire","client","&eacute;tat"};
      pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());
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