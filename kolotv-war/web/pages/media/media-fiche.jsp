<%--
    Author     : Toky20
--%>

<%@page import="media.MediaCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    MediaCpl objet = new MediaCpl();
    objet.setNomTable("MEDIA_CPL");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche M&eacute;dia");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("duree").setLibelle("Dur&eacute;e");
    pc.getChampByName("idTypeMedia").setVisible(false);
    pc.getChampByName("idTypeMediaLib").setLibelle("Type M&eacute;dia");
    pc.getChampByName("idClient").setVisible(false);
    pc.getChampByName("idClientLib").setLibelle("Client");

    String lien = (String) session.getValue("lien");
    String pageModif = "media/media-modif.jsp";
    String classe = "media.MediaCpl";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=media/media-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=media/media-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


