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

<%
  try{
    String  mapping = "reservation.Reservation",
            nomtable = "RESERVATION",
            apres = "reservation/reservation-fiche.jsp",
            titre = "Saisie De Diffusion Emission";
    String colonneMere = "idmere";
    String lien = (String) session.getValue("lien");
    Support [] supports = (Support[]) CGenUtil.rechercher(new Support(),null,null,null,"");
%>
<div class="content-wrapper">
  <h1><%=titre%></h1>
  <form action="<%=lien%>?but=apresReservation.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <input name="acte" type="hidden" id="nature" value="insertReservationMultipleForEmission">
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
            <label class="col-md-12 nopadding fontinter labelinput" for="Projet">Campagne</label>
            <span class="col-md-12 nopadding">
            <input name="remarque" type="text" class="form-control" id="remarque" value="" data-text="SÃ©lectionnez votre fichier">
            <input type="hidden" value="" name="remarqueauto">
          </span>
          </div>
          <div class="form-input">
            <label class="col-md-12 nopadding fontinter labelinput" for="Date">Date de r&eacute;servation</label>
            <span class="col-md-12 nopadding">
            <input name="daty" type="date" class="form-control" id="daty">
          </span>
          </div>
          <div class="form-input">
            <label class="col-md-12 nopadding fontinter labelinput" for="Date">Date debut</label>
            <span class="col-md-12 nopadding">
            <input name="daty1" type="date" class="form-control" id="daty1">
          </span>
          </div>
          <div class="form-input">
            <label class="col-md-12 nopadding fontinter labelinput" for="Date">Date de fin</label>
            <span class="col-md-12 nopadding">
            <input name="daty2" type="date" class="form-control" id="daty2">
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
          <input type="hidden" name="nbJours" value="0" id="nbJours">
          <div class="col-xs-12">
            <a href="">
              <button type="button" class="btn btn-danger pull-right" style="margin-right: 4px;">Reinitializer</button>
            </a>
            <button type="button" id="btn-start" onclick="startSaisie()" class="btn btn-success pull-right" style="margin-right: 0;">Commencer</button>
            <button type="submit" id="btn-valider" class="btn btn-success pull-right" style="margin-right: 0;display: none">Enregistrer</button>
          </div>
        </div>
      </div>
      <div class="col-md-4"></div>
    </div>

    <div id="conteneur" class="row" style="padding: 0px 30px 0 30px;display: none">
      <div class="col-md-12 cardradius" style="background: white;padding: 15px;margin-top: 20px;">
        <div style="overflow-x: auto;">
          <table class="table table-bordered" style="margin-top: 15px;">
            <tbody>
            <tr id="tab-title">
              <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91; text-align: center" colspan="1"><input onclick="CocheToutCheckbox(this, 'ids')" type="checkbox"></th>
              <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 200px;" colspan="1">
                <label for="idproduit_0">&eacute;mission</label>
              </th>
              <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91" colspan="1">
                <label for="heure_0">Heure</label>
              </th>
              <th class="contenuetable fontinter" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
                <label for="heure_0">Duree</label>
              </th>
            </tr>
            </tbody>
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
    const jours = ['dimanche', 'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi'];
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

  function startSaisie(){
    var btn1 = document.getElementById("btn-start");
    var btn2 = document.getElementById("btn-valider");
    btn1.style.display = "none";
    btn2.style.display = "flex";
    var dt1 = document.getElementById("daty1");
    var dt2 = document.getElementById("daty2");
    if (dt1!=null && dt2!=null){
      document.getElementById("conteneur").style.display = "flex";
      dt1.setAttribute("readonly","");
      dt1.se
      dt2.setAttribute("readonly","");
      var listDate = getDatesBetween(dt1.value,dt2.value);
      document.getElementById("nbJours").value = listDate.length;
      createHeader(listDate);
      addLigne(1);
    }
    else {
      alert("date debut et date fin obligatoire");
    }
  }

  function createHeader(lisDate){
    var titre = document.getElementById("tab-title");
    for (let i = 0; i < lisDate.length; i++) {
      var colonne = document.createElement("th");
      colonne.setAttribute("class","contenuetable fontinter");
      colonne.setAttribute("style","color:white;background-color:#2c3d91;text-align: center");
      colonne.setAttribute("colSpan","1");
      colonne.innerHTML = "<p>"+getJourSemaine(lisDate[i])+"</p>"+
              "<p>"+lisDate[i]+"</p>";
      titre.appendChild(colonne);
    }
  }

  function addLigne(nb) {
    var listChamp = document.querySelectorAll('input[id^="heure_"]');
    var nbLigne = 0;
    var dernierChampServiceLib = "";
    var dernierChampService = "";
    var dernierChampPu = "";
    var dernierChampDuree = "";
    var dernierChampRemise = "0";
    if (listChamp!=null && listChamp.length>0){
      nbLigne = listChamp.length;
      dernierChampServiceLib = document.getElementById("idproduit_" + (nbLigne-1) + "libelle")?.value || '';
      dernierChampService = document.getElementById("idproduit_" + (nbLigne-1))?.value || '';
      dernierChampPu = document.getElementById("pu_" + (nbLigne-1))?.value || '';
      dernierChampDuree = document.getElementById("duree_" + (nbLigne-1))?.value || '';
      dernierChampRemise = document.getElementById("remise_" + (nbLigne-1))?.value || '0';
    }
    var listDate = getDatesBetween(document.getElementById("daty1").value,document.getElementById("daty2").value);
    if (listDate.length>0){
      for (let i = 0; i < nb; i++) {
        createLigne(dernierChampServiceLib,dernierChampService,dernierChampRemise,dernierChampDuree,dernierChampPu,nbLigne,listDate);
        nbLigne += 1;
      }
    }
  }

  function createLigne (value1,value2,value3,value4,value5,id,listDate){
    var champs = Array("idproduit_"+id,"heure_"+id,"duree_"+id,"date_"+id);
    var html_template = "<td style=\"text-align: center;vertical-align: middle;\" align=\"center\">\n" +
            "<input type=\"checkbox\" value=\""+id+"\" name=\"ids\" id=\"checkbox"+id+"\"/>\n" +
            "</td>\n" +
            "<td>\n" +
            "<div style=\"display: inline-flex; align-items: center;width: 90%;\">\n" +
            "<input name=\""+champs[0]+"libelle\" type=\"text\" class=\"form-control ui-autocomplete-input\"\n" +
            "id=\""+champs[0]+"libelle\" value=\""+value1+"\" style=\"min-width: 50%;\" onChange=\"synchro(this,checkbox"+id+".id)\"\n" +
            "autoComplete=\"off\"/>\n" +
            "<input type=\"hidden\" value=\""+value2+"\" name=\""+champs[0]+"\" id=\""+champs[0]+"\"/>\n" +
            "<button type=\"button\" class=\"btnheight\" id=\""+champs[0]+"searchBtn\">\n" +
            "<i class=\"fa fa-search\" aria-hidden=\"true\"></i>\n" +
            "</button>\n" +
            "</div>\n" +
            "</td>\n" +
            "<td>\n" +
            "<input name=\""+champs[1]+"\" type=\"time\" step='1' class=\"form-control\" id=\""+champs[1]+"\" data-text=\"SÃ©lectionnez votre fichier\"\n" +
            "onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n" +
            "<td>\n" +
            "<input name=\""+champs[2]+"\" type=\"text\" class=\"form-control\" id=\""+champs[2]+"\" value=\"\"\n" +
            "data-text=\"SÃ©lectionnez votre fichier\" onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
            "</td>\n";

    for (let i = 0; i < listDate.length; i++) {
      var name = champs[3]+"_"+i;
      html_template += "<td style=\"text-align: center;vertical-align: middle;\" align=\"center\">\n" +
              "<input name=\""+name+"_quantite\" type=\"text\" class=\"form-control\" id=\""+name+"_quantite\" value=\"0\"\n" +
              "data-text=\"SÃ©lectionnez votre fichier\" onInput=\"if(this.value !== '') { synchro(this,checkbox"+id+".id) }\"/>\n" +
              "<input type='hidden' value='"+listDate[i]+"' name='"+name+"_date'>\n"+
              "</td>";
    }
    var aWhere = " and idSupport='\"+document.getElementById('idSupport').options[document.getElementById('idSupport').selectedIndex].value+\"'";

    var script = `jQuery(document).ready(function () {$(function() {\n`+
            `var autocompleteTriggered = false;\n`+
            `$("#`+champs[0]+`libelle").autocomplete({\n`+
            `source: function(request, response) {\n`+
            `$("#`+champs[0]+`").val('');\n`+
            `if (autocompleteTriggered) {\n`+
            `fetchAutocomplete(request, response, "null", "id", "null", "EMISSION", "emission.Emission", "true","heuredebut;duree","`+aWhere+`");\n`+
            `}\n`+
            `},\n`+
            `select: function(event, ui) {\n`+
            `$("#`+champs[0]+`libelle").val(ui.item.label);\n`+
            `$("#`+champs[0]+`").val(ui.item.value);\n`+
            `$("#`+champs[0]+`").trigger('change');\n`+
            `$(this).autocomplete('disable');\n`+
            `var champsDependant = ['`+champs[1]+`','`+champs[2]+`'];\n`+
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

