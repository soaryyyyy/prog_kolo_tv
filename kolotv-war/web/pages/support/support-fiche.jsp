<%--
    Author     : Toky20
--%>

<%@page import="support.SupportCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>


<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    SupportCpl objet = new SupportCpl();
    objet.setNomTable("Support_cpl");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche Support");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("libell&eacute;");
    pc.getChampByName("desce").setLibelle("Description");
    pc.getChampByName("idPointLib").setLibelle("Point");
    String lien = (String) session.getValue("lien");
    String pageModif = "support/support-modif.jsp";
    String classe = "support.SupportCpl";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/plage-details", "");
    map.put("inc/service-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/service-details";
    }
    map.put(tab, "active");
    tab = tab + ".jsp";

    String pageActuel = "support/support-fiche.jsp";

%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=support/support-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=support/support-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                            <a class="btn btn-success pull-right"  href="<%= lien + "?but=plage/plage-saisie.jsp&idSupport=" + id%>" style="margin-right: 10px">Ajouter une plage</a>
                            <a class="btn btn-primary pull-right"  href="<%= lien + "?but=produits/services-saisie.jsp&idSupport=" + id%>" style="margin-right: 10px">Ajouter un service</a>
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
                    <li class="<%=map.get("inc/service-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/service-details">Services de diffusion</a></li>
                    <li class="<%=map.get("inc/plage-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/plage-details">Plages horaires</a></li>
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


