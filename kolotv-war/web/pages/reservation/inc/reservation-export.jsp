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
<%@ page import="utilitaire.ConstanteEtat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="produits.CategorieIngredient" %>
<%
  try {
    Support [] supports = (Support[]) CGenUtil.rechercher(new Support(),null,null,null,"");
    CategorieIngredient[] categorieIngredients = (CategorieIngredient[]) CGenUtil.rechercher(new CategorieIngredient(),null,null,null,"");
%>

<div class="content-wrapper">
  <div style="width: 100%;display: flex;justify-content: center">
    <div class='box box-primary box-solid'>
      <div class='box-header' style='background-color: rgb(32, 83, 150); border-top: 3px solid #205396;'>
        <h3 class='box-title' color='#edb031'><span color='#edb031'>Export Excel</span></h3>
      </div>
      <div class='box-insert'>
        <form action="${pageContext.request.contextPath}/ExportCSV" method="POST" style="background-color: white;padding: 10px;margin: 5px;border-radius: 5px">
          <input type="hidden" name="action" value="exp_reservation_journalier">
          <label class="nopadding fontinter labelinput">Support</label>
          <div class="form-input">
            <select name="idSupport" class="form-control">
              <option value="">Tous</option>
              <% for (Support s:supports){%>
                <option value="<%=s.getId()%>"><%=s.getVal()%></option>
              <% } %>
            </select>
          </div>
          <label class="nopadding fontinter labelinput">Type de service</label>
          <div class="form-input">
            <% for (CategorieIngredient s:categorieIngredients){%>
            <label><%=s.getVal()%></label>
            <input type="checkbox" name="idTypeService" value="<%=s.getId()%>">
            <% } %>
          </div>

          <label class="nopadding fontinter labelinput">Etat</label>
          <div class="form-input">
            <select name="etat" class="form-control">
              <option value="">Tous</option>
              <option value="1">CR&Eacute;E</option>
              <option value="11">VALID&Eacute;E</option>
            </select>
          </div>
          <label class="nopadding fontinter labelinput">Date de d&eacute;but</label>
          <div class="form-input">
            <input name="dtDebut" type="date" class="form-control" value="<%= LocalDate.now() %>">
          </div>
          <label class="nopadding fontinter labelinput">Date Fin</label>
          <div class="form-input">
            <input name="dtFin" type="date" class="form-control" value="<%= LocalDate.now() %>">
          </div>
          <button class="btn btn-success" style="width: 100%;text-align: center" type="submit">Exporter</button>
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

