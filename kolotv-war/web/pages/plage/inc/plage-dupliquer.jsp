<%--
    Document   : plage-dupliquer
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageRecherche"%>
<%@page import="prevision.Prevision"%>
<%@page import="support.Support"%>
<%@page import="bean.*"%>
<%
    try {
        String[] intervalles = {};
        String[] criteres = {};
        String[] libEntete = {};
        String[] libEnteteAffiche = {};
        PageRecherche pr = new PageRecherche(new Prevision(), request, criteres, intervalles, 3, libEntete, libEntete.length);

        pr.setUtilisateur((UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        String lien = (String) session.getValue("lien");

    String[] joursString = new String[] {"Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"};
    String jour =request.getParameter("jour");

    String support =request.getParameter("support");
    String idPlage =request.getParameter("id");

    Support criteria = new Support();
    Support[] listeSupport = (Support[]) CGenUtil.rechercher(criteria, null, null, "");

    String apres = "plage/plage-liste.jsp";

%>

<style>
    .strong{
        font-size: 15px;
        padding-top: 4px;
    }
</style>

<div class="content-wrapper">
    <section class="content-header">

    </section>
    <form action="<%=lien%>?but=apresReservation.jsp" method="post">
        <div class='box box-primary box-solid'>
            <div class='box-header' style='background-color: rgb(32, 83, 150); border-top: 3px solid #205396;'>
                <h3 class='box-title' color='#edb031'><span color='#edb031'>Duplication plage</span></h3>
            </div>
            <div class='box-insert'>
                <div class='box-body'>
                    <div class="form-group">
                        <div class="col-md-12">
                            <label for="supports">Support a dupliquer :</label>
                        </div>

                        <div class="col-md-4">
                            <select class="form-control" name="support" id="support">
                                <%
                                    for (Support s : listeSupport) {
                                        String val = s.getVal();
                                        String id = s.getId();
                                        String desce = s.getDesce();
                                %>
                                    <%if(id.equals(support)){%>
                                        <option selected value="<%= id %>"><%= val %></option>
                                    <%} else {%>
                                    <option value="<%= id %>"><%= val %></option>
                                <% } }%>
                            </select>
                        </div>

                        <div class="col-md-12">
                            <br>
                            <br>
                        </div>

                        <div class="col-md-12">
                            <label>Choisissez les jours :</label>
                        </div>

                        <%
                            for (String j : joursString) {
                        %>
                            <div class="col-md-4">
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="jours" value="<%=j%>"> <%=j%>
                                    </label>
                                </div>
                            </div>
                        <%
                            }
                        %>

                        <br>
                        <br>
                        <br>
                        <div class='col-xs-12'>
                            <button type="submit" class='btn btn-success pull-right' style='margin-right: 25px;'>Dupliquer</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <input name="acte" type="hidden" id="nature" value="dupliquerPlage">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="id" type="hidden" id="id" value="<%=idPlage%>">
    </form>

</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

