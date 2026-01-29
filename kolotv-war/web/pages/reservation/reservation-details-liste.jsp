<%@page import="affichage.PageRecherche"%>
<%@ page import="reservation.ReservationDetailsAvecDiffusion" %>

<% try{
    ReservationDetailsAvecDiffusion rdd = new ReservationDetailsAvecDiffusion();
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        rdd.setNomTable(request.getParameter("etat"));
    } else {
        rdd.setNomTable("RESERVATIONSDETAILS_TOUS");
    }

    String[] listeCrt = {"daty","montantFinal","id", "idmere","campagne","libelleproduit","idSupportLib","remarque"};
    String[] listeInt = {"daty","montantFinal"};
    String[] libEntete = {"id", "idmere","campagne","libelleproduit","idSupportLib","daty","heureDiffusion","remarque","montantFinal"};
    String[] libEnteteAffiche = {"id", "Id Reservation","campagne","Services M&eacute;dia","Support","Date","Heure","remarque","Montant Final"};
    PageRecherche pr = new PageRecherche(rdd, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des d&eacute;tails de reservation ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("reservation/reservation-details-liste.jsp");
    String[] colSomme = { "montantFinal"};

    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idmere").setLibelle("Id Reservation");
    pr.getFormu().getChamp("libelleproduit").setLibelle("Services M&eacute;dia");
    pr.getFormu().getChamp("idSupportLib").setLibelle("Support");
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date Max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("montantFinal1").setLibelle("Montant Final Min");
    pr.getFormu().getChamp("montantFinal2").setLibelle("Montant Final Max");
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-fiche.jsp"};
    String colonneLien[] = {"idMere"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
    function changerDesignation() {
        document.reservation.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="reservation" id="reservation">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-2"></div>
                <div class="col-md-8">
                    <div class="row" style="display: flex;align-items: center;justify-content: center;">
                        <div class="col-md-4">
                            &Eacute;tat :
                            <select name="etat" class="champ form-control" id="etat" onchange="changerDesignation()" >
                                <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("RESERVATIONSDETAILS_TOUS") == 0) {%>
                                    <option value="RESERVATIONSDETAILS_TOUS" selected>Tous</option>
                                <% } else { %>
                                    <option value="RESERVATIONSDETAILS_TOUS">Tous</option>
                                <% } %>
                                <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("RESERVATIONSDETAILS_CREE") == 0) {%>
                                    <option value="RESERVATIONSDETAILS_CREE" selected>Cr&eacute;&eacute;</option>
                                <% } else { %>
                                    <option value="RESERVATIONSDETAILS_CREE">Cr&eacute;&eacute;</option>
                                <% } %>
                                <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("RESERVATIONSDETAILS_VALIDE") == 0) {%>
                                    <option value="RESERVATIONSDETAILS_VALIDE" selected>Valid&eacute;</option>
                                <% } else { %>
                                    <option value="RESERVATIONSDETAILS_VALIDE">Valid&eacute;</option>
                                <% } %>
                                <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("RESERVATIONSDETAILS_ANNULE") == 0) {%>
                                    <option value="RESERVATIONSDETAILS_ANNULE" selected>Annul&eacute;</option>
                                <% } else { %>
                                    <option value="RESERVATIONSDETAILS_ANNULE">Annul&eacute;</option>
                                <% } %>
                                <% if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("RESERVATIONAVECDIFFUSION") == 0) {%>
                                <option value="RESERVATIONAVECDIFFUSION" selected>Diffus&eacute;</option>
                                <% } else { %>
                                <option value="RESERVATIONAVECDIFFUSION">Diffus&eacute;</option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    </br>
                </div>
                <div class="col-md-2"></div>
            </div>

        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>




