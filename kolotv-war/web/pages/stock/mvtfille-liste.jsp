<%@page import="stock.MvtStockFilleLib"%>
<%@page import="stock.MvtStockFille"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
    MvtStockFilleLib t = new MvtStockFilleLib();
    t.setNomTable("MVTSTOCKFILLELIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "libelleexacte", "Entree","sortie","pu","montant"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        System.out.println("idmere "+request.getParameter("id"));
        pr.setAWhere(" and idmvtstock='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Id", "Ingredients", "Entr&eacute;e","Sortie","pu","montant"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         }else
         {
               %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
         }

        
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>


