<%--
    Author     : Toky20
--%>

<%@page import="emission.ParrainageEmissionCpl"%>
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
    ParrainageEmissionCpl objet = new ParrainageEmissionCpl();
    objet.setNomTable("PARRAINAGEEMISSION_CPL");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche de parrainage &eacute;mission");
    ParrainageEmissionCpl t = (ParrainageEmissionCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    String lien = (String) session.getValue("lien");

    pc.getChampByName("id").setLibelle("id");
    pc.getChampByName("idclient").setVisible(false);
    pc.getChampByName("idemission").setVisible(false);
    pc.getChampByName("datedebut").setLibelle("Date de d&eacute;but");
    pc.getChampByName("datefin").setLibelle("Date de fin");
    pc.getChampByName("idclientlib").setLibelle("Client");
    pc.getChampByName("idclientlib").setLien(lien+"?but=client/client-fiche.jsp&id="+t.getIdclient(), "");
    pc.getChampByName("idemissionlib").setLibelle("&Eacute;mission");
    pc.getChampByName("idemissionlib").setLien(lien+"?but=emission/emission-fiche.jsp&id="+t.getIdemission(), "");
    pc.getChampByName("qte").setLibelle("Quantit&eacute;");
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
    pc.getChampByName("etatlib").setVisible(false);
//    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idreservation").setLibelle("R&eacute;servation");
    pc.getChampByName("billiboardIn").setVisible(false);
    pc.getChampByName("billBoardInLib").setLibelle("Billboard IN");
    pc.getChampByName("billiboardOut").setVisible(false);
    pc.getChampByName("billBoardOutLib").setLibelle("Billboard OUT");
    pc.getChampByName("source").setVisible(false);
    pc.getChampByName("qteAvant").setLibelle("Quantit&eacute; Avant");
    pc.getChampByName("qtePendant").setLibelle("Quantit&eacute; Pendant");
    pc.getChampByName("qteApres").setLibelle("Quantit&eacute; Apr&egrave;s");
    pc.getChampByName("dureeAvant").setLibelle("Dur&eacute;e Avant");
    pc.getChampByName("dureePendant").setLibelle("Dur&eacute;e Pendant");
    pc.getChampByName("dureeApres").setLibelle("Dur&eacute;e Apr&egrave;s");


    if (t.getSource()!=null){
        pc.getChampByName("source").setVisible(true);
        if (t.getSource().startsWith("FCBC")){
            pc.getChampByName("source").setLien(lien+"?but=vente/bondecommande/bondecommande-fiche.jsp", "id=");
        }
    }
    if (t.getIdreservation()!=null){
        pc.getChampByName("idreservation").setLien(lien+"?but=reservation/reservation-fiche.jsp", "id=");
    }

    String pageModif = "emission/parrainageemission-modif.jsp";
    String classe = "emission.ParrainageEmission";
    String pageActuel = "emission/parrainageemission-fiche.jsp";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/parrainageemission-details", "");
    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/parrainageemission-details";
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
                        <h1 class="box-title"><a href=<%= lien + "?but=emission/parrainageemission-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>
                        <div class="box-footer">
                            <% if (t.getEtat()<ConstanteEtat.getEtatValider()){ %>
                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=emission/parrainageemission-fiche.jsp&classe=emission.ParrainageEmission&nomtable=PARRAINAGEEMISSION"%> " style="margin-right: 10px">Viser</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=emission/parrainageemission-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
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
                    <li class="<%=map.get("inc/parrainageemission-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/parrainageemission-details">Details</a></li>
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
