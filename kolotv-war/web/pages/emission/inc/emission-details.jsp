<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="affichage.*" %>
<%@ page import="emission.EmissionDetails" %>


<%
    try{
        EmissionDetails t = new EmissionDetails();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "jour","heureDebut","heureFin","heureDebutCoupure","heureFinCoupure"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
            pr.setApres("emission/emission-fiche.jsp&id="+request.getParameter("id"));
            pr.setAWhere(" and idmere='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"ID", "Jour","Heure d&eacute;but","Heure de fin","D&eacute;but coupure","Fin Coupure"};
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
