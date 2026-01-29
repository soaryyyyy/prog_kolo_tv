<%--
    Document   : vente-saisie
    Created on : 22 mars 2024, 14:37:44
    Author     : Angela
--%>


<%@page import="caisse.Caisse"%>
<%@page import="bean.TypeObjet"%>

<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@page import="produits.*"%>
<%@page import="reservation.*"%>
<%@ page import="support.Support" %>
<%@ page import="vente.*" %>
<%
    try {
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        InsertionVente mere = new InsertionVente();
        InsertionVenteDetails fille = new InsertionVenteDetails();
        fille.setNomTable("vente_details_saisie");
        int nombreLigne = 10;
        String idresa = request.getParameter("id");
        VenteDetails[] ventesDetails = null;
        Reservation resa = new Reservation();

        if (idresa != null && idresa.startsWith("RESA"))
        {
            resa.setId(idresa);
            resa = (Reservation) CGenUtil.rechercher(resa,null,null,null,"")[0];
            ventesDetails = resa.genereVenteDetails(null);
            if (ventesDetails.length>0){
                nombreLigne = ventesDetails.length;
            }
        }


        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);


        pi.getFormu().getChamp("idClient").setLibelle("Client");
        pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
        pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");

        String readonly = "";
        if (idresa != null && idresa.startsWith("RESA"))
        {
            pi.getFormu().getChamp("idClient").setDefaut(resa.getIdclient());
            pi.getFormu().getChamp("remarque").setDefaut(resa.getRemarque());
            pi.getFormu().getChamp("idClient").setAutre("readonly");
            pi.getFormu().getChamp("designation").setDefaut("Facturation de Reservation "+idresa);
            readonly = "readonly";
        }

        BonDeCommandeFIlleCpl[] bdcfille = null;
        if (idresa != null && idresa.startsWith("FCBC")) {
            BonDeCommande bcObj = new BonDeCommande();
            bcObj.setNomTable("BONDECOMMANDE_CLIENT");
            bcObj.setId(idresa);
            bcObj = (BonDeCommande) CGenUtil.rechercher(bcObj, null, null, null,"")[0];
            BonDeCommandeFIlleCpl search = new BonDeCommandeFIlleCpl();
            search.setNomTable("BC_CLIENT_FILLE_CPL_LIB");
            search.setIdbc(idresa);
            bdcfille = (BonDeCommandeFIlleCpl[]) CGenUtil.rechercher(search, null, null,"");

            pi.getFormu().getChamp("idMagasin").setDefaut(bcObj.getIdMagasin());
            pi.getFormu().getChamp("idClient").setDefaut(bcObj.getIdClient());
            pi.getFormu().getChamp("idOrigine").setDefaut(bcObj.getId());
            pi.getFormu().getChamp("referenceBc").setDefaut((bcObj.getReference() != null) ? bcObj.getReference() : "");
            pi.getFormu().getChamp("designation").setDefaut((bcObj.getDesignation() != null) ? bcObj.getDesignation() : "");
            pi.getFormu().getChamp("remarque").setDefaut((bcObj.getRemarque() != null) ? bcObj.getRemarque() : "");
        }

        pi.setLien((String) session.getValue("lien"));
        Liste[] liste = new Liste[4];
        liste[0] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
        liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
        liste[1].setDefaut("AR");
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
        pi.getFormu().getChamp("idOrigine").setLibelle("Origine");
        pi.getFormu().getChamp("idOrigine").setVisible(false);
//        pi.getFormu().getChamp("idOrigine").setPageAppelComplete("reservation.Reservation","id","reservation");
        pi.getFormu().getChamp("idOrigine").setDefaut(request.getParameter("id"));
        pi.getFormu().getChamp("idMagasin").setLibelle("Site");
        pi.getFormu().getChamp("designation").setLibelle("Campagne");
        pi.getFormu().getChamp("estPrevu").setLibelle("Est Pr&eacute;vu");
        pi.getFormu().getChamp("datyPrevu").setLibelle("Date pr&eacute;visionnelle d'encaissement");
        //pi.getFormu().getChamp("designation").setDefaut("Vente particulier du "+utilitaire.Utilitaire.dateDuJour());
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("remarque").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("idDevise").setLibelle("Devise");
        pi.getFormu().getChamp("idDevise").setAutre("onChange='deviseModification()'");
        //pi.getFormu().getChamp("idReservation").setDefaut(request.getParameter("id"));
        pi.getFormu().getChamp("idReservation").setVisible(false);
        pi.getFormu().getChamp("tva").setLibelle("TVA");
        pi.getFormu().getChamp("echeance").setLibelle("&eacute;ch&eacute;ance");
        pi.getFormu().getChamp("reglement").setLibelle("r&egrave;glement");
        pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormu().getChamp("referenceBc").setLibelle("R&eacute;f&eacute;rence de bon de commande");

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
        if (resa!=null && resa.getIdSupport()!=null && !resa.getIdSupport().isEmpty()){
            pi.getFormu().getChamp("idSupport").setDefaut(resa.getIdSupport());
        }


        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idProduit"),"produits.Ingredients","id","ST_INGREDIENTSAUTOVENTE","pv;compte_vente;libelle;tva","pu;compte;designation;tva");

        pi.getFormufle().getChamp("uniteRemise_0").setLibelle("Unit&eacute; de remise");
        pi.getFormufle().getChamp("reference_0").setLibelle("R&eacute;f&eacute;rence");
        pi.getFormufle().getChamp("idProduit_0").setLibelle("Produit");
        pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
        pi.getFormufle().getChamp("designation_0").setLibelle("D&eacute;signation");
        pi.getFormufle().getChamp("compte_0").setLibelle("Compte");
        pi.getFormufle().getChamp("remise_0").setLibelle("remise");
        pi.getFormufle().getChamp("idOrigine_0").setLibelle("Origine");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChampMulitple("idVente").setVisible(false);
        pi.getFormufle().getChampMulitple("id").setVisible(false);
        pi.getFormufle().getChampMulitple("IdOrigine").setVisible(false);
        pi.getFormufle().getChampMulitple("puAchat").setVisible(false);
        pi.getFormufle().getChampMulitple("puVente").setVisible(false);
        pi.getFormufle().getChampMulitple("idDevise").setVisible(false);
        pi.getFormufle().getChamp("tauxDeChange_0").setLibelle("Taux de change");
        pi.getFormufle().getChampMulitple("tauxDeChange").setVisible(false);

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("qte"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("remise"),"onchange='convertir(this)'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idProduit"),"onchange='calculerMontantV2()'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("uniteRemise"),"onchange='changeUnite(this)'");


        if(ventesDetails != null && ventesDetails.length>0){
            pi.setDefautFille(ventesDetails);
        }
        if(bdcfille != null && bdcfille.length>0){
            for (int i = 0; i < bdcfille.length; i++) {
                pi.getFormufle().getChamp("idProduit_" + i).setDefaut(bdcfille[i].getProduit());
                pi.getFormufle().getChamp("qte_" + i).setDefaut("" + bdcfille[i].getQuantite());
                pi.getFormufle().getChamp("pu_" + i).setDefaut("" + bdcfille[i].getPu());
                pi.getFormufle().getChamp("remise_" + i).setDefaut("" + bdcfille[i].getRemise());
                pi.getFormufle().getChamp("compte_"+i).setDefaut("" + bdcfille[i].getCompte());
                pi.getFormufle().getChamp("designation_"+i).setDefaut("" + bdcfille[i].getRemarque());
            }
        }
        pi.preparerDataFormu();

        for(int i=0;i<pi.getNombreLigne();i++){
            pi.getFormufle().getChamp("designation_"+i).setType("editor");
            pi.getFormufle().getChamp("compte_"+i).setAutre("readonly");
//            pi.getFormufle().getChamp("qte_"+i).setAutre(" onChange='calculerMontant("+i+")'");
        }
        String[] order = {"reference","idProduit", "designation", "compte", "qte", "pu", "remise","uniteRemise", "tva" ,"tauxDeChange"};
        pi.getFormufle().setColOrdre(order);

        //Variables de navigation
        String classeMere = "vente.InsertionVente";
        String classeFille = "vente.VenteDetails";
        String butApresPost = "vente/vente-fiche.jsp";
        String colonneMere = "idVente";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

        String titre = "";
        String acte = request.getParameter("acte");
        if(acte != null && !acte.isEmpty()){
            titre = "Modification de facture client";
        }else{
            titre = "Enregistrement de facture client";
        }

%>

<div class="content-wrapper" >
    <h1><%= titre %></h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
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

            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="Vente_Details">
        </form>
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

    /*
    function deviseModification() {

        var nombreLigne = parseInt($("#nombreLigne").val());
        for(let iL=0;iL<nombreLigne;iL++){
            $(function(){
                var mapping = {
                    "AR": {
                        "table": "produit_lib_mga",
                    },
                    "USD": {
                        "table": "produit_lib_usd"
                    },
                    "EUR": {
                        "table": "produit_lib_euro"
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
                            fetchAutocomplete(request, response, "null", "id", "null", mapping[idDevise].table, "annexe.ProduitLib", "true","puVente;puAchat;taux;val");
                        }
                    },
                    select: function(event, ui) {
                        $("#idProduit_"+iL+"libelle").val(ui.item.label);
                        $("#idProduit_"+iL).val(ui.item.value);
                        $("#idProduit_"+iL).trigger('change');
                        $(this).autocomplete('disable');
                        var champsDependant = ['pu_'+iL,'puAchat_'+iL,'tauxDeChange_'+iL,'designation_'+iL];
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

    document.addEventListener('DOMContentLoaded', function() {
        const tvaInput = document.getElementById('tva');

        tvaInput.addEventListener('input', function() {
            var listChamp = document.querySelectorAll('input[id^="pu_"]');

            const valeurTva = this.value;

            for (let i = 0; i <listChamp.length; i++) {
                const champTva = document.getElementById('tva_' + i);
                if (champTva) {
                    champTva.value = valeurTva;
                }
            }
        });
        calculerMontantV2();
    });

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

