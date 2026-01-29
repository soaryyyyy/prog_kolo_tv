<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@page import="vente.VenteDetailsLib"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationDetailsLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.ReservationDetailsAvecDiffusion" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="reservation.Reservation" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.time.LocalDate" %>


<style>
  .table-container {
    max-height: 600px;
    overflow: auto;
  }

  #myTable th,#myTable td {
     background: white;
    white-space: nowrap;
  }
  /* En-tête sticky */
  #myTable thead th {
    position: sticky; !important;
    top: 0;
    background: #f2f2f2;
    z-index: 3; !important;
  }

  /* Colonnes sticky - left défini en JS */

  #myTable .sticky-col {
    position: sticky; !important;
    z-index: 2; !important;
  }

  /* En-tête colonnes fixes au-dessus de tout */
  #myTable thead .sticky-col {
    z-index: 4; !important;
  }
</style>


<%
  try{
    String lien = (String) session.getValue("lien");
    user.UserEJB u= (user.UserEJB) session.getValue("u");

    String idResa = request.getParameter("id");
    Reservation resa = new Reservation();
    resa.setId(idResa);
    resa = (Reservation) CGenUtil.rechercher(resa,null,null,null,"")[0];
    LocalDate[] intervales = resa.getDateInterval(null);
%>
<div>
  <input type="hidden" id="idResa" value="<%=idResa%>">
  <div id="conteneur" class="row" style="padding: 0px 30px 0 30px;display: none">
    <div class="col-md-12 cardradius" style="background: white">
      <div style="width: 100%;display: flex">
        <form class="col-md-6 col-xs-12" method="Get" style="display: flex;align-items: end;">

          <div class="form-input col-md-4 col-xs-12">
            <label class="nopadding fontinter labelinput">Date debut</label>
            <input class='form-control' type='date' value='<%=intervales[0]%>' id='daty1'>
          </div>
          <div class="form-input col-md-4 col-xs-12">
            <label class="nopadding fontinter labelinput">Date fin</label>
            <input class='form-control' type='date' value='<%=intervales[1]%>' id='daty2'>
          </div>
          <div class="form-input col-md-4 col-xs-12">
            <button class="btn btn-success" style="width: 100%;height: 32px;text-align: center" type="button" onclick="startSaisie()">Filtrer</button>
          </div>
        </form>
      </div>
      <div class="table-container">
        <table id="myTable" class="table table-bordered" style="margin-top: 15px;" cellspacing="0">
          <thead id="tab-head">
          <tr id="tab-title">
            <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
              <label for="remarque_0">Remarque</label>
            </th>
            <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
              <label for="source_0">Source</label>
            </th>
            <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91" colspan="1">
              <label for="heure_0">Heure</label>
            </th>
            <th rowspan="3" class="contenuetable fontinter sticky-col" style="color:white;background-color:#2c3d91;min-width: 100px;" colspan="1">
              <label for="source_0">Quantite</label>
            </th>
          </tr>
          </thead>
          <tbody id="ajout_multiple_ligne">

          </tbody>
        </table>
      </div>
    </div>
  </div>
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
    var nbLigne = document.querySelectorAll('[id="heure"]').length;
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
      colonne.setAttribute("style","color:white;background-color:#2c3d91;text-align: center;top:45px;");
      colonne.setAttribute("colSpan","1");
      colonne.innerHTML = "<p style='margin: 1px'>"+getJourSemaine(lisDate[i])+"</p>"+
              "<p style='margin:0px'>"+date[0]+"</p>";
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


  async function initialiseDonneeModif(dtDebut,dtFin,listDate,idResa) {
    await fetch('<%=request.getContextPath()%>/ReservationServlet?action=find_details_planning&dtDebut='+dtDebut+'&dtFin='+dtFin+'&idReservation='+idResa)
            .then(res => res.json())
            .then(data => {
              console.log(data);
              var totalSpots = new Map();
              for (let i = 0; i < data.length; i++) {
                createLigneWithData(data[i],listDate,i,totalSpots);
              }
              createLigneFooter(listDate,data.length,totalSpots);
              updateStickyOffsets();
            })
            .catch(error => console.error("Erreur :", error));
  }

  function createLigneWithData (resa,listDate,id,totalSpots){
    var nbSpot = resa.dates.length;
    var total = totalSpots?.get("total") || 0;
    totalSpots.set("total",total+nbSpot);
    var html_template =
            "<td style='border: 0.2px solid #2e2e2e;' class='sticky-col'>"+resa.remarque+"</td>\n"+
            "<td style='border: 0.2px solid #2e2e2e;' class='sticky-col'>"+resa.source+"</td>\n"+
            // "<td class='sticky-col'>"+resa.isEntete+"</td>\n"+
            "<td style='border: 0.2px solid #2e2e2e;' class='sticky-col' id='heure'>"+resa.heure+"</td>\n"+
            "<td style='border: 0.2px solid #2e2e2e;' class='sticky-col'>"+nbSpot+"</td>\n";

    for (let i = 0; i < listDate.length; i++) {

      var idResaDetails = resa.planning[i][0];
      var color = resa.planning[i][1];
      var url = "";
      var cursor = "default";
      if (idResaDetails!=null && idResaDetails!==""){
        url = "onclick=\"ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-details-fiche.jsp&id="+idResaDetails+"','modalContent')\"";
        cursor = "pointer";
        total = totalSpots?.get(listDate[i]) || 0;
        totalSpots.set(listDate[i],total+1);
      }

      html_template += "<td "+url+" style=\"text-align: center;vertical-align: middle;background-color: "+color+";cursor:"+cursor+";border: 0.2px solid #2e2e2e;\" align=\"center\"></td>\n";
    }

    var element = document.createElement("tr");
    element.setAttribute("id", "ligne-multiple-"+id);
    element.innerHTML = html_template;
    var tableau = document.getElementById("ajout_multiple_ligne");
    tableau.appendChild(element);
  }

  function createLigneFooter (listDate,id,totalSpots){
    var total = totalSpots?.get("total") || 0;
    var html_template = "<td class='sticky-col' style='background-color: white;border: none'></td>\n"+
            "<td class='sticky-col' style='background-color: white;border: none'></td>\n"+
            "<td class='sticky-col' style='background-color: white;border: none'></td>\n"+
            "<td id='heure' class='sticky-col' style=\"vertical-align: middle;background-color: gainsboro;\">"+total+"</td>\n";

    for (let i = 0; i < listDate.length; i++) {
      total = totalSpots?.get(listDate[i]) || 0;
      html_template += "<td style=\"vertical-align: middle;background-color: gainsboro;\" align=\"center\">"+total+"</td>\n";
    }

    var element = document.createElement("tr");
    element.setAttribute("id", "ligne-multiple-"+id);
    element.innerHTML = html_template;
    var tableau = document.getElementById("ajout_multiple_ligne");
    tableau.appendChild(element);
  }

  function updateStickyOffsets() {
    const table = document.getElementById("myTable");
    var nbCell = 4;
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


<%
  }catch(Exception e){
    e.printStackTrace();
  }
%>

