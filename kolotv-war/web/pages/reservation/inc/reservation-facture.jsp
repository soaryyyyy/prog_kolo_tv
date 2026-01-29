<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.VenteLib" %>
<%
    try{

        VenteLib t = new VenteLib();
        t.setNomTable("VENTE_CPLVISE");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"daty","designation","montantttc","remarque"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        if(request.getParameter("id") != null){
            pr.setApres("reservation/reservation-fiche.jsp&id="+request.getParameter("id"));
            pr.setAWhere(" and idorigine='"+request.getParameter("id")+"'");
        }
        pr.creerObjetPage(libEntete, colSomme);
        /*Reservation resa=new Reservation();
        resa.setId(request.getParameter("id"));
        pr.getTableau().setData(resa.getFactureClient("vente_cpl",null));
        pr.getTableau().transformerDataString();
        int nombreLigne = pr.getTableau().getData().length;*/
%>

<div class="box-body">
    <%
      String libEnteteAffiche[] = {"Date","Designation","Montant","Remarque"};
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
