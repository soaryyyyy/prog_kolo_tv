
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationLib" %>
<%@page import="bean.AdminGen"%>
<%
    try{
    ReservationLib t = new ReservationLib();
    t.setNomTable("RESERVATION_LIB_VISEE");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "daty","remarque","idSupportLib","montantTTC","paye","resteAPayer"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    if(request.getParameter("id") != null){
        pr.setAWhere(" and idclient='"+request.getParameter("id")+"'");
    } 
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    ReservationLib[] listeFille=(ReservationLib[]) pr.getTableau().getData();
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
        String colonneLien[] = {"id"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        String libEnteteAffiche[] =   {"ID","Date","Remarque","Support","Montant TTC","Montant pay&eacute;","Reste A Payer"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());%>
         <div class="w-100" style="display: flex; flex-direction: row-reverse;">
            <table style="width: 20%"class="table">
                <tr>
                    <td><b>Montant TTC:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantTTC")) %> Ar</b></td>
                </tr>
                <tr>
                    <td><b>Montant pay&eacute;:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"paye")) %> Ar</b></td>
                </tr>
                <tr>
                    <td><b>Reste A Payer:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"resteAPayer")) %> Ar</b></td>
                </tr>
            </table>
        </div>
   <% }
         else
         {
               %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
         }
    %>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
}%>