<%-- 
    Document   : proforma-liste
    Created on : 25 juillet 2025, 10:57:03
    Author     : Toky20
--%>

<%@page import="vente.VenteLib"%>
<%@page import="vente.Vente"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="static java.time.DayOfWeek.MONDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.previousOrSame" %>
<%@ page import="static java.time.DayOfWeek.SUNDAY" %>
<%@ page import="static java.time.temporal.TemporalAdjusters.nextOrSame" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="vente.Vente" %>
<%@ page import="vente.Proforma" %>

<% try{
    Proforma bc = new Proforma();
    String[] etatVal = {"","1","11", "0"};
    String[] etatAff = {"Tous","Cr&eacute;e(s)", "Vis&eacute;e(s)", "Annul&eacute;e(s)"};
    bc.setNomTable("PROFORMA");

    LocalDate today = LocalDate.now();
    LocalDate monday = today.with(previousOrSame(MONDAY));
    LocalDate sunday = today.with(nextOrSame(SUNDAY));

    if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("") != 0) {
        bc.setNomTable(request.getParameter("devise"));
    } else {
        bc.setNomTable("PROFORMA");
    }
    String listeCrt[] = {"id", "designation","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "designation","daty","montantRevient"};
    String libEnteteAffiche[] = {"id", "D&eacute;signation","Date","Montant de revient"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    if(request.getParameter("etat")!=null && request.getParameter("etat").compareToIgnoreCase("")!=0) {
        pr.setAWhere(" and etat=" + request.getParameter("etat"));
    } 
    pr.setTitre("Liste des proforma ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/proforma/proforma-liste.jsp");
    String[] colSomme = {};
    pr.getFormu().getChamp("id").setLibelle("ID");
//    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(monday)));
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.datetostring(Date.valueOf(sunday)));
    pr.creerObjetPage(libEntete, colSomme);
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
   
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=vente/proforma-modif.jsp");
    lienTab.put("Valider",pr.getLien() + "?&classe=vente.Proforma&but=apresTarif.jsp&bute=vente/proforma/proforma-fiche.jsp&acte=valider"+pr.getFormu().getChamp("id").getValeur()+"");
//    lienTab.put("Livrer",pr.getLien() + "?but=bondelivraison-client/apresLivraisonFacture.jsp&bute=vente/encaissement-modif.jsp" + pr.getFormu().getChamp("id").getValeur()+"");
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/proforma/proforma-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/proforma/inc/proforma-details.jsp&id=");
%>
<script>
     function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="vente" id="vente">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
            <div class="col-md-2"></div>
            <div class="col-md-8">
                <div class="row">
                    <!-- <div class="col-md-6">
                        Devises : 
                        <select name="devise" class="champ form-control" id="devise" onchange="changerDesignation()" >
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("vente_cpl_avec_montant") == 0) {%>
                            <option value="proforma" selected>Tous</option>
                            <% } else { %>
                            <option value="proforma">Tous</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("vente_cpl_avec_montant_mga") == 0) {%>
                            <option value="proforma" selected>AR</option>
                            <% } else { %>
                            <option value="proforma">AR</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("vente_cpl_avec_montant_eur") == 0) {%>
                            <option value="proforma" selected>EUR</option>
                            <% } else { %>
                            <option value="proforma">EUR</option>
                            <% } %>
                            <% if (request.getParameter("devise") != null && request.getParameter("devise").compareToIgnoreCase("vente_cpl_avec_montant_usd") == 0) {%>
                            <option value="proforma" selected>USD</option>
                            <% } else { %>
                            <option value="proforma">USD</option>
                            <% } %>
                        </select>
                    </div> -->
                    <div class="col-md-6">
                        &Eacute;tat :
                        <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()">
                                <%
                                    for( int i = 0; i < etatAff.length; i++ ){ %>
                                        <% if(request.getParameter("etat") !=null && request.getParameter("etat").compareToIgnoreCase(etatVal[i]) == 0) {%>
                                        <option value="<%= etatVal[i] %>" selected> <%= etatAff[i] %> </option>
                                        <% } else { %>
                                        <option value="<%= etatVal[i] %>"> <%= etatAff[i] %> </option>
                                        <% } %>
                                <%    }
                                %>
                        </select>
                    </div>
                </div>
                </br>
            </div>
            <div class="col-md-2"></div>
</div>

        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




