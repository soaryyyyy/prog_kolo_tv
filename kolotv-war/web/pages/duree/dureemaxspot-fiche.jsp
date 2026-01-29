<%--
    Author     : Toky20
--%>

<%@page import="duree.DureeMaxSpotCpl"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>


<%
    UserEJB u = (user.UserEJB)session.getValue("u");

%>
<%
    DureeMaxSpotCpl objet = new DureeMaxSpotCpl();
    objet.setNomTable("DureeMaxSpot_Cpl");
    PageConsulte pc = new PageConsulte(objet, request, u);
    pc.setTitre("Fiche de disponibilit&eacute; de diffusion");
    pc.getBase();
    String id=pc.getBase().getTuppleID();
    pc.getChampByName("id").setLibelle("Id");
    pc.getChampByName("heureDebut").setLibelle("Heure d&eacute;but");
    pc.getChampByName("heureFin").setLibelle("Heure de fin");
    pc.getChampByName("jour").setLibelle("Jour");
    pc.getChampByName("max").setLibelle("Seconde max");
    pc.getChampByName("idSupport").setVisible(false);
    pc.getChampByName("idCategorieIngredient").setVisible(false);
    pc.getChampByName("idSupportLib").setLibelle("Support");
    pc.getChampByName("idCategorieIngredientLib").setLibelle("Categorie");

    String lien = (String) session.getValue("lien");
    String pageModif = "duree/dureemaxspot-modif.jsp";
    String classe = "duree.DureeMaxSpotCpl";

    String temp="";
    temp=temp+ "<div class=\"modal fade\" id=\"linkModal\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"linkModalLabel\" aria-hidden=\"true\">\r\n" +
        "  <div style='width:60%;' class=\"modal-dialog modal-dialog-centered\" role=\"dialog\">\r\n" + //
        "    <div style=\"border-radius: 16px;padding:15px;\" class=\"modal-content\">\r\n" + //
        "      <div class=\"modal-body\">\r\n"+
        "       <div id=\"modalContent\">\r\n>";
    temp +=                "</div>\r\n" + //
        "    </div>\r\n" + //
        "   </div>\r\n" + //
        "  </div>\r\n" + //
        "</div>";

    String jour = pc.getChampByName("jour").getValeur();
    String support = pc.getChampByName("idSupportLib").getValeur();
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=duree/dureemaxspot-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=duree/dureemaxspot-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                            <a class="btn btn-success pull-right" href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=duree/inc/dureemaxspot-dupliquer.jsp&amp;jour=<%=jour%>&amp;support=<%=support%>&amp;id=<%=id%>','modalContent')" style="margin-right: 10px">Dupliquer</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<% out.println(temp);%>





