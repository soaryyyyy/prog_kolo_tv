<%@ page import="java.util.Vector" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.LocalTime" %>
<%@ page import="java.time.Duration" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="reservation.EtatReservationDetails" %>
<%@ page import="reservation.ReservationDetailsAvecDiffusion" %>
<%@ page import="support.Support" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="utils.CalendarUtil" %>
<%@ page import="utils.UrlUtils" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Locale" %>

<style>
.form-input {
  margin-bottom: 0;
}
.ca-grid {
  width: 100%;
  border-collapse: collapse;
  background: #fff;
}
.ca-grid th,
.ca-grid td {
  border: 1px solid #d9d9d9;
  padding: 10px 6px;
  text-align: center;
}
.ca-grid thead th {
  background: #0f3f88;
  color: #fff;
  font-weight: 700;
}
.hour-col {
  background: #f3f6fb;
  font-weight: 700;
  min-width: 90px;
}
.total-col {
  background: #fff5e8;
  font-weight: 700;
}
.total-row th {
  background: #0f3f88;
  color: #fff;
}
.amount-cell {
  font-size: 12px;
}
.empty-cell {
  color: #a5a5a5;
}
.week-nav {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
  margin: 6px 0 12px 0;
}
</style>

<%
  try {
    String lien = (String) session.getValue("lien");

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    String dateEncours = request.getParameter("d");
    if (dateEncours != null) {
      dateEncours = CalendarUtil.castDateToFormat(dateEncours, DateTimeFormatter.ofPattern("yyyy-MM-dd"), formatter);
    }
    if (dateEncours == null || dateEncours.trim().isEmpty()) {
      dateEncours = LocalDate.now().format(formatter);
    }

    String[] debutEtFinDeSemaine = CalendarUtil.getDebutEtFinDeSemaine(dateEncours);
    String idSupport = request.getParameter("idSupport");
    if (idSupport == null) {
      idSupport = "SUPP002";
    }

    Support[] supports = (Support[]) CGenUtil.rechercher(new Support(), null, null, null, "");
    CategorieIngredient[] categorieIngredients = (CategorieIngredient[]) CGenUtil.rechercher(new CategorieIngredient(), null, null, null, "");

    String idTypeService = request.getParameter("idCategorieIngredient");
    if ((idTypeService == null || idTypeService.trim().isEmpty()) && categorieIngredients != null) {
      for (CategorieIngredient c : categorieIngredients) {
        if (c != null && c.getVal() != null && c.getVal().toLowerCase(Locale.ROOT).contains("pub")) {
          idTypeService = c.getId();
          break;
        }
      }
    }

    EtatReservationDetails eta = new EtatReservationDetails(idSupport, idTypeService, debutEtFinDeSemaine[0], debutEtFinDeSemaine[1]);
    String[] listeDate = eta.getListeDate();
    String[] nomsJours = new String[] {"Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"};
    List<LocalTime[]> listeHoraire = CalendarUtil.trierParReference(eta.getHoraire(), LocalTime.MIDNIGHT);

    double[][] montantCellule = new double[listeHoraire.size()][listeDate.length];
    double[] totalParJour = new double[listeDate.length];
    double[] totalParPlage = new double[listeHoraire.size()];
    double totalGeneral = 0;

    for (int j = 0; j < listeDate.length; j++) {
      Vector reservationsDuJour = eta.getReservations().get(listeDate[j]);
      if (reservationsDuJour == null) {
        continue;
      }
      for (Object item : reservationsDuJour) {
        ReservationDetailsAvecDiffusion r = (ReservationDetailsAvecDiffusion) item;
        if (r == null || r.getHeure() == null || r.getMontantTtc() <= 0) {
          continue;
        }

        LocalTime heureDebut;
        try {
          heureDebut = LocalTime.parse(CalendarUtil.formatTimeToHMS(r.getHeure()));
        } catch (Exception ex) {
          continue;
        }
        int dureeSeconde = 0;
        if (r.getDuree() != null && r.getDuree().trim().length() > 0) {
          try {
            dureeSeconde = (int) Double.parseDouble(r.getDuree());
          } catch (Exception ex) {
            dureeSeconde = 0;
          }
        }
        LocalTime heureFin = heureDebut.plusSeconds(Math.max(dureeSeconde, 1));

        ArrayList<Integer> plagesTouchees = new ArrayList<Integer>();
        ArrayList<Long> dureesChevauchement = new ArrayList<Long>();
        long totalChevauchement = 0;
        for (int i = 0; i < listeHoraire.size(); i++) {
          LocalTime plageDebut = listeHoraire.get(i)[0];
          LocalTime plageFin = listeHoraire.get(i)[1];
          LocalTime debutChevauchement = heureDebut.isAfter(plageDebut) ? heureDebut : plageDebut;
          LocalTime finChevauchement = heureFin.isBefore(plageFin) ? heureFin : plageFin;
          long secondesChevauchement = Duration.between(debutChevauchement, finChevauchement).getSeconds();
          if (secondesChevauchement > 0) {
            plagesTouchees.add(i);
            dureesChevauchement.add(secondesChevauchement);
            totalChevauchement += secondesChevauchement;
          }
        }

        if (plagesTouchees.size() == 0 || totalChevauchement <= 0) {
          continue;
        }

        for (int idx = 0; idx < plagesTouchees.size(); idx++) {
          int iPlage = plagesTouchees.get(idx);
          long dureePlage = dureesChevauchement.get(idx);
          double part = r.getMontantTtc() * ((double) dureePlage / (double) totalChevauchement);
          montantCellule[iPlage][j] += part;
          totalParPlage[iPlage] += part;
        }
        totalParJour[j] += r.getMontantTtc();
        totalGeneral += r.getMontantTtc();
      }
    }

    String urlComplete = request.getRequestURL().toString();
    String queryString = request.getQueryString();
    if (queryString != null) {
      urlComplete += "?" + queryString;
    }

    String lienPrecedent = UrlUtils.modifierParametreDansUrl(
      urlComplete,
      "d",
      CalendarUtil.castDateToFormat(debutEtFinDeSemaine[2], formatter, DateTimeFormatter.ofPattern("yyyy-MM-dd"))
    );
    String lienSuivant = UrlUtils.modifierParametreDansUrl(
      urlComplete,
      "d",
      CalendarUtil.castDateToFormat(debutEtFinDeSemaine[3], formatter, DateTimeFormatter.ofPattern("yyyy-MM-dd"))
    );

    String bute = "reservation/chiffre-affaire-publicite-calendrier.jsp";
%>
<div class="content-wrapper">
  <section class="content-header">
    <h1><i class="fa fa-line-chart"></i>&nbsp;&nbsp;&nbsp;Grille CA publicit&eacute;</h1>
  </section>

  <div class="week-nav">
    <a href="<%=lienPrecedent%>" class="btn btn-default"><i class="fa fa-chevron-left"></i></a>
    <span>Semaine du <%=debutEtFinDeSemaine[0]%> au <%=debutEtFinDeSemaine[1]%></span>
    <a href="<%=lienSuivant%>" class="btn btn-default"><i class="fa fa-chevron-right"></i></a>
  </div>

  <div style="width: 100%;display: flex;justify-content: center">
    <form class="col-md-8 col-xs-12" action="<%=lien%>" method="Get" style="padding: 10px;margin: 5px;border-radius: 5px;display: flex;align-items: end;">
      <div class="form-input col-md-3 col-xs-12">
        <label class="nopadding fontinter labelinput">Support</label>
        <select class="form-control" name="idSupport">
          <option value="">Tous</option>
          <% for (Support s : supports) {
            String selected = "";
            if (idSupport != null && idSupport.equals(s.getId())) {
              selected = "selected";
            }
          %>
          <option <%=selected%> value="<%=s.getId()%>"><%=s.getVal()%></option>
          <% } %>
        </select>
      </div>

      <div class="form-input col-md-3 col-xs-12">
        <label class="nopadding fontinter labelinput">Type service</label>
        <select class="form-control" name="idCategorieIngredient">
          <option value="">Tous</option>
          <% for (CategorieIngredient c : categorieIngredients) {
            String selected = "";
            if (idTypeService != null && idTypeService.equals(c.getId())) {
              selected = "selected";
            }
          %>
          <option <%=selected%> value="<%=c.getId()%>"><%=c.getVal()%></option>
          <% } %>
        </select>
      </div>

      <div class="form-input col-md-3 col-xs-12">
        <label class="nopadding fontinter labelinput">Date</label>
        <input class="form-control" type="date" value="<%=CalendarUtil.castDateToFormat(dateEncours, formatter, DateTimeFormatter.ofPattern("yyyy-MM-dd"))%>" name="d">
      </div>

      <input type="hidden" value="<%=bute%>" name="but">
      <div class="form-input col-md-3 col-xs-12">
        <button class="btn btn-success" style="width: 100%;height: 32px;text-align: center" type="submit">Afficher</button>
      </div>
    </form>
  </div>

  <section class="content">
    <div class="row">
      <div class="col-xs-12 calendar-scroll">
        <table class="ca-grid">
          <thead>
          <tr>
            <th class="hour-col">Plage</th>
            <% for (int j = 0; j < listeDate.length; j++) { %>
            <th>
              <div><%=nomsJours[j]%></div>
              <small><%=listeDate[j]%></small>
            </th>
            <% } %>
            <th class="total-col">Total plage</th>
          </tr>
          </thead>
          <tbody>
          <% for (int i = 0; i < listeHoraire.size(); i++) {
            LocalTime[] plage = listeHoraire.get(i);
          %>
          <tr>
            <td class="hour-col"><%=plage[0]%> - <%=plage[1]%></td>
            <% for (int j = 0; j < listeDate.length; j++) {
              double montant = montantCellule[i][j];
            %>
            <td class="amount-cell">
              <% if (montant > 0) { %>
              <%=Utilitaire.formaterAr(montant)%>
              <% } else { %>
              <span class="empty-cell">-</span>
              <% } %>
            </td>
            <% } %>
            <td class="total-col"><%=Utilitaire.formaterAr(totalParPlage[i])%></td>
          </tr>
          <% } %>
          </tbody>
          <tfoot>
          <tr class="total-row">
            <th>Total jour</th>
            <% for (int j = 0; j < listeDate.length; j++) { %>
            <th><%=Utilitaire.formaterAr(totalParJour[j])%></th>
            <% } %>
            <th><%=Utilitaire.formaterAr(totalGeneral)%></th>
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
  }
%>
