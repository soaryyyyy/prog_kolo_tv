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
<%@ page import="reservation.ReservationDetailsLib" %>
<%@ page import="utils.ConstanteAsync" %>
<%@ page import="utils.CalendarUtil" %>
<%@ page import="utils.UrlUtils" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="reservation.EtatReservationDetails" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.util.List" %>
<%@ page import="reservation.ReservationDetailsAvecDiffusion" %>
<%@ page import="java.util.Vector" %>
<%@ page import="produits.Acte" %>
<%@ page import="support.Support" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="produits.CategorieIngredient" %>


<style>
.form-input {
  margin-bottom: 0px;
}
table td{
  max-width: 30%;
}
.planning-content p{
  font-weight: bold;
  margin: 0px;
  font-size: 10px;
}
.calendar-grid {
  width: 100%;
  background-color: white;
  overflow: hidden;
  border-radius: 2px;
}
.calendar-cell {
  border-style: solid;
  border-width: 0.5px;
  border-color: #c8c8c8;
  padding: 20px 10px;
  text-align: center;
}
.event{
  display: flex;
  justify-content: space-between;
  gap: 2px;
  align-items: flex-start;
  font-size: 16px;
  line-height: 1.2;
  text-overflow: ellipsis;
}

.day-btn {
  cursor: pointer;
  color: white;
  background-color: #003695db;
  padding: 10px 2px;
  text-align: center;
  font-size: 18px;
  border-style: solid;
  border-width: 0.5px;
  border-color: #c8c8c8;
  font-weight: bold;
  transition: 0.3s ease;
}
.day-btn:hover{
  color: rgba(255, 255, 255, 0.87);
  background-color: #0b3881;
}
.event-title {
  width: 80%;
  background: #f4f4f4;
  border-left: 3px solid #0e66ff;
  padding: 2px 6px;
  margin: 2px 0;
  border-radius: 3px;
  overflow: hidden;
  cursor: pointer;
  transition: 0.3s ease;
}

.event-title:hover{
  box-shadow: 0 0 5px #616161;
}

.event-title p{
  margin: 0;
  padding: 0;
}
.event-hours{
  width: fit-content;
  padding: 2px 2px;
  color: #333;
}

.calendar-cell-title{
  padding: 10px 2px;
  text-align: center;
  font-size: 18px;
  background-color: rgba(231, 231, 231, 0.334);
  border-style: solid;
  border-width: 0.5px;
  border-color: #c8c8c8;
  font-weight: bold;
}

.calendar-footer{
  border-style: solid;
  border-width: 0.5px;
  border-color: #c8c8c8;
  padding: 5px;
}
</style>

<%
  try{
    String lien = (String) session.getValue("lien");
    user.UserEJB u= (user.UserEJB) session.getValue("u");

    /* Récuperer la date par défaut */
    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String dateEncours = request.getParameter("d");
    if (dateEncours!=null){
      dateEncours = CalendarUtil.castDateToFormat(dateEncours,DateTimeFormatter.ofPattern("yyyy-MM-dd"),formatter);
    }
    if (dateEncours == null || dateEncours.trim().isEmpty()) {
      LocalDate aujourdHui = LocalDate.now();
      dateEncours = aujourdHui.format(formatter);
    }

    String debutEtFinDeSemaine[]=CalendarUtil.getDebutEtFinDeSemaine(dateEncours);
    String idSupport = request.getParameter("idSupport");
    if (idSupport==null){
      idSupport = "SUPP002";
    }
    String idTypeService = request.getParameter("idCategorieIngredient");

    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    EtatReservationDetails eta=new EtatReservationDetails(idSupport,idTypeService,debutEtFinDeSemaine[0],debutEtFinDeSemaine[1]);
    String[] listeDate=eta.getListeDate();
    List<LocalTime[]> listeHoraire=eta.getHoraire();
    HashMap<String,Double[]> total = eta.getTotal();

    // URL du site
    String urlComplete = request.getRequestURL().toString();
    String queryString = request.getQueryString();

    if (queryString != null) {
      urlComplete += "?" + queryString;
    }
    String lienPrecedent = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,CalendarUtil.castDateToFormat(debutEtFinDeSemaine[2],formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd")));
    String lienSuivant = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,CalendarUtil.castDateToFormat(debutEtFinDeSemaine[3],formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd")));

    Support [] supports = (Support[]) CGenUtil.rechercher(new Support(),null,null,null,"");
    CategorieIngredient [] categorieIngredients = (CategorieIngredient[]) CGenUtil.rechercher(new CategorieIngredient(),null,null,null,"");
  String temp="";
  temp=temp+ "<div class=\"modal fade\" id=\"linkModal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"linkModalLabel\" aria-hidden=\"true\">\r\n" +
          "  <div style='width:60%;background:transparent;' class=\"modal-dialog modal-dialog-centered\" role=\"dialog\">\r\n" + //
          "    <div style=\"border-radius: 16px;padding:15px;overflow-y:auto;height:80vh\" class=\"modal-content\">\r\n" + //
          "      <div class=\"modal-body\">\r\n"+
          "       <div id=\"modalContent\">\r\n>";
  temp +=                "</div>\r\n" + //
          "    </div>\r\n" + //
          "   </div>\r\n" + //
          "  </div>\r\n" + //
          "</div>";
  String bute = "reservation/reservation-details-calendrier.jsp";
%>
<div class="content-wrapper">

  <section class="content-header">
    <h1> <i class="fa fa-calendar"></i>&nbsp;&nbsp;&nbsp; Grille de diffusion</h1>
  </section>

  <!-- Navigation semaine -->
  <div class="week-nav">
    <a href="<%=lienPrecedent%>" id="prev-week" class="btn btn-default">
      <i class="fa fa-chevron-left"></i>
    </a>
    <span class="week-range" id="week-range">Semaine du <%=debutEtFinDeSemaine[0]%> au <%=debutEtFinDeSemaine[1]%></span>
    <a href="<%=lienSuivant%>" id="next-week" class="btn btn-default">
      <i class="fa fa-chevron-right"></i>
    </a>
  </div>

  <!-- Sélection du support -->
  <div style="width: 100%;display: flex;justify-content: center">
    <form class="col-md-6 col-xs-12" action="<%=lien%>" method="Get" style="padding: 10px;margin: 5px;border-radius: 5px;display: flex;align-items: end;">
      <div class='form-input col-md-4 col-xs-12'>
        <label class="nopadding fontinter labelinput">Support</label>
        <select class="form-control" name="idSupport">
          <option value="">Tous</option>

          <% for (Support s:supports) {
            String isSelected = "";
            if(idSupport!=null && idSupport.equals(s.getId())){
                isSelected="selected";
              }
          %>
             <option <%=isSelected%> value="<%=s.getId()%>"><%=s.getVal()%></option>
          <% } %>
        </select>

      </div>
      <div class='form-input col-md-4 col-xs-12'>
        <label class="nopadding fontinter labelinput">Type Service</label>
        <select class="form-control" name="idCategorieIngredient">
          <option value="">Tous</option>

          <% for (CategorieIngredient c:categorieIngredients) {
            String isSelected = "";
            if(idTypeService!=null && idTypeService.equals(c.getId())){
              isSelected="selected";
            }
          %>
          <option <%=isSelected%> value="<%=c.getId()%>"><%=c.getVal()%></option>
          <% } %>
        </select>

      </div>
      <div class="form-input col-md-4 col-xs-12">
        <label class="nopadding fontinter labelinput">Date</label>
        <input class='form-control' type='date' value='<%=CalendarUtil.castDateToFormat(dateEncours,formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd"))%>' name='d'>
      </div>
      <input type='hidden' value='<%=bute%>' name='but'>
      <div class="form-input col-md-4 col-xs-12">
        <button class="btn btn-success" style="width: 100%;height: 32px;text-align: center" type="submit">Afficher</button>
      </div>
    </form>
  </div>
  <!-- Support selection -->

  <!-- Légende -->
  <div class="legend">
<%--    <span class="occupe">Diffuser</span>--%>
<%--    <span class="disponible">Disponible</span>--%>
<%--    <span class="en-attente">En attente</span>--%>
  </div>
  <section class="content">
    <div class="row">
      <div class="col-xs-12 calendar-scroll">
        <table class="calendar-grid">
          <thead>
          <tr>
            <th class="calendar-cell-title">Horaire</th>
            <% for(int i=0;i<listeDate.length;i++)
            { %>
            <th class="day-btn" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/inc/reservation-popup.jsp&daty=<%=listeDate[i]%>&idSupport=<%=idSupport%>&idCategorieIngredient=<%=idTypeService%>','modalContent')">
              <%=listeDate[i]%>
            </th>
            <%  } %>
          </tr>
          </thead>
          <tbody>
          <tr>
              <% for(int i=0;i<listeHoraire.size();i++) {
                LocalTime [] intervales = listeHoraire.get(i);
              %>
          <tr>
            <td class="calendar-cell-title">
              <%=intervales[0]%>
            </td>
            <% for(int j=0;j<listeDate.length;j++) { %>
            <%
              ReservationDetailsAvecDiffusion [] reservations = eta.getReservationByTime(intervales,listeDate[j]);
              if(reservations != null && reservations.length>0) { %>
            <td class="calendar-cell">
              <% for (int k=0;k<reservations.length && k<2;k++) {
                if (reservations[k] != null) { %>
              <div class="event" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/reservation-details-fiche.jsp&id=<%=reservations[k].getId()%>','modalContent')">
                <div class="event-title" style="border-left: 3px solid <%=reservations[k].getCodeCouleur()%>"><p><%=reservations[k].getRemarque()%></p></div>
                <div class="event-hours"><%=reservations[k].getHeure()%></div>
              </div>
              <% } }%>
              <% if (reservations.length > 2) { %>
                  <a class="btn btn-primary" style="width: 100%;margin-top: 4px" onclick="ouvrirModal(event,'moduleLeger.jsp?but=reservation/inc/reservation-popup.jsp&bute=<%=bute%>&daty=<%=listeDate[j]%>&heureDebut=<%=intervales[0]%>&heureFin=<%=intervales[1]%>&idSupport=<%=idSupport%>&idCategorieIngredient=<%=idTypeService%>','modalContent')">
                      <i class="fa fa-search-plus"></i> Voir plus (<%=reservations.length-2%>)
                  </a>
              <% } %>

              <% if(eta.getResteADiffuser(intervales)>0) { %>
                <a class="btn btn-success" style="width: 100%;margin-top: 4px" href="<%=lien%>?but=reservation/reservation-groupe-saisie.jsp&date=<%=CalendarUtil.castDateToFormat(listeDate[j],formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd"))%>&heure=<%=intervales[0].format(DateTimeFormatter.ofPattern("HH:mm:ss"))%>&idSupport=<%=idSupport%>">
                  <i class="fa fa-plus"></i> <%=CalendarUtil.secondToHMS(eta.getResteADiffuser(intervales))%>
                </a>
              <% } %>
            </td>

            <%  } else { %>
            <td class="calendar-cell">
              <a href="<%=lien%>?but=reservation/reservation-groupe-saisie.jsp&date=<%=CalendarUtil.castDateToFormat(listeDate[j],formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd"))%>&idSupport=<%=idSupport%>&heure=<%=intervales[0].format(DateTimeFormatter.ofPattern("HH:mm:ss"))%>">
                <i class="fa fa-plus"></i>
              </a>
            </td>
            <% } %>
            <%  } %>

          </tr>
          <%  } %>

          </tbody>
          <tfoot>
          <tr>
            <th class="calendar-cell-title">TOTAL</th>
            <% for(int k=0;k<listeDate.length;k++) {
              Double [] tab = total.get(listeDate[k]);
            %>
              <th class="calendar-footer">
                <%-- <p>Montant : <strong><%=Utilitaire.formaterAr(tab[0])%></strong></p> --%>
                <p>Dur&eacute;e de diffusion : <strong><%=CalendarUtil.secondToHMS(Math.round(tab[1]))%></strong></p>

              </th>
            <%  } %>
          </tr>
          </tfoot>
        </table>
      </div>
    </div>
  </section>
</div>

<% out.println(temp);%>

<script>


  function affModal(idResa) {
    var checkboxes = document.querySelectorAll('input[name="id"]:checked');
    if (checkboxes.length==0){
      alert("vous devez cocher");
      return;
    }
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

  function sendSingnalement(){
    var checkboxes = document.querySelectorAll('input[name="id"]:checked');
    var description = document.getElementById("description").value;
    if (description===""){
      alert("Veuillez ajouter une description");
      return;
    }
    const formData = new URLSearchParams();
    Array.from(checkboxes).forEach(cb=>{
      formData.append('ids',cb.value);
    })
    formData.append('description',description);

    fetch('<%=request.getContextPath()%>/NotificationServlet?action=send_notif', {
      method: 'POST',
      headers:{
        'Content-Type':'application/x-www-form-urlencoded'
      },
      body: formData
    })
    .then(response => response.text())
    .then(data => {
        // Affiche simplement la réponse du serveur (ex: texte CSV, message, etc.)
        console.log("Réponse du serveur :", data);
        alert("Message envoy&eacute;"); // ou injecter dans une div

    })
    .catch(error => {
        console.error('Erreur lors de l\'export :', error);
        alert("Une erreur est survenue.");
    });
  }
</script>


<%
  } catch (Exception e) {
    e.printStackTrace();
  } %>

