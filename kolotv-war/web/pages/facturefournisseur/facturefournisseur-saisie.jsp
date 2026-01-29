<%@page import="faturefournisseur.FactureFournisseur"%>
<%@page import="faturefournisseur.FactureFournisseurDetails"%>
<%@page import="faturefournisseur.As_BonDeCommande_Fille_CPL_Livre"%>
<%@page import="faturefournisseur.As_BonDeLivraison_Fille_Cpl"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="caisse.Caisse"%>
<%@page import="vente.InsertionVente"%>
<%@page import="vente.VenteDetails"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%> 
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="mg.cnaps.compta.ConstanteCompta"%>
<%
    try {
        String idbc = request.getParameter("id");
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        PageInsertMultiple pi = null;
        FactureFournisseur mere = new FactureFournisseur();
        FactureFournisseurDetails fille = new FactureFournisseurDetails();
        fille.setNomTable("FactureFournisseurFille");
        int nombreLigne = 10;
        As_BonDeCommande_Fille_CPL_Livre[] detailsBC = null;
        As_BonDeLivraison_Fille_Cpl [] detailsBL = null;
        if (idbc != null && idbc.startsWith("BC")) {
            As_BonDeCommande_Fille_CPL_Livre bcfille = new As_BonDeCommande_Fille_CPL_Livre();
            bcfille.setNomTable("as_bondecommande_livre");
            bcfille.setIdbc(idbc);
            detailsBC = (As_BonDeCommande_Fille_CPL_Livre[]) CGenUtil.rechercher(bcfille, null, null,"");
            pi = new PageInsertMultiple(mere, fille, request, detailsBC.length, u);
        }  else if (idbc != null && idbc.startsWith("BL")) {
            As_BonDeLivraison_Fille_Cpl blfille = new As_BonDeLivraison_Fille_Cpl();
            blfille.setNomTable("AS_BONDELIVRAISON_LIBCPL");
            blfille.setNumbl(idbc);
            detailsBL = (As_BonDeLivraison_Fille_Cpl[]) CGenUtil.rechercher(blfille, null, null, "");
            pi = new PageInsertMultiple(mere, fille, request, detailsBL.length, u);
        }else {
            pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        }
        pi.setLien((String) session.getValue("lien"));

        Liste[] liste = new Liste[4];
        liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
        liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
       
        liste[1].setDefaut("AR");
         ModePaiement mp = new ModePaiement();
        liste[2] = new Liste("idmodepaiement",mp,"val","id");

        liste[3] = new Liste("estPrevu");
        liste[3].makeListeOuiNon();

        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("idmodepaiement").setLibelle("Mode de paiement");
        pi.getFormu().getChamp("IdMagasin").setLibelle("Magasin");

          
        
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
        pi.getFormu().getChamp("idFournisseur").setPageAppelComplete("faturefournisseur.Fournisseur","id","fournisseur");
        pi.getFormu().getChamp("idFournisseur").setPageAppelInsert("fournisseur/fournisseur-saisie.jsp","idFournisseur;idFournisseurlibelle","id;nom");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("dateEcheancePaiement").setVisible(false);
        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        pi.getFormu().getChamp("idBc").setVisible(false);
        pi.getFormu().getChamp("devise").setVisible(false);
        pi.getFormu().getChamp("taux").setVisible(false);
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
       
        pi.getFormu().getChamp("estPrevu").setLibelle("Est Pr&eacute;vu");
        pi.getFormu().getChamp("datyPrevu").setLibelle("Date pr&eacute;visionnelle de paiement");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"annexe.ProduitLib","id","PRODUIT_LIB","puAchat;compte","pu;compte");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"annexe.ProduitLib","id","PRODUIT_ACHAT_LIB_MGA","puAchat;compte","puAchat;compte");
        //affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compta_compte","","");

        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("remises_0").setLibelle("remise");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
         pi.getFormufle().getChamp("idDevise_0").setVisible(false);


        pi.getFormufle().getChampMulitple("idFactureFournisseur").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDetail").setVisible(false);
        pi.getFormufle().getChampMulitple("idbcDevise").setVisible(false);
        pi.preparerDataFormu();
        if(detailsBC != null && detailsBC.length>0){
            for (int i = 0; i < detailsBC.length; i++) {
                pi.getFormufle().getChamp("idProduit_" + i).setDefaut(detailsBC[i].getProduit());
                pi.getFormufle().getChamp("qte_" + i).setDefaut("" + detailsBC[i].getQte_reste());
                pi.getFormufle().getChamp("pu_" + i).setDefaut("" + detailsBC[i].getPu());
                pi.getFormufle().getChamp("tva_" + i).setDefaut("" + detailsBC[i].getTva());
                pi.getFormufle().getChamp("idDevise_"+i).setVisible(false);
                pi.getFormufle().getChamp("tauxDeChange_"+i).setVisible(false);
                pi.getFormufle().getChamp("compte_" + i).setDefaut("" + detailsBC[i].getCompte());
                pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            }
        }else if(detailsBL != null){
            for (int i = 0; i < detailsBL.length; i++) {
                pi.getFormufle().getChamp("idProduit_" + i).setDefaut(detailsBL[i].getProduit());
                pi.getFormufle().getChamp("qte_" + i).setDefaut("" + detailsBL[i].getQuantite());
                pi.getFormufle().getChamp("pu_" + i).setDefaut("" + detailsBL[i].getPu());
                pi.getFormufle().getChamp("tva_"+i).setDefaut("" + detailsBL[i].getTva());
                pi.getFormufle().getChamp("compte_" + i).setDefaut("" + detailsBL[i].getCompte());
                pi.getFormufle().getChamp("idDevise_"+i).setVisible(false);
                pi.getFormufle().getChamp("tauxDeChange_"+i).setVisible(false);
                pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            }
        }else{
            for(int i=0;i<nombreLigne;i++){
            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
            pi.getFormufle().getChamp("tva_"+i).setDefaut("0");
            pi.getFormufle().getChamp("idDevise_"+i).setVisible(false);
            pi.getFormufle().getChamp("tauxDeChange_"+i).setVisible(false);
            pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
            }
        }
        //Variables de navigation
        String classeMere = "faturefournisseur.FactureFournisseur";
        String classeFille = "faturefournisseur.FactureFournisseurDetails";
        String butApresPost = "facturefournisseur/facturefournisseur-fiche.jsp";
        String colonneMere = "idFactureFournisseur";
        //Preparer les affichages
        String[] colOrdreMere = {"daty"};
        pi.getFormu().setOrdre(colOrdreMere);
        String[] colOrdre = {"id","idProduit","compte","qte","pu","tva","idDevise","tauxDeChange"};
        pi.getFormufle().setColOrdre(colOrdre);
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
   <div class="row">
        <div class="col-md-12">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1>Nouvelle facture fournisseur</h1>
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
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    function calculerMontant(indice,source) {
        var val = 0;
            $('input[id^="qte_"]').each(function() {
                var quantite =  parseFloat($("#"+$(this).attr('id').replace("qte","pu")).val());
                var montant = parseFloat($(this).val());
                if(!isNaN(quantite) && !isNaN(montant)){
                    var value =quantite * montant;
                    val += value;
                }
            });
        $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
            minimumFractionDigits: 2,
            maximumFractionDigits: 2
        }).format(val));
    }
    /*function deviseModification() {
        
        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "produit_achat_lib_mga",
                    },
                    "USD": {
                        "table": "produit_achat_lib_usd"
                    },
                    "EUR": {
                        "table": "produit_achat_lib_euro"
                    }
                };
                $("#deviseLibelle").html($('#idDevise').val());
                var idDevise = $('#idDevise').val();
                $("#idDevise_"+iL).val(idDevise);
                let autocompleteTriggered = false;
                $("#idProduit_"+iL+"libelle").autocomplete('destroy');
                $("#tauxDeChange_"+iL).val('');
                $("#pu_"+iL).val('');
                $("#idProduit_"+iL+"libelle").autocomplete({
                    source: function(request, response) {
                        $("#idProduit_"+iL).val('');
                        if (autocompleteTriggered) {
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "annexe.ProduitLib", "true","pu;taux;compte;compte");
                        }
                    },
                    select: function(event, ui) {
                        $("#idProduit_"+iL+"libelle").val(ui.item.label);
                        $("#idProduit_"+iL).val(ui.item.value);
                        $("#idProduit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'tauxDeChange_'+iL,'compte_'+iL,'compte_'+iL+'libelle'];
                        for(let i=0;i<champsDependant.length;i++){
                            $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
                        }            
                        autocompleteTriggered = false;
                        return false;
                    }
                }).autocomplete('disable');
                $("#idProduit_"+iL+"libelle").off('keydown');
                $("#idProduit_"+iL+"libelle").keydown(function(event) {
                    if (event.key === 'Tab') {
                        event.preventDefault();
                        autocompleteTriggered = true;
                        $(this).autocomplete('enable').autocomplete('search', $(this).val());
                    }
                });
                $("#idProduit_"+iL+"libelle").off('input');
                $("#idProduit_"+iL+"libelle").on('input', function() {
                    $("#idProduit_"+iL).val('');
                    autocompleteTriggered = false;
                    $(this).autocomplete('disable');
                });
                $("#idProduit_"+iL+"searchBtn").off('click');
                $("#idProduit_"+iL+"searchBtn").click(function() {
                    autocompleteTriggered = true;
                    $("#idProduit_"+iL+"libelle").autocomplete('enable').autocomplete('search', $("#idProduit_"+iL+"libelle").val());
                });
            });
        }
    }*/
</script>
<%
	} catch (Exception e) {
		e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage()%>');
        history.back();
    </script>
<% }%>
