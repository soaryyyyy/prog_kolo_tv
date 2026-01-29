<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 15:13
  To change this template use File | Settings | File Templates.
--%>
<%@page import="vente.VenteDetailsLib"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*" %>
<%@ page import="reservation.ReservationDetailsLib" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.ReservationDetailsAvecDiffusion" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="reservation.Reservation" %>
<%@ page import="java.lang.reflect.Array" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>


<%
    try{
        String lien = (String) session.getValue("lien");
        user.UserEJB u= (user.UserEJB) session.getValue("u");

        ReservationDetailsAvecDiffusion t = new ReservationDetailsAvecDiffusion();
        String bute = "reservation/reservation-details-calendrier.jsp";
        if (request.getParameter("bute")!=null){
            bute = request.getParameter("bute");
        }
        String titre = "";
        String awhere = "";
        if(request.getParameter("daty") != null){
            String daty = request.getParameter("daty");
            String idSupport = request.getParameter("idSupport");
            String idCategorieIngredient = request.getParameter("idCategorieIngredient");
            titre = daty;
            awhere = " and DATY = TO_DATE('"+daty+"','DD/MM/YYYY')\n";
            if (request.getParameter("heureDebut") != null && request.getParameter("heureFin") != null){
                String hDebut = request.getParameter("heureDebut");
                String hFin = request.getParameter("heureFin");
                awhere += " AND TO_DATE(HEURE,'HH24:MI:SS') >= TO_DATE('"+hDebut+"','HH24:MI:SS')\n" +
                        "  AND TO_DATE(HEURE,'HH24:MI:SS') < TO_DATE('"+hFin+"','HH24:MI:SS')";
                titre+=" : "+hDebut+"-"+hFin;
            }
            if (idSupport!=null && !idSupport.isEmpty() && !idSupport.equals("null")){
                awhere += " and idSupport = '"+idSupport+"'";
            }
            if (idCategorieIngredient!=null && !idCategorieIngredient.isEmpty() && !idCategorieIngredient.equals("null")){
                awhere += " and CATEGORIEPRODUIT = '"+idCategorieIngredient+"'";
            }
        }

        ReservationDetailsAvecDiffusion [] resa = (ReservationDetailsAvecDiffusion[]) CGenUtil.rechercher(t,null,null,null,awhere+" ORDER BY ID ASC ");
        List<ReservationDetailsAvecDiffusion> list = Reservation.trierResa(Arrays.asList(resa),null);
%>
    <div class="content-wrapper">
        <section class="content-header">
            <h1><%=titre%></h1>
        </section>
        <section class="content">
            <form action="<%=lien%>?but=apresReservation.jsp" method="post">
                <input name="acte" type="hidden" id="nature" value="diffuserMultiple">
                <input name="bute" type="hidden" id="bute" value="<%=bute%>">
                <div class="row">
                    <div class="row col-md-12">
                        <div class="box " style="padding: 15px;background-color: white;border-radius: 16px;">
                            <div class="box-body table-responsive no-padding" style="overflow-y: auto;height: 50vh">
                                <div id="selectnonee">
                                    <table width="100%" border="0" align="center" cellpadding="3" cellspacing="3" class="table table-hover" style="font-size: 14px;">
                                        <thead>
                                        <tr class="head">
                                            <th align="center" valign="top" style="background-color:#bed1dd">
                                                <input onclick="CocheToutCheckbox(this, 'id')" type="checkbox">
                                            </th>
                                            <%if (u.getUser().getIdrole().equals("diffuseur")==false){ %>
                                            <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                                <a>ID</a>
                                            </th>
                                            <%}%>
                                            <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                                <a>Remarque</a>
                                            </th>
                                            <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                                <a>Heure</a>
                                            </th>
                                            <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                                <a>Client</a>
                                            </th>
                                            <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                                <a>M&eacute;dia</a>
                                            </th>
                                            <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                                <a>Dur&eacute;e</a>
                                            </th>
                                            <th width="8%" align="center" valign="top" style="background-color:#bed1dd">
                                                <a>Etat</a>
                                            </th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                            <% for (ReservationDetailsAvecDiffusion r:list){ %>
                                                <tr onmouseover="this.style.backgroundColor='#EAEAEA'" onmouseout="this.style.backgroundColor=''" style="">
                                                    <td align="center" width="1%">
                                                        <input type="checkbox" value="<%=r.getId()%>" name="id" id="checkbox0">
                                                    </td>
                                                    <%if (u.getUser().getIdrole().equals("diffuseur")==false){ %>
                                                    <td width="8%" align="left">
                                                        <a href="module.jsp?but=reservation/reservation-details-fiche.jsp&id=<%=r.getId()%>"><%=r.getId()%></a>
                                                    </td>
                                                    <%}%>
                                                    <td width="8%" align="left" style="background-color: <%=r.getBackGround()%>"><%=(r.getRemarque() != null) ? r.getRemarque() : ""%></td>
                                                    <td width="8%" align="left"><%=r.getHeure()%></td>
                                                    <td width="8%" align="left"><%=r.getClient()%></td>
                                                    <td width="8%" align="left" style="background-color: <%=r.getBackGround()%>"><%=(r.getLibellemedia() != null) ? r.getLibellemedia() : ""%></td>
                                                    <td width="8%" align="left"><%=r.getDuree()%></td>
                                                    <td width="8%" align="left"><%=r.getEtatDiffusion()%></td>
                                                </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="box-footer col-xs-12">
                                <button type="button" onclick='affModal()' class="btn btn-warning pull-right" style="margin-right: 5px;">Signaler</button>
                                <button type="submit" class="btn btn-success pull-right" style="margin-right: 25px;">Diffuser</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-12"></div>
            </form>
        </section>
    </div>

<div class="modal fade" id="linkModal2" tabindex="-1" role="dialog" aria-labelledby="linkModal2Label" aria-hidden="true">
    <div style='width:60%;background:transparent;' class="modal-dialog modal-dialog-centered" role="dialog">
        <div style="border-radius: 16px;padding:15px;" class="modal-content">
            <div class="modal-body">
                <div id="modalContent">
                    <div class='box box-primary box-solid'>
                        <div class='box-header' style='background-color: rgb(32, 83, 150); border-top: 3px solid #205396;'>
                            <h3 class='box-title' color='#edb031'><span color='#edb031'>Signalement</span></h3>
                        </div>
                        <div class='box-insert'>
                            <form action="<%= lien + "?but=apresReservation.jsp" %>" method="POST" style="background-color: white;padding: 10px;margin: 5px;border-radius: 5px">
                                <label class="nopadding fontinter labelinput">Description</label>
                                <div class="form-input">
                                    <textarea id="description" name="description" class="form-control">

                                    </textarea>
                                </div>
                                <br>
                                <button class="btn btn-success" style="width: 100%;text-align: center" type="button" onclick="sendSingnalement()">Envoyer</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>

