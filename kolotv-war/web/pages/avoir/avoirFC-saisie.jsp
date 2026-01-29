<%-- 
    Document   : avoirFC-saisie
    Created on : 2 ao�t 2024, 14:51:01
    Author     : randr
--%>

<%@page import="avoir.AvoirFC"%>
<%@page import="avoir.AvoirFCFille"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%> 
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="vente.*"%>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        AvoirFC mere = new AvoirFC();
        AvoirFCFille fille = new AvoirFCFille();
        String idvente = request.getParameter("id");
        Vente vente = new Vente();
        AvoirFCFille[] vntDtls = null;
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[1];
        liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idMagasin").setLibelle("Point de vente");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        pi.getFormu().getChamp("idVente").setAutre("readonly");
        pi.getFormu().getChamp("idVente").setLibelle("Id Vente");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setVisible(false);
        pi.getFormu().getChamp("idMotif").setVisible(false);
        pi.getFormu().getChamp("idCategorie").setVisible(false);
        String readonly = "";
        if (idvente != null && idvente.startsWith("VNT"))
        {
            vente.setId(idvente);
            vente = (Vente) CGenUtil.rechercher(vente,null,null,null,"")[0];
            AvoirFC generated  = vente.genererAvoir();
            vntDtls = vente.genererAvoirDetails(null);
            pi.getFormu().setDefaut(generated);
            readonly = "readonly";
        }
        //fille
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"annexe.ProduitLib","id","PRODUIT_LIB_MGA","puVente;puAchat;taux;val","pu;puAchat;tauxDeChange;designation");
        affichage.Champ.setPageAppelInsert(pi.getFormufle().getChampFille("idProduit"),"annexe/produit/produit-saisie.jsp","id;val");
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("remise_0").setLibelle("remise");
        pi.getFormufle().getChamp("idVenteDetails_0").setLibelle("Vente details");
        pi.getFormufle().getChamp("pu_0").setLibelle("Montant");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        if(vntDtls != null && vntDtls.length>0){
            pi.setDefautFille(vntDtls);
        }
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idAvoirFC").setVisible(false);
        pi.getFormufle().getChampMulitple("idOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);
        pi.getFormufle().getChampMulitple("compte").setAutre("readonly");
        pi.getFormufle().getChampMulitple("idVenteDetails").setAutre("readonly");
        pi.preparerDataFormu();

        String[] order = {"idProduit", "designation", "compte", "qte", "pu", "remise", "tva", "idVenteDetails"};
        pi.getFormufle().setColOrdre(order);
        //Variables de navigation
        String classeMere = "avoir.AvoirFC";
        String classeFille = "avoir.AvoirFCFille";
        String butApresPost = "avoir/avoirFC-fiche.jsp";
        String colonneMere = "idAvoirFC";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
   <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1>Nouvel avoir FC</h1>
                    </div>
                    <div class="box-body">
                        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
                            <%

                                out.println(pi.getFormu().getHtmlInsert());
                            %>
                            <h3>Total  : <span id="montanttotal">0</span><span id="deviseLibelle">Ar</span></h3>
                            <%
                                out.println(pi.getFormufle().getHtmlTableauInsert());
                            %>

                            <input name="acte" type="hidden" id="nature" value="insert">
                            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
                            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
                            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
                            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
                            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
                            <input name="nomtable" type="hidden" id="nomtable" value="avoirFCFille">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>

