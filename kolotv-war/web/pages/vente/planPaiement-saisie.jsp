<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="bean.ClassMAPTable" %>
<%@ page import="utilitaire.*" %>
<%@page import="faturefournisseur.*"%>
<%@ page import="affichage.*" %>
<%@ page import="affichage.Champ" %>
<%@ page import="caisse.EtatCaisse" %>
<%@ page import="prevision.Prevision" %>
<%@ page import="caisse.Caisse" %>
<%@ page import="vente.VenteLib" %>
<%@ page import="prevision.PrevisionComplet" %>
<%
    try{
        FactureFournisseurCpl ff = null;
        VenteLib vente = null;
        ClassMAPTable[] vls = null;
        String classeButApresPost = null;

        System.out.println("classe: " + request.getParameter("classe"));
        if(request.getParameter("classe")!=null){
            classeButApresPost = request.getParameter("classe");
            if(request.getParameter("classe").equals("faturefournisseur.FactureFournisseur")){
                ff = new FactureFournisseurCpl();
                ff.setNomTable(request.getParameter("table"));
                ff.setId(request.getParameter("idvt"));
                vls=(FactureFournisseurCpl[]) CGenUtil.rechercher(ff, null, null, "");
            }
            if(request.getParameter("classe").equals("vente.Vente")){
                vente = new VenteLib();
                vente.setNomTable(request.getParameter("table"));
                vente.setId(request.getParameter("idvt"));
                vls = (VenteLib[]) CGenUtil.rechercher(vente, null, null, "");
                
            }
        } 
        if (request.getParameter("classe")==null ||request.getParameter("classe").equals("null") || request.getParameter("classe").equals("prevision.PrevisionComplet") ) {
            PrevisionComplet prev = new PrevisionComplet();
            prev.setIdFacture(request.getParameter("idvt")) ;
            vls=(PrevisionComplet[]) CGenUtil.rechercher(prev, null, null, "");
        }
       
        
        PrevisionComplet prev = new PrevisionComplet();
        prev.setIdFacture(request.getParameter("idvt"));
        prev.setNomTable("PREVISION_COMPLET_CPLPositif");
        PrevisionComplet[] listePrev = (PrevisionComplet[]) CGenUtil.rechercher(prev, null, null, "");
        Prevision a = new Prevision();
        PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
        pi.setLien((String) session.getValue("lien"));
        // liste deroulante
        Champ[] liste = new Champ[1];
        Caisse caisse = new Caisse();
        liste[0] = new Liste("idCaisse", caisse, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        //Modification des affichages
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
 
        String idclient="";
        String designation="";
        String devise="";
        String tauxdechange="";
        String obj="";
        if(vls[0] instanceof FactureFournisseurCpl) {
            ff = (FactureFournisseurCpl)vls[0];
            designation = ff.getDesignation(); 
            devise = ff.getIdDevise(); 
            tauxdechange=String.valueOf(ff.getTauxdechange());
            obj="FactureFournisseur";
           
        } 
        else if(vls[0] instanceof VenteLib) {
            vente = (VenteLib)vls[0];
            designation = vente.getDesignation();
            idclient = vente.getIdClient();
            devise = vente.getIdDevise(); 
            tauxdechange=String.valueOf(vente.getTauxdechange());
            obj="Vente";
        }
        else if(vls[0] instanceof PrevisionComplet) {
            prev = (PrevisionComplet)vls[0];
            designation = prev.getDesignation(); 
            devise = prev.getIdDevise(); 
            // tauxdechange=String.valueOf(prev.getTauxdechange());
            obj="PrevisionComplet";
        }
        pi.getFormu().getChamp("designation").setDefaut("Plan de paiement de "+designation);
        pi.getFormu().getChamp("idcaisse").setLibelle("Caisse");
        pi.getFormu().getChamp("idventedetail").setVisible(false);
        pi.getFormu().getChamp("idvirement").setVisible(false);
        pi.getFormu().getChamp("debit").setLibelle("Debit");
        pi.getFormu().getChamp("credit").setLibelle("Credit");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idop").setVisible(false);
        pi.getFormu().getChamp("idorigine").setVisible(false);
        pi.getFormu().getChamp("iddevise").setLibelle("Devise");
        pi.getFormu().getChamp("iddevise").setDefaut(devise);
        pi.getFormu().getChamp("taux").setLibelle("Taux de change"); 
        pi.getFormu().getChamp("taux").setDefaut(tauxdechange); 
        pi.getFormu().getChamp("idtiers").setLibelle("Client");
        if (!idclient.equalsIgnoreCase(""))
        {
            pi.getFormu().getChamp("idtiers").setDefaut(idclient);
            pi.getFormu().getChamp("idtiers").setAutre("readonly");
        }
        else pi.getFormu().getChamp("idtiers").setPageAppelCompleteInsert("client.Client", "id", "CLIENT", "client/client-saisie.jsp", "id;nom");

        pi.getFormu().getChamp("compte").setVisible(false);
        pi.getFormu().getChamp("idFacture").setLibelle("Facture");
        if (request.getParameter("idvt") != null && !request.getParameter("idvt").equalsIgnoreCase(""))
        {
            pi.getFormu().getChamp("idFacture").setDefaut(request.getParameter("idvt"));
            pi.getFormu().getChamp("idFacture").setAutre("readonly");
        }
        //Variables de navigation
        String classe = "prevision.PrevisionComplet";
        String butApresPost = "vente/planPaiement-saisie.jsp&idvt="+request.getParameter("idvt")+"&classe="+classeButApresPost;
        String nomTable = "PREVISION";
        //Generer les affichages
        pi.preparerDataFormu();
        pi.getFormu().makeHtmlInsertTabIndex();
%>
<div class="content-wrapper">
    <h1 align="center">Plan de Paiement</h1>
    <form  action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
        <%
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classe %>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
    </form>
    <div class="row">
<%--        <div class="col-md-1"></div>--%>
        <br>
        <div class="col-md-12" style="padding: 0 30px 0 30px">
            <div class="box-fiche">
                <div class="box ">
                    <div class="title-box with-border">
                        <h1>Modifier Plan de Paiement</h1>
                    </div>
                    <form  id="incident" class="incident-pp-fiche" onsubmit='modifEtatMult(event)' enctype="multipart/form-data">
                        <!--<form action="<%=(String) session.getValue("lien")%>?but=modifierEtatMultiple.jsp" method="post" name="incident" id="incident"> -->
                        <%
                            if(obj.equalsIgnoreCase("FactureFournisseur"))
                            {%>
                                
                                <a class="btn btn-primary pull-right link-ff-fiche" href="<%=pi.getLien()%>?but=facturefournisseur/facturefournisseur-fiche.jsp&tab=inc/liste-prevision&id=<%=request.getParameter("idvt")%>">Voir facture</a>
                            <%        
                            } if(obj.equalsIgnoreCase("Vente"))
                            {%>
                                <a class="btn btn-primary pull-right link-ff-fiche" href="<%=pi.getLien()%>?but=vente/vente-fiche.jsp&tab=liste-prevision&id=<%=request.getParameter("idvt")%>">Voir vente</a>
                            <%
                            }
                        %>
                        
                        <div class="box-body table-responsive">
                            <input type="hidden" name="bute" value="vente/planPaiement-saisie.jsp&idvt=<%=request.getParameter("idvt")%>&classe=<%=classeButApresPost%>"/>
                            <input type="hidden" name="acte" id="acte"/>

                            <table class="table table-bordered table-modif-pp">
                                <thead>
                                <tr>
                                    <th align="center" valign="top" style="background-color:#bed1dd">
                                        <input onclick="CocheToutCheckbox(this, 'ids')" type="checkbox">
                                    </th>
                                    <th align="center" valign="top">D&eacute;signation</th>
                                    <th align="center" valign="top">Caisse</th>
                                    <th align="center" valign="top">Debit</th>
                                    <th align="center" valign="top">Credit</th>
                                    <th align="center" valign="top">Date</th>
                                    <th align="center" valign="top">Devise</th>
                                    <th align="center" valign="top">Taux</th> 
                                </tr>
                                </thead>

                                <tbody>
                                <%
                                    for (int i = 0; i < listePrev.length; i++) {
                                %>
                                <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                    <td align="center">
                                        <input type="checkbox" value="<%=listePrev[i].getId()%>_<%=i%>" name="ids" id="<%=listePrev[i].getId()%>_<%=i%>">
                                    </td>

                                    <td  align="center"><%=listePrev[i].getDesignation()%></td>
                                    <td  align="center"><%=listePrev[i].getIdCaisseLib()%></td>
                                    <td width="14%" align="center"><input class="form-control" type="text" id="debit<%=i%>" name="debit" value="<%=listePrev[i].getDebit()%>" onchange="synchro(this,<%=listePrev[i].getId()%>_<%=i%>.value)"></td>
                                    <td width="14%" align="center"><input class="form-control" type="text" id="credit<%=i%>" name="credit" value="<%=listePrev[i].getEcart()%>" onchange="synchro(this,<%=listePrev[i].getId()%>_<%=i%>.value)"></td>
                                    <td  align="right"><input class="form-control" type="date" id="daty<%=i%>" name="daty" value="<%=listePrev[i].getDaty()%>" onchange="synchro(this,<%=listePrev[i].getId()%>_<%=i%>.value)"></td>
                                    <td  align="right"><%=listePrev[i].getIdDevise()%></td>
                                    <td  align="right"><input class="form-control" type="text" id="taux<%=i%>" name="taux" value="<%=listePrev[i].getTaux()%>" onchange="synchro(this,<%=listePrev[i].getId()%>_<%=i%>.value)"></td>
                                </tr>
                                <%
                                    }
                                %>

                                </tbody>
                            </table>

                        <div class="col-md-12 pp-fiche-btn" style="margin-top: 2rem;" align="right">
                            <button type="submit" name="acte" value="modifier_prevision" class="btn btn-success pull-right" style="margin-right: 25px;" onclick="document.getElementById('acte').value='scinder_prevision'" >Scinder</button>
                            <button type="submit" name="acte" value="modifier_prevision" class="btn btn-success pull-right" style="margin-right: 25px;" onclick="document.getElementById('acte').value='modifier_prevision'" >Modifier</button>
                            <button type="submit" name="acte" value="supprimer_prevision" class="btn btn-danger pull-left" style="margin-right: 25px;" onclick="document.getElementById('acte').value='supprimer_prevision'" >Supprimer</button>
                        </div>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    } %>