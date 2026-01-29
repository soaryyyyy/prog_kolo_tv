<%--
  Created by IntelliJ IDEA.
  User: diva
  Date: 27/07/2025
  Time: 20:21
  To change this template use File | Settings | File Templates.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="plage.PlageCpl" %>
<%@ page import="notification.Notification" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

    Notification notif = new Notification();

    PageConsulte pc = new PageConsulte(notif, request, u);
    pc.setTitre("Fiche Notification");
    notif = (Notification) pc.getBase();
    String id=pc.getBase().getTuppleID();
    String lien = (String) session.getValue("lien");

    pc.getChampByName("idUser").setVisible(false);
    pc.getChampByName("direction").setVisible(false);
    pc.getChampByName("service").setVisible(false);
    pc.getChampByName("destinataire").setVisible(false);
    pc.getChampByName("lien").setVisible(false);
    pc.getChampByName("idUser_Recevant").setVisible(false);
    pc.getChampByName("prestation").setVisible(false);
    pc.getChampByName("priorite").setVisible(false);
    pc.getChampByName("idObjet").setVisible(false);
    pc.getChampByName("etat").setVisible(false);
    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("objet").setLien(lien+"?but="+notif.getLien(), "");


%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=historique/notification-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
<%--                        <div class="box-footer">--%>
<%--                            <a class="btn btn-success pull-right" href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=plage/inc/plage-dupliquer.jsp&amp;support=<%=support%>&amp;id=<%=id%>','modalContent')" style="margin-right: 10px">Dupliquer</a>--%>
<%--                        </div>--%>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

