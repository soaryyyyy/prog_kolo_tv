<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 15/04/2025
  Time: 11:36
  To change this template use File | Settings | File Templates.
--%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="reservation.ReservationSimple" %>
<%@ page import="support.Support" %>
<%@ page import="affichage.Liste" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="utils.CalendarUtil" %>
<%@ page import="org.joda.time.LocalDate" %>

<style>
    .table-container {
        max-height: 600px;
        overflow: auto;
    }
    /* En-tête sticky */
    thead th {
        position: sticky; !important;
        top: 0; !important;
        background: #f2f2f2;
        z-index: 3; !important;
    }

</style>

<%
    try{
        String  mapping = "reservation.Reservation",
                nomtable = "RESERVATION",
                apres = "reservation/reservation-fiche.jsp",
                titre = "Saisie De R&eacute;servation";
        String colonneMere = "idmere";
        String lien = (String) session.getValue("lien");
        String date = request.getParameter("date");
        if (date==null){
            date = LocalDate.now().toString();
        }
        Support [] supports = (Support[]) CGenUtil.rechercher(new Support(),null,null,null,"");
        String idClient = "";
        String idBc = "";
        if (request.getParameter("idClient")!=null){
            idClient = request.getParameter("idClient");
        }
        if (request.getParameter("idBC")!=null){
            idBc = request.getParameter("idBC");
        }
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <form action="<%=lien%>?but=apresReservation.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <input name="acte" type="hidden" id="nature" value="insertReservationMultipleAmeliorer">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        <div class="row">
            <div class="col-md-4"></div>
            <div class="col-md-4 cardradius" style="background: white;padding: 35px;margin-top: 10px;">
                <h1 class="box-title cardtitle fontinter" align="left">Saisie</h1>
                <div class="row" style="padding: 5px;margin-bottom: 20px;">
                    <div class="form-input">
                        <label class="col-md-12 nopadding fontinter labelinput" for="Client">Client</label>
                        <span class="col-md-12 nopadding">
            <div style="display: inline-flex; align-items: baseline;width:calc(100% - 60px);">
              <input name="idclientlibelle" type="text" class="form-control ui-autocomplete-input" id="idclientlibelle" value="<%=idClient%>" style="min-width: 50%;" autocomplete="off">
              <input type="hidden" value="<%=idClient%>" name="idclient" id="idclient">
            </div>
            <button type="button" class="btnheight" id="idclientsearchBtn"><i class="fa fa-search" aria-hidden="true"></i></button>
            <button type="button" class="btnheight" onclick="pagePopUp('modulePopup.jsp?but=client/client-saisie.jsp&amp;champReturn=idclient;idclientlibelle&amp;champUrl=id;nom')"><i class="fa fa-plus"></i></button>
          </span>
                    </div>
                    <div class="form-input">
                        <label class="col-md-12 nopadding fontinter labelinput" for="Projet">Campagne</label>
                        <span class="col-md-12 nopadding">
            <input name="remarque" type="text" class="form-control" id="remarque" value="" data-text="SÃ©lectionnez votre fichier">
            <input type="hidden" value="" name="remarqueauto">
          </span>
                    </div>
                    <div class="form-input">
                        <label class="col-md-12 nopadding fontinter labelinput" for="Date">Date de r&eacute;servation</label>
                        <span class="col-md-12 nopadding">
            <input name="daty" type="date" class="form-control" value="<%=date%>" id="daty">
          </span>
                    </div>
                    <div class="form-input">
                        <label class="col-md-12 nopadding fontinter labelinput" for="Support">Support</label>
                        <span class="col-md-12 nopadding">
            <select name="idSupport" class="form-control" id="idSupport">
              <% for (Support s:supports){ %>
                <option value="<%=s.getId()%>"><%=s.getVal()%></option>
              <% } %>
            </select>
          </span>
                    </div>
                    <div class="form-input">
                        <label class="col-md-12 nopadding fontinter labelinput" for="Client">Bon de commande</label>
                        <span class="col-md-12 nopadding">
                        <div style="display: inline-flex; align-items: baseline;width:calc(100% - 60px);">
                          <input name="idBclibelle" type="text" class="form-control ui-autocomplete-input" id="idBclibelle" value="<%=idBc%>" style="min-width: 50%;" autocomplete="off">
                          <input type="hidden" value="<%=idBc%>" name="idBc" id="idBc">
                        </div>
                        <button type="button" class="btnheight" id="idBcsearchBtn"><i class="fa fa-search" aria-hidden="true"></i></button>
                        </span>
                    </div>

                    <input type="hidden" name="nbJours" value="0" id="nbJours">
                    <div class="col-xs-12">
                        <a href="">
                            <button type="button" class="btn btn-danger pull-right" style="margin-right: 4px;">Reinitializer</button>
                        </a>
                        <button type="submit" id="btn-valider" class="btn btn-success pull-right" style="margin-right: 0;">Enregistrer</button>
                    </div>
                </div>

            </div>
            <div class="col-md-4"></div>
        </div>

        <div id="conteneur" class="row" style="padding: 0px 30px 0 30px">
            <div class="col-md-12 cardradius" style="background: white;padding: 15px;margin-top: 20px;">
                <div class="table-container">
                    <table class="table table-bordered" style="margin-top: 15px;">
                        <thead>
                        <tr id="tab-title">
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91; text-align: center" colspan="1"><input onclick="CocheToutCheckbox(this, 'ids')" type="checkbox"></th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 200px;" colspan="1">
                                <label for="idproduit_0">Services</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 200px;" colspan="1">
                                <label for="idmedia_0">M&eacute;dia</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91" colspan="1">
                                <label for="heure_0">Heure</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                                <label for="source_0">Ordre</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                                <label for="remarque_0">Remarque</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                                <label for="source_0">Source</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                                <label for="source_0">Date de d&eacute;but</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                                <label for="source_0">Date Fin</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;width: 10px;" colspan="1">
                                <label for="source_0">L</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;width: 10px;" colspan="1">
                                <label for="source_0">M</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;width: 10px;" colspan="1">
                                <label for="source_0">M</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;width: 10px;" colspan="1">
                                <label for="source_0">J</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;width: 10px;" colspan="1">
                                <label for="source_0">V</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;width: 10px;" colspan="1">
                                <label for="source_0">S</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;width: 10px;" colspan="1">
                                <label for="source_0">D</label>
                            </th>
                            <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 250px;" colspan="1">
                                <label for="source_0">Date Interdite</label>
                            </th>
                        </tr>
                        </thead>
                        <tbody id="ajout_multiple_ligne">

                        </tbody>
                    </table>
                </div>
                <div class="col-xs-12">
                    <button type="button" onclick="addLigne(10)" class="btn btn-default btnradius pull-right col-xs-5 col-md-1" style="margin-right: 25px;">Ajouter dix ligne</button>
                    <button type="button" onclick="addLigne(1)" class="btn btn-default btnradius pull-right col-xs-5 col-md-1" style="margin-right: 25px;">Ajouter une ligne</button>
                </div>
            </div>
        </div>
    </form>

</div>

<script>


    document.addEventListener('DOMContentLoaded', function() {
        addLigne(1);
    });

    function addLigne(nb) {
        var listChamp = document.querySelectorAll('input[id^="heure_"]');
        var nbLigne = 0;
        var dernierChampServiceLib = "";
        var dernierChampService = "";
        var dernierChampPu = "";
        var dernierChampDuree = "";
        var dernierChampMediaLib = "";
        var dernierChampMedia = "";
        var dernierChampSource = "";
        var dernierChampRemarque = "";
        var dernierChampDateDebut = "";
        var dernierChampDateFin = "";
        var dernierChampDateInvalide = "";
        if (listChamp!=null && listChamp.length>0){
            nbLigne = listChamp.length;
            dernierChampServiceLib = document.getElementById("idproduit_" + (nbLigne-1) + "libelle")?.value || '';
            dernierChampService = document.getElementById("idproduit_" + (nbLigne-1))?.value || '';
            dernierChampPu = document.getElementById("pu_" + (nbLigne-1))?.value || '';
            dernierChampDuree = document.getElementById("duree_" + (nbLigne-1))?.value || '';
            dernierChampMediaLib = document.getElementById("idmedia_" + (nbLigne-1) + "libelle")?.value || '';
            dernierChampMedia = document.getElementById("idmedia_" + (nbLigne-1))?.value || '';
            dernierChampSource = document.getElementById("source_" + (nbLigne-1))?.value || '';
            dernierChampRemarque = document.getElementById("remarque_" + (nbLigne-1))?.value || '';
            dernierChampDateDebut = document.getElementById("dateDebut_" + (nbLigne-1))?.value || '';
            dernierChampDateFin = document.getElementById("dateFin_" + (nbLigne-1))?.value || '';
            dernierChampDateInvalide = document.getElementById("dateInvalide_" + (nbLigne-1))?.value || '';
        }
        var listDate = Array("lundi","mardi","mercredi","jeudi","vendredi","samedi","dimanche");

        if (listDate.length>0){
            for (let i = 0; i < nb; i++) {
                createLigne(dernierChampServiceLib,dernierChampService,dernierChampPu,dernierChampDuree,dernierChampMedia,dernierChampMediaLib,dernierChampSource,dernierChampRemarque,dernierChampDateDebut,dernierChampDateFin,dernierChampDateInvalide,nbLigne,listDate,listChamp.length);
                nbLigne += 1;
            }
        }
    }

    function createLigne (dernierChampServiceLib,dernierChampService,dernierChampPu,dernierChampDuree,dernierChampMedia,dernierChampMediaLib,dernierChampSource,dernierChampRemarque,dernierChampDateDebut,dernierChampDateFin,dernierChampDateInvalide,id,listDate,totalNbLigne){
        var champs = Array("idproduit_"+id,"idmedia_"+id,"heure_"+id,"remarque_"+id,"date_"+id,"duree_"+id,"pu_"+id,"source_"+id,"dateDebut_"+id,"dateFin_"+id,"jours_"+id,"dateInvalide_"+id,"isEntete_"+id);
        var html_template = "<td style=\"text-align: center;vertical-align: middle;\" align=\"center\">\n" +
            "<input type=\"checkbox\" value=\"" + id + "\" name=\"ids\" id=\"checkbox" + id + "\"/>\n" +
            "</td>\n" +
            "<td>\n" +
            "<div style=\"display: inline-flex; align-items: center;width: 90%;\">\n" +
            "<input name=\"" + champs[0] + "libelle\" type=\"text\" class=\"form-control ui-autocomplete-input\"\n" +
            "id=\"" + champs[0] + "libelle\" value=\"" + dernierChampServiceLib + "\" style=\"min-width: 50%;\" onChange=\"synchro(this,checkbox" + id + ".id)\"\n" +
            "autoComplete=\"off\"/>\n" +
            "<input type=\"hidden\" value=\"" + dernierChampService + "\" name=\"" + champs[0] + "\" id=\"" + champs[0] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + dernierChampDuree + "\" name=\"" + champs[5] + "\" id=\"" + champs[5] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + dernierChampPu + "\" name=\"" + champs[6] + "\" id=\"" + champs[6] + "\"/>\n" +
            "<button type=\"button\" class=\"btnheight\" id=\"" + champs[0] + "searchBtn\">\n" +
            "<i class=\"fa fa-search\" aria-hidden=\"true\"></i>\n" +
            "</button>\n" +
            "</div>\n" +
            "</td>\n" +
            "<td>\n" +
            "<div style=\"display: inline-flex; align-items: center;width: 90%;\">\n" +
            "<input name=\"" + champs[1] + "libelle\" type=\"text\" class=\"form-control ui-autocomplete-input\"\n" +
            "id=\""+champs[1]+"libelle\" value=\""+dernierChampMediaLib+"\" style=\"min-width: 50%;\" onChange=\"synchro(this,checkbox"+id+".id)\"\n" +
            "autoComplete=\"off\"/>\n" +
            "<input type=\"hidden\" value=\""+dernierChampMedia+"\" name=\""+champs[1]+"\" id=\""+champs[1]+"\"/>\n" +
            "<button type=\"button\" class=\"btnheight\" id=\""+champs[1]+"searchBtn\">\n" +
            "<i class=\"fa fa-search\" aria-hidden=\"true\"></i>\n" +
            "</button>\n" +
            "<button type=\"button\" class=\"btnheight\" onclick=\"pagePopUp('modulePopup.jsp?&but=media/media-saisie.jsp&amp;champReturn="+champs[1]+";"+champs[1]+"libelle&amp;champUrl=id;description')\">\n"+
            "<i class=\"fa fa-plus\"></i>\n" +
            "</button>\n" +
            "</div>\n" +
            "</td>\n" +
            "<td>\n" +
            "<input name=\""+champs[2]+"\" type=\"time\" class=\"form-control\" id=\""+champs[2]+"\" data-text=\"SÃ©lectionnez votre fichier\"\n" +
            "onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n" +
            "<td>" +
            "<select name=\""+champs[12]+"\" class=\"form-control\" id=\""+champs[12]+"\" >" +
            "<option value='0'>Aucun</option>"+
            "<option value='1'>T&ecirc;te d'&eacute;cran</option>"+
            "<option value='-1'>Fin d'&eacute;cran</option>"+
            "</select>" +
            "</td>"+
            "<td>\n" +
            "<input name=\""+champs[3]+"\" value=\""+dernierChampRemarque+"\" type=\"text\" class=\"form-control\" id=\""+champs[3]+"\"\n" +
            "data-text=\"SÃ©lectionnez votre fichier\" onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n"+
            "<td>\n" +
            "<input name=\""+champs[7]+"\" type=\"text\" class=\"form-control\" id=\""+champs[7]+"\" value=\""+dernierChampSource+"\"\n" +
            "data-text=\"SÃ©lectionnez votre fichier\" onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n"+
            "<td>\n" +
            "<input name=\""+champs[8]+"\" type=\"date\" value=\""+dernierChampDateDebut+"\" class=\"form-control\" id=\""+champs[8]+"\"\n" +
            "onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n"+
            "<td>\n" +
            "<input name=\""+champs[9]+"\" type=\"date\" value=\""+dernierChampDateFin+"\" class=\"form-control\" id=\""+champs[9]+"\"\n" +
            "onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n";

        for (let i = 0; i < listDate.length; i++) {
            var inputCheckBoxOld = document.getElementById("jours_"+(totalNbLigne-1)+"_"+listDate[i]);
            var isChecked = "";
            if (inputCheckBoxOld!=null && inputCheckBoxOld.checked==true){
                isChecked = "checked";
            }
            var name = champs[10]+"_"+listDate[i];
            html_template += "<td style=\"text-align: center;vertical-align: middle;\" align=\"center\">\n" +
                "<input name=\""+champs[10]+"\" "+isChecked+" type=\"checkbox\" value=\""+listDate[i]+"\" id=\""+name+"\" value=\"0\"\n" +
                "onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
                "</td>";
        }

        html_template += "<td>\n" +
                "<input name=\""+champs[11]+"\" type=\"text\" placeholder=\"01/01/2025;10/02/2025\" class=\"form-control\" value=\""+dernierChampDateInvalide+"\" id=\""+champs[11]+"\"\n" +
                "onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
                "</td>\n";
        var aWhere = " and idSupport='\"+document.getElementById('idSupport').options[document.getElementById('idSupport').selectedIndex].value+\"'";

        var script = `jQuery(document).ready(function () {$(function() {\n`+
            `var autocompleteTriggered = false;\n`+
            `$("#`+champs[0]+`libelle").autocomplete({\n`+
            `source: function(request, response) {\n`+
            `$("#`+champs[0]+`").val('');\n`+
            `if (autocompleteTriggered) {\n`+
            `fetchAutocomplete(request, response, "null", "id", "null", "PRODUIT_VENTE_LIB", "annexe.ProduitLib", "true","montant;duree","`+aWhere+`");\n`+
            `}\n`+
            `},\n`+
            `select: function(event, ui) {\n`+
            `$("#`+champs[0]+`libelle").val(ui.item.label);\n`+
            `$("#`+champs[0]+`").val(ui.item.value);\n`+
            `$("#`+champs[0]+`").trigger('change');\n`+
            `$(this).autocomplete('disable');\n`+
            `var champsDependant = ['`+champs[6]+`','`+champs[5]+`'];\n`+
            `for(let i=0;i<champsDependant.length;i++){\n`+
            `$("#"+champsDependant[i]).val(ui.item.retour.split(';')[i]);\n`+
            `}\n`+
            `autocompleteTriggered = false;\n`+
            `return false;\n`+
            `}\n`+
            `}).autocomplete('disable');\n`+
            `$("#`+champs[0]+`libelle").keydown(function(event) {\n`+
            `if (event.key === 'Tab') {\n`+
            `event.preventDefault();\n`+
            `autocompleteTriggered = true;\n`+
            `$(this).autocomplete('enable').autocomplete('search', $(this).val());\n`+
            `}\n`+
            `});\n`+
            `$("#`+champs[0]+`libelle").on('input', function() {\n`+
            `$("#`+champs[0]+`").val('');\n`+
            `autocompleteTriggered = false;\n`+
            `$(this).autocomplete('disable');\n`+
            `});\n`+
            `$("#`+champs[0]+`searchBtn").click(function() {\n`+
            `autocompleteTriggered = true;\n`+
            `$("#`+champs[0]+`libelle").autocomplete('enable').autocomplete('search', $("#`+champs[0]+`libelle").val());\n`+
            `});\n`+
            `});});\n`;

        aWhere = " and idClient='\"+(document.getElementById('idclient')?.value || '')+\"'";
        script += `jQuery(document).ready(function () {$(function() {\n`+
            `var autocompleteTriggered = false;\n`+
            `$("#`+champs[1]+`libelle").autocomplete({\n`+
            `source: function(request, response) {\n`+
            `$("#`+champs[1]+`").val('');\n`+
            `if (autocompleteTriggered) {\n`+
            `fetchAutocomplete(request, response, "null", "id", "null", "MEDIA", "media.Media", "true","duree","`+aWhere+`");\n`+
            `}\n`+
            `},\n`+
            `select: function(event, ui) {\n`+
            `$("#`+champs[1]+`libelle").val(ui.item.label);\n`+
            `$("#`+champs[1]+`").val(ui.item.value);\n`+
            `$("#`+champs[1]+`").trigger('change');\n`+
            `$(this).autocomplete('disable');\n`+
            `var champsDependant = ['`+champs[5]+`'];\n`+
            `for(let i=0;i<champsDependant.length;i++){\n`+
            `$("#"+champsDependant[i]).val(ui.item.retour.split(';')[i]);\n`+
            `}\n`+
            `autocompleteTriggered = false;\n`+
            `return false;\n`+
            `}\n`+
            `}).autocomplete('disable');\n`+
            `$("#`+champs[1]+`libelle").keydown(function(event) {\n`+
            `if (event.key === 'Tab') {\n`+
            `event.preventDefault();\n`+
            `autocompleteTriggered = true;\n`+
            `$(this).autocomplete('enable').autocomplete('search', $(this).val());\n`+
            `}\n`+
            `});\n`+
            `$("#`+champs[1]+`libelle").on('input', function() {\n`+
            `$("#`+champs[1]+`").val('');\n`+
            `autocompleteTriggered = false;\n`+
            `$(this).autocomplete('disable');\n`+
            `});\n`+
            `$("#`+champs[1]+`searchBtn").click(function() {\n`+
            `autocompleteTriggered = true;\n`+
            `$("#`+champs[1]+`libelle").autocomplete('enable').autocomplete('search', $("#`+champs[1]+`libelle").val());\n`+
            `});\n`+
            `});});\n`;
        var element = document.createElement("tr");
        element.setAttribute("id", "ligne-multiple-"+id);
        element.innerHTML = html_template;

        var scriptElement = document.createElement("script");
        scriptElement.type = "text/javascript";
        scriptElement.text = script;
        element.appendChild(scriptElement);

        var tableau = document.getElementById("ajout_multiple_ligne");
        tableau.appendChild(element);
    }
</script>

<script>
    jQuery(document).ready(function () {$(function() {
        var autocompleteTriggered = false;
        $("#idclientlibelle").autocomplete({
            source: function(request, response) {
                $("#idclient").val('');
                if (autocompleteTriggered) {
                    fetchAutocomplete(request, response, "null", "id", "null", "Client", "client.Client", "true","","null");
                }
            },
            select: function(event, ui) {
                $("#idclientlibelle").val(ui.item.label);
                $("#idclient").val(ui.item.value);
                $("#idclient").trigger('change');
                $(this).autocomplete('disable');
                var champsDependant = [''];   for(let i=0;i<champsDependant.length;i++){
                    $(`#${champsDependant[i]}`).val(ui.item.retour.split(';')[i]);
                }            autocompleteTriggered = false;
                return false;
            }
        }).autocomplete('disable');
        $("#idclientlibelle").keydown(function(event) {
            if (event.key === 'Tab') {
                event.preventDefault();
                autocompleteTriggered = true;
                $(this).autocomplete('enable').autocomplete('search', $(this).val());
            }
        });
        $("#idclientlibelle").on('input', function() {
            $("#idclient").val('');
            autocompleteTriggered = false;
            $(this).autocomplete('disable');
        });
        $("#idclientsearchBtn").click(function() {
            autocompleteTriggered = true;
            $("#idclientlibelle").autocomplete('enable').autocomplete('search', $("#idclientlibelle").val());
        });
    });$(function() {
        var autocompleteTriggered = false;
        $("#idBclibelle").autocomplete({
            source: function(request, response) {
                $("#idBc").val('');
                if (autocompleteTriggered) {
                    fetchAutocomplete(request, response, "null", "id", "null", "BONDECOMMANDE_CLIENT", "vente.BonDeCommande", "true","","null");
                }
            },
            select: function(event, ui) {
                $("#idBclibelle").val(ui.item.label);
                $("#idBc").val(ui.item.value);
                $("#idBc").trigger('change');
                $(this).autocomplete('disable');
                var champsDependant = [''];   for(let i=0;i<champsDependant.length;i++){
                    $(`#${champsDependant[i]}`).val(ui.item.retour.split(';')[i]);
                }            autocompleteTriggered = false;
                return false;
            }
        }).autocomplete('disable');
        $("#idBclibelle").keydown(function(event) {
            if (event.key === 'Tab') {
                event.preventDefault();
                autocompleteTriggered = true;
                $(this).autocomplete('enable').autocomplete('search', $(this).val());
            }
        });
        $("#idBclibelle").on('input', function() {
            $("#idBc").val('');
            autocompleteTriggered = false;
            $(this).autocomplete('disable');
        });
        $("#idBcsearchBtn").click(function() {
            autocompleteTriggered = true;
            $("#idBclibelle").autocomplete('enable').autocomplete('search', $("#idBclibelle").val());
        });
    });}); </script>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
history.back();</script>

<% }%>

