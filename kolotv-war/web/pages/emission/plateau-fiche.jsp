<%--
    Author     : Toky20
--%>

<%@page import="emission.ParticipantEmissionCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="emission.PlateauCpl" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>

<%
    PlateauCpl objet = new PlateauCpl();
    objet.setNomTable("PLATEAU_CPL");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche de plateau");
    PlateauCpl t = (PlateauCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    String lien = (String) session.getValue("lien");

    pc.getChampByName("id").setLibelle("id");
    pc.getChampByName("idClient").setVisible(false);
    pc.getChampByName("idClientLib").setLibelle("Client");
    pc.getChampByName("idClientlib").setLien(lien+"?but=client/client-fiche.jsp&id="+t.getIdClient(), "");
    pc.getChampByName("idEmission").setVisible(false);
    pc.getChampByName("idEmissionLib").setLibelle("&Eacute;mission");
    pc.getChampByName("idEmissionlib").setLien(lien+"?but=emission/emission-fiche.jsp&id="+t.getIdEmission(), "");

    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("dateReserver").setLibelle("Date Reserver");
    pc.getChampByName("etatlib").setLibelle("Etat");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idReservation").setLibelle("Reservation");
    pc.getChampByName("source").setVisible(false);

    if (t.getSource()!=null){
        pc.getChampByName("source").setVisible(true);
        if (t.getSource().startsWith("FCBC")){
            pc.getChampByName("source").setLien(lien+"?but=vente/bondecommande/bondecommande-fiche.jsp", "id=");
        }
    }
    if (t.getIdReservation()!=null){
        pc.getChampByName("idReservation").setLien(lien+"?but=reservation/reservation-fiche.jsp", "id=");
    }
    String pageModif = "emission/plateau-modif.jsp";
    String classe = "emission.Plateau";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=emission/plateau-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>
                        <div class="box-footer">
                            <% if (t.getEtat()<ConstanteEtat.getEtatValider()){ %>
                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=emission/plateau-fiche.jsp&classe=emission.Plateau&nomtable=PLATEAU"%> " style="margin-right: 10px">Viser</a>
                            <% } %>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=emission/plateau-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
