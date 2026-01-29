<%@page import="faturefournisseur.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="vente.BonDeCommandeCpl"%>
<%@ page import="fichier.AttacherFichier" %>
<%@ page import="uploadbean.UploadService" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>
<%
    try{
    BonDeCommandeCpl f = new BonDeCommandeCpl();
    f.setNomTable("BONDECOMMANDE_CLIENT_CPL");
    PageConsulte pc = new PageConsulte(f, request, u);
    pc.setTitre("Fiche du bon de commande");
    f = (BonDeCommandeCpl) pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
    pc.getChampByName("daty").setLibelle("date");
    pc.getChampByName("remarque").setLibelle("Remarque");
    pc.getChampByName("modepaiementlib").setLibelle("Mode de paiement");
    pc.getChampByName("designation").setLibelle("d&eacute;signation");
    pc.getChampByName("idclientlib").setLibelle("Client");
    pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("idclient").setVisible(false);
    pc.getChampByName("idMagasinLib").setLibelle("Point");
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("etat").setLibelle("&Eacute;tat");
      pc.getChampByName("modepaiement").setVisible(false);
       pc.getChampByName("echeance").setLibelle("Ech&eacute;ance");
       pc.getChampByName("modereglement").setLibelle("Mode de r&egrave;glement");
    String pageActuel = "vente/bondecommande/bondecommande-fiche.jsp";

    String lien = (String) session.getValue("lien");
    String pageModif = "vente/bondecommande/bondecommande-saisie.jsp";
    String classe = "vente.BonDeCommande";

    Map<String, String> map = new HashMap<String, String>();
    map.put("inc/bondecommande-detail", "");
    map.put("inc/vente-cpl-visee", "");
        map.put("inc/reservation-details", "");
        map.put("inc/plateau-commande", "");


    String tab = request.getParameter("tab");
    if (tab == null) {
        tab = "inc/bondecommande-detail";
    }

    map.put(tab, "active");
    tab = tab + ".jsp";
    f = (BonDeCommandeCpl)pc.getBase();
        AttacherFichier[] fichiers = UploadService.getUploadFile(request.getParameter("id"));
        configuration.CynthiaConf.load();
        String cdn = configuration.CynthiaConf.properties.getProperty("cdnReadUri");
        String projectName = pc.getChampByName("designation").getValeur()
                .replace("'","_")
                .replace("/","_")
                .replace("-","_")
                .replace(":", "_")
                .replace("*", "_")
                .replace(" ", "_");
        String dossierTemp = "bondDeCommande/files/"+projectName;
        String dossier = dossierTemp;
        String but = request.getParameter("but");
        String currentParams = "but=" + but + "&id=" + id;
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=vente/bondecommande/bondecommande-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (f.getEtat() < ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/bondecommande/bondecommande-fiche.jsp&classe=" + classe %> " style="margin-right: 10px">Viser</a>
                                <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <% } %>
                            <% if (f.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=reservation/reservation-groupe-saisie.jsp&idBC=" + id + "&classe=" + classe+"&idClient="+f.getIdClient()%> " style="margin-right: 10px"><i class="fa fa-calendar-alt"></i> R&eacute;servation</a>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=emission/parrainageemission-saisie.jsp&idBC=" + id + "&classe=" + classe+"&idClient="+f.getIdClient()%> " style="margin-right: 10px;"><i class="fa fa-tower-broadcast"></i> Parrainnage</a>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=emission/plateau-saisie.jsp&idBC=" + id + "&classe=" + classe+"&idClient="+f.getIdClient()%> " style="margin-right: 10px;background-color: #5bc0de; color: #fff;border-color:#5bc0de"><i class="fa fa-microphone"></i> Plateau</a>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/vente-saisie.jsp&id=" + id + "&classe=" + classe%> " style="margin-right: 10px; color: #fff;border-color:#299100"> <i class="fa fa-file-invoice"></i> Facturer</a>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree.jsp&idOp=" + id + "&idTiers=" + f.getIdClient()%> " style="margin-right: 10px">Acompte</a>
<%--                            <a class="btn btn-warning pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/bondecommande/apresFacturer.jsp&id=" + request.getParameter("id") + "&classe=" + classe%> " style="margin-right: 10px">Facturer</a>--%>
                            <% } %>
                            <a class="btn btn-info pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
                            <a class="btn btn-info pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=impression_bc&sans=false&type=smpc&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Export SMPC</a>
                            <a class="btn btn-primary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=impression_bc&sans=true&type=smpc&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Export SMPC sans en-t&ecirc;te</a>

                            <a class="btn btn-info pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=impression_bc&sans=false&type=kprod&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Export KPROD</a>
                            <a class="btn btn-primary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=impression_bc&sans=true&type=kprod&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Export KPROD sans en-t&ecirc;te</a>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") +"?but=vente/proforma/signature-modal.jsp&from=" + currentParams %>" style="margin-right: 10px">Signer</a>
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
                    <li class="<%=map.get("inc/bondecommande-detail")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/bondecommande-detail">Détails </a></li>
                    <li class="<%=map.get("inc/vente-cpl-visee")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/vente-cpl-visee">Détails de la facturation</a></li>
                    <li class="<%=map.get("inc/reservation-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/reservation-details">Détails de la planification</a></li>
                    <li class="<%=map.get("inc/plateau-commande")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/plateau-commande">Plateau</a></li>
                    <%-- <li class="<%=map.get("inc/factureclient-details")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/factureclient-details">Détails facturation</a></li> --%>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab %>" >
                        <jsp:param name="idbc" value="<%= id %>" />
                    </jsp:include>
                </div>
            </div>

        </div>
    </div>
    <div class="row">
        <%--        <div class="col-md-1"></div>--%>
        <div class="col-md-12 bottom-vente-fiche">
            <div class="box">
                <h2 class="box-title" style="margin-left: 10px;">Les fichiers attach&eacute;s</h2>
                <div class="box-body" style="padding: 0 20px 20px 20px;">
                    <table class="table table-striped table-bordered table-condensed tree" style="color: #4e4e4e;">
                        <thead>
                        <tr>
                            <th style="background-color: #2c3d91;color: white;"></th>
                            <th style="background-color: #2c3d91;color: white;">Libell&eacute;</th>
                            <th style="background-color: #2c3d91;color: white;">Fichier</th>
                            <th style="background-color: #2c3d91;color: white;">Date d`upload</th>
                            <th style="background-color: #2c3d91;color: white;">Telecharger</th>
                        </tr>
                        </thead>
                        <tbody>
                        <%if (fichiers == null || fichiers.length == 0) { %>
                        <tr>
                            <td colspan="3" style="text-align: center;"><strong>Aucun fichier</strong></td>
                        </tr>
                        <%} else {
                            for (AttacherFichier fichier : fichiers) {%>
                        <tr class="treegrid-1 treegrid-expanded">
                            <td><span class="treegrid-expander glyphicon glyphicon-minus"></span></td>
                            <td><%=fichier.getChemin()%></td>
                            <td><%=Utilitaire.champNull(fichier.getLibelle())%></td>
                            <td><%=fichier.getDaty()%></td>
                            <td>
                                <a href="../FileManager2?parent=<%= "/"+dossier + "/" +fichier.getChemin()  %>" class="btn btn-success" >Telecharger</a>
                            </td>
                        </tr>
                        <%}
                        }%>

                        </tbody>

                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<style>
    .bottom-vente-fiche {
        padding: 0 30px 0 30px; !important;
    }
</style>

<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>
