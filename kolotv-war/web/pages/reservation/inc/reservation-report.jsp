<%--
    Document   : reservation-report
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="prevision.Prevision"%>
<%@page import="support.Support"%>
<%@page import="bean.*"%>
<%@ page import="utils.CalendarUtil" %>
<%
    try {
        String[] ids = request.getParameterValues("ids");
        String lien = (String) session.getValue("lien");
        String butApresPost = "reservation/reporter-reservation.jsp";
%>

<div class="content-wrapper">
    <div style="width: 100%;display: flex;justify-content: center">
     <div class='box box-primary box-solid'>
        <div class='box-header' style='background-color: rgb(32, 83, 150); border-top: 3px solid #205396;'>
            <h3 class='box-title' color='#edb031'><span color='#edb031'>Reporter r&eacute;servation</span></h3>
        </div>
        <div class='box-insert'>
        <form action="<%= lien + "?but=apresReservation.jsp" %>" method="POST" style="background-color: white;padding: 10px;margin: 5px;border-radius: 5px">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input type="hidden" name="acte" value="reporterReservation">

            <% for (String id:ids){ %>
                    <input type="hidden" name="ids" value="<%=id%>">
            <% } %>

            <label class="nopadding fontinter labelinput">Date</label>
            <div class="form-input">
                <input name="date" type="date" class="form-control" id="date" >
            </div>
            <label class="nopadding fontinter labelinput">Heure</label>
            <div class="form-input">
                <input name="heure" value="<%= utilitaire.Utilitaire.heureCouranteHM() %>" type="time" class="form-control" id="heure" >
            </div>
            <button class="btn btn-success" style="width: 100%;text-align: center" type="submit">Valider</button>
        </form>
    </div>
    </div>
    </div>

</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

