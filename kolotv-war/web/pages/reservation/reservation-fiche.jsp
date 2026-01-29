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
<%@ page import="reservation.ReservationLib" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="user.UserEJB" %>
<%@ page import="utils.ConstanteKolo" %>

<%
    try{
        String ismodal = request.getParameter("ismodal");
        String lien = (String) session.getValue("lien");
        UserEJB user = (UserEJB) session.getValue("u");
        ReservationLib t = new ReservationLib();
        PageConsulte pc = new PageConsulte(t, request, (user.UserEJB) session.getValue("u"));
        t = (ReservationLib) pc.getBase();
        String id=pc.getBase().getTuppleID( );
        pc.getChampByName("id").setLibelle("ID");
        pc.getChampByName("idclient").setVisible(false);
        pc.getChampByName("idclientlib").setLibelle("Client");
        pc.getChampByName("idclientlib").setLien(lien+"?but=client/client-fiche.jsp&id="+t.getIdclient(), "");
        pc.getChampByName("daty").setLibelle("Date de R&eacute;servation");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("montant").setLibelle("Montant HT");
        pc.getChampByName("montantTva").setLibelle("Montant TVA");
        pc.getChampByName("montantTTC").setLibelle("Montant TTC");
        pc.getChampByName("montantRemise").setVisible(false);
        pc.getChampByName("montantFinal").setVisible(false);
        pc.getChampByName("paye").setLibelle("Montant paye");
        pc.getChampByName("resteAPayer").setLibelle("Reste &agrave; payer");
        pc.getChampByName("idBc").setLibelle("Bon de commande");
        pc.getChampByName("idSupportLib").setLibelle("Support");
        pc.getChampByName("idSupportLib").setLien(lien+"?but=support/support-fiche.jsp&id="+t.getIdSupport(), "");
        pc.getChampByName("source").setVisible(false);
        if (t.getSource()!=null){
            pc.getChampByName("source").setVisible(true);
            if (t.getSource().startsWith("PRE")){
                pc.getChampByName("source").setLien(lien+"?but=emission/parrainageemission-fiche.jsp", "id=");
            }
            if (t.getSource().startsWith("PLT")){
                pc.getChampByName("source").setLien(lien+"?but=emission/plateau-fiche.jsp", "id=");
            }
        }
        if (t.getIdBc()!=null){
            pc.getChampByName("idBc").setLien(lien+"?but=vente/bondecommande/bondecommande-fiche.jsp", "id=");
        }
        pc.setTitre("Fiche R&eacute;servation");
        String pageModif = "reservation/reservation-groupe-modif.jsp";
        String pageActuel = "reservation/reservation-fiche.jsp";
        String classe = "reservation.ReservationLib";
        String nomTable = "RESERVATION_LIB";


        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/reservation-planning", "");
        map.put("inc/reservation-details", "");
        map.put("inc/liste-checkin", "");
        map.put("inc/liste-checkout", "");
        map.put("inc/reservation-paiement", "");
        map.put("inc/reservation-facture", "");
        map.put("inc/liste-acte-service", "");
        map.put("inc/diffusion-rattache","");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/reservation-details";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";
        ReservationLib dp=(ReservationLib)pc.getBase();

        String temp="";
        temp=temp+ "<div class=\"modal fade\" id=\"linkModal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"linkModalLabel\" aria-hidden=\"true\">\r\n" +
                "  <div style='width:60%;background:transparent;' class=\"modal-dialog modal-dialog-centered\" role=\"dialog\">\r\n" + //
                "    <div style=\"border-radius: 16px;padding:15px;\" class=\"modal-content\">\r\n" + //
                "      <div class=\"modal-body\">\r\n"+
                "       <div id=\"modalContent\">\r\n>";
        temp +=                "</div>\r\n" + //
                "    </div>\r\n" + //
                "   </div>\r\n" + //
                "  </div>\r\n" + //
                "</div>";

        String support = pc.getChampByName("idSupportLib").getValeur();
        String date = pc.getChampByName("daty").getValeur();
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                    <h1 class="box-title"><a href="<%=lien%>?but=reservation/reservation-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a><% out.println(pc.getTitre()); %></h1>
                    </div>
                    <div class="box-body">
                        <%
                           out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (user.getUser().getIdrole().equalsIgnoreCase("diffuseur")==false){ %>
                                <% if (t.getEtat()<ConstanteEtat.getEtatValider()){ %>
                                <a href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=annuler&bute=reservation/reservation-fiche.jsp&classe="+classe %>" style="margin-right: 10px"><button class="btn btn-danger">Annuler</button></a>
                                <a class="btn btn-success" href="<%= lien + "?but=apresTarif.jsp&acte=valider&id=" + id + "&bute=reservation/reservation-fiche.jsp&classe=reservation.Reservation&nomtable=RESERVATION"%> " style="margin-right: 10px">Viser</a>
                                <% } %>
                                <a class="btn btn-warning pull-left"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Mettre &agrave; jour</a>
                                <a class="btn btn-info pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + pc.getBase().getClass().getSimpleName() + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("id").getValeur() %>" style="margin-right: 10px;">Attacher Fichier</a>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree-fc.jsp&idOp=" + request.getParameter("id") + "&montant="+(dp.getMontantTTC())*ConstanteAsync.propAvance +"&devise=AR&&tiers="+dp.getIdclient() %> " style="margin-right: 10px">Acompte</a>
                                <% if (t.getEtat() >= ConstanteEtat.getEtatValider()){ %>
                                <a class="btn btn-primary" href="<%= lien + "?but=vente/vente-saisie.jsp&id=" + id %> " style="margin-right: 10px">Facturer</a>
                                <a class="btn btn-primary" href="<%= lien + "?but=apresReservation.jsp&acte=diffuser&id=" + id+ "&bute=reservation/reservation-fiche.jsp&classe=reservation.Reservation&nomtable=RESERVATION" %>" style="margin-right: 10px">Diffuser</a>
<%--                                    <% if (t.getEtat()== ConstanteKolo.etatSuspendu){ %>--%>
<%--                                        <a class="btn btn-warning" href="<%= lien + "?but=apresReservation.jsp&acte=relancer&id=" + id+ "&bute=reservation/reservation-fiche.jsp&classe=reservation.Reservation&nomtable=RESERVATION" %>" style="margin-right: 10px">Relancer</a>--%>
<%--                                    <%}else {%>--%>
<%--                                        <a class="btn btn-danger" href="<%= lien + "?but=apresReservation.jsp&acte=suspendre&id=" + id+ "&bute=reservation/reservation-fiche.jsp&classe=reservation.Reservation&nomtable=RESERVATION" %>" style="margin-right: 10px">Suspendre</a>--%>
<%--                                    <% } %>--%>
                                <% } %>
                                <a class="btn btn-primary pull-right" href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/inc/reservation-dupliquer.jsp&id=<%=id%>&date=<%=date%>&support=<%=support%>','modalContent')" style="margin-right: 10px">Dupliquer</a>
                            <% } %>

                            <a class="btn btn-success pull-right"  href="${pageContext.request.contextPath}/ExportCSV?action=exp_reservation&idReservation=<%=request.getParameter("id")%>" style="margin-right: 10px">Export Excel</a>
                            <a class="btn btn-success pull-right"  href="${pageContext.request.contextPath}/ExportCSV?action=exp_reservation_mattraquage&idReservation=<%=request.getParameter("id")%>" style="margin-right: 10px">Export Mattraquage</a>

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
                    <%
                        if (ismodal != null && ismodal.equalsIgnoreCase("true"))
                        {
                    %>
                        <li class="<%=map.get("inc/reservation-details")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-details&ismodal=true','modalContent')">D&eacute;tails</a></li>
<%--                        <li class="<%=map.get("inc/liste-checkin")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-checkin&ismodal=true','modalContent')">Check In effectu&eacute;s</a></li>--%>
<%--                        <li class="<%=map.get("inc/liste-checkout")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-checkout&ismodal=true','modalContent')">Check Out effectu&eacute;s</a></li>--%>
                        <li class="<%=map.get("inc/reservation-paiement")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-paiement&ismodal=true','modalContent')">Liste Paiement effectu&eacute;s </a></li>
<%--                        <li class="<%=map.get("inc/liste-acte-service")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/liste-acte-service&ismodal=true','modalContent')">Services medias rattachés</a></li>--%>
                        <li class="<%=map.get("inc/reservation-facture")%>"><a href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-fiche.jsp&id=<%= id %>&tab=inc/reservation-facture&ismodal=true','modalContent')">Liste Facture  </a></li>
                    <%}else {%>
                    <li class="<%=map.get("inc/reservation-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-details">D&eacute;tails</a></li>
                    <li class="<%=map.get("inc/reservation-planning")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-planning">Planning</a></li>
                    <%--                        <li class="<%=map.get("inc/liste-checkin")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-checkin">Check In effectu&eacute;</a></li>--%>
<%--                        <li class="<%=map.get("inc/liste-checkout")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-checkout">Check Out effectu&eacute;</a></li>--%>
                        <li class="<%=map.get("inc/reservation-paiement")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-paiement">Liste Paiement effectu&eacute;s </a></li>
<%--                        <li class="<%=map.get("inc/liste-acte-service")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/liste-acte-service">Services medias rattachés</a></li>--%>
                        <li class="<%=map.get("inc/reservation-facture")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%=id %>&tab=inc/reservation-facture">Liste Facture</a></li>
                        <li class="<%=map.get("inc/diffusion-rattache")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%=id %>&tab=inc/diffusion-rattache">Diffusion Rattache</a></li>
                    <%}%>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="id" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>

    <div class="row">
        <%=pc.getHtmlAttacherFichier()%>
    </div>


</div>
<% out.println(temp);%>


<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>

