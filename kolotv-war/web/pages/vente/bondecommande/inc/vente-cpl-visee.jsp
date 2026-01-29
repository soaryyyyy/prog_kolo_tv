<%--
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="vente.VenteDetailsLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.VenteCplVisee" %>


<%
    try{
    VenteCplVisee t = new VenteCplVisee();
    t.setNomTable("VENTE_CPL_BC_VISEE");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "designation", "idorigine", "montantttc","montanttva","montanttotal", "montantpaye","montantreste","margeBrute","montantRevient"};
//    id | desce | montantPayé | montantTTC | montantTVA
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idorigine='"+request.getParameter("id")+"'");
    }
    String[] colSomme = null;

    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"id", "D&eacute;signation","ID Origine", "Montant TTC","Montant TVA","Montant","Montant Pay&eacute;","Reste a pay&eacute;","Marge Brute","Montant de revient"};
        String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        VenteCplVisee[] liste=(VenteCplVisee[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <% if(pr.getListe().length > 0) {%>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant HT:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montanttotal")) %> <%= ((VenteCplVisee)pr.getListe()[0]).getIddevise() %></b></td>
            </tr>
            <tr>
                <td><b>Montant TVA:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTva")) %> <%= ((VenteCplVisee)pr.getListe()[0]).getIddevise() %></b></td>
            </tr>
            <tr>
                <td><b>Montant TTC:</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montantTTC")) %> <%= ((VenteCplVisee)pr.getListe()[0]).getIddevise() %></b></td>
            </tr>
        </table>
    </div>
    <%}%>
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

