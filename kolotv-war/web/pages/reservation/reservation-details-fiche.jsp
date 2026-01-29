<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@ page import="reservation.ReservationDetailsAvecDiffusion" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="utils.ConstanteKolo" %>

<%
    try{
        String lien = (String) session.getValue("lien");
        ReservationDetailsAvecDiffusion t = new ReservationDetailsAvecDiffusion();
        t.setNomTable("RESERVATIONDETAILS_SANSETAT");
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (ReservationDetailsAvecDiffusion) pc.getBase();
        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("idBcFille").setVisible(false);
        pc.getChampByName("idmere").setLien(lien+"?but=reservation/reservation-fiche.jsp", "id=");
        pc.getChampByName("daty").setLibelle("Date de R&eacute;servation");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatLib").setVisible(false);
        pc.getChampByName("etatMere").setVisible(false);
        pc.getChampByName("montant").setLibelle("Montant HT");
        pc.getChampByName("libelleproduit").setLibelle("Service");
        pc.getChampByName("libellemedia").setLibelle("M&eacute;dia");
        pc.getChampByName("categorieproduit").setVisible(false);
        pc.getChampByName("categorieproduitlib").setVisible(false);
        pc.getChampByName("idMediaLib").setVisible(false);
        pc.getChampByName("idMedia").setVisible(false);
        pc.getChampByName("idSupportLib").setLibelle("Support");
        pc.getChampByName("qte").setVisible(false);
        pc.getChampByName("pu").setVisible(false);
        pc.getChampByName("idDiffusion").setVisible(false);
        pc.getChampByName("idproduit").setVisible(false);
        pc.getChampByName("heureDiffusion").setVisible(false);
        pc.getChampByName("dureeDiffusion").setVisible(false);
        pc.getChampByName("idSupport").setVisible(false);
        pc.getChampByName("remise").setVisible(false);
        pc.getChampByName("tva").setLibelle("TVA %");
        pc.getChampByName("montantTva").setLibelle("Montant TVA");
        pc.getChampByName("montantTtc").setLibelle("Montant TTC");
        pc.getChampByName("montantRemise").setVisible(false);
        pc.getChampByName("montantFinal").setLibelle("Montant Final");
        pc.getChampByName("duree").setLibelle("Dur&eacute;e");
        pc.getChampByName("codeCouleur").setLibelle("Code Couleur");
        pc.getChampByName("etatDiffusion").setLibelle("&Eacute;tat de duffusion");
        pc.setTitre("Fiche de R&eacute;servation");
        String pageModif = "reservation/reservation-modif.jsp";
        String pageActuel = "reservation/reservation-fiche.jsp";
        String classe = "reservation.ReservationDetailsLib";
        String nomTable = "RESERVATIONDETAILS_LIB";

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/reservation-fille-details","");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/reservation-fille-details";
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
                        <h1 class="box-title"><% out.println(pc.getTitre()); %></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (t.getEtatMere() != ConstanteKolo.etatSuspendu) { %>
                                <% if (t.getEtatMere() >= ConstanteEtat.getEtatValider()) { %>
                                    <% if (t.getIdDiffusion() == null) { %>
                                        <a class="btn btn-primary" href="<%= lien + "?but=apresReservation.jsp&acte=diffuserFille&id=" + id+ "&bute=reservation/reservation-details-fiche.jsp&classe=reservation.ReservationDetails&nomtable=RESERVATIONDETAILS" %>" style="margin-right: 10px">Diffuser</a>
                                        <a class="btn btn-primary" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/inc/reservation-report.jsp&','modalContent')" style="margin-right: 10px">Reporter</a>
                                    <% } %>
                            <% } %>
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
                    <li class="<%=map.get("inc/reservation-fille-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%=id %>&tab=inc/diffusion-rattache">Diffusion Rattache</a></li>
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

