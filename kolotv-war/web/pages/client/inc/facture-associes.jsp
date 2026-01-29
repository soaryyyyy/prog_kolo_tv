<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.VenteLib" %>
<%@ page import="reservation.Reservation" %>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="bean.AdminGen"%>
<%@page import="bean.CGenUtil"%>
<%
    try{

        VenteLib t = new VenteLib();
        t.setNomTable("VENTE_CPLVISE");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","daty","designation","montantttc","montantpaye","montantreste"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
          pr.setAWhere(" and idclient='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        VenteLib[] listeFille=(VenteLib[]) pr.getTableau().getData();
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=vente/vente-fiche.jsp"};
        String colonneLien[] = {"id"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
      String libEnteteAffiche[] = {"ID","Date","Designation","Montant TTC","Montant pay&eacute;","Reste A Payer"};
      pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());%>
         <div class="w-100" style="display: flex; flex-direction: row-reverse;">
            <table style="width: 20%"class="table">
                <tr>
                    <td><b>Montant TTC:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantttc")) %> Ar</b></td>
                </tr>
                <tr>
                    <td><b>Montant pay&eacute;:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantpaye")) %> Ar</b></td>
                </tr>
                <tr>
                    <td><b>Reste A Payer:</b></td>
                    <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantreste")) %> Ar</b></td>
                </tr>
            </table>
        </div>
      <% }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }
  
  %>
  </div>
  <%
    } catch (Exception e) {
      e.printStackTrace();
    }%>