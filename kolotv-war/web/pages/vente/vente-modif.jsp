<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>


<%@page import="caisse.Caisse"%>
<%@page import="vente.InsertionVente"%>
<%@page import="vente.VenteDetails"%>
<%@page import="bean.TypeObjet"%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="vente.*"%>
<%@ page import="support.Support" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        UpdateVente mere = new UpdateVente();
        UpdateVenteDetails fille = new UpdateVenteDetails();
        fille.setNomTable("UPDATEVENTEDETAILS");
        int nombreLigne = 10;
        UpdateVenteDetails[] filles = (UpdateVenteDetails[])CGenUtil.rechercher(fille,null,null, " and idVente ='"+request.getParameter("id")+"'");
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, filles, request, u,filles.length);
        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[4];
        liste[0] = new Liste("idDevise",new caisse.Devise(),"val","id");
        liste[1] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
        liste[2] = new Liste("estPrevu");
        liste[2].makeListeOuiNon();
        Support typeMed= new Support();
        liste[3] = new Liste("idSupport", typeMed, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        Liste[] listeFille = new Liste[1];
        TypeObjet typeRemise = new TypeObjet();
        typeRemise.setNomTable("MODEREMISE");
        listeFille[0] = new Liste("uniteRemise",typeRemise,"desce","val");
        pi.getFormufle().changerEnChamp(listeFille);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("idOrigine").setVisible(false);
        pi.getFormu().getChamp("idreservation").setVisible(false);
        pi.getFormu().getChamp("idMagasin").setLibelle("Site");
        pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("designation").setDefaut("Vente particulier du "+utilitaire.Utilitaire.dateDuJour());
        //pi.getFormu().getChamp("estPrevu").setLibelle("Est Pr&eacute;vu");
        //pi.getFormu().getChamp("datyPrevu").setLibelle("Date encaissement");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        // pi.getFormu().getChamp("idClient").setVisible(false);
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client","id","idClient");
        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientLibLibelle","id;nom");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("referenceBc").setLibelle("R&eacute;f&eacute;rence de bon de commande");
        pi.getFormu().getChamp("echeance").setLibelle("&eacute;ch&eacute;ance");
        pi.getFormu().getChamp("reglement").setLibelle("r&egrave;glement");

        String table = "PRODUIT_LIB_MGA";
        for(int i=0; i<filles.length; i++) {
            if(filles[i].getIdDevise().compareToIgnoreCase("EUR")==0) {
                System.out.println("devise ====> " + filles[i].getIdDevise());
                table = "PRODUIT_LIB_EUR";
            } else if(filles[i].getIdDevise().compareToIgnoreCase("USD")==0) {
                System.out.println("devise ====> " + filles[i].getIdDevise());
                table = "PRODUIT_LIB_USD";
            } else if(filles[i].getIdDevise().compareToIgnoreCase("AR")==0){
                System.out.println("devise ====> " + filles[i].getIdDevise());
                table = "PRODUIT_LIB_MGA";
            }
        }

        pi.getFormu().getChamp("idSupport").setLibelle("Support");

        String ac_affiche_val = "null";
        String ac_valeur_val = "id";
        String ac_colFiltre_val = "null";
        String ac_nomTable_val = "ST_INGREDIENTSAUTOVENTE";
        String ac_classe_val = "produits.Ingredients";
        String ac_useMotcle_val = "true";
        String ac_champRetour_val = "pv;compte_vente;libelle;tva";
        String dependentFieldsToMap_str_val = "pu;compte;designation;tva";
        String columnForCountLine = "pu";

        String onChangeParam = "dynamicAutocompleteDependant(this, " +
                "\"IDSUPPORT\", " +
                "\"LIKE\", " +
                "\"idProduit\", " +
                "\"" + nombreLigne + "\", " +
                "\"" + ac_affiche_val + "\", " +
                "\"" + ac_valeur_val + "\", " +
                "\"" + ac_colFiltre_val + "\", " +
                "\"" + ac_nomTable_val + "\", " +
                "\"" + ac_classe_val + "\", " +
                "\"" + ac_useMotcle_val + "\", " +
                "\"" + ac_champRetour_val + "\", " +
                "\"" + dependentFieldsToMap_str_val + "\"," + // Last parameter
                "\"" + columnForCountLine + "\"" + // Last parameter
                ")";

        pi.getFormu().getChamp("idSupport").setAutre("onChange='" + onChangeParam + "'");

//        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduitLib"),"annexe.ProduitLib","id",table,"puVente;puAchat;taux;val;id;compte","pu;puAchat;tauxDeChange;designation;idProduit;comptelibelle");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.Ingredients","id","ST_INGREDIENTSAUTOVENTE","pv;compte_vente;libelle;tva","pu;compte;designation;tva");

        pi.getFormufle().getChamp("uniteRemise_0").setLibelle("Unit&eacute; de remise");
        pi.getFormufle().getChamp("reference_0").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("remise_0").setLibelle("remise");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("compte"),"mg.cnaps.compta.ComptaCompte","compte","compta_compte","","");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChampMulitple("idVente").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("IdOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("idProduitLib").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"oninput='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("qte"),"oninput='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"oninput='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remise"),"oninput='calculerMontantV2()' onchange='convertir(this)'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idProduit"),"oninput='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("uniteRemise"),"onchange='changeUnite(this)'");

        pi.preparerDataFormu();
        for(int i=0;i<pi.getNombreLigne();i++){
            //pi.getFormufle().getChamp("pu_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("designation_"+i).setType("editor");
//            pi.getFormufle().getChamp("qte_"+i).setAutre("onChange='calculerMontant("+i+")'");
            pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
            pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
            pi.getFormufle().getChamp("tauxDeChange_"+i).setAutre("readonly");
        }

        String[] order = {"reference","idProduit", "designation", "compte", "qte", "pu", "remise","uniteRemise", "tva" ,"tauxDeChange","idDevise"};
        pi.getFormufle().setColOrdre(order);

        //Variables de navigation
        String classeMere = "vente.UpdateVente";
        String classeFille = "vente.UpdateVenteDetails";
        String butApresPost = "vente/vente-fiche.jsp";
        String colonneMere = "idVente";
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
                        <h1>Modification de facture</h1>
                    </div>
                    <div class="box-body">
                        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post" >
                            <%

                                out.println(pi.getFormu().getHtmlInsert());
                            %>
                            <div style="background-color: white;padding: 5px;margin: 5px 11px;border-radius: 8px;display: flex;gap: 5px;align-items: center;justify-content: space-around">
                                <h4 style="font-size: 16px"><b>Montant HT :</b> <span id="montantHt">0</span><span id="deviseLibelle">Ar</span></h4>
                                <h4 style="font-size: 16px"><b>Montant Remise :</b> <span id="montantRemise">0</span><span id="deviseLibelle">Ar</span></h4>
                                <h4 style="font-size: 16px"><b>Montant TVA :</b> <span id="montantTva">0</span><span id="deviseLibelle">Ar</span></h4>
                                <h4 style="font-size: 16px"><b>Montant TTC :</b> <span id="montantTtc">0</span><span id="deviseLibelle">Ar</span></h4>
                            </div>
                            <%
                                out.println(pi.getFormufle().getHtmlTableauInsert());
                            %>

                            <input name="acte" type="hidden" id="nature" value="updateInsert">
                            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
                            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
                            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
                            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= pi.getNombreLigne() %>">
                            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page='taux.jsp'/>
<script>

    function calculerMontant(indice) {
        var val = 0;
            $('input[id^="qte_"]').each(function() {
                var quantite =  parseFloat($("#"+$(this).attr('id').replace("qte","pu")).val());
                var montant = parseFloat($(this).val());
                if(!isNaN(quantite) && !isNaN(montant)){
                    var value =quantite * montant;
                    val += value;
                }
            });
            $("#montanttotal").html(val.toFixed(2));
    }

    function calculerMontantV2(){
        var listChamp = document.querySelectorAll('input[id^="pu_"]');
        let montantHt = 0;
        let montantRemise = 0;
        let montantTva = 0;
        let montantTtc = 0;
        for (let i = 0; i < listChamp.length; i++) {
            let pu = parseFloat(document.getElementById("pu_"+i)?.value || 0);
            let qte = parseFloat(document.getElementById("qte_"+i)?.value || 0);
            let tva = parseFloat(document.getElementById("tva_"+i)?.value || 0);
            let remise = parseFloat(document.getElementById("remise_"+i)?.value || 0);
            let uniteRemise = document.getElementById("uniteRemise_"+i).value;

            montantHt += (pu*qte)-remise;
            montantRemise += remise;
            montantTva += ((pu*qte)-remise)*(tva/100);
            montantTtc += ((pu*qte)-remise)+(((pu*qte)-remise)*(tva/100));
        }
        document.getElementById("montantHt").innerHTML = montantHt.toLocaleString('en-US');
        document.getElementById("montantRemise").innerHTML = montantRemise.toLocaleString('en-US');
        document.getElementById("montantTva").innerHTML = montantTva.toLocaleString('en-US');
        document.getElementById("montantTtc").innerHTML = montantTtc.toLocaleString('en-US');
    }

    function convertir(champ){
        let remise = parseFloat(champ?.value||0);
        let id = champ.getAttribute("id").split("_")[1];
        let pu = parseFloat(document.getElementById("pu_"+id)?.value || 0);
        let qte = parseFloat(document.getElementById("qte_"+id)?.value || 0);
        let uniteRemise = document.getElementById("uniteRemise_"+id).value;
        let remiseFinal = remise;
        if (uniteRemise === "%"){
            remiseFinal = (pu*qte)*(remise/100);
        }
        champ.value = remiseFinal;
        calculerMontantV2();
    }

    function changeUnite(champ){
        let id = champ.getAttribute("id").split("_")[1];
        convertir(document.getElementById("remise_"+id));
    }

    // function deviseModification() {
    //     var nombreLigne = parseInt($("#nombreLigne").val());
    //     for(let iL=0;iL<nombreLigne;iL++){
    //         $(function(){
    //             var mapping = {
    //                 "AR": {
    //                     "table": "produit_lib_mga",
    //                 },
    //                 "USD": {
    //                     "table": "produit_lib_usd"
    //                 },
    //                 "EUR": {
    //                     "table": "produit_lib_euro"
    //                 }
    //             };
    //             $("#deviseLibelle").html($('#idDevise').val());
    //             var idDevise = $('#idDevise').val();
    //             $("#idDevise_"+iL).val(idDevise);
    //             let autocompleteTriggered = false;
    //             $("#idProduit_"+iL+"libelle").autocomplete('destroy');
    //             $("#tauxDeChange_"+iL).val('');
    //             $("#pu_"+iL).val('');
    //             $("#idProduit_"+iL+"libelle").autocomplete({
    //                 source: function(request, response) {
    //                     $("#idProduit_"+iL).val('');
    //                     if (autocompleteTriggered) {
    //                         fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "annexe.ProduitLib", "true","puVente;puAchat;taux");
    //                     }
    //                 },
    //                 select: function(event, ui) {
    //                     $("#idProduit_"+iL+"libelle").val(ui.item.label);
    //                     $("#idProduit_"+iL).val(ui.item.value);
    //                     $("#idProduit_"+iL).trigger('change');
    //                     $(this).autocomplete('disable');
    //                     var champsDependant = ['pu_'+iL,'puAchat_'+iL,'tauxDeChange_'+iL];
    //                     for(let i=0;i<champsDependant.length;i++){
    //                         $('#'+champsDependant[i]).val(ui.item.retour.split(';')[i]);
    //                     }
    //                     autocompleteTriggered = false;
    //                     return false;
    //                 }
    //             }).autocomplete('disable');
    //             $("#idProduit_"+iL+"libelle").off('keydown');
    //             $("#idProduit_"+iL+"libelle").keydown(function(event) {
    //                 if (event.key === 'Tab') {
    //                     event.preventDefault();
    //                     autocompleteTriggered = true;
    //                     $(this).autocomplete('enable').autocomplete('search', $(this).val());
    //                 }
    //             });
    //             $("#idProduit_"+iL+"libelle").off('input');
    //             $("#idProduit_"+iL+"libelle").on('input', function() {
    //                 $("#idProduit_"+iL).val('');
    //                 autocompleteTriggered = false;
    //                 $(this).autocomplete('disable');
    //             });
    //             $("#idProduit_"+iL+"searchBtn").off('click');
    //             $("#idProduit_"+iL+"searchBtn").click(function() {
    //                 autocompleteTriggered = true;
    //                 $("#idProduit_"+iL+"libelle").autocomplete('enable').autocomplete('search', $("#idProduit_"+iL+"libelle").val());
    //             });
    //         });
    //     }
    // }
    // deviseModification();
    calculerMontantV2();
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

