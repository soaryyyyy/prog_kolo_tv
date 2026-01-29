<%--
    Document   : participantemission-liste
    Author     : Toky20
--%>

<%@page import="affichage.PageRecherche"%>
<%@ page import="emission.PlateauCpl" %>
<%@ page import="bean.AdminGen" %>

<%
  try {
    PlateauCpl t = new PlateauCpl();
    t.setNomTable("PLATEAU_CPL");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "idEmissionLib", "idClientLib", "remarque","montant", "daty", "heure"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des plateaux");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));

    if(request.getParameter("id") != null){
      pr.setApres("emission/plateau-fiche.jsp&id="+request.getParameter("id"));
      pr.setAWhere(" and idEmission='"+request.getParameter("id")+"'");
    }

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=emission/plateau-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"ID", "&Eacute;mission", "Client", "Remarque", "Montant", "Date","Heure"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="box-body">
  <%
    if(pr.getTableau().getHtml() != null){
      out.println(pr.getTableau().getHtml());
      out.println(pr.getBasPageOnglet());
    }%>
  <div class="w-100" style="display: flex; flex-direction: row-reverse;">
    <table style="width: 40%"class="table">
      <tr>
        <td><b>Montant Total:</b></td>
        <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getListe(),"montant")) %></b> Ar</td>
      </tr>
    </table>
  </div>
    <%if(pr.getTableau().getHtml() == null)
  {
  %><center><h4>Aucune donne trouvee</h4></center><%
  }


%>



</div>
<%
  } catch (Exception e) {
    e.printStackTrace();
  }%>
