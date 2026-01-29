<%-- 
    Document   : proforma-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>
<%@ page import="affichage.*" %>
<%@ page import="vente.ProformaDetails" %>


<%
    try{
    ProformaDetails t = new ProformaDetails();
    t.setNomTable("PROFORMA_DETAILS");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"designation", "qte","pu","puRevient","idDevise","tauxDeChange","tva","montantRevient","margeBrute","reference"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/proforma/proforma-fiche.jsp&id="+request.getParameter("id"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idProforma='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;

    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"D&eacute;signation","Quantit&eacute;","PU","PU revient","Devise","Taux","TVA(en %)","Montant de revient","marge brute","R&eacute;f&eacute;rence"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        ProformaDetails[] liste=(ProformaDetails[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPageOnglet());
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

