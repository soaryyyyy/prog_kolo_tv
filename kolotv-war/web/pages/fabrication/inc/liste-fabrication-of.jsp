<%--
    Document   : liste-fabrication-of
    Created on :  03 avril 2025
    Author     : Safidy
--%>


<%@page import="fabrication.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>


<%
    try{
        FabricationCpl t = new FabricationCpl();
        t.setNomTable("FabricationCpl");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","libelle","remarque","daty","etatlib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and IDOF='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        pr.getTableau().transformerDataString();
        String lienTableau[] = {pr.getLien() + "?but=fabrication/fabrication-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLienFille("fabrication/inc/fabrication-details.jsp&id=");
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id","D&eacute;signation","Remarque","Date","Etat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

