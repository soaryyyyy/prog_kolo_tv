<%--
    Document   : participantemission-saisie.jsp
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="emission.ParticipantEmission"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>

<%
try {
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "emission.ParticipantEmission",
           nomtable = "PARTICIPANTEMISSION",
           apres = "emission/participantemission-fiche.jsp",
           titre = "Insertion de participant &eacute;mission";

    ParticipantEmission objet = new ParticipantEmission();
    objet.setNomTable("PARTICIPANTEMISSION");
    PageInsert pi = new PageInsert(objet, request, u);
    pi.setLien((String) session.getValue("lien"));

    pi.getFormu().getChamp("nom").setLibelle("Nom");
    pi.getFormu().getChamp("contact").setLibelle("Contact");
    pi.getFormu().getChamp("adresse").setLibelle("Adresse");
    pi.getFormu().getChamp("datedenaissance").setLibelle("Date de naissance");
    pi.getFormu().getChamp("idemission").setLibelle("Emission");
    pi.getFormu().getChamp("idemission").setPageAppelComplete("emission.Emission", "id","Emission");

    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%> </h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<% } catch (Exception e) {
    e.printStackTrace(); %>
<script language="JavaScript"> alert('<%=e.getMessage()%>'); history.back();</script>
<% } %>
