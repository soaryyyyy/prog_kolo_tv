
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="categorieheure.CategorieHeure" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

    CategorieHeure client = new CategorieHeure();

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche de Cat&eacute;gorie d'Heure");
    pc.getBase();
    String id=pc.getBase().getTuppleID();

    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("val").setLibelle("Valeur");
    pc.getChampByName("desce").setLibelle("Description");

    String lien = (String) session.getValue("lien");
    String pageModif = "categorieheure/categorieheure-modif.jsp";
    String classe = "categorieheure.CategorieHeure";
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=categorieheure/categorieheure-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=categorieheure/categorieheure-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

