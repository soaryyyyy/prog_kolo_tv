<%--
    Document   : liste-parrainageemission
    Author     : Toky20
--%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@page import="emission.ParrainageEmissionCpl"%>
<%@page import="bean.AdminGen"%>
<%
    try{
        ParrainageEmissionCpl t = new ParrainageEmissionCpl();
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "datedebut", "datefin", "idclientlib","remise","montant","qte"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
            pr.setApres("emission/emission-fiche.jsp&id="+request.getParameter("id"));
            pr.setAWhere(" and idemission='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        String lienTableau[] = {pr.getLien() + "?but=emission/parrainageemission-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
%>
<div class="box-body">
    <%
    String libEnteteAffiche[] ={"ID", "Date D&eacute;but", "Date de fin", "Client","Remise","Montant","Quantit&eacute;"};
      pr.getTableau().setLibelleAffiche(libEnteteAffiche);
      if(pr.getTableau().getHtml() != null){
        out.println(pr.getTableau().getHtml());
        out.println(pr.getBasPageOnglet());
      }%>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 40%"class="table">
            <tr>
                <td><b>Montant Total:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montant")) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <%
      if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donnee trouvee</h4></center><%
    }

  %>



  </div>
  <%
    } catch (Exception e) {
      e.printStackTrace();
    }%>














