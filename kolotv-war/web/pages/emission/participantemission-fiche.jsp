<%--
    Author     : Toky20
--%>

<%@page import="emission.ParticipantEmissionCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>

<%
    ParticipantEmissionCpl objet = new ParticipantEmissionCpl();
    objet.setNomTable("PARTICIPANTEMISSION_CPL");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche de participant &eacute;mission");
    pc.getBase();
    String id=pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("id");
    pc.getChampByName("nom").setLibelle("Nom");
    pc.getChampByName("contact").setLibelle("Contact");
    pc.getChampByName("adresse").setLibelle("Adresse");
    pc.getChampByName("datedenaissance").setLibelle("Date de naissance");
    pc.getChampByName("idemission").setLibelle("ID Emission");
    pc.getChampByName("idemissionlib").setLibelle("libell&eacute; &eacute;mission");

    String lien = (String) session.getValue("lien");
    String pageModif = "emission/participantemission-modif.jsp";
    String classe = "emission.ParticipantEmission";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=emission/participantemission-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=emission/participantemission-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
