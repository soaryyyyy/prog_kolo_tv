<%-- 
    Document   : avoirfc-details
    Created on : 9 ao�t 2024, 15:37:27
    Author     : bruel
--%>

<%@page import="avoir.AvoirFCLib"%>
<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    try{
    AvoirFCLib t = new AvoirFCLib();
    t.setNomTable("AVOIRFCLIB_CPL_VISEE");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"id", "idMagasinLib", "designation","montantHT", "montantTVA", "montantTTC"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idvente='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;
    pr.setNpp(10);
    String lienTableau[] = {pr.getLien() + "?but=avoir/avoirFC-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
         String libEnteteAffiche[] =  {"ID", "Magasin", "D&eacute;signation", "Montant HT", "Montant TVA", "Montant TTC"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant :</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantHT")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Montant TVA:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTVA")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Montant TTC:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTTC")) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <% }if(pr.getTableau().getHtml() == null){
               %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
         }
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>
