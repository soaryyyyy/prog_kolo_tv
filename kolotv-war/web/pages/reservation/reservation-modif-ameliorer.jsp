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
<%@ page import="reservation.Reservation" %>
<%@ page import="java.time.LocalDate" %>

<style>
  .table-container {
    max-height: 600px;
    overflow: auto;
  }

  /* Tableau */

  th, td {
    border: 1px solid #ccc;
    background: white;
    white-space: nowrap; !important;
  }

  /* En-tête sticky */
  thead th {
    position: sticky; !important;
    top: 0; !important;
    background: #f2f2f2;
    z-index: 3; !important;
  }

  /* Colonnes sticky - left défini en JS */

  .sticky-col {
    position: sticky; !important;
    z-index: 2; !important;
  }

  /* En-tête colonnes fixes au-dessus de tout */
  thead .sticky-col {
    z-index: 4; !important;
  }
</style>


<%
  try{
    String  mapping = "reservation.Reservation",
            nomtable = "RESERVATION",
            apres = "reservation/reservation-fiche.jsp",
            titre = "Modification de R&eacute;servation";
    String colonneMere = "idmere";
    String lien = (String) session.getValue("lien");
    Support [] supports = (Support[]) CGenUtil.rechercher(new Support(),null,null,null,"");

    Reservation resa = new Reservation();
    resa.setId(request.getParameter("id"));
    resa = (Reservation) CGenUtil.rechercher(resa,null,null,null,"")[0];
    String date = String.valueOf(resa.getDaty());
    String idClient = resa.getIdclient();
    String idBc = resa.getIdBc()!=null ? resa.getIdBc():"";
    String campagne = resa.getRemarque();
    LocalDate[] intervales = resa.getDateInterval(null);
%>
<div class="content-wrapper">
  <h1><%=titre%></h1>
  <form action="<%=lien%>?but=apresReservation.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <input name="acte" type="hidden" id="nature" value="modifReservation">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    <input name="idResa" id="idResa" type="hidden" value="<%=resa.getId()%>">
    <div class="row">
      <div class="col-md-4"></div>
      <div class="col-md-4 cardradius" style="background: white;padding: 35px;margin-top: 10px;">
        <h1 class="box-title cardtitle fontinter" align="left"><%=titre%></h1>
        <div class="row" style="padding: 5px;margin-bottom: 20px;">
          <div class="form-input">
            <label class="col-md-12 nopadding fontinter labelinput" for="Date">Date de r&eacute;servation</label>
            <span class="col-md-12 nopadding">
            <input name="daty" type="date" class="form-control" value="<%=date%>" id="daty">
          </span>
          </div>
          <div class="form-input">
            <label class="col-md-12 nopadding fontinter labelinput" for="Date">Date de debut</label>
            <span class="col-md-12 nopadding">
            <input name="dtDebut" type="date" value="<%=intervales[0].toString()%>" class="form-control" id="daty1">
          </span>
          </div>
          <div class="form-input">
            <label class="col-md-12 nopadding fontinter labelinput" for="Date">Date de fin</label>
            <span class="col-md-12 nopadding">
            <input name="dtFin" type="date" value="<%=intervales[1].toString()%>" class="form-control" id="daty2">
          </span>
          </div>

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
            <input name="remarque" type="text" class="form-control" id="remarque" value="<%=campagne%>" data-text="SÃ©lectionnez votre fichier">
            <input type="hidden" value="" name="remarqueauto">
          </span>
          </div>
          <div class="form-input">
            <label class="col-md-12 nopadding fontinter labelinput" for="Support">Support</label>
            <span class="col-md-12 nopadding">
            <select name="idSupport" class="form-control" id="idSupport">
              <% for (Support s:supports){
                  String selected = "";
                  if (s.getId().equals(resa.getIdSupport())){
                    selected = "selected";
                  }
              %>
                <option <%=selected%> value="<%=s.getId()%>"><%=s.getVal()%></option>
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
          <div class="col-xs-12">
            <a href="">
              <button type="button" class="btn btn-danger pull-right" style="margin-right: 4px;">Reinitializer</button>
            </a>
            <button type="button" id="btn-start" onclick="startSaisie()" class="btn btn-success pull-right" style="margin-right: 0;">Commencer</button>
            <button type="submit" id="btn-valider" class="btn btn-success pull-right" style="margin-right: 0;">Enregistrer</button>
          </div>
        </div>

      </div>
      <div class="col-md-4"></div>
    </div>

    <div id="conteneur" class="row" style="padding: 0px 30px 0 30px;display: none">
      <div class="col-md-12 cardradius" style="background: white;padding: 15px;margin-top: 20px;">
        <div class="table-container">
          <table id="myTable" class="table table-bordered" style="margin-top: 15px;">
            <thead id="tab-head">
            <tr id="tab-title">
              <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91; text-align: center" colspan="1"><input onclick="CocheToutCheckbox(this, 'ids')" type="checkbox"></th>
              <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91;min-width: 200px;" colspan="1">
                <label for="idproduit_0">Services</label>
              </th>
              <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91;min-width: 200px;" colspan="1">
                <label for="idmedia_0">M&eacute;dia</label>
              </th>
              <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91" colspan="1">
                <label for="heure_0">Heure</label>
              </th>
              <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                <label for="remarque_0">Remarque</label>
              </th>
              <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                <label for="source_0">Source</label>
              </th>
              <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                <label for="source_0">Ordre</label>
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

  function getDatesBetween(startDateStr, endDateStr) {
    const startDate = new Date(startDateStr);
    const endDate = new Date(endDateStr);
    const dateList = [];

    if (isNaN(startDate) || isNaN(endDate)) {
      return dateList;
    }

    if (startDate > endDate) {
      alert("La date de début doit être antérieure à la date de fin");
    }

    let currentDate = new Date(startDate);


    while (currentDate <= endDate) {
      dateList.push(formatDate(currentDate));
      currentDate.setDate(currentDate.getDate() + 1);
    }

    return dateList;
  }

  function getJourSemaine(input) {
    const jours = ['D', 'L', 'M', 'M', 'J', 'V', 'S'];
    let date;

    if (typeof input === 'string' && /^\d{2}\/\d{2}\/\d{4}$/.test(input)) {
      const [day, month, year] = input.split('/');
      date = new Date(Number(year), Number(month) - 1, Number(day));
    } else {
      date = new Date(input);
    }

    if (isNaN(date)) {
      console.warn("Date invalide :", input);
      return "";
    }

    return jours[date.getDay()];
  }

  function formatDate(input) {

    const day = String(input.getDate()).padStart(2, '0');
    const month = String(input.getMonth() + 1).padStart(2, '0');
    const year = input.getFullYear();
    return day+"/"+month+"/"+year;
  }

  document.addEventListener('DOMContentLoaded', function() {
    startSaisie();
  });



  async function startSaisie() {
    document.getElementById("loader").style.display = "flex";
    var nbLigne = document.querySelectorAll('input[id^="heure_"]').length;
    for (let i = 0; i < nbLigne; i++) {
      var element = document.getElementById("ligne-multiple-" + i);
      if (element!=null){
        element.remove();
      }
    }
    var dt1 = document.getElementById("daty1");
    var dt2 = document.getElementById("daty2");
    var idResa = document.getElementById("idResa").value;
    if (dt1!=null && dt2!=null){
      document.getElementById("conteneur").style.display = "flex";
      var listDate = getDatesBetween(dt1.value,dt2.value);
      createHeader(listDate);
      await initialiseDonneeModif(dt1.value, dt2.value, listDate, idResa);
    }
    else {
      alert("date debut et date fin obligatoire");
    }
    document.getElementById("loader").style.display = "none";
  }

  function getMonthName(dateStr) {
    const [day, month, year] = dateStr.split('/').map(Number);
    const months = [
      "Janvier", "Fevrier", "Mars", "Avril", "Mai", "Juin",
      "Juillet", "Aout", "Septembre", "Octobre", "Novembre", "D&eacute;cembre"
    ];
    return months[month - 1];
  }

  function createHeader(lisDate){
    var lastElement = document.querySelectorAll('[id="title-date"]');
    lastElement.forEach(el=>el.remove());
    var lastTitreDay = document.querySelectorAll('[id="tab-title-day"]');
    lastTitreDay.forEach(el=>el.remove());
    var lastTitreMonth = document.querySelectorAll('[id="tab-title-month"]');
    lastTitreMonth.forEach(el=>el.remove());

    var titre = document.getElementById("tab-head");

    var monthMap = new Map();
    var titreDay = document.createElement("tr");
    titreDay.setAttribute("id","tab-title-day");
    for (let i = 0; i < lisDate.length; i++) {
      var date = lisDate[i].split("/");
      var mois = getMonthName(lisDate[i]);
      var colonne = document.createElement("th");
      colonne.setAttribute("class","contenuetable fontinter");
      colonne.setAttribute("style","color:white;background-color:#2c3d91;text-align: center;top:45px");
      colonne.setAttribute("colSpan","1");
      colonne.innerHTML = "<p style='margin: 1px'>"+getJourSemaine(lisDate[i])+"</p>"+
              "<p style='margin: 0px'>"+date[0]+"</p>";
      titreDay.appendChild(colonne);
      var size = monthMap.get(mois+"_"+date[2]);
      if (size==null){
        size = 1;
      }else {
        size++;
      }
      monthMap.set(mois+"_"+date[2],size);
    }

    var titreMonth = document.createElement("tr");
    titreMonth.setAttribute("id","tab-title-month");
    monthMap.forEach((size, cle) => {
      var colonne = document.createElement("th");
      colonne.setAttribute("class","contenuetable fontinter");
      colonne.setAttribute("style","color:white;background-color:#2c3d91;text-align: center");
      colonne.setAttribute("colspan",""+size);
      colonne.innerHTML = cle.split("_")[0];
      titreMonth.appendChild(colonne);
    });
    titre.appendChild(titreMonth);
    titre.appendChild(titreDay);
  }

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
    var dernierChampListDate = "";
    var dernierChampOrdre = 0;

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
      dernierChampListDate = document.getElementById("listDate_" + (nbLigne-1))?.value || '';
      dernierChampOrdre = document.getElementById("ordre_" + (nbLigne-1))?.value || 0;
      dernierChampOrdre = Number(dernierChampOrdre)+1;
    }
    var listDate = getDatesBetween(document.getElementById("daty1").value,document.getElementById("daty2").value);

    if (listDate.length>0){
      for (let i = 0; i < nb; i++) {
        createLigne(dernierChampServiceLib,dernierChampService,dernierChampPu,dernierChampDuree,dernierChampMedia,dernierChampMediaLib,dernierChampSource,dernierChampRemarque,dernierChampListDate,dernierChampOrdre,nbLigne,listDate,listChamp.length);
        nbLigne += 1;
      }
    }
    updateStickyOffsets();
  }

  function createLigne (dernierChampServiceLib,dernierChampService,dernierChampPu,dernierChampDuree,dernierChampMedia,dernierChampMediaLib,dernierChampSource,dernierChampRemarque,dernierChampListDate,dernierChampOrdre,id,listDate,totalNbLigne){
    var champs = Array("idproduit_"+id,"idmedia_"+id,"heure_"+id,"remarque_"+id,"date_"+id,"duree_"+id,"pu_"+id,"source_"+id,"isEntete_"+id,"listDate_"+id,"ordre_"+id);
    var html_template = "<td class='sticky-col' style=\"text-align: center;vertical-align: middle;\" align=\"center\">\n" +
            "<input type=\"checkbox\" value=\"" + id + "\" name=\"ids\" id=\"checkbox" + id + "\"/>\n" +
            "</td>\n" +
            "<td class='sticky-col'>\n" +
            "<div style=\"display: inline-flex; align-items: center;width: 90%;\">\n" +
            "<input name=\"" + champs[0] + "libelle\" type=\"text\" class=\"form-control ui-autocomplete-input\"\n" +
            "id=\"" + champs[0] + "libelle\" value=\"" + dernierChampServiceLib + "\" style=\"min-width: 50%;\" onChange=\"synchro(this,checkbox" + id + ".id)\"\n" +
            "autoComplete=\"off\"/>\n" +
            "<input type=\"hidden\" value=\"" + dernierChampService + "\" name=\"" + champs[0] + "\" id=\"" + champs[0] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + dernierChampDuree + "\" name=\"" + champs[5] + "\" id=\"" + champs[5] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + dernierChampPu + "\" name=\"" + champs[6] + "\" id=\"" + champs[6] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + dernierChampListDate + "\" name=\"" + champs[9] + "\" id=\"" + champs[9] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + dernierChampOrdre + "\" name=\"" + champs[10] + "\" id=\"" + champs[10] + "\"/>\n" +
            "<button type=\"button\" class=\"btnheight\" id=\"" + champs[0] + "searchBtn\">\n" +
            "<i class=\"fa fa-search\" aria-hidden=\"true\"></i>\n" +
            "</button>\n" +
            "</div>\n" +
            "</td>\n" +
            "<td class='sticky-col'>\n" +
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
            "<td class='sticky-col'>\n" +
            "<input name=\""+champs[2]+"\" type=\"time\" class=\"form-control\" id=\""+champs[2]+"\" data-text=\"SÃ©lectionnez votre fichier\"\n" +
            "onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n" +
            "<td class='sticky-col'>\n" +
            "<input name=\""+champs[3]+"\" type=\"text\" value=\""+dernierChampRemarque+"\" class=\"form-control\" id=\""+champs[3]+"\"\n" +
            "data-text=\"SÃ©lectionnez votre fichier\" onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n"+
            "<td class='sticky-col'>\n" +
            "<input name=\""+champs[7]+"\" type=\"text\" class=\"form-control\" id=\""+champs[7]+"\" value=\""+dernierChampSource+"\"\n" +
            "data-text=\"SÃ©lectionnez votre fichier\" onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n"+
            "<td class='sticky-col'>" +
            "<select name=\""+champs[8]+"\" class=\"form-control\" id=\""+champs[8]+"\" >" +
            "<option value='0'>Aucun</option>"+
            "<option value='1'>T&ecirc;te d'&eacute;cran</option>"+
            "<option value='-1'>Fin d'&eacute;cran</option>"+
            "</select>" +
            "</td>";

    for (let i = 0; i < listDate.length; i++) {
      var inputCheckBoxOld = document.getElementById("date_"+(totalNbLigne-1)+"_"+i+"_date");
      var isChecked = "";
      if (inputCheckBoxOld!=null && inputCheckBoxOld.checked==true){
        isChecked = "checked"
      }
      var name = champs[4]+"_"+i;
      html_template += "<td style=\"text-align: center;vertical-align: middle;\" align=\"center\">\n" +
              "<input name=\""+name+"_date\" "+isChecked+" type=\"checkbox\" value='"+listDate[i]+"' id=\""+name+"_date\"\n" +
              "onInput=\"updateChampListDate(this,"+id+")\"/>\n" +
              // "<input type='hidden' value='"+listDate[i]+"' name='"+name+"_date'>\n"+
              "</td>";
    }
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

  function updateChampListDate(checkBox,numeroLigne){
    var champListDate = document.getElementById("listDate_"+numeroLigne);
    var str = champListDate.value;
    var arr = str.split(';');

    const index = arr.indexOf(checkBox.value);

    if (index===-1){
      if (checkBox.checked){
        arr.push(checkBox.value);
        champListDate.value = arr.join(";");
      }
    }else {
      if (!checkBox.checked){
        arr.splice(index,1);
        champListDate.value = arr.join(";");
      }
    }
    console.log(champListDate.value);
  }
  document.getElementById(<%=nomtable%>).addEventListener('submit',function (){
    var inputs = document.querySelectorAll('#<%=nomtable%> input');
    inputs.forEach(function (input){
      if (input.name.startsWith('date_')){
        console.log("Champ ignorer : "+ input.name);
        input.disabled = true;
      }
    });
  });


  async function initialiseDonneeModif(dtDebut,dtFin,listDate,idResa) {
    await fetch('<%=request.getContextPath()%>/ReservationServlet?action=find_donnee_modif&dtDebut='+dtDebut+'&dtFin='+dtFin+'&idReservation='+idResa)
            .then(res => res.json())
            .then(data => {
              console.log(data);
              for (let i = 0; i < data.length; i++) {
                createLigneWithData(data[i],listDate,i);
              }
              updateStickyOffsets();

            })
            .catch(error => console.error("Erreur :", error));
  }

  function createLigneWithData (resa,listDate,id){
    var champs = Array("idproduit_"+id,"idmedia_"+id,"heure_"+id,"remarque_"+id,"date_"+id,"duree_"+id,"pu_"+id,"source_"+id,"isEntete_"+id,"listDate_"+id,"ordre_"+id);
    var html_template = "<td class='sticky-col' style=\"text-align: center;vertical-align: middle;\" align=\"center\">\n" +
            "<input type=\"checkbox\" checked value=\"" + id + "\" name=\"ids\" id=\"checkbox" + id + "\"/>\n" +
            "</td>\n" +
            "<td class='sticky-col'>\n" +
            "<div style=\"display: inline-flex; align-items: center;width: 90%;\">\n" +
            "<input name=\"" + champs[0] + "libelle\" type=\"text\" class=\"form-control ui-autocomplete-input\"\n" +
            "id=\"" + champs[0] + "libelle\" value=\"" + resa.serviceLib + "\" style=\"min-width: 50%;\" onChange=\"synchro(this,checkbox" + id + ".id)\"\n" +
            "autoComplete=\"off\"/>\n" +
            "<input type=\"hidden\" value=\"" + resa.service + "\" name=\"" + champs[0] + "\" id=\"" + champs[0] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + resa.duree + "\" name=\"" + champs[5] + "\" id=\"" + champs[5] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + resa.pu + "\" name=\"" + champs[6] + "\" id=\"" + champs[6] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + resa.dates.join(";") + "\" name=\"" + champs[9] + "\" id=\"" + champs[9] + "\"/>\n" +
            "<input type=\"hidden\" value=\"" + resa.ordre + "\" name=\"" + champs[10] + "\" id=\"" + champs[10] + "\"/>\n" +
            "<button type=\"button\" class=\"btnheight\" id=\"" + champs[0] + "searchBtn\">\n" +
            "<i class=\"fa fa-search\" aria-hidden=\"true\"></i>\n" +
            "</button>\n" +
            "</div>\n" +
            "</td>\n" +
            "<td class='sticky-col'>\n" +
            "<div style=\"display: inline-flex; align-items: center;width: 90%;\">\n" +
            "<input name=\"" + champs[1] + "libelle\" type=\"text\" class=\"form-control ui-autocomplete-input\"\n" +
            "id=\""+champs[1]+"libelle\" value=\""+resa.mediaLib+"\" style=\"min-width: 50%;\" onChange=\"synchro(this,checkbox"+id+".id)\"\n" +
            "autoComplete=\"off\"/>\n" +
            "<input type=\"hidden\" value=\""+resa.media+"\" name=\""+champs[1]+"\" id=\""+champs[1]+"\"/>\n" +
            "<button type=\"button\" class=\"btnheight\" id=\""+champs[1]+"searchBtn\">\n" +
            "<i class=\"fa fa-search\" aria-hidden=\"true\"></i>\n" +
            "</button>\n" +
            "<button type=\"button\" class=\"btnheight\" onclick=\"pagePopUp('modulePopup.jsp?&but=media/media-saisie.jsp&amp;champReturn="+champs[1]+";"+champs[1]+"libelle&amp;champUrl=id;description')\">\n"+
            "<i class=\"fa fa-plus\"></i>\n" +
            "</button>\n" +
            "</div>\n" +
            "</td>\n" +
            "<td class='sticky-col'>\n" +
            "<input name=\""+champs[2]+"\" value=\""+resa.heure+"\" type=\"time\" class=\"form-control\" id=\""+champs[2]+"\" data-text=\"SÃ©lectionnez votre fichier\"\n" +
            "onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n" +
            "<td class='sticky-col'>\n" +
            "<input name=\""+champs[3]+"\" type=\"text\" value=\""+resa.remarque+"\" class=\"form-control\" id=\""+champs[3]+"\"\n" +
            "data-text=\"SÃ©lectionnez votre fichier\" onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n"+
            "<td class='sticky-col'>\n" +
            "<input name=\""+champs[7]+"\" type=\"text\" class=\"form-control\" id=\""+champs[7]+"\" value=\""+resa.source+"\"\n" +
            "data-text=\"SÃ©lectionnez votre fichier\" onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n"+
            "<td class='sticky-col'>" +
            "<select name=\""+champs[8]+"\" class=\"form-control\" id=\""+champs[8]+"\" >" +
            "<option "+resa.isEntete[0]+" value='0'>Aucun</option>"+
            "<option "+resa.isEntete[1]+" value='1'>T&ecirc;te d'&eacute;cran</option>"+
            "<option "+resa.isEntete[2]+" value='-1'>Fin d'&eacute;cran</option>"+
            "</select>" +
            "</td>";

    for (let i = 0; i < listDate.length; i++) {
      var isChecked = resa.planning[i][0];
      var isDisable = resa.planning[i][1];
      var name = champs[4]+"_"+i;
      html_template += "<td style=\"text-align: center;vertical-align: middle;\" align=\"center\">\n" +
              "<input  name=\""+name+"_date\" "+isChecked+" "+isDisable+" type=\"checkbox\" value='"+listDate[i]+"' id=\""+name+"_date\"\n" +
              "onInput=\"updateChampListDate(this,"+id+")\"/>\n" +
              // "<input type='hidden' value='"+listDate[i]+"' name='"+name+"_date'>\n"+
              "</td>";
    }
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

  function updateStickyOffsets() {
    const table = document.getElementById("myTable");
    var nbCell = 7;
    var totalWidth = 0;
    for (let i = 1; i <= nbCell; i++) {
      if(i===1){
        const firstColCells = table.querySelectorAll("thead th:nth-child("+i+"), tbody td:nth-child("+i+")");
        firstColCells.forEach(cell => {
          cell.style.left = "0px";
        });
      }else{
        const secondColCells = table.querySelectorAll("thead th:nth-child("+i+"), tbody td:nth-child("+i+")");

        let firstColWidth = table.querySelector("thead th:nth-child("+(i-1)+")").offsetWidth;
        totalWidth += firstColWidth;
        secondColCells.forEach(cell => {
          cell.style.left = totalWidth + "px";
        });
      }

    }

  }

  window.addEventListener("resize", updateStickyOffsets);
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


