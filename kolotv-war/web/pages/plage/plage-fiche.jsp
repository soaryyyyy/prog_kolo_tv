
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="user.*" %>
<%@ page import="affichage.*" %>
<%@ page import="plage.PlageCpl" %>

<%
    UserEJB u = (user.UserEJB)session.getValue("u");

    PlageCpl client = new PlageCpl();

    PageConsulte pc = new PageConsulte(client, request, u);
    pc.setTitre("Fiche Plage");
    pc.getBase();
    String id=pc.getBase().getTuppleID();

    pc.getChampByName("daty").setLibelle("Date");
    pc.getChampByName("heureDebut").setLibelle("Heure de debut");
    pc.getChampByName("heureFin").setLibelle("Heure de fin");
    pc.getChampByName("heureDescription").setLibelle("Cat&eacute;gorie de l'heure");
    pc.getChampByName("idSupportLib").setLibelle("Support");

    String lien = (String) session.getValue("lien");
    String pageModif = "plage/plage-modif.jsp";
    String classe = "plage.Plage";

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
    String support = pc.getChampByName("id").getValeur();
%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=plage/plage-liste.jsp"%> <i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <a class="btn btn-warning pull-right"  href="<%= lien + "?but="+ pageModif +"&id=" + id%>" style="margin-right: 10px">Modifier</a>
                            <a  class="pull-right" href="<%= lien + "?but=apresTarif.jsp&id=" + id+"&acte=delete&bute=plage/plage-liste.jsp&classe="+classe %>"><button class="btn btn-danger">Supprimer</button></a>
                            <a class="btn btn-success pull-right" href="#" onclick="ouvrirModal(event,'moduleLeger.jsp?but=plage/inc/plage-dupliquer.jsp&amp;support=<%=support%>&amp;id=<%=id%>','modalContent')" style="margin-right: 10px">Dupliquer</a>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<% out.println(temp);%>

