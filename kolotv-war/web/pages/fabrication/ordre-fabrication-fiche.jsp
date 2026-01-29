<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 2025-04-01
  Time: 16:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fabrication.Of" %>
<%@ page import="utilitaire.Constante" %>
<%@ page import="utils.ConstanteProcess" %>
<%@ page import="oracle.jdbc.driver.Const" %>

<%
    try{
        Of t = new Of();
        t.setNomTable("OFABLIB");
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (Of) pc.getBase();
        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("lancepar").setLibelle("Lanc&eacute; par");
        pc.getChampByName("cible").setLibelle("Cible");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("libelle").setLibelle("D&eacute;signation");
        pc.getChampByName("besoin").setLibelle("Besoin");
        pc.getChampByName("daty").setLibelle("Date");
        //pc.getChampByName("etat").setVisible(false);
        pc.setTitre("Fiche Ordre de Fabrication");
        String lien = (String) session.getValue("lien");
        String pageModif = "fabrication/ordre-fabrication-modif.jsp";
        String pageActuel = "fabrication/ordre-fabrication-fiche.jsp";
        String classe = "fabrication.Of";
        String nomTable = "OFAB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/ordre-fabrication-details", "");
        map.put("inc/liste-fabrication-of", "");
        map.put("inc/ordre-fabrication-historique", "");
        map.put("inc/ordre-fabrication-besoins", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/ordre-fabrication-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="#"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuel+"&classe="+classe %>" style="margin-right: 10px"><button class="btn btn-danger">Supprimer</button></a>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=fabrication.Of&nomtable=OFAB"%> " style="margin-right: 10px">Viser</a>
                            <%if (t.getEtat()>= ConstanteEtat.getEtatValider()){%>
                            <a class="btn btn-success" href="<%= lien + "?but=fabrication/fabrication-saisie.jsp&idOF=" + id %> " style="margin-right: 10px">Fabriquer</a>
                            <%}%>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase("11")||pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.bloque))) { %>    <%-- VALIDEE --%>
                            <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=entamer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-success">(Re)Entamer</button></a>
                            <% } %>
                            <% if (pc.getChampByName("etat").getValeur().equalsIgnoreCase(String.valueOf(ConstanteProcess.entame))) { %>    <%-- ENTAMMEE --%>
                            <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=bloquer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-warning">Bloquer</button></a>
                            <a href="<%= lien + "?but=process/process-saisie.jsp&id=" + id+"&nomProcess=terminer&objet=fabrication.Of" %>" style="margin-right: 10px"><button class="btn btn-success">Terminer</button></a>
                            <% } %>

                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="nav-tabs-custom">
                <ul class="nav nav-tabs">
                    <!-- a modifier -->
                    <li class="<%=map.get("inc/ordre-fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/liste-fabrication-of")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-fabrication-of">Fabrications</a></li>
                       <li class="<%=map.get("inc/ordre-fabrication-besoins")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-besoins">Besoins</a></li>
                    <li class="<%=map.get("inc/ordre-fabrication-historique")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/ordre-fabrication-historique">Historique</a></li>
<%--                    <li class="<%=map.get("inc/facture-client-paiement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-client-paiement">Paiements associ&eacute;s</a></li>--%>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>


</div>


<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>


