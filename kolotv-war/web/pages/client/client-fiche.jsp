<%--
    Document   : client-fiche
    Created on : 22 mars 2024, 14:50:51
    Author     : SAFIDY
--%>

<%@page import="client.Client"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    Client  client = new Client();
    client.setNomTable("CLIENT");

    Map<String, String> map = new HashMap<String, String>();
        map.put("inc/liste-reservation", "");
        map.put("inc/facture-associes", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/liste-reservation" +
                    "";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche du Client");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("telephone").setLibelle("T&eacute;l&eacute;phone");
    pc.getChampByName("mail").setLibelle("Adresse e-mail");
    pc.getChampByName("adresse").setLibelle("Adresse");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("type").setLibelle("Type");
    pc.getChampByName("daty").setLibelle("Date");
    String lien = (String) session.getValue("lien");
    String pageActuel = "client/client-fiche.jsp";
    String pageModif = "client/client-modif.jsp";
    String classe = "client.Client";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=client/client-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=client/client-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
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
                    <li class="<%=map.get("inc/liste-reservation")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-reservation">R&eacute;servations</a></li>
                    <li class="<%=map.get("inc/facture-associes")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/facture-associes">Facture associ&eacute;es</a></li>
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

