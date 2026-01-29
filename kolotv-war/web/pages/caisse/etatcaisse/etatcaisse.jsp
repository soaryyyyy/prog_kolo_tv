<%@page import="annexe.Point" %>
<%@page import="caisse.TypeCaisse" %>
<%@page import="caisse.EtatCaisse" %>
<%@page import="bean.ClassMAPTable" %>
<%@page import="bean.AdminGen" %>
<%@page import="user.UserEJB" %>
<%@page import="utilitaire.Utilitaire" %>

<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@page import="affichage.PageRecherche" %>

<% 
try{ 
    String queryString=request.getQueryString(); 
    String lien = (String)session.getValue("lien"), apres=queryString.substring(4); 
    String daty=request.getParameter("daty"); 
    String daty1=request.getParameter("daty1"); 
    String point = request.getParameter("point");
    String type = request.getParameter("type");
    if (daty==null || daty.compareToIgnoreCase("")==0) {
        daty=Utilitaire.dateDuJour(); 
    } 
    if (daty1==null || daty1.compareToIgnoreCase("")==0) {
        daty1=Utilitaire.dateDuJour(); 
    } 
    if (point==null || point.compareToIgnoreCase("")==0) {
        point = "tous";
    } 
    if (type==null || type.compareToIgnoreCase("")==0) {
        type = "tous";
    } 
    EtatCaisse caisse=new EtatCaisse(); 
    EtatCaisse [] liste=caisse.getEtatCaisse(null,daty,point,type); 
    Point [] points=new Point().getAllPoint(null); 
    TypeCaisse [] types=new TypeCaisse().getAllTypeCaisse(null); 
%>
<style>
    .th-middle{
        vertical-align: middle !important;
        background-color: #2c3d91;
    }
    .th-center {
        text-align: center !important;
        vertical-align: middle !important;
        background-color: #2c3d91;
    }
    .td-right {
        text-align: right !important;
    }
</style>
<script>
    function changerDesignation() {
        document.depense.submit();
    }
</script>
<div class="content-wrapper" style="min-height: 638px;">
    <section class="content-header">
        <h1>SITUATION DE CAISSE ESTIMÉE LE <%=daty%>
        </h1>
    </section>
    <section class="content">
        <form action="<%=lien%>?but=<%=apres%>" method="post" name="situation"
            id="situation">
            <div class="row">
                <div class="col-md-12">
                    <div style="background:white; color:#212529;border-top-right-radius: 10px;border-top-left-radius: 16px;border-bottom-right-radius: 16px;border-bottom-left-radius: 16px;"
                        class="box box-solid collapsed">
                        <div style="padding: 16px;" class="box-header">
                            <h3 class="box-title" color="#212529"><span
                                    class="fontinter filtretitle">Filtre de
                                    recherche</span></h3>
                            <div class="box-tools pull-right" style="padding: 10px;">
                                <button data-original-title="Collapse"
                                    class="btn btn-box-tool" data-widget="collapse"
                                    data-toggle="tooltip" title="" tabindex="1"><img
                                        src="../dist/img/collapse.svg"
                                        style="height: 16px;margin-top: -3px;transform:rotate(180deg);transition:0.3s;"
                                        onclick="this.style.transform = this.style.transform === 'rotate(180deg)' ? 'rotate(0deg)' : 'rotate(180deg)'"
                                        alt="plus icon"></button> </div>
                        </div>
                        <div class="box-body cardsearch" style="padding-bottom:16px;"
                            id="pagerecherche">
                            <div class="row">
                                <div class="col-md-10 col-xs-12">
                                    <div class="form-group">
                                        <div class="col-md-3"><label
                                                class="fontinter labelinput"
                                                for="Point">Date</label>
                                                <input name="daty" type="text"
                                                class="form-control datepicker" id="daty"
                                                value="<%=daty%>"
                                                onkeydown="return searchKeyPress(event)"></div>
                                            <%-- <div class="col-md-3"><label
                                                class="fontinter labelinput"
                                                for="Point">Date Max</label>
                                                <input name="daty1" type="text"
                                                class="form-control datepicker" id="daty1"
                                                value="<%=daty1%>"
                                                onkeydown="return searchKeyPress(event)"></div> --%>
                                            <div class="col-md-3"><label
                                                class="fontinter labelinput"
                                                for="Point">Point</label>
                                                <select name="point" id="point" class="form-control">
                                                    <option value="tous" <%= (point == "tous") ? "selected" : "" %>>Tous</option>
                                                    <%
                                                        for (Point p : points) {
                                                    %>
                                                        <option value="<%= p.getId() %>" <%= (p.getId().compareToIgnoreCase(point)==0) ? "selected" : "" %>>
                                                            <%= p.getVal() %>
                                                        </option>
                                                    <%
                                                        }
                                                    %>
                                                </select></div>
                                            <div class="col-md-3"><label
                                                class="fontinter labelinput"
                                                for="Point">Type caisse</label>
                                                <select name="type" id="type" class="form-control">
                                                    <option value="tous" <%= (type == "tous") ? "selected" : "" %>>Tous</option>
                                                    <%
                                                        for (TypeCaisse t : types) {
                                                    %>
                                                        <option value="<%= t.getId() %>" <%= (t.getId().compareToIgnoreCase(type)==0) ? "selected" : "" %>>
                                                            <%= t.getVal() %>
                                                        </option>
                                                    <%
                                                        }
                                                    %>
                                                </select></div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <div class="col-md-3"></div>
                                    </div>
                                </div>
                                <div class="col-md-2 col-xs-11 ">
                                    <div align="center"><input name="afficher"
                                            value="Afficher" type="submit"
                                            class="btn filtrebtn btnradius"
                                            style="background:#2c3d91;" id="btnListe"
                                            tabindex="8"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
        <%-- <div class="row">
            <form action="<%=lien%>?but=<%=apres%>" method="post" name="situation"
                id="situation">
                <div class="box box-solid collapsed">
                    <div style="background-color:#103a8e;text-align: center; color:white;"
                        class="box-header with-border">
                        <h3 class="box-title" color="#edb031">
                            <span color="#edb031">Recherche avanc�e</span>
                        </h3>
                        <div class="box-tools pull-right">
                            <button data-original-title="Collapse"
                                class="btn btn-box-tool" data-widget="collapse"
                                data-toggle="tooltip" title="">
                                <i class="fa fa-minus"></i>
                            </button>
                        </div>
                    </div>
                    <div class="box-body" id="pagerecherche" style="display: block;">
                        <div class="form-group">
                            <div class="col-md-3">
                                <label for="Date" debut="">Date</label>
                                <input name="daty" type="text"
                                    class="form-control datepicker" id="daty"
                                    value="<%=daty%>"
                                    onkeydown="return searchKeyPress(event)">
                            </div>
                        </div>
                    </div>
                    <br />
                    <div class="box-footer" style="display: block;">
                        <div class="row">
                            <div class="col-xs-4" align="center">
                                <input name="afficher" value="Afficher" type="submit"
                                    class="btn" style="background:#103a8e; color:white"
                                    id="btnListe">
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div> --%>
        <br />
        <div class="row">
            <div class="col-md-12">
                <div class="box cardradius box-solid"
                    style="padding: 16px;border-radius: 16px;">
                    <%-- <div style="background:#2c3d91; color:white;" class="box-header">
                        <h3 class="box-title" align="center">SITUATION CAISSE COURANTS
                        </h3>
                    </div> --%>

                    <div class="box-body table-responsive no-padding">
                        <div id="selectnonee">
                            <table width="100%" border="0" align="center"
                                cellpadding="3" cellspacing="3"
                                class="table table-hover table-striped">
                                <thead>
                                    <tr class="head">
                                        <th rowspan="2" class="th-middle" >
                                            <a href="#" style="color:white;">ID</a>
                                        </th>
                                        <th rowspan="2" class="th-middle">
                                            <a href="#" style="color:white;">CAISSE</a>
                                        </th>
                                        <th rowspan="2" class="th-middle">
                                            <a href="#" style="color:white;">POINT</a>
                                        </th>
                                        <th rowspan="2" class="th-middle">
                                            <a href="#" style="color:white;">TYPE</a>
                                        </th>
                                        <th rowspan="2" class="th-center th-middle">
                                            <a href="#" style="color:white;">CAISSE DU
                                                <%=Utilitaire.ajoutJourDateString(Utilitaire.stringDate(daty),
                                                    -1)%></a>
                                        </th>
                                        <th colspan="2" class="th-center">
                                            <a href="#"
                                                style="color:white;">MOUVEMENTS</a>
                                        </th>
                                        <th rowspan="2" class="th-center">
                                            <a href="#" style="color:white;">SOLDE
                                                FINALE</a>
                                        </th>
                                    </tr>
                                    <tr class="head">
                                        <th class="th-center">
                                            <a href="#" style="color:white;">RECETTE</a>
                                        </th>
                                        <th class="th-center">
                                            <a href="#" style="color:white;">DEPENSE</a>
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        for (int i=0; i < liste.length; i++) { 
                                            if(i<liste.length-1){
                                    %>
                                        <tr onmouseover="this.style.backgroundColor = '#EAEAEA'"
                                            onmouseout="this.style.backgroundColor = ''"
                                            style="">
                                            <td class="contenuetable" align="left">
                                                <%=liste[i].getIdCaisse()%>
                                            </td>
                                            <td class="contenuetable" align="left">
                                                <%=liste[i].getIdCaisselib()%>
                                            </td>
                                            <td class="contenuetable" align="left">
                                                <%=liste[i].getIdPointlib()%>
                                            </td>
                                            <td class="contenuetable" align="left">
                                                <%=liste[i].getIdTypeCaisselib()%>
                                            </td>
                                            <td class="contenuetable td-right">
                                                <%=String.format("%,.2f",
                                                    (double)liste[i].getMontantDernierReport())%>
                                            </td>
                                            <td class="contenuetable td-right">
                                                <%=String.format("%,.2f",
                                                    (double)liste[i].getCredit())%>
                                            </td>
                                            <td class="contenuetable td-right">
                                                <%=String.format("%,.2f",
                                                    (double)liste[i].getDebit())%>
                                            </td>
                                            <td class="contenuetable td-right">
                                                <%=String.format("%,.2f",
                                                    (double)liste[i].getReste())%>
                                            </td>
                                        </tr>
                                    <% }else if(liste[i]!=null){ %>
                                        <tr onmouseover="this.style.backgroundColor = '#EAEAEA'"
                                            onmouseout="this.style.backgroundColor = ''"
                                            style="">
                                            <td class="contenuetable" colspan="4" align="left">
                                                <b><%=liste[i].getIdTypeCaisselib()%></b>
                                            </td>
                                            <td class="contenuetable td-right">
                                                <b><%=String.format("%,.2f",
                                                    (double)liste[i].getMontantDernierReport())%></b>
                                            </td>
                                            <td class="contenuetable td-right">
                                                <b><%=String.format("%,.2f",
                                                    (double)liste[i].getCredit())%></b>
                                            </td>
                                            <td class="contenuetable td-right">
                                                <b><%=String.format("%,.2f",
                                                    (double)liste[i].getDebit())%></b>
                                            </td>
                                            <td class="contenuetable td-right">
                                                <b><%=String.format("%,.2f",
                                                    (double)liste[i].getReste())%></b>
                                            </td>
                                        </tr>
                                    <% } }%>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>
<% } catch (Exception ex) { ex.printStackTrace(); }%>