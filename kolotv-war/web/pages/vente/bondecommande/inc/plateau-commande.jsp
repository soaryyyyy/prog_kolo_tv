
<%@page import="reservation.ReservationLib"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="emission.ParrainageEmissionCpl" %>
<%@ page import="emission.PlateauCpl" %>

<%
    try{
        PlateauCpl t = new PlateauCpl();

        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "idEmissionLib", "idClientLib", "remarque","montant", "daty", "heure"};

        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("idbc") != null){
            pr.setAWhere(" and source ='"+request.getParameter("idbc")+"' ");
        }
        String[] colSomme = null;

        String idDevise = (String) request.getAttribute("idDevise");
        if(idDevise==null) idDevise="Ar";
        pr.creerObjetPage(libEntete, colSomme);
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] = {"ID", "Emission", "Client", "Remarque", "Montant", "Date","Heure"};


        String lienTableau[] = {pr.getLien() + "?but=emission/plateau-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant :</b></td>
                <td><b><%= utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montant")) %> <%= idDevise %></b></td>
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


