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
<%@ page import="prix.ConfigurationPrixCpl" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.sql.Date" %>


<%
    try{
        Date [] intervales = new Date[2];
        if (request.getParameter("daty1")!=null && request.getParameter("daty1").isEmpty()==false){
            intervales[0] = Date.valueOf(request.getParameter("daty1"));
        }
        if (request.getParameter("daty2")!=null && request.getParameter("daty2").isEmpty()==false){
            intervales[1] = Date.valueOf(request.getParameter("daty2"));
        }

        ConfigurationPrixCpl t = new ConfigurationPrixCpl();
        t.setNomTable("CONFIGURATIONPRIX_CPL");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id","daty","pu","pv","pu1","pu2","etatLib"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        String awhere = "";
        if(request.getParameter("id") != null){
            pr.setApres("produits/as-ingredients-fiche.jsp&id="+request.getParameter("id"));
            awhere += " and idingredient='"+request.getParameter("id")+"' order by daty desc";
        }
        if (intervales[0]!=null){
            awhere = " and DATY >= TO_DATE('"+intervales[0]+"','YYYY-MM-DD')\n";
        }
        if (intervales[1]!=null){
            awhere = " and DATY <= TO_DATE('"+intervales[1]+"','YYYY-MM-DD')\n";
        }
        pr.setAWhere(awhere);
        pr.creerObjetPage(libEntete, colSomme);
        int nombreLigne = pr.getTableau().getData().length;

%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=configuration/configurationprix-fiche.jsp"};
        String colonneLien[] = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        String libEnteteAffiche[] = {"ID","Date","Prix unitaire","Prix de vente","Prix prime time","Prix heure basse","&Eacute;tat"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){ %>
        <div style="width: 100%;display: flex">
            <form class="col-md-6 col-xs-12" action="<%=pr.getLien()%>" method="Get" style="display: flex;align-items: end;">
                <input type="hidden" name="but" value="<%=pr.getApres()%>">
                <div class="form-input col-md-4 col-xs-12">
                    <label class="nopadding fontinter labelinput">Date debut</label>
                    <input class='form-control' type='date' value='<%=(intervales[0] != null) ? intervales[0].toString() : ""%>' name="daty1" id='daty1'>
                </div>
                <div class="form-input col-md-4 col-xs-12">
                    <label class="nopadding fontinter labelinput">Date fin</label>
                    <input class='form-control' type='date' value='<%=(intervales[1] != null) ? intervales[1].toString() : ""%>' name="daty2" id='daty2'>
                </div>
                <div class="form-input col-md-4 col-xs-12">
                    <button class="btn btn-success" style="width: 100%;height: 32px;text-align: center" type="submit">Filtrer</button>
                </div>
            </form>
        </div>
        <% out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPageOnglet());
        }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center>
    <% }%>



</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
