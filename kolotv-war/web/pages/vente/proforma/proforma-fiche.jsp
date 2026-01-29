<%@page import="vente.Proforma"%>
<%@ page import="utilitaire.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="fichier.AttacherFichier"%>
<%@page import="uploadbean.*"%>

<%
    try {
        //Information sur les navigations via la page
        String lien = (String) session.getValue("lien");
        String pageModif = "vente/proforma/proforma-saisie.jsp";
        String classe = "vente.Proforma";
        String pageActuel = "vente/proforma/proforma-fiche.jsp";

        //Information sur la fiche
        Proforma dp = new Proforma();
        dp.setNomTable("proforma");
        PageConsulte pc = new PageConsulte(dp, request, (user.UserEJB) session.getValue("u"));
        dp = (Proforma) pc.getBase();
        request.setAttribute("proforma", dp);
        String id = request.getParameter("id");

        pc.getChampByName("idOrigine").setLibelle("Origine");
        if (dp.getIdOrigine()!=null && dp.getIdOrigine().startsWith("RESA")){
            pc.getChampByName("idOrigine").setLien(lien+"?but=reservation/reservation-fiche.jsp", "id=");
        }
        if (dp.getIdOrigine()!=null && dp.getIdOrigine().startsWith("FCBC")){
            pc.getChampByName("idOrigine").setLien(lien+"?but=vente/bondecommande/bondecommande-fiche.jsp", "id=");
        }
        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("designation").setLibelle("R&eacute;f&eacute;rence");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("idMagasin").setVisible(false);
        pc.getChampByName("idClient").setVisible(false);
        pc.getChampByName("estPrevu").setVisible(false);
        pc.getChampByName("datyPrevu").setVisible(false);
        pc.getChampByName("idReservation").setVisible(false);
        pc.getChampByName("tva").setVisible(false);
        pc.getChampByName("echeance").setLibelle("&eacute;ch&eacute;ance");
        pc.getChampByName("reglement").setLibelle("r&egrave;glement");

        pc.setTitre("Details Proforma Client");
        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("proforma-details", "");
        if(dp.getEtat() >= ConstanteEtat.getEtatValider()) {
            map.put("mvtcaisse-details", "");
        }
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "proforma-details";
        }
        map.put(tab, "active");
        tab = "inc/" + tab + ".jsp";
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
        String dossierTemp = "vente/files/"+projectName;
        String dossier = dossierTemp;
//        pc.getTableau().setModalOnClick(true);
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=vente/proforma/proforma-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (dp.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-warning pull-right" href="<%= lien + "?but=" + pageModif + "&id=" + id + "&acte=update"%>" style="margin-right: 10px">Modifier</a>
                            <a class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute=vente/proforma/proforma-fiche.jsp&classe=" + classe%>"><button class="btn btn-danger" style="margin-right: 10px">Annuler</button></a>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/proforma/proforma-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                            <% }%>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/bondecommande/bondecommande-saisie.jsp&idorigine=" + id%> " style="margin-right: 10px">G&eacute;n&eacute;rer Bon de commande</a>

                            <a class="btn btn-info pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=impression_proforma&sans=false&type=smpc&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Export SMPC</a>
                            <a class="btn btn-primary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=impression_proforma&sans=true&type=smpc&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Export SMPC sans en-t&ecirc;te</a>

                            <a class="btn btn-info pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=impression_proforma&sans=false&type=kprod&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Export KPROD</a>
                            <a class="btn btn-primary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=impression_proforma&sans=true&type=kprod&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Export KPROD sans en-t&ecirc;te</a>
                            <br>
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
                    <li class="<%=map.get("proforma-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=proforma-details">D&eacute;tail(s)</a></li>
                        <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>

                    <li class="<%=map.get("pertegainimprevue-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=pertegainimprevue-details">Gain(s) ou perte(s)</a></li>
                    <% }%>
                </ul>
                <div class="tab-content">
                    <jsp:include page="<%= tab%>" >
                        <jsp:param name="idmere" value="<%= id%>" />
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
    <!--                                    <form action="../UploadDownloadFileServlet" method="get">
                                            <input type="submit" value="download">
                                            <input type="hidden" name="fileName" value="<%=cdn + dossier + "/" + fichier.getChemin()%>">
                                        </form>-->
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
    }%>
