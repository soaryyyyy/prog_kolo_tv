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


<%
    try{
        String lien = (String) session.getValue("lien");
        ReservationLib t = new ReservationLib();
        user.UserEJB u= (user.UserEJB) session.getValue("u");

        /* Récuperer la date par défaut */
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        String dateEncours = request.getParameter("d");
        if (dateEncours == null || dateEncours.trim().isEmpty()) {
            LocalDate aujourdHui = LocalDate.now();
            dateEncours = aujourdHui.format(formatter);
        }

        String debutEtFinDeSemaine[]=CalendarUtil.getDebutEtFinDeSemaine(dateEncours);

        reservation.EtatReservation eta=u.getEtatReservation(null,"ReservationDetailsAvecMere",debutEtFinDeSemaine[0],debutEtFinDeSemaine[1]);
        String[] listeDate=eta.getListeDate();
        String[] listIdChambre=eta.getListeIdChambre();
        String[] listeChambre=eta.getListeChambre();

        // URL du site
        String urlComplete = request.getRequestURL().toString();
        String queryString = request.getQueryString();

        if (queryString != null) {
            urlComplete += "?" + queryString;
        }
        String lienPrecedent = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,debutEtFinDeSemaine[2]);
        String lienSuivant = UrlUtils.modifierParametreDansUrl(urlComplete,"d" ,debutEtFinDeSemaine[3]);



%>
<div class="content-wrapper">
    <section class="content-header">
        <h1> <i class="fa fa-calendar"></i>&nbsp;&nbsp;&nbsp;Planning hebdomadaire</h1>
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
    <!-- Légende -->
    <div class="legend">
        <span class="occupe">Occup&eacute;</span>
        <span class="disponible">Disponible</span>
        <span class="en-attente">En attente</span>
    </div>
    <section class="content">
    <div class="row">
    <div class="col-xs-12 calendar-scroll">
    <table class="table table-bordered calendar-table">
        <thead>
            <tr>
                <th class="room-col">Chambres</th>
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
            <% for(int i=0;i<listeChambre.length;i++) 
                { %>
                <tr>
                    <td class="room-col">
                    <%=listeChambre[i]%>
                    </td>
                    <% for(int j=0;j<listeDate.length;j++) { %>
                    <% ReservationDetailsLib[] resaChambre=eta.getResaById(listeDate[j],listIdChambre[i]);
                    int countResaOK=0;
                    if(resaChambre != null && resaChambre.length>0) { %>
                    <td>
                        <%
                            for (ReservationDetailsLib r : resaChambre) {
                                if (r != null) { %>
                                <% if(r.getLibelleStatus()=="occupe") countResaOK=1; %>


                                <div class="<%=r.getLibelleStatus()%>">
                                    <a href="<%=lien%>?but=reservation/reservation-fiche.jsp&id=<%=r.getIdmere()%>">
                                        <%=r.getLibelleClient()%>
                                    </a>
                                </div>
                               <% }
                            }
                            %>
                        <% if(countResaOK==0) { %>
                        <div>
                        <a href="<%=lien%>?but=reservation/reservation-simple-saisie.jsp&daty=<%=listeDate[j]%>&idproduit=<%=listIdChambre[i]%>">
                            <i class="fa fa-plus"></i>
                        </a>
                        </div>
                        <% } %>
                    </td>

                    <%  } else { %>
                     <td class="disponible">
                         <a href="<%=lien%>?but=reservation/reservation-simple-saisie.jsp&daty=<%=listeDate[j]%>&idproduit=<%=listIdChambre[i]%>">
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
            <% for(int i=0;i<listeDate.length;i++)
            { %>
            <th>
                <%=Utilitaire.formaterAr(eta.getSommeBydate(listeDate[i]))%>
            </th>
            <%  } %>
        </tr>
        </tfoot>
    </table>
      </div>
        </div>
    </section>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>

