<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="affichage.PageConsulte"%>
<%@page import="reservation.MajorationDiffusion"%>
<%@page import="user.UserEJB"%>

<%
    UserEJB u = (user.UserEJB) session.getValue("u");
    MajorationDiffusion objet = new MajorationDiffusion();

    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche majoration de diffusion");
    pc.getBase();
    String id = pc.getBase().getTuppleID();

    pc.getChampByName("jour").setLibelle("Jour");
    pc.getChampByName("heureDebut").setLibelle("Heure d&eacute;but");
    pc.getChampByName("heureFin").setLibelle("Heure fin");
    pc.getChampByName("tauxMajoration").setLibelle("Taux de majoration (%)");

    String lien = (String) session.getValue("lien");
    String pageModif = "reservation/majoration-diffusion-modif.jsp";
    String classe = "reservation.MajorationDiffusion";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title">
                            <a href="<%= lien + "?but=reservation/majoration-diffusion-liste.jsp"%>">
                                <i class="fa fa-arrow-circle-left"></i>
                            </a>
                            <%=pc.getTitre()%>
                        </h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right" href="<%= lien + "?but=" + pageModif + "&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id + "&acte=delete&bute=reservation/majoration-diffusion-liste.jsp&classe=" + classe %>">
                                <button class="btn btn-danger">Supprimer</button>
                            </a>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
