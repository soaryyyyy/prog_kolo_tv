<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="fabrication.FabricationCpl" %>
<%@ page import="utilitaire.Constante" %>
<%@ page import="utils.ConstanteProcess" %>

<%
    try{
        String lien = (String) session.getValue("lien");
        FabricationCpl t = new FabricationCpl();
        t.setNomTable("FabricationCpl");
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (FabricationCpl) pc.getBase();
        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("lanceparLib").setLibelle("Lanc&eacute; par");
        pc.getChampByName("lancepar").setVisible(false);
        pc.getChampByName("cibleLib").setLibelle("Cible");
        pc.getChampByName("cible").setVisible(false);
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("libelle").setLibelle("D&eacute;signation");
        pc.getChampByName("besoin").setLibelle("Besoin");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("idOf").setLien(lien+"?but=fabrication/ordre-fabrication-fiche.jsp", "id=");
        pc.getChampByName("idOf").setLibelle(" Ordre de fabrication associ&eacute;");
        pc.getChampByName("etatlib").setVisible(false);
        pc.setTitre("Fiche de Fabrication");
        String pageModif = "fabrication/fabrication-modif.jsp";
        String pageActuel = "fabrication/fabrication-fiche.jsp";
        String pageActuelListe = "fabrication/fabrication-liste.jsp";
        String classe = "fabrication.Fabrication";
        String nomTable = "FabricationAB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/fabrication-details", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/fabrication-details";
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
                        <h1 class="box-title"><a href="<%= lien + "?but=" +pageActuelListe %>"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute="+pageActuelListe+"&classe="+classe %>&nomtable=fabrication" style="margin-right: 10px"><button class="btn btn-danger">Supprimer</button></a>
                            <% if(t.getEtat()==1){ %>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute="+pageActuel+"&classe=fabrication.Fabrication&nomtable=fabrication"%> " style="margin-right: 10px">Valider</a>
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
                    <li class="<%=map.get("inc/fabrication-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/fabrication-mvtstock")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/fabrication-mvtstock">Mouvement de stock</a></li>
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


