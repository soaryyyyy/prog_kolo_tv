<%--
    Document   : client-saisie.php
    Created on : 22 mars 2024, 14:50:09
    Author     : SAFIDY
--%>


<%@page import="client.Client"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>

<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "client.Client",
            nomtable = "CLIENT",
            apres = "client/client-fiche.jsp",
            titre = "Nouveau Client";

    Client  client = new Client();
    client.setNomTable("CLIENT");
    PageInsert pi = new PageInsert(client, request, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("nom").setLibelle("Nom");
    pi.getFormu().getChamp("telephone").setLibelle("T&eacute;l&eacute;phone");
    pi.getFormu().getChamp("mail").setLibelle("Adresse e-mail");
    pi.getFormu().getChamp("adresse").setLibelle("Adresse");
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
    pi.getFormu().getChamp("type").setLibelle("Type");
    pi.getFormu().getChamp("compte").setDefaut("401001");
    pi.getFormu().getChamp("daty").setLibelle("Date");

    affichage.Champ[] liste = new affichage.Champ[1];
    Liste typeClientListe=new Liste("type");
    String[] typeClient = new String[] {"Commerical","Institutionnel"};
    typeClientListe.makeListeString(typeClient,typeClient);
    liste[0] = typeClientListe;
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().setOrdre(new String[]{"daty"});
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
        out.println(pi.getHtmlAddOnPopup());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>
