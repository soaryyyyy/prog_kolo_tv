<%--
    Document   : dureemaxspot-dupliquer
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
        String support = request.getParameter("support");
        String idReservation = request.getParameter("id");
        String date = request.getParameter("date");
        Support s = new Support();
        Support[] listeSupport = (Support[]) CGenUtil.rechercher(s, null, null, "");
        String lien = (String) session.getValue("lien");

        String butApresPost = "reservation/reservation-fiche.jsp";
%>

<div class="content-wrapper">
    <div style="width: 100%;display: flex;justify-content: center">
        <div class='box box-primary box-solid'>
            <div class='box-header' style='background-color: rgb(32, 83, 150); border-top: 3px solid #205396;'>
                <h3 class='box-title' color='#edb031'><span color='#edb031'>Duplication de r&eacute;servation</span></h3>
            </div>
            <div class='box-insert'>
                <form action="<%= lien + "?but=apresReservation.jsp" %>" method="POST" style="background-color: white;padding: 10px;margin: 5px;border-radius: 5px">
                    <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
                    <input type="hidden" name="acte" value="dupliquerReservation">
                    <input type="hidden" name="idReservation" value="<%=idReservation%>">
                    <label class="nopadding fontinter labelinput">Support</label>
                    <div class='form-input'>
                        <select name="idSupport" class="form-control">
                            <% for (Support sup:listeSupport){ %>
                                    <option value="<%=sup.getId()%>"><%=sup.getVal()%></option>
                            <% } %>
                        </select>
                    </div>
                    <label class="nopadding fontinter labelinput">Date</label>
                    <div class="form-input">
                        <input class='form-control' type='date' name='date'>
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

