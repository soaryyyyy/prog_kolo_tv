<%--
    Document   : as-produits-fiche
    Created on : 1 d�c. 2016, 10:40:08
    Author     : Joe
--%>

<%@page import="produits.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%
    UserEJB u=(user.UserEJB) session.getValue("u");
    String lien = (String) session.getValue("lien");
    Ingredients a = new Ingredients();
    a.setNomTable("as_ingredients_lib");
    PageConsulte pc = pc = new PageConsulte(a, request, u);//ou avec argument liste Libelle si besoin

    String isDispo=pc.getChampByName("etatlib").getValeur();
    //pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("unite").setLibelle("Unit&eacute;");
    pc.getChampByName("pu").setLibelle("Prix Unitaire");
    pc.getChampByName("pu1").setLibelle("Prix prime time");
    pc.getChampByName("pu2").setLibelle("Prix heure basse");
    pc.getChampByName("quantiteparpack").setLibelle("Quantit&eacute; par pack");
    pc.getChampByName("bienOuServ").setLibelle("Bien ou Service");
    pc.getChampByName("categorieingredient").setLibelle("Cat&eacute;gorie de service");
    pc.getChampByName("etatlib").setLibelle("Disponibilit&eacute;");
    pc.getChampByName("pv").setLibelle("Prix de vente");
    pc.getChampByName("idSupport").setLibelle("Support");
    pc.getChampByName("idSupport").setLien(lien+"?but=support/support-fiche.jsp", "id=");
    pc.getChampByName("idFournisseur").setVisible(false);
    pc.getChampByName("seuil").setVisible(false);
    pc.getChampByName("unite").setVisible(false);
    pc.getChampByName("quantiteparpack").setVisible(false);
    pc.getChampByName("actif").setVisible(false);
    pc.getChampByName("compose").setVisible(false);
    pc.getChampByName("bienOuServ").setVisible(false);
    pc.getChampByName("bienOuServ").setVisible(false);
    pc.getChampByName("photo").setVisible(false);
    pc.getChampByName("daty").setVisible(false);
    pc.getChampByName("id").setVisible(false);
    pc.getChampByName("calorie").setVisible(false);

    pc.setTitre("Fiche de service");
    Ingredients base = (Ingredients) (pc.getBase());
    RecetteLib[] liste = base.getRecette(null, null);
    Recette[] listeBase = base.decomposerBase(null);
    RecetteLib[] listerecette = base.getRecetteIngredient(null, null);
    double montantTotal = AdminGen.calculSommeDouble(listeBase, "qtetotal");
    if(base.getCompose()>0) pc.getChampByName("pu").setValeurDirect(Utilitaire.formaterAr (montantTotal));

    boolean isDG=false;
    if(u.getUser().isSuperUser()) isDG=true;

    try {
        // insertion recette
        Recette proc = new Recette();
        PageInsert pi = new PageInsert(proc, request, u);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("idProduits").setLibelle("Produits");
        pi.getFormu().getChamp("idProduits").setAutre("readonly");
        pi.getFormu().getChamp("idproduits").setDefaut(request.getParameter("id"));
        pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
        pi.getFormu().getChamp("unite").setAutre("readonly");
        pi.getFormu().getChamp("idingredients").setLibelle("Ingr&eacute;dient");
        pi.getFormu().getChamp("idingredients").setPageAppelCompleteInsert("produits.IngredientsLib", "id", "as_ingredients_lib","unite", "unite", "produits/as-ingredients-saisie.jsp", "id;libelle");
        pi.getFormu().getChamp("quantite").setLibelle("Quantit&eacute;");

        pi.getFormu().getChamp("idProduits").setAutre("readonly");
        pi.getFormu().setNbColonne(2);

        pi.preparerDataFormu();

        Map<String, String> map = new HashMap<String, String>();
        map.put("inc/historique-prix", "");
        String tab = request.getParameter("tab");
        if (tab == null) {
            tab = "inc/historique-prix";
        }
        map.put(tab, "active");
        tab = tab + ".jsp";

        String id = base.getId();
        String pageActuel = "produits/as-ingredients-fiche.jsp";
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-6 lol" style="padding-bottom: 0;padding-top: 10px;">
            <div class="box-fiche box-fiche-space">
                <div class="box">
                    <div class="row">
                        <div style="font-size: 3.5rem; float: left" class="col-md-2">
                            <a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a>
                        </div>
                        <div class="title-box with-border col-md-8" style="float: left">
                            <div>
                                <h1><%=pc.getTitre()%></h1>
                            </div>
                        </div>
                        <div class="col-md-2">
                        </div>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <a class="btn btn-warning pull-right"  href="<%=(String) session.getValue("lien") + "?but=produits/as-ingredients-modif.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier</a>
                        <a class="btn btn-warning pull-right"  href="<%=(String) session.getValue("lien") + "?but=configuration/configurationprix-saisie.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier les prix</a>
                        <%  if(isDispo.equals("INDISPONIBLE")) {%> <a class="btn btn-success pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=disponible&isdispo=true&&id=" + request.getParameter("id")%>" style="margin-right: 10px">Disponible</a><%}%>
                        <%  if(isDispo.equals("DISPONIBLE")) { %> <a class="btn btn-danger pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=disponible&isdispo=false&id=" + request.getParameter("id")%>" style="margin-right: 10px">Indisponible</a><%}%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6 lol" style="padding-bottom: 0;padding-top: 10px;" >
            <div class="box-fiche box-fiche-space">
<%--                <div class="box">--%>
                    <div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            <!-- a modifier -->
                            <li class="<%=map.get("inc/historique-prix")%>"><a href="<%= lien %>?but=<%= pageActuel %>&id=<%= id %>&tab=inc/historique-prix">Historiques des prix</a></li>
                        </ul>
                        <div class="tab-content">
                            <jsp:include page="<%= tab %>" >
                                <jsp:param name="id" value="<%= id %>" />
                            </jsp:include>
                        </div>
                    </div>
<%--                </div>--%>
            </div>
        </div>
    </div>
    <%if(isDG){%>
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol" >
            <form id="maForme"  onsubmit='insertAj(event)' >
                <div class="box-fiche box-fiche-space">
                    <div class="box">
                        <div class="title-box with-border">
                            <h1>Ajout Composant</h1>
                        </div>
                        <div class="box-body">

                            <%--                            <table class="table table-bordered">--%>
                            <%--                                <thead>--%>
                            <%--                                    <tr>--%>
                            <%--                                        <th>Idproduit</th>--%>
                            <%--                                        <th colspan="2" >Ingredient</th>--%>
                            <%--                                        <th>Quantit&eacute;</th>--%>

                            <%--                                    </tr>--%>
                            <%--                                </thead>--%>
                            <%--                                <tbody>--%>
                            <%--                                    <tr>--%>
                            <%--                                        <td  align="center"><input name="idproduits" type="hidden" value="<%=request.getParameter("id")%>"><%=request.getParameter("id")%></td>--%>
                            <%--                                        <td  align="center">--%>
                            <%--                                            <input name="idingredientslibelle" type="textbox" class="form-control" id="idingredientslibelle" value="" tabindex="2" readonly ><input type="hidden" value="" name="idingredients" id="idingredients">--%>
                            <%--                                        </td>--%>
                            <%--                                        <td>--%>
                            <%--                                            <input name="choix" type="button" class="submit" onclick="pagePopUp('choix/listeIngredientChoix.jsp?champReturn=idingredients;idingredientslibelle&amp;apresLienPageAppel=')" value="...">--%>
                            <%--                                        </td>--%>
                            <%--                                        <td width="14%" align="center">--%>
                            <%--                                            <input name="quantite" type="textbox" class="form-control" id="quantite" value="0" onblur="calculer('quantite')" tabindex="3">--%>
                            <%--                                        </td>--%>

                            <%--                                    </tr>--%>
                            <%--                                </tbody>--%>
                            <%--                            </table>--%>
                            <%
                                pi.getFormu().makeHtmlInsertTabIndex();
                                out.println(pi.getFormu().getHtmlInsert());
//        out.println(pi.getHtmlAddOnPopup());
                            %>

                            <input name="acte" type="hidden" id="nature" value="insert">
                            <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-fiche.jsp&id=<%=request.getParameter("id")%>">
                            <input name="classe" type="hidden" id="classe" value="produits.Recette">
                        </div>
                        <%--                        <div class="box-footer">--%>
                        <%--                            <% //if(u.getUser().getLoginuser().equalsIgnoreCase("narindra") || u.getUser().getLoginuser().equalsIgnoreCase("Baovola") ) { %>--%>
                        <%--                            <button type="submit" name="Submit2" class="btn btn-success pull-right" style="margin-right: 25px;">Ajouter ligne</button>--%>
                        <%--                            <%  //} %>--%>

                        <%--                        </div>--%>


                    </div>
                </div>
            </form>
        </div>
    </div>
    <%}%>

    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol" style="padding-bottom: 0;padding-top: 10px;" >
            <div class="box-fiche box-fiche-space">
                <div class="box">
                    <div class="title-box with-border">
                        <h1>Composition</h1>
                    </div>
                    <form  id="incident" onsubmit='modifEtatMult(event)' enctype="multipart/form-data">
                        <!--<form action="<%=(String) session.getValue("lien")%>?but=modifierEtatMultiple.jsp" method="post" name="incident" id="incident"> -->
                        <div class="box-body table-responsive">
                            <input type="hidden" name="bute" value="produits/as-ingredients-fiche.jsp&id=<%=request.getParameter("id")%>"/>
                            <input type="hidden" name="acte" id="acte"/>




                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th align="center" valign="top" style="background-color:#bed1dd">
                                            <input onclick="CocheToutCheckbox(this, 'id')" type="checkbox">
                                        </th>
                                        <th>Ingredient</th>
                                        <th>Quantit&eacute;</th>

                                    <th>Unit&eacute;</th>
                                </tr>
                                </thead>

                                <tbody>
                                <%
                                    for (int i = 0; i < liste.length; i++) {
                                %>
                                <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                    <td align="center">
                                        <input type="checkbox" value="<%=liste[i].getId()%>_<%=i%>" name="ids" id="<%=liste[i].getId()%>_<%=i%>">
                                    </td>

                                    <td  align="center"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-fiche.jsp&id=<%=liste[i].getIdingredients()%>"><%=liste[i].getLibelleingredient()%></a></td>
                                    <td width="14%" align="center"><input type="text" id="quantite<%=i%>" name="quantite" value="<%=liste[i].getQuantite()%>" onchange="synchro(this,<%=liste[i].getId()%>_<%=i%>.value)"></td>
                                    <td  align="right"><%=liste[i].getValunite()%></td>
                                </tr>
                                <%
                                    }
                                %>

                                </tbody>
                            </table>

                            <div class="box-footer">
                                <button type="submit" name="acte" value="modifier_recette" class="btn btn-warning pull-right" style="margin-right: -8px;" onclick="document.getElementById('acte').value='modifier_recette'" >Modifier</button>
                                <button type="submit" name="acte" value="supprimer_recette" class="btn btn-danger pull-left" style="position: absolute;right: 0;margin-right: 110px;" onclick="document.getElementById('acte').value='supprimer_recette'" >Supprimer</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol">
            <div class="box-fiche box-fiche-space">
                <div class="box">
                    <div class="title-box with-border">
                        <h1>D&eacute;composition finale</h1>
                    </div>
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>Ingredient</th>
                                <th>Quantit&eacute;</th>
                                <th>Unit&eacute;</th>
                                <th>Prix Unitaire</th>
                                <th>Montant</th>
                            </tr>
                            </thead>

                            <tbody>
                            <%
                                for (int i = 0; i < listeBase.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                <td  align="center"><%=listeBase[i].getLibIngredients()%></td>
                                <td  align="right"><%=listeBase[i].getQuantite()%></td>
                                <td  align="right"><%=listeBase[i].getUnite()%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(listeBase[i].getQteav())%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(listeBase[i].getQtetotal())%></td>

                            </tr>
                            <%
                                }
                            %>

                            </tbody>
                        </table>

                        <h3 class="asi-fiche-cout"> Co&ucirc;t de revient : <%=Utilitaire.formaterAr(montantTotal)%> Ar</h3>
                        <%if(base.getPv()>0){%>
                        <h3 class="asi-fiche-cout"> Marge brute : <%=Utilitaire.formaterAr(base.getPv()- montantTotal)%> Ar</h3>
                        <%}%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol">
            <div class="box-fiche box-fiche-space">
                <div class="box">
                    <div class="title-box with-border">
                        <h1 >Autres Composants concern&eacute;s</h1>
                    </div>
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>Produit</th>
                                <th>Quantit&eacute;</th>
                                <th>Unit&eacute;</th>
                            </tr>
                            </thead>

                            <tbody>
                            <%
                                for (int i = 0; i < listerecette.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                <td  align="center"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-fiche.jsp&id=<%=listerecette[i].getIdproduits()%>"><%=listerecette[i].getLibelleproduit()%></a></td>
                                <td  align="right"><%=listerecette[i].getQuantite()%></td>
                                <td  align="right"><%=listerecette[i].getValunite()%></td>
                            </tr>
                            <%
                                }
                            %>

                            </tbody>
                        </table>

                    </div>

                </div>
            </div>
        </div>
    </div>
    <%if(base.getCompose()==0){
        HistoriquePrixIng[] histopu =base.getHistoriquePu(null,"pu","HISTORIQUEPUINGTRIE");
    %>
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6 lol">
            <div class="box-fiche">
                <div class="box box-asi-fiche">
                    <div class="title-box with-border">
                        <h1 >Historique prix achat</h1>
                    </div>
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Date</th>
                                    <th>Prix unitaire d&#39; Achat</th>

                                <th>Remarque</th>
                            </tr>
                            </thead>

                            <tbody>
                            <%
                                if( histopu!=null&&histopu.length>0){
                                    for (int i = 0; i < histopu.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">

                                <td  align="right"><%=Utilitaire.formatterDaty(histopu[i].getDaty())%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(histopu[i].getPu())%> Ar</td>

                                <td  align="right"><%=Utilitaire.remplacerNull(histopu[i].getRemarque())%></td>

                            </tr>
                            <%
                                    }}
                            %>

                            </tbody>
                        </table>

                    </div>

                </div>
            </div>
        </div>
    </div>
    <%}%>
    <%if(base.getCompose()>0){
        HistoriquePrixIng[] histopv =base.getHistoriquePu(null,"pv","HISTORIQUEPVINGTRIE");%>
    <div class="row lolHisto">
        <%--        <div class="col-md-3"></div>--%>
        <div class="col-md-6 lol lolHisto-bas">
            <div class="box-fiche">
                <div class="box box-asi-fiche">
                    <div class="title-box with-border">
                        <h1 >Historique prix de vente</h1>
                    </div>
                    <div class="box-body table-responsive">
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Prix unitaire</th>

                                <th>Remarque</th>
                            </tr>
                            </thead>

                            <tbody>
                            <%
                                if( histopv!=null&&histopv.length>0){
                                    for (int i = 0; i < histopv.length; i++) {
                            %>
                            <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                <td  align="right"><%=Utilitaire.formatterDaty(histopv[i].getDaty())%></td>
                                <td  align="right"><%=Utilitaire.formaterAr(histopv[i].getPu())%> Ar</td>

                                <td  align="right"><%=Utilitaire.remplacerNull(histopv[i].getRemarque())%></td>
                            </tr>
                            <%
                                    }}
                            %>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%}%>
</div>
<style>
    #maForme .col-md-6 {
        width: 100%
    }
    .lol
    {
        padding: 0 !important;
    }
    .lol #maForme .box-body .cardradius {
        padding: 0 !important;
        margin: 0 !important;
    }
    .lolHisto {
        display: flex;
        justify-content: center;
    }
    .lolHisto-bas {
        width: 71% !important;
    }
    .cardradius > div {
        margin-bottom: 0px  !important;
    }
</style>
<%
    } catch (Exception e)
    {
        e.printStackTrace();
    }
%>
<script>
    const secondRow = document.querySelectorAll('.row')[3];
    const colMd3Divs = secondRow.querySelectorAll('div.col-md-3');
    colMd3Divs.forEach(div => {
        div.classList.remove('col-md-3');
        div.classList.add('col-md-1');
    });
    const colMd6Div = secondRow.querySelector('div.col-md-6');
    if (colMd6Div) {
        colMd6Div.classList.remove('col-md-6');
        colMd6Div.classList.add('col-md-12');
    }
</script>
