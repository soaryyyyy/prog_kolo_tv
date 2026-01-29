<%--
    Document   : bondecommande-saisie
    Created on : 17 juil. 2024, 16:27:57
    Author     : micha
--%>


<%@page import="bean.CGenUtil"%>
<%@page import="affichage.PageUpdateMultiple"%>
<%@page import="vente.*"%>
<%@page import="bean.UnionIntraTable"%>
<%@page import="user.UserEJB"%>
<%@page import="affichage.PageInsertMultiple"%>
<%@page import="java.util.Calendar"%>
<%@page import="affichage.Liste"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.PageInsert"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="faturefournisseur.ModePaiement"%>
<%@page import="annexe.Unite"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="support.Support" %>

<%
    try{
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    BonDeCommandeFille[] bcFilles;
    InsertionBonDeCommande mere = new InsertionBonDeCommande();
    InsertionBcFille fille = new InsertionBcFille();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("dateBesoin").setLibelle("Date de besoin");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("remarque").setLibelle("Campagne");
    pi.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("idClient").setLibelle("Client");

    pi.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("designation").setVisible(false);
    
     pi.getFormu().getChamp("echeance").setLibelle("Ech&eacute;ance");
     pi.getFormu().getChamp("modereglement").setLibelle("Mode de r&egrave;glement");

    Liste[] liste = new Liste[4];
    ModePaiement mp = new ModePaiement();
    liste[0] = new Liste("modepaiement",mp,"val","id");
    liste[1] = new Liste("idDevise",new caisse.Devise(),"val","id");
    liste[1].setDefaut("AR");
    liste[1].setLibelle("Devise");
    liste[1].setLibelle("Devise");
    liste[2] = new Liste("idMagasin",new magasin.Magasin(),"val","id");
    liste[2].setLibelle("Point");
    Support typeMed= new Support();
    liste[3] = new Liste("idSupport", typeMed, "val", "id");
    pi.getFormu().changerEnChamp(liste);
    pi.getFormu().getChamp("modepaiement").setLibelle("Mode de paiement");
    //pi.getFormu().getChamp("fournisseur").setPageAppel("choix/fournisseur/fournisseur-choix.jsp","fournisseur;fournisseurlibelle");
    pi.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientLibelle","id;nom");

    pi.getFormu().getChamp("idSupport").setLibelle("Support");

    String ac_affiche_val = "null";
    String ac_valeur_val = "id";
    String ac_colFiltre_val = "null";
    String ac_nomTable_val = "as_ingredients";
    String ac_classe_val = "produits.Ingredients";
    String ac_useMotcle_val = "true";
    String ac_champRetour_val = "pv;tva;unite";
    String dependentFieldsToMap_str_val = "pu;tva;unite";
    String columnForCountLine = "pu";

    String onChangeParam = "dynamicAutocompleteDependant(this, " +
            "\"IDSUPPORT\", " +
            "\"LIKE\", " +
            "\"produit\", " +
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
    //Nommage et visibilite

    Liste[] listeFille = new Liste[1];
    TypeObjet typeRemise = new TypeObjet();
    typeRemise.setNomTable("MODEREMISE");
    listeFille[0] = new Liste("uniteRemise",typeRemise,"desce","val");
    pi.getFormufle().changerEnChamp(listeFille);


    pi.getFormufle().getChamp("quantite_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
    pi.getFormufle().getChamp("montant_0").setLibelle("Montant");
    pi.getFormufle().getChamp("tva_0").setLibelle("TVA");
    pi.getFormufle().getChamp("idDevise_0").setLibelle("Devise");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Designation");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise");
        pi.getFormufle().getChamp("uniteRemise_0").setLibelle("Unit&eacute; de remise");
         pi.getFormufle().getChamp("reference_0").setLibelle("R&eacute;f&eacute;rence");

//    affichage.Champ.setVisible(pi.getFormufle().getChampFille("remise"), false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idbc"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("montant"),false);
    pi.getFormufle().getChampMulitple("unite").setVisible(false);
    pi.getFormufle().getChamp("unite_0").setLibelle("Unit&eacute;");

    affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"onchange='calculerMontantV2()'");
    affichage.Champ.setAutre(pi.getFormufle().getChampFille("quantite"),"onchange='calculerMontantV2()'");
    affichage.Champ.setAutre(pi.getFormufle().getChampFille("tva"),"onchange='calculerMontantV2()'");
    affichage.Champ.setAutre(pi.getFormufle().getChampFille("remise"),"onchange='convertir(this)'");
    affichage.Champ.setAutre(pi.getFormufle().getChampFille("produit"),"onchange='calculerMontantV2()'");
    affichage.Champ.setAutre(pi.getFormufle().getChampFille("uniteRemise"),"onchange='changeUnite(this)'");

    for (int i = 0; i < nombreLigne; i++) {
        pi.getFormufle().getChamp("produit_" + i).setLibelle("Service m&eacute;dia");
        pi.getFormufle().getChamp("quantite_"+i).setDefaut("0");
        pi.getFormufle().getChamp("idDevise_"+i).setDefaut("AR");
        pi.getFormufle().getChamp("idDevise_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("unite_"+i).setAutre("readonly");
        pi.getFormufle().getChamp("remarque_"+i).setType("editor");
    }

    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("produit").getListeChamp(), "produits.Ingredients", "id", "as_ingredients", "pv;tva;unite","pu;tva;unite");

    BonDeCommande ocr = (BonDeCommande) session.getAttribute("ocr");
    if(ocr!=null){
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        LocalDate localDate = ocr.getDaty().toLocalDate();
        String formattedDate = localDate.format(formatter);
        pi.getFormu().getChamp("designation").setDefaut(ocr.getDesignation());
        pi.getFormu().getChamp("daty").setDefaut(formattedDate);
        if(ocr.getIdClient()!=null){
            pi.getFormu().getChamp("idClient").setDefaut(ocr.getIdClient());
        }
        if(ocr.getIdMagasin()!=null){
            pi.getFormu().getChamp("idMagasin").setDefaut(ocr.getIdMagasin());
        }
        pi.setDefautFille(ocr.getFille());
    }

     String[] order = {"reference","produit", "remarque", "quantite", "pu","remise","uniteRemise", "tva" ,"idDevise"};
    //String[] order = {"produit", "remarque", "quantite", "pu","remise","uniteRemise", "tva" ,"idDevise"};
    pi.getFormufle().setColOrdre(order);

    session.removeAttribute("ocr");

    String id = request.getParameter("idorigine");
    Proforma prf = new Proforma();
    if (id != null && id.startsWith("PRF")) {
        prf.setId(id);
        prf = (Proforma) CGenUtil.rechercher(prf,null,null,null,"")[0];
        pi.getFormu().setDefaut(prf);
        bcFilles = prf.genererBondeCommandeDetails(null);
        if(bcFilles != null && bcFilles.length>0){
            pi.setDefautFille(bcFilles);
        }
    }

    //Variables de navigation
    String classeMere = "vente.InsertionBonDeCommande";
    String classeFille = "vente.BonDeCommandeFille";
    String butApresPost = "vente/bondecommande/bondecommande-fiche.jsp";
    String colonneMere = "idbc";
    //Preparer les affichages
  
    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Saisie d'un bon de Commande</h1>
    <!--  -->
    <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
        <%

            out.println(pi.getFormu().getHtmlInsert()); %>
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
    </form>

</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const deviseSelect = document.getElementById('idDevise');
        deviseSelect.addEventListener('change', function() {
            const deviseSelectionne = this.value;
            for (let i = 0; i <= 10; i++) {
                const champDevise = document.getElementById('idDevise_' + i);
                if (champDevise) {
                    champDevise.value = deviseSelectionne;
                    if (champDevise.tagName === 'SELECT') {
                        for (let j = 0; j < champDevise.options.length; j++) {
                            if (champDevise.options[j].value === deviseSelectionne) {
                                champDevise.selectedIndex = j;
                                break;
                            }
                        }
                    }
                    const event = new Event('change');
                    champDevise.dispatchEvent(event);
                }
            }
        });
    });
</script>

<script>
    function calculerMontant(indice,source) {
        var val = 0;
        $('input[id^="quantite_"]').each(function() {
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
            let qte = parseFloat(document.getElementById("quantite_"+i)?.value || 0);
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
        let qte = parseFloat(document.getElementById("quantite_"+id)?.value || 0);
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
            calculerMontantV2();
        });
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

