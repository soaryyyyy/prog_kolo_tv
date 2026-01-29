<%--
  Created by IntelliJ IDEA.
  User:
  Date: 11/04/2025
  Time: 10:44
  To change this template use File | Settings | File Templates.
--%>
<%@page import="user.*"%>
<%@ page import="bean.*" %>
<%@page import="affichage.*"%>
<%@page import="utilitaire.*"%>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetails" %>
<%@ page import="vente.BonDeCommandeFille" %>
<%@ page import="reservation.ReservationDetailsGroupe" %>
<%@ page import="support.Support" %>

<style>
    #calendar {
        width: 100%;
        margin: 20px auto;
        overflow: auto; /* permet le scroll si zoom ou tableau large */
        transform-origin: top left;
    }

    /* Styles personnalisés */
    .monthHeader {
        background-color: #003791 !important;
        color: white !important;
        font-weight: bold !important;
        text-align: center !important;
    }
    .dayHeader {
        background-color: #f0f0f0 !important;
        font-weight: bold !important;
        text-align: center !important;
    }
    .dayNumber {
        text-align: center !important;
    }

    #zoomContainer {
        margin: 10px auto;
        text-align: center;
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0; top: 0;
        width: 100%; height: 100%;
        background-color: rgba(0,0,0,0.4);
    }
    .modal-content {
        background-color: white;
        margin: 10% auto;
        padding: 5px;
        width: 43%;
        max-width: 900px;
        border-radius: 8px;
    }
    .close {
        float: right;
        font-size: 22px;
        font-weight: bold;
        cursor: pointer;
    }

    .calendar-btn{
        display: flex;
        gap: 10px;
        justify-content: right;
    }
</style>
<%
    try {
        String idbc = request.getParameter("id");
        UserEJB u = null;
        u = (UserEJB) session.getValue("u");
        Reservation mere = new Reservation();
        String id = request.getParameter("id");
        mere = (Reservation) mere.getById(id,mere.getNomTable(),null);
        ReservationDetailsGroupe fille = new ReservationDetailsGroupe();
        ReservationDetailsGroupe [] reservationDetailsGroupes = mere.genererReservationDetailsGroupe(null);
        int nombreLigne = 10;
        if (reservationDetailsGroupes.length>0){
            nombreLigne = reservationDetailsGroupes.length;
        }
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        pi.getFormu().setDefaut(mere);
        pi.setLien((String) session.getValue("lien"));
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("remarque").setLibelle("Campagne");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.datetostring(mere.getDaty()));
        pi.getFormu().getChamp("idclient").setLibelle("Client");
        pi.getFormu().getChamp("idclient").setPageAppelCompleteInsert("client.Client","id","Client", "client/client-saisie.jsp","id;nom");
        pi.getFormu().getChamp("idbc").setLibelle("Bon de commande");
        pi.getFormu().getChamp("idbc").setPageAppelComplete("vente.BonDeCommande","id","BONDECOMMANDE_CLIENT");
        pi.getFormu().getChamp("idSupport").setLibelle("Support");
        pi.getFormu().getChamp("source").setLibelle("Source");
        pi.getFormu().getChamp("source").setVisible(false);
//    pi.getFormu().getChamp("idSupport").setPageAppelComplete("support.Support","id","SUPPORT");
        pi.getFormufle().getChamp("idproduit_0").setLibelle("Services");
        pi.getFormufle().getChamp("idmedia_0").setLibelle("M&eacute;dia");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"annexe.ProduitLib","id","PRODUIT_VENTE_LIB","montant;duree","pu;duree");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idmedia"),"media.Media","id","MEDIA","duree","duree");

        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("source_0").setLibelle("Source");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix Unitaire");
        pi.getFormufle().getChamp("dateDiffusion_0").setLibelle("Date de diffusion");
        pi.getFormufle().getChamp("datedebut_0").setLibelle("Date de d&eacute;but");
        pi.getFormufle().getChamp("datefin_0").setLibelle("Date de fin");
        pi.getFormufle().getChamp("heure_0").setLibelle("Heure");
        pi.getFormufle().getChamp("duree_0").setLibelle("Dur&eacute;e");
        pi.getFormufle().getChamp("nbspot_0").setLibelle("Quantite");
        affichage.Champ[] liste = new affichage.Champ[1];
        Support typeMed= new Support();
        liste[0] = new Liste("idSupport", typeMed, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("idSupport").setLibelle("Support");
        affichage.Champ[] listeFille = new affichage.Champ[1];
        TypeObjet tp= new TypeObjet();
        tp.setNomTable("ORDREDIFFUSION");
        listeFille[0] = new Liste("isEntete", tp, "desce", "val");
        pi.getFormufle().changerEnChamp(listeFille);
        pi.getFormufle().getChamp("isEntete_0").setLibelle("Ordre");

        String ac_affiche_val = "null";
        String ac_valeur_val = "id";
        String ac_colFiltre_val = "null";
        String ac_nomTable_val = "PRODUIT_VENTE_LIB";
        String ac_classe_val = "annexe.ProduitLib";
        String ac_useMotcle_val = "true";
        String ac_champRetour_val = "montant;duree";
        String dependentFieldsToMap_str_val = "pu;duree";
        String columnForCountLine = "remarque";

        String onChangeParam = "dynamicAutocompleteDependant(this, " +
                "\"IDSUPPORT\", " +
                "\"LIKE\", " +
                "\"idproduit\", " +
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

        ac_affiche_val = "null";
        ac_valeur_val = "id";
        ac_colFiltre_val = "null";
        ac_nomTable_val = "MEDIA";
        ac_classe_val = "media.Media";
        ac_useMotcle_val = "true";
        ac_champRetour_val = "duree";
        dependentFieldsToMap_str_val = "duree";

        onChangeParam = "dynamicAutocompleteDependantForChampAutoComplete(\"idclient\", " +
                "\"IDCLIENT\", " +
                "\"LIKE\", " +
                "\"idmedia\", " +
                "\""+nombreLigne+"\", " +
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
        pi.getFormu().getChamp("idclient").setAutre("onChange='"+onChangeParam+"'");

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("dateDiffusion"),"placeholder='"+Utilitaire.dateDuJour()+";"+Utilitaire.dateDuJour()+"' onclick=\"affChampCalendrier(this,'datedebut','datefin')\" onchange='updateNbSpot(this)'");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("nbspot"),"readonly");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("pu"),"0");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("nbspot"),"0");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("datedebut"),Utilitaire.dateDuJour());
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("datefin"),Utilitaire.dateDuJour());
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("duree"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("ordre"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("dateInvalide"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idmere"),false);

        for (int i = 0; i < nombreLigne; i++) {
            pi.getFormufle().getChamp("heure_"+i).setType("time");
            pi.getFormufle().getChamp("idmedia_"+i).setPageAppelInsert("media/media-saisie.jsp","idmedia_"+i+";idmedia_"+i+"libelle","id;description");
        }

        int lastOrder = 0;
        if (reservationDetailsGroupes.length>0){
            lastOrder = reservationDetailsGroupes[reservationDetailsGroupes.length-1].getOrdre();
            pi.setNombreLigne(reservationDetailsGroupes.length);
            pi.setDefautFille(reservationDetailsGroupes);
        }

        pi.preparerDataFormu();

        String[] order = {"idproduit","idmedia","remarque","source","isEntete","heure","pu","datedebut","datefin","dateDiffusion","nbspot","duree","dateInvalide","idmere"};
        pi.getFormufle().setColOrdre(order);
        pi.getFormu().setOrdre(new String[]{"daty","idclient","remarque","idbc"});
        //Variables de navigation
        String classeMere = "reservation.Reservation";
        String classeFille = "reservation.ReservationDetailsGroupe";
        String butApresPost = "reservation/reservation-fiche.jsp";
        String colonneMere = "idmere";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <h1>Modification de r&eacute;servation</h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresReservation.jsp" method="post" >
            <% out.println(pi.getFormu().getHtmlInsert()); %>
            <div style="position: sticky !important;top: 0 !important;z-index: 3">
                <h4 style="font-size: 16px"><b>Nombre de spot total :</b> <span id="nbSpotTotal">0</span></h4>
            </div>
            <% out.println(pi.getFormufle().getHtmlTableauInsert()); %>
            <input name="acte" type="hidden" id="nature" value="modifReservationGroupe">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="RESERVATIONDETAILS">
            <input name="idResa" type="hidden" value="<%=id%>">
            <input name="lastOrder" type="hidden" value="<%=lastOrder%>">
        </form>
    </div>
</div>

<div id="calendarModal" class="modal">
    <div class="modal-content">
        <div id="calendar"></div>
        <div class="calendar-btn">
            <button class="btn btn-default" type="button" onclick="hideChampCalendrier()">Annuler</button>
            <button id="btn-save-calendar-multiple" class="btn btn-success" type="button">Enregistrer</button>
        </div>
    </div>
</div>

<script>
    // --- Classes ---
    class Jour {
        constructor(nom, dayNumber, date) {
            this.nom = nom;
            this.dayNumber = dayNumber;
            this.acronyme = nom[0];
            this.date = date;
        }
    }

    class Mois {
        constructor(nom, annee) {
            this.nom = nom;
            this.annee = annee;
            this.jours = new Map();
        }
        ajouterJour(jour) {
            this.jours.set(jour.date, jour);
        }
    }

    let hot;
    const joursSemaine = ["Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi"];
    const moisNoms = ["Janvier","F&eacute;vrier","Mars","Avril","Mai","Juin","Juillet","Ao&ucirc;t","Septembre","Octobre","Novembre","D&eacute;cembre"];

    function normalizeDate(dateStr) {
        if (!dateStr || typeof dateStr !== "string") return null;
        // Supprimer les espaces parasites
        dateStr = dateStr.trim();

        // Cas 1 : format dd/mm/yyyy (tolère 1/8/2025 aussi)
        const regexFR = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;
        const matchFR = dateStr.match(regexFR);
        if (matchFR) {
            let [_, dd, mm, yyyy] = matchFR;
            dd = dd.padStart(2, "0");
            mm = mm.padStart(2, "0");
            return yyyy+"-"+mm+"-"+dd;
        }

        // Cas 2 : format yyyy-mm-dd
        const regexISO = /^(\d{4})-(\d{1,2})-(\d{1,2})$/;
        const matchISO = dateStr.match(regexISO);
        if (matchISO) {
            let [_, yyyy, mm, dd] = matchISO;
            dd = dd.padStart(2, "0");
            mm = mm.padStart(2, "0");
            return yyyy+"-"+mm+"-"+dd;
        }

        // Si aucun format valide
        return null;
    }

    function parseDate(str) {
        const [y, m, d] = str.split("-").map(Number);
        return new Date(y, m - 1, d);
    }

    function formatDate(date) {
        const d = String(date.getDate()).padStart(2,"0");
        const m = String(date.getMonth()+1).padStart(2,"0");
        const y = date.getFullYear();
        return d+"/"+m+"/"+y;
    }

    function genererMois(dateDebutStr, dateFinStr) {
        if (!dateDebutStr || !dateFinStr) return [];
        let dateDebut = parseDate(dateDebutStr);
        let dateFin = parseDate(dateFinStr);
        if (dateDebut > dateFin) return [];

        let result = [];
        let moisCourants = {};
        let current = new Date(dateDebut);

        while (current <= dateFin) {
            let jourNom = joursSemaine[current.getDay()];
            let jourDate = formatDate(current);
            let dayNumber = current.getDate();
            let moisNom = moisNoms[current.getMonth()];
            let annee = current.getFullYear();

            let jour = new Jour(jourNom, dayNumber, jourDate);

            let keyMois = moisNom+"-"+annee;
            if (!moisCourants[keyMois]) {
                moisCourants[keyMois] = new Mois(moisNom, annee);
                result.push(moisCourants[keyMois]);
            }
            moisCourants[keyMois].ajouterJour(jour);

            current.setDate(current.getDate() + 1);
        }
        return result;
    }

    function afficherCalendrier(dateDebut,dateFin,listeDates) {
        // --- Générer calendrier ---
        const moisListe = genererMois(dateDebut,dateFin);

        // --- Préparer les données ---
        let headerRow = [];
        let dayNameRow = [];
        let dayNumberRow = [];
        let merges = [];
        let colIndex = 0;

        moisListe.forEach(mois => {
            const startCol = colIndex;
            mois.jours.forEach(jour => {
                headerRow.push(mois.nom+" "+mois.annee);
                dayNameRow.push(jour.acronyme);
                dayNumberRow.push(jour.dayNumber);
                colIndex++;
            });
            merges.push({
                row: 0,
                col: startCol,
                rowspan: 1,
                colspan: colIndex - startCol
            });
        });

        const hotData = [headerRow, dayNameRow, dayNumberRow];

        const container = document.getElementById('calendar');
        if (hot) hot.destroy();
        hot = new Handsontable(container, {
            data: hotData,
            rowHeaders: false,
            colHeaders: false,
            licenseKey: 'non-commercial-and-evaluation',
            stretchH: 'none',
            readOnly: true,  // toutes les cellules de base read-only
            manualColumnResize: true,
            height: 'auto',
            width: 'auto',
            mergeCells: merges,
            autoColumnSize: true,
            cells: function(row, col) {
                const cellProperties = {};
                cellProperties.renderer = function(instance, td, row, col, prop, value, cellProperties) {
                    Handsontable.renderers.TextRenderer.apply(this, arguments);
                    if (row === 0) td.classList.add("monthHeader");
                    else if (row === 1) td.classList.add("dayHeader");
                    else if (row === 2) td.classList.add("dayNumber");
                };
                return cellProperties;
            }
        });

        ajouterLignePresence(hot,listeDates);
    }

    function ajouterLignePresence(hot, listeDates) {
        const dayRowIndex = 2;
        const colCount = hot.countCols();
        const headerRowRaw = hot.getDataAtRow(0) || [];
        let lastMois = null;
        const headerRow = new Array(colCount).fill(null);
        for (let c = 0; c < colCount; c++) {
            const v = headerRowRaw[c];
            lastMois = (v) ? v : lastMois;
            headerRow[c] = lastMois;
        }

        const dayNumbers = hot.getDataAtRow(dayRowIndex) || [];
        const newRow = new Array(colCount).fill("");

        for (let col = 0; col < colCount; col++) {
            const moisNomComplet = headerRow[col];
            const numeroJour = dayNumbers[col];
            if (!moisNomComplet || numeroJour===undefined) continue;
            const parts = String(moisNomComplet).trim().split(/\s+/);
            const annee = parts.pop();
            const moisNom = parts.join(" ");
            const moisIndex = moisNoms.indexOf(moisNom) + 1;
            if (moisIndex<=0) continue;
            const dateFormat = String(numeroJour).padStart(2,"0") + "/" + String(moisIndex).padStart(2,"0") + "/" + annee;
            if (listeDates.includes(dateFormat)) newRow[col] = 1;
        }

        hot.batch(() => {
            hot.alter("insert_row_below", hot.countRows()-1, 1);
            const newRowIndex = hot.countRows()-1;
            for (let col=0; col<colCount; col++) {
                if (newRow[col]!=="") hot.setDataAtCell(newRowIndex, col, newRow[col]);
                hot.setCellMeta(newRowIndex, col, 'readOnly', false); // ligne editable
            }
        });
    }

    function enregistrerDates(champId) {
        const editableRowIndex = hot.countRows() - 1; // ligne editable
        const dayRowIndex = 2; // ligne des numéros des jours
        const colCount = hot.countCols();

        const headerRowRaw = hot.getDataAtRow(0);       // ligne des mois (fusionnée)
        const dayNumbers = hot.getDataAtRow(dayRowIndex);

        // 🔹 Propager les mois sur toutes les colonnes fusionnées
        let lastMois = null;
        const headerRow = new Array(colCount).fill(null);
        for (let c = 0; c < colCount; c++) {
            const v = headerRowRaw[c];
            if (v !== null && v !== undefined && v !== "") lastMois = v;
            headerRow[c] = lastMois;
        }

        let dates = [];

        for (let col = 0; col < colCount; col++) {
            const val = hot.getDataAtCell(editableRowIndex, col);
            if (val === 1 || val === '1') { // cellule cochée
                const moisNomComplet = headerRow[col];
                const numeroJour = dayNumbers[col];

                if (!moisNomComplet || numeroJour === undefined) continue;

                const parts = moisNomComplet.trim().split(/\s+/);
                const annee = parts.pop();
                const moisNom = parts.join(" ");
                const moisIndex = moisNoms.indexOf(moisNom) + 1;

                const dateStr = String(numeroJour).padStart(2,"0") + "/" +
                    String(moisIndex).padStart(2,"0") + "/" +
                    annee;
                dates.push(dateStr);
            }
        }

        const inputField = document.getElementById(champId);
        inputField.value = dates.join(";");// reconstruire le champ texte
        updateNbSpot(inputField);
        hideChampCalendrier(); // fermer le modal
    }

    function affChampCalendrier(champDateMultiple,champDateDebut,champDateFin){
        let index = champDateMultiple.getAttribute("id").split("_")[1];
        let dtDebut = document.getElementById(champDateDebut+"_"+index);
        let dtFin = document.getElementById(champDateFin+"_"+index);
        const modal = document.getElementById("calendarModal");
        const listeDates = champDateMultiple.value.split(";").map(s=>s.trim()).filter(s=>s!=="");
        afficherCalendrier(normalizeDate(dtDebut.value),normalizeDate(dtFin.value),listeDates);
        modal.style.display = "block";
        const btn_save = document.getElementById("btn-save-calendar-multiple");
        btn_save.setAttribute("onclick","enregistrerDates('"+champDateMultiple.getAttribute("id")+"')");
    }

    function hideChampCalendrier(){
        const modal = document.getElementById("calendarModal");
        modal.style.display = "none";
    }

    function updateNbSpot(champDateMultiple){
        let index = champDateMultiple.getAttribute("id").split("_")[1];
        const listeDates = champDateMultiple.value.split(";").map(s=>s.trim()).filter(s=>s!=="");
        document.getElementById("nbspot_"+index).value = listeDates.length;

        var listChamp = document.querySelectorAll('input[id^="heure_"]');
        let total = 0;
        for (let i = 0; i < listChamp.length; i++) {
            let nbSpot = parseInt(document.getElementById("nbspot_"+i)?.value || 0);
            total += nbSpot;
        }
        document.getElementById("nbSpotTotal").innerHTML = ""+total;
    }

    document.addEventListener("DOMContentLoaded", function() {
        var listChamp = document.querySelectorAll('input[id^="heure_"]');
        let total = 0;
        for (let i = 0; i < listChamp.length; i++) {
            let champDateMultiple = document.getElementById("dateDiffusion_"+i);
            const listeDates = champDateMultiple.value.split(";").map(s=>s.trim()).filter(s=>s!=="");
            let nbSpot = listeDates.length;
            document.getElementById("nbspot_"+i).value = nbSpot;
            total += nbSpot;
        }
        document.getElementById("nbSpotTotal").innerHTML = ""+total;
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
