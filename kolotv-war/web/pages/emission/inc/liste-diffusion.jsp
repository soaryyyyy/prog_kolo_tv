<%--
    Document   : liste-diffusion
    Author     : Toky20
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@page import="produits.ActeLib"%>
<%
    try{
        ActeLib t = new ActeLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "libelle","daty","libelleproduit","montant","idclientlib","etatlib","idmedialib", "idsupportlib", "idreservationfille"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
             pr.setAWhere(" and idemission='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=acte/acte-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
%>
<div class="box-body">
    <%
    String libEnteteAffiche[] = {"id", "d&eacute;signation","date","Services M&eacute;dia","montant","client","&eacute;tat","M&eacute;dia", "Support", "Reservation"};
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





















    









