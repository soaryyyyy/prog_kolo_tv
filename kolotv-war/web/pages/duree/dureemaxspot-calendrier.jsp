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
<%@ page import="duree.DisponibiliteHeure" %>
<%@ page import="duree.EtatDureeMaxSpot" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.util.List" %>
<%@ page import="support.Support" %>
<%@ page import="bean.CGenUtil" %>

<style>
.form-input {
  margin-bottom: 0px;
}
.planning-box{
    width: 100%;
    background-color: aquamarine;
    padding: 4px;
    border-radius: 5px;
    font-family: sans-serif;
    transition: 0.2s ease-in;
}
.planning-box:hover{
    box-shadow: 0 0 4px rgb(52, 52, 52);
}
.planning-header{
    margin: 0px;
    font-size: 12px;
    font-weight: bold;
}
.planning-body{
    background-color: rgba(255, 255, 255, 0.952);
    border-radius: 5px;
    padding: 4px;
}
.planning-content{
    border-bottom-style: solid;
    border-bottom-width: 0.2px;
    padding-bottom: 4px;
    padding-top: 2px;
    border-bottom-color: rgba(0, 0, 0, 0.145);
    margin-bottom: 4px;
}
.planning-content p{
    font-weight: bold;
    margin: 0px;
    font-size: 10px;
}
.planning-content-time-interval{
    display: flex;
    width: 100%;
    justify-content: space-around;
    font-size: 10px;
}
.time-interval-start{
    font-weight: bold;
    text-align: center;
    width: 40%;
    background-color:  rgb(149, 203, 232);
    margin: 0px;
    color: rgb(3, 94, 143);
    padding-left: 4%;
    padding-right: 4%;
    padding-top: 2.5px;
    padding-bottom: 2.5px;
    border-radius: 2px;
}
.time-interval-end{
    font-weight: bold;
    text-align: center;
    width: 40%;
    background-color:  rgb(252, 218, 182);
    margin: 0px;
    color: rgb(232, 151, 64);
    padding-left: 4%;
    padding-right: 4%;
    padding-top: 2.5px;
    padding-bottom: 2.5px;
    border-radius: 2px;
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
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        String idSupport = request.getParameter("idSupport");
        if (idSupport==null){
            idSupport = "SUPP002";
        }
        EtatDureeMaxSpot eta = new EtatDureeMaxSpot(idSupport);
        String[] listeDate=eta.getJoursString();
        List<LocalTime[]> listeHoraire=eta.getHoraire();
        HashMap<String,Double[]> total = eta.getDureeTotal();
        // URL du site
        String urlComplete = request.getRequestURL().toString();
        String queryString = request.getQueryString();

        if (queryString != null) {
            urlComplete += "?" + queryString;
        }
        String lienPrecedent = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,CalendarUtil.castDateToFormat(debutEtFinDeSemaine[2],formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        String lienSuivant = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,CalendarUtil.castDateToFormat(debutEtFinDeSemaine[3],formatter,DateTimeFormatter.ofPattern("yyyy-MM-dd")));

        Support [] supports = (Support[]) CGenUtil.rechercher(new Support(),null,null,null,"");

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

%>
<div class="content-wrapper">

    <section class="content-header">
        <h1> <i class="fa fa-calendar"></i>&nbsp;&nbsp;&nbsp;Configuration de diffusion</h1>
    </section>
    <!-- Légende -->
    <div style="width: 100%;display: flex;justify-content: center">
        <form class="col-md-4" action="<%=lien%>" method="Get" style="padding: 10px;margin: 5px;border-radius: 5px;display: flex;align-items: end;">

            <div class='form-input col-md-6 col-xs-12'>
                <label class="nopadding fontinter labelinput">Support</label>
                <select class="form-control" name="idSupport">
                    <% for (Support s:supports) {
                        String isSelected = "";
                        if(idSupport.equals(s.getId())){
                            isSelected="selected";
                        }
                    %>
                    <option <%=isSelected%> value="<%=s.getId()%>"><%=s.getVal()%></option>
                    <% } %>
                </select>

            </div>
            <input type='hidden' value='duree/dureemaxspot-calendrier.jsp' name='but'>

            <button class="btn btn-success col-md-6" style="height:32px;text-align: center" type="submit">Afficher</button>

        </form>
    </div>
    <div class="legend">
<%--        <span class="occupe">Occup&eacute;</span>--%>
        <span class="disponible">Disponible</span>
        <span class="en-attente">Occup&eacute;</span>
    </div>
    <section class="content">
        <div class="row">
            <div class="col-xs-12 calendar-scroll">
                <table class="table table-bordered calendar-table">
                    <thead>
                    <tr>
                        <th class="room-col">Heure</th>
                        <% for(int i=0;i<listeDate.length;i++)
                        { %>
                        <th>
                            <%=listeDate[i]%>
                        </th>
                        <%  } %>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <% for(int i=0;i<listeHoraire.size();i++){
                            LocalTime [] intervales = listeHoraire.get(i);
                    %>
                    <tr>
                        <td class="room-col">
                            <%=intervales[0]%>
                        </td>
                        <% for(int j=0;j<listeDate.length;j++) {
                        %>
                        <% DisponibiliteHeure[] dsph=eta.getDisponibiliteHeuresByTime(intervales,listeDate[j]);
                            if(dsph != null && dsph.length>0) { %>
                        <td>
                            <%
                                for (DisponibiliteHeure r : dsph) {
                                    double resteDuree = r.getResteDuree();
                            %>
                                    <% if (r != null) { %>
                                        <div onclick="ouvrirModal(event,'moduleLeger.jsp?but=duree/dureemaxspot-fiche.jsp&id=<%=r.getId()%>','modalContent')" class="planning-box" style="background-color: <%=r.getLibelleStatus()%>">
                                            <p class="planning-header"><%=r.getIdCategorieIngredientLib()%></p>
                                            <div class="planning-body">
                                                <div class="planning-content">
                                                    <p>Duree : <%=CalendarUtil.secondToHMS(Long.parseLong(r.getMax()))%></p>
                                                </div>
                                                <div class="planning-content-time-interval">
                                                    <p class="time-interval-start"><%=r.getHeureDebut()%></p>
                                                    <p class="time-interval-end"><%=r.getHeureFin()%></p>
                                                </div>
                                            </div>
                                        </div>
                                    <% } %>
                            <% } %>

                        </td>

                        <%  } else { %>
                        <td>
                            <a href="<%=lien%>?but=duree/dureemaxspot-saisie.jsp&jour=<%=listeDate[j]%>&idSupport=<%=idSupport%>&heureDebut=<%=intervales[0].format(DateTimeFormatter.ofPattern("HH:mm:ss"))%>&heureFin=<%=intervales[1].format(DateTimeFormatter.ofPattern("HH:mm:ss"))%>">
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
                        <th class="room-col">TOTAL</th>
                        <% for(int i=0;i<listeDate.length;i++) {
                            Double [] tab = total.get(listeDate[i]);
                        %>
                        <th>
                            <p>Dur&eacute;e Max : <strong><%=CalendarUtil.secondToHMS(Math.round(tab[0]))%></strong></p>
                            <p>Dur&eacute;e de diffusion : <strong><%=CalendarUtil.secondToHMS(Math.round(tab[1]))%></strong></p>
                            <p>Reste : <strong><%=CalendarUtil.secondToHMS(Math.round(tab[2]))%></strong></p>
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

<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>

