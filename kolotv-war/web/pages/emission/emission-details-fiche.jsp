<%--
    Author     : Toky20
--%>

<%@page import="emission.Emission"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.*" %>
<%@ page import="emission.EmissionLib" %>
<%@ page import="emission.EmissionDetailsLib" %>
<%
    UserEJB u = (user.UserEJB)session.getValue("u");
%>

<%
    EmissionDetailsLib objet = new EmissionDetailsLib();
    objet.setNomTable("EMISSIONDETAILS_LIB");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche d'&eacute;mission");
    objet = (EmissionDetailsLib) pc.getBase();
    String id=pc.getBase().getTuppleID();
    String lien = (String) session.getValue("lien");

    pc.getChampByName("idSupportLib").setLibelle("Support");
    pc.getChampByName("idSupport").setVisible(false);
    pc.getChampByName("idMere").setLien(lien+"?but=emission/emission-fiche.jsp", "id=");
    pc.getChampByName("libelleemission").setLibelle("Emission");
    pc.getChampByName("heureDebut").setLibelle("Heure de d&eacute;but");
    pc.getChampByName("heureFin").setLibelle("Heure de fin");
    pc.getChampByName("heureDebutCoupure").setLibelle("D&eacute;but coupure");
    pc.getChampByName("heureFinCoupure").setLibelle("Fin Coupure");
    pc.getChampByName("idGenreLib").setLibelle("Genre");
    pc.getChampByName("idGenre").setVisible(false);

    String pageModif = "emission/emission-modif.jsp";

%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
<%--                    <div class="box-title with-border">--%>
<%--                        <h1 class="box-title"><a href=<%= lien + "?but=emission/emission-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>--%>
<%--                    </div>--%>
                    <div class="box-body">
                        <%= pc.getHtml() %>
                        <br/>
                        <div class="box-footer">
                            <%if (u.getUser().getIdrole().equals("diffuseur")==false){ %>
                                <a class="btn btn-primary pull-right"  href="<%= lien + "?but=emission/parrainageemission-saisie.jsp&idEmission=" + objet.getIdMere()%>" style="margin-right: 10px">Parrainer</a>
                                <a class="btn btn-success pull-right"  href="<%= lien + "?but=emission/plateau-saisie.jsp&idEmission=" + objet.getIdMere()%>" style="margin-right: 10px">Plateau</a>
                                <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + objet.getIdMere()%>" style="margin-right: 10px">Modifier</a>
                            <%}%>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
