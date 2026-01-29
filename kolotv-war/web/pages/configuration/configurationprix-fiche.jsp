<%--
    Author     : Toky20
--%>

<%@page import="prix.ConfigurationPrixCpl"%>
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
    ConfigurationPrixCpl  configurationPrixCpl = new ConfigurationPrixCpl();
    configurationPrixCpl.setNomTable("CONFIGURATIONPRIX_CPL");

    PageConsulte pc = new PageConsulte(configurationPrixCpl, request, u);
    String lien = (String) session.getValue("lien");
    pc.setTitre("Fiche de configuration prix");
    configurationPrixCpl = (ConfigurationPrixCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("idIngredientLib").setLibelle("Service M&eacute;dia");
    pc.getChampByName("idIngredientLib").setLien(lien+"?but=produits/as-ingredients-fiche.jsp&id="+configurationPrixCpl.getIdingredient(), "");
    pc.getChampByName("pu").setLibelle("PU hors prime time commercial");
    pc.getChampByName("pu1").setLibelle("PU prime time commercial");
    pc.getChampByName("pu2").setLibelle("PU emission commercial");
    pc.getChampByName("pu3").setLibelle("PU hors prime time institutionnel");
    pc.getChampByName("pu4").setLibelle("PU prime time institutionnel");
    pc.getChampByName("pu5").setLibelle("PU &eacute;mission institutionnel");
    pc.getChampByName("pu3").setVisible(false);
    pc.getChampByName("pu4").setVisible(false);
    pc.getChampByName("pu5").setVisible(false);
    pc.getChampByName("idingredient").setVisible(false);
    pc.getChampByName("etatLib").setLibelle("Etat");
    String pageModif = "configuration/configurationprix-modif.jsp";
    String classe = "prix.ConfigurationPrix";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=configuration/configurationprix-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-success pull-right" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=configuration/configurationprix-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                            <%-- <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a> --%>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=configuration/configurationprix-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

