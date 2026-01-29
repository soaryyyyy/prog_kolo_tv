<%@page import="vente.VenteLib"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="constante.ConstanteEtat" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@page import="fichier.AttacherFichier"%>
<%@page import="configuration.*"%>
<%@page import="uploadbean.*"%>

<%
    try {
        //Information sur les navigations via la page
        String lien = (String) session.getValue("lien");
        UserEJB u = (UserEJB) session.getValue("u");
        String pageModif = "vente/vente-saisie.jsp";
        String classe = "vente.Vente";
        String pageActuel = "vente/vente-fiche.jsp";

        //Information sur la fiche
        VenteLib dp = new VenteLib();
        PageConsulte pc = new PageConsulte(dp, request, (user.UserEJB) session.getValue("u"));
        dp = (VenteLib) pc.getBase();
        request.setAttribute("vente", dp);
        String id = request.getParameter("id");
        String but = request.getParameter("but");
        String currentParams = "but=" + but + "&id=" + id;

        pc.getChampByName("idOrigine").setLibelle("Origine");
        if (dp.getIdOrigine()!=null && dp.getIdOrigine().startsWith("RESA")){
            pc.getChampByName("idOrigine").setLien(lien+"?but=reservation/reservation-fiche.jsp", "id=");
        }
        if (dp.getIdOrigine()!=null && dp.getIdOrigine().startsWith("FCBC")){
            pc.getChampByName("idOrigine").setLien(lien+"?but=vente/bondecommande/bondecommande-fiche.jsp", "id=");
        }
        pc.getChampByName("id").setLibelle("Id");
        pc.getChampByName("designation").setLibelle("D&eacute;signation");
        pc.getChampByName("remarque").setLibelle("Remarque");
        pc.getChampByName("daty").setLibelle("Date");
        pc.getChampByName("etat").setVisible(false);
        pc.getChampByName("idMagasin").setVisible(false);
        pc.getChampByName("etatlib").setLibelle("&Eacute;tat");
        pc.getChampByName("idDevise").setLibelle("Devise");
        pc.getChampByName("idMagasinLib").setLibelle("Magasin");
        pc.getChampByName("idClient").setVisible(false);
        pc.getChampByName("idClientLib").setLibelle("Client");
        pc.getChampByName("idClientLib").setLien(lien+"?but=client/client-fiche.jsp&id="+dp.getIdClient(), "");
        pc.getChampByName("montanttotal").setLibelle("Montant HT");
        pc.getChampByName("montanttva").setLibelle("Montant TVA");
        pc.getChampByName("montantttc").setLibelle("Montant TTC");
        pc.getChampByName("montantTtcAr").setLibelle("Montant TTC en Ariary");
        pc.getChampByName("montantTtcAr").setVisible(false);
        pc.getChampByName("Montantpaye").setLibelle("Montant Pay&eacute;");
        pc.getChampByName("Montantreste").setLibelle("Reste &agrave; payer");
        pc.getChampByName("Tauxdechange").setLibelle("Taux de change");
        pc.getChampByName("montantRevient").setLibelle("Montant de revient");
        pc.getChampByName("margeBrute").setLibelle("Marge Brute");
        pc.getChampByName("margeBrute").setVisible(false);
        pc.getChampByName("echeance").setLibelle("&eacute;ch&eacute;ance");
        pc.getChampByName("reglement").setLibelle("r&egrave;glement");
        pc.getChampByName("reference").setLibelle("R&eacute;f&eacute;rence");
        pc.getChampByName("referenceBc").setLibelle("R&eacute;f&eacute;rence de bon de commande");
        pc.getChampByName("idReservation").setLibelle("R&eacute;servation");
        pc.setTitre("Details de la facture Client");
        Onglet onglet = new Onglet("page1");
        onglet.setDossier("inc");
        Map<String, String> map = new HashMap<String, String>();
        map.put("vente-details", "");
        map.put("encaissement-vise-liste", "");
        map.put("livraison-detail", "");
        map.put("liste-prevision", "");
        if(dp.getEtat() >= ConstanteEtat.getEtatValider()) {
            map.put("mvtcaisse-details", "");
            map.put("ecriture-detail", "");
            map.put("avoirfc-details", "");
        }
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "vente-details";
        }
        map.put("avoir-details", "");
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

        String[] ordre = {"daty","reference","referenceBc"};
        pc.setOrdre(ordre);
//        pc.getTableau().setModalOnClick(true);
%>

<style type="text/css">
    /* div {
       margin-top: 1em;
       margin-bottom: 1em;
   }

   input {
       padding: .5em;
       margin: .5em;
   }

   select {
       padding: .5em;
       margin: .5em;
   } */

    #signatureparent {
        color: darkblue;
        background-color: darkgrey;
        padding: 20px;
    }

    /* This is the div within which the signature canvas is fitted */
    #signature {
        border: 2px dotted black;
        background-color: lightgrey;
        height: 500px;
    }

    /* Drawing the 'gripper' for touch-enabled devices */
    html.touch #content {
        float: left;
        width: 92%;
    }

    html.touch #scrollgrabber {
        float: right;
        width: 4%;
        margin-right: 2%;
        background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAAFCAAAAACh79lDAAAAAXNSR0IArs4c6QAAABJJREFUCB1jmMmQxjCT4T/DfwAPLgOXlrt3IwAAAABJRU5ErkJggg==)
    } */

    html.borderradius #scrollgrabber {
        border-radius: 1em;
    }
</style>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=vente/vente-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if (dp.getEtat() < ConstanteEtat.getEtatValider()) {%>
                            <a class="btn btn-warning pull-right" href="<%= lien + "?but=" + pageModif + "&acte=update&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=annuler&bute=vente/vente-fiche.jsp&classe=" + classe%>"><button class="btn btn-danger" style="margin-right: 10px">Annuler</button></a>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=apresTarif.jsp&acte=valider&id=" + request.getParameter("id") + "&bute=vente/vente-fiche.jsp&classe=" + classe%> " style="margin-right: 10px">Viser</a>
                            <% }%>
                            <%if (u.getUser().getIdrole().equals("caisse")==true){ %>
                                <% if (dp.getEtat() >= ConstanteEtat.getEtatValider() ) {%>
                                <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") + "?but=pertegain/pertegainimprevue-saisie.jsp&idorigine=" + id%> " style="margin-right: 10px">G&eacute;n&eacute;rer Perte/Gain</a><% }%>
                                <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=caisse/mvt/mvtCaisse-saisie-entree-fc.jsp&idOrigine=" + request.getParameter("id") + "&montant="+dp.getMontantreste()+"&devise=" + dp.getIdDevise()+"&tiers="+dp.getIdClient()+"&taux="+dp.getTauxdechange() %> " style="margin-right: 10px">Encaisser</a>
                                <% }%>
                                <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=avoir/avoirFC-saisie.jsp&id="+id%> " style="margin-right: 10px">G&eacute;n&eacute;rer avoir</a>
                                <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=vente/planPaiement-saisie.jsp&idvt="+id+"&classe=vente.Vente&table="+dp.getNomTable()+"&bute="+pageActuel%>" style="margin-right: 10px">Plan de Paiement</a>
                                <% }%>
                            <% } %>

                            <a class="btn btn-info pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente&sans=false&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer SMPC</a>
                            <a class="btn btn-primary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente_kprod&sans=false&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer KPROD</a>

                            <a class="btn btn-info pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente&sans=true&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer SMPC sans en-t&ecirc;te</a>
                            <a class="btn btn-primary pull-right"  href="${pageContext.request.contextPath}/ExportPDF?action=fiche_vente_kprod&sans=true&id=<%=request.getParameter("id")%>" style="margin-right: 10px">Imprimer KPROD sans en-t&ecirc;te</a>
                            <a class="btn btn-primary pull-right" href="<%= (String) session.getValue("lien") +"?but=vente/proforma/signature-modal.jsp&from=" + currentParams %>" style="margin-right: 10px">Signer</a>

                            <a class="btn btn-primary pull-right" href="#" onclick="affModal()" style="margin-right: 10px">Imprimer</a>
                            <a class="btn btn-success pull-right" href="<%= (String) session.getValue("lien") + "?but=pageupload.jsp&id=" + request.getParameter("id") + "&dossier=" + dossier + "&nomtable=ATTACHER_FICHIER&procedure=GETSEQ_ATTACHER_FICHIER&bute=" + pageActuel + "&id=" + request.getParameter("id") + "&nomprj="+ pc.getChampByName("designation").getValeur() %>" style="margin-right: 10px;/*! display: block; *//*! margin: 5px auto; *//*! width: 111px; *//*! max-width: 111px; */">Attacher Fichier</a>
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
                    <li class="<%=map.get("vente-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=vente-details">D&eacute;tail(s)</a></li>
                    <li class="<%=map.get("ecriture-detail")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=ecriture-detail">&Eacute;critures</a></li>
                        <li class="<%=map.get("liste-prevision")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%=id%>&tab=liste-prevision">Plan de paiements</a></li>
                        <% if (dp.getEtat() >= ConstanteEtat.getEtatValider()) {%>

                    <li class="<%=map.get("pertegainimprevue-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=pertegainimprevue-details">Gain(s) ou perte(s)</a></li>
                    <li class="<%=map.get("encaissement-vise-liste")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=encaissement-vise-liste">Paiement(s)</a></li>
                    <li class="<%=map.get("avoirfc-details")%>"><a href="<%= lien%>?but=<%= pageActuel%>&id=<%= id%>&tab=avoirfc-details">Avoir(s)</a></li>
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

<div class="modal fade" id="linkModal2" tabindex="-1" role="dialog" aria-labelledby="linkModal2Label" aria-hidden="true">
    <div style='width:60%;background:transparent;' class="modal-dialog modal-dialog-centered" role="dialog">
        <div style="border-radius: 16px;padding:15px;" class="modal-content">
            <div class="modal-body">
                <div id="modalContent">
                    <div>
                        <div class="row">
                            <div class="col-md-12">

                                <div id="content">
                                    <div id="signatureparent">
                                        <div>Signez ici</div>
                                        <div id="signature"></div>
                                    </div>
                                    <div id="tools" style="display: flex;align-items: first baseline;gap: 12px;">
                                        <form action="/univ/imprimerRecu" method="post">
                                            <input type="hidden" name="action" value="imprimerRecu"/>
                                            <input type="hidden" name="id" value="<%=request.getParameter("id")%>"/>
                                            <input type="hidden" name="signature" id="impression1"/>
                                            <button class="link btn btn-primary" type="submit" id="btnImprimer1">Imprimer</button>
                                        </form>

                                        <!-- Formulaire 2 -->
                                        <form action="/univ/imprimerRecu" method="post">
                                            <input type="hidden" name="action" value="imprimerRecuXprinter"/>
                                            <input type="hidden" name="id" value="<%=request.getParameter("id")%>"/>
                                            <input type="hidden" name="signature" id="impression2"/>
                                            <button class="link btn btn-secondary" type="submit" id="btnImprimer2">Imprimer sur XPRINTER</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="scrollgrabber"></div>
                    </div>
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
<script src="${pageContext.request.contextPath}/dist/js/libs/jquery.js"></script>
<script type="text/javascript">
    jQuery.noConflict()
    function affModal() {
        // document.getElementById("loader").style.display = "flex";
        var modalElement = $('#linkModal2');
        if (modalElement.length) {
            modalElement.modal('show');
            modalElement.css({
                'opacity': '1',
                'padding': '25rem 0px 0px 0px'
            });
        }
        // document.getElementById("loader").style.display = "none";
    }
</script>
<script>
    /*  @preserve
    jQuery pub/sub plugin by Peter Higgins (dante@dojotoolkit.org)
    Loosely based on Dojo publish/subscribe API, limited in scope. Rewritten blindly.
    Original is (c) Dojo Foundation 2004-2010. Released under either AFL or new BSD, see:
    http://dojofoundation.org/license for more information.
    */
    (function ($) {
        var topics = {};
        $.publish = function (topic, args) {
            if (topics[topic]) {
                var currentTopic = topics[topic],
                    args = args || {};

                for (var i = 0, j = currentTopic.length; i < j; i++) {
                    currentTopic[i].call($, args);
                }
            }
        };
        $.subscribe = function (topic, callback) {
            if (!topics[topic]) {
                topics[topic] = [];
            }
            topics[topic].push(callback);
            return {
                "topic": topic,
                "callback": callback
            };
        };
        $.unsubscribe = function (handle) {
            var topic = handle.topic;
            if (topics[topic]) {
                var currentTopic = topics[topic];

                for (var i = 0, j = currentTopic.length; i < j; i++) {
                    if (currentTopic[i] === handle.callback) {
                        currentTopic.splice(i, 1);
                    }
                }
            }
        };
    })(jQuery);

</script>
<script src="${pageContext.request.contextPath}/dist/js/libs/jSignature.min.noconflict.js"></script>
<script>
    (function ($) {

        $(document).ready(function () {

            // This is the part where jSignature is initialized.
            var $sigdiv = $("#signature").jSignature({ 'UndoButton': true })

                // All the code below is just code driving the demo.
                , $tools = $('#tools')
                , $extraarea = $('#displayarea')
                , pubsubprefix = 'jSignature.demo.'

            var export_plugins = $sigdiv.jSignature('listPlugins', 'export')
                , name

            $('#btnImprimer1').bind('click', function (e) {
                var data = $sigdiv.jSignature('getData', 'default');
                $('#impression1').attr("value", data);
            });

            $('#btnImprimer2').bind('click', function (e) {
                var data = $sigdiv.jSignature('getData', 'default');
                $('#impression2').attr("value", data);
            });


            $('<input type="button" value="Reset" class="btn btn-tertiary">').bind('click', function (e) {
                $sigdiv.jSignature('reset')
            }).appendTo($tools)

            if (Modernizr.touch) {
                $('#scrollgrabber').height($('#content').height())
            }

        })

    })(jQuery)
</script>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
