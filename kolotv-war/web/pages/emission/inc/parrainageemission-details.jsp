<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="affichage.*" %>
<%@ page import="emission.ParrainageEmissionDetailsLib" %>


<%
    try{
        ParrainageEmissionDetailsLib t = new ParrainageEmissionDetailsLib();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idProduitLib","idmedia","remarque","avant","pendant","apres"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
            pr.setApres("emission/parrainageemission-fiche.jsp&id="+request.getParameter("id"));
            pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
        }
//        String lienTableau[] = {pr.getLien() + "?but=media/media-fiche.jsp"};
//        String colonneLien[] = {"idmedia"};
//        pr.getTableau().setLien(lienTableau);
//        pr.getTableau().setColonneLien(colonneLien);

        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"ID", "Service","M&eacute;dia","Remarque","Avant","Pendant","Apr&egrave;s"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
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
