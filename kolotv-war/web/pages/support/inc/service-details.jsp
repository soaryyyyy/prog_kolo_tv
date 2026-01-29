<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationDetailsLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="annexe.ProduitLib" %>


<%
  try{
    ProduitLib t = new ProduitLib();
    t.setNomTable("PRODUIT_VENTE_LIB");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] = {"id", "val","idCategorieLib","montant","montantprimetime", "montantheurebasse", "idSupportLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    if(request.getParameter("id") != null){
      pr.setApres("support/support-fiche.jsp&id="+request.getParameter("id"));
      pr.setAWhere(" and idSupport='"+request.getParameter("id")+"'");
    }

    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;

%>

<div class="box-body">
  <%
    String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    String libEnteteAffiche[] = {"ID", "D&eacute;signation","Cat&eacute;gorie","Montant heure normal","Montant prime time","Montant heure basse", "Support"};
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
