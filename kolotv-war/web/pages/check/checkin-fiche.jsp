<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetails" %>
<%@ page import="reservation.Check" %>
<%@ page import="reservation.CheckInLib" %>
<% 
    try{
        String lien = (String) session.getValue("lien");
        CheckInLib t = new CheckInLib();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (CheckInLib) pc.getBase();
        String id=pc.getBase().getTuppleID();
        pc.getChampByName("id").setLibelle("ID");
        //pc.getChampByName("idclient").setVisible(false);
        pc.getChampByName("client").setLibelle("Client");
        pc.getChampByName("client").setLien(lien+"?but=client/client-fiche.jsp", "id=");
        pc.getChampByName("reservation").setLibelle("R&eacute;servation");
        pc.getChampByName("reservation").setLien(lien+"?but=reservation/reservation-fiche.jsp&tab=inc/liste-checkin", "id=");
        pc.getChampByName("daty").setLibelle("Date de R&eacute;servation");
        pc.getChampByName("idclient").setVisible(false);
        pc.getChampByName("idProduit").setVisible(false);
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("pu").setLibelle("Prix Unitaire");
        pc.getChampByName("tva").setLibelle("TVA");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("Etat");
        pc.getChampByName("produitLibelle").setLibelle("Services");
        pc.getChampByName("remarque").setLibelle("Remarque"); 
        pc.setTitre("Fiche CheckIn");
        String pageModif = "check/checkin-modif.jsp";
        String pageActuel = "check/checkin-fiche.jsp";
        String classe = "reservation.Check";
        String nomTable = "CHECKINLIBELLE";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/liste-acte", ""); 
        map.put("inc/reservation-facture", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        Check dp=(Check)pc.getBase();
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                    <h1 class="box-title"><a href="#"><i class="fa fa-arrow-circle-left"></i></a><% out.println(pc.getTitre()); %></h1>
                    </div>
                    <div class="box-body">
                        <%
                           out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=check/checkin-fiche.jsp&classe="+classe %>" style="margin-right: 10px"><button class="btn btn-danger">Annuler</button></a>
                            <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=reservation/reservation-fiche.jsp&idresa="+pc.getChampByName("reservation").getValeur()+"&classe="+classe+"&nomtable=checkIn&tab=inc/liste-checkin"%> " style="margin-right: 10px" onsubmit="closeModal()">Viser</a>
                            <a class="btn btn-primary" href="<%= lien + "?but=vente/vente-saisie.jsp&id=" + id %> " style="margin-right: 10px">Facturer</a>
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
                    <li class="<%=map.get("inc/reservation-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&idreservation=<%= id %>&tab=inc/reservation-facture">Liste Facture </a></li>
                    <li class="<%=map.get("inc/liste-acte")%>"><a href="<%= lien %>?but=<%= pageActuel %>&idreservation=<%= id %>&tab=inc/liste-acte">Liste Services rattrachees</a></li>
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

