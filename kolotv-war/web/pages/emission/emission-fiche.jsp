<%--
    Author     : Toky20
--%>

<%@page import="emission.Emission"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.*" %>
<%@ page import="emission.EmissionLib" %>
<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>

<%
    EmissionLib objet = new EmissionLib();
    objet.setNomTable("EMISSION_LIB");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche d'&eacute;mission");
    pc.getBase();
    String id=pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("idSupportLib").setLibelle("Support");
    pc.getChampByName("idSupport").setVisible(false);

    pc.getChampByName("tarifplateau").setLibelle("Tarif plateau");
    pc.getChampByName("tarifparainage").setLibelle("Tarif parrainage");
    pc.getChampByName("secondeparainage").setLibelle("Nombre de spot");
    pc.getChampByName("idGenreLib").setLibelle("Genre");
    pc.getChampByName("idGenre").setVisible(false);
    pc.getChampByName("duree").setLibelle("Dur&eacute;e");

    String lien = (String) session.getValue("lien");
    String pageModif = "emission/emission-saisie.jsp";
    String classe = "emission.Emission";

    String pageActuel = "emission/emission-fiche.jsp";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/emission-details", "");
    map.put("inc/liste-parrainageemission", "");
    map.put("inc/plateau-emission", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/emission-details";
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
                        <h1 class="box-title"><a href=<%= lien + "?but=emission/emission-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>
                        <div class="box-footer">
                            <%if (u.getUser().getIdrole().equals("diffuseur")==false){ %>
                                <a class="btn btn-primary pull-right"  href="<%= lien + "?but=emission/parrainageemission-saisie.jsp&idEmission=" + id%>" style="margin-right: 10px">Parrainer</a>
                                <a class="btn btn-success pull-right"  href="<%= lien + "?but=emission/plateau-saisie.jsp&idEmission=" + id%>" style="margin-right: 10px">Plateau</a>
                                <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                                <a class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=emission/emission-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                            <%}%>
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
                    <li class="<%=map.get("inc/emission-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/emission-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/liste-parrainageemission")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-parrainageemission">Liste parrainage</a></li>
                    <li class="<%=map.get("inc/plateau-emission")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/plateau-emission">Liste participants</a></li>
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
