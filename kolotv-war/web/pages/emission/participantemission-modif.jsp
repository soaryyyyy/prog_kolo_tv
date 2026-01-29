<%--
    Document   : participantemission-modif
    Author     : Toky20
--%>

<%@page import="emission.ParticipantEmission"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    ParticipantEmission t = new ParticipantEmission();

    String  mapping = "emission.ParticipantEmission",
          nomtable = "PARTICIPANTEMISSION",
          apres = "emission/participantemission-fiche.jsp",
          titre = "Modification de participant &eacute;mission";

    PageUpdate pu = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pu.setLien((String) session.getValue("lien"));
    pu.setTitre("Modification de participant &eacute;mission");

    pu.getFormu().getChamp("id").setAutre("readonly");
    pu.getFormu().getChamp("nom").setLibelle("Nom");
    pu.getFormu().getChamp("contact").setLibelle("Contact");
    pu.getFormu().getChamp("adresse").setLibelle("Adresse");
    pu.getFormu().getChamp("datedenaissance").setLibelle("Date de naissance");
    pu.getFormu().getChamp("idemission").setLibelle("Emission");
    pu.getFormu().getChamp("idemission").setPageAppelComplete("emission.EmissionLib", "id","EMISSION_LIB");

    String lien = (String) session.getValue("lien");
    String id=pu.getBase().getTuppleID();
    pu.preparerDataFormu();
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=emission/participantemission-fiche.jsp&id="+id%> <i class="fa fa-arrow-circle-left"></i></a><%=pu.getTitre()%></h1>
                    </div>
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%=request.getParameter("id")%>" method="post">
                        <%= pu.getFormu().getHtmlInsert() %>
                        <div class="row">
                            <div class="col-md-11">
                                <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                            </div><br><br>
                        </div>
                        <input name="acte" type="hidden" value="update">
                        <input name="bute" type="hidden" value="<%=apres%>">
                        <input name="classe" type="hidden" value="<%=mapping%>">
                        <input name="rajoutLien" type="hidden" value="id-<%=request.getParameter("id")%>">
                        <input name="nomtable" type="hidden" value="<%=nomtable%>">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
