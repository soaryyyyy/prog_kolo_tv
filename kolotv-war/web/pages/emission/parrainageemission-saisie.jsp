<%--
    Document   : parrainageemission-saisie.jsp
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="emission.ParrainageEmission"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="emission.ParrainageEmissionDetails" %>

<%
try {
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String titre = "Saisie d'un parrainage d'&eacute;mission";

    ParrainageEmission mere = new ParrainageEmission();
    ParrainageEmissionDetails fille = new ParrainageEmissionDetails();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request,nombreLigne , u);
    pi.setLien((String) session.getValue("lien"));

    pi.getFormu().getChamp("idreservation").setVisible(false);
    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idemission").setLibelle("&eacute;mission");
    if (request.getParameter("idEmission")!=null){
        pi.getFormu().getChamp("idemission").setDefaut(request.getParameter("idEmission"));
    }

    pi.getFormu().getChamp("idemission").setPageAppelComplete("emission.EmissionLib", "id","EMISSION_LIB","tarifparainage","montant");
    pi.getFormu().getChamp("datedebut").setLibelle("Date de d&eacute;but");
    pi.getFormu().getChamp("datefin").setLibelle("Date de fin");
    pi.getFormu().getChamp("remise").setLibelle("Remise");
    pi.getFormu().getChamp("montant").setLibelle("Montant");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("qte").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("qte").setVisible(false);
    pi.getFormu().getChamp("qteAvant").setLibelle("Quantit&eacute; avant");
    pi.getFormu().getChamp("dureeAvant").setLibelle("Duree avant");
    pi.getFormu().getChamp("dureeAvant").setType("time");
    pi.getFormu().getChamp("dureeAvant").setAutre("step='1'");
    pi.getFormu().getChamp("qtePendant").setLibelle("Quantit&eacute; pendant");
    pi.getFormu().getChamp("dureePendant").setLibelle("Dur&eacute;e pendant");
    pi.getFormu().getChamp("dureePendant").setType("time");
    pi.getFormu().getChamp("dureePendant").setAutre("step='1'");
    pi.getFormu().getChamp("qteApres").setLibelle("Quantit&eacute; apr&egrave;s");
    pi.getFormu().getChamp("dureeApres").setLibelle("Duree apr&egrave;s");
    pi.getFormu().getChamp("dureeApres").setType("time");
    pi.getFormu().getChamp("dureeApres").setAutre("step='1'");
    pi.getFormu().getChamp("source").setLibelle("Bon de commande");
    pi.getFormu().getChamp("dureeAvant").setVisible(false);
    pi.getFormu().getChamp("dureePendant").setVisible(false);
    pi.getFormu().getChamp("dureeApres").setVisible(false);
    if(request.getParameter("idBC")!=null){
        pi.getFormu().getChamp("source").setDefaut(request.getParameter("idBC"));
        pi.getFormu().getChamp("source").setAutre("readonly");
    }else {
        pi.getFormu().getChamp("source").setPageAppelComplete("vente.BonDeCommande","id","BONDECOMMANDE_CLIENT");
    }

    if (request.getParameter("idClient")!=null){
        pi.getFormu().getChamp("idclient").setDefaut(request.getParameter("idClient"));
    }
    pi.getFormu().getChamp("billiboardIn").setLibelle("Billboard IN");
    pi.getFormu().getChamp("billiboardOut").setLibelle("Billboard OUT");
    pi.getFormu().getChamp("billiboardIn").setVisible(false);
    pi.getFormu().getChamp("billiboardOut").setVisible(false);
    pi.getFormu().getChamp("billiboardIn").setPageAppelCompleteAWhere("media.Media", "id","MEDIA_CPL","",""," AND IDTYPEMEDIALIB LIKE '%Billboard%'");
    pi.getFormu().getChamp("billiboardOut").setPageAppelCompleteAWhere("media.Media", "id","MEDIA_CPL","",""," AND IDTYPEMEDIALIB LIKE '%Billboard%'");
    pi.getFormu().getChamp("billiboardIn").setPageAppelInsert("media/media-saisie.jsp","billiboardIn;billiboardInlibelle","id;description");
    pi.getFormu().getChamp("billiboardOut").setPageAppelInsert("media/media-saisie.jsp","billiboardOut;billiboardOutlibelle","id;description");

    String ac_affiche_val1 = "null";
    String ac_valeur_val1 = "id";
    String ac_colFiltre_val1 = "null";
    String ac_nomTable_val1 = "MEDIA_CPL";
    String ac_classe_val1 = "media.Media";
    String ac_useMotcle_val1 = "true";
    String ac_champRetour_val1 = "";
    String dependentFieldsToMap_str_val1 = "";
    String ac_awhere1 = "";

    String onChangeParam1 = "dynamicAutocompleteDependantForChampSimple(\"idclient\", " +
            "\"IDCLIENT\", " +
            "\"LIKE\", " +
            "\"billiboardIn\", " +
            "\"" + ac_affiche_val1 + "\", " +
            "\"" + ac_valeur_val1 + "\", " +
            "\"" + ac_colFiltre_val1 + "\", " +
            "\"" + ac_nomTable_val1 + "\", " +
            "\"" + ac_classe_val1 + "\", " +
            "\"" + ac_useMotcle_val1 + "\", " +
            "\"" + ac_champRetour_val1 + "\", " +
            "\"" + dependentFieldsToMap_str_val1 + "\"," + // Last parameter
            "\"" + ac_awhere1 + "\"" + // Last parameter
            ")";

    String onChangeParam2 = "dynamicAutocompleteDependantForChampSimple(\"idclient\", " +
            "\"IDCLIENT\", " +
            "\"LIKE\", " +
            "\"billiboardOut\", " +
            "\"" + ac_affiche_val1 + "\", " +
            "\"" + ac_valeur_val1 + "\", " +
            "\"" + ac_colFiltre_val1 + "\", " +
            "\"" + ac_nomTable_val1 + "\", " +
            "\"" + ac_classe_val1 + "\", " +
            "\"" + ac_useMotcle_val1 + "\", " +
            "\"" + ac_champRetour_val1 + "\", " +
            "\"" + dependentFieldsToMap_str_val1 + "\"," + // Last parameter
            "\"" + ac_awhere1 + "\"" + // Last parameter
            ")";


    String ac_affiche_val = "null";
    String ac_valeur_val = "id";
    String ac_colFiltre_val = "null";
    String ac_nomTable_val = "MEDIA";
    String ac_classe_val = "media.Media";
    String ac_useMotcle_val = "true";
    String ac_champRetour_val = "";
    String dependentFieldsToMap_str_val = "";
    String columnForCountLine = "remarque";

    String onChangeParam = "dynamicAutocompleteDependantForChampAutoComplete(\"idclient\", " +
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

    ac_affiche_val = "null";
    ac_valeur_val = "id";
    ac_colFiltre_val = "null";
    ac_nomTable_val = "PRODUIT_EMISSION";
    ac_classe_val = "annexe.ProduitLib";
    ac_useMotcle_val = "true";
    ac_champRetour_val = "";
    dependentFieldsToMap_str_val = "";
    columnForCountLine = "remarque";

    String onChangeParam3 = "dynamicAutocompleteDependantForChampAutoComplete(\"idemission\", " +
            "\"IDEMISSION\", " +
            "\"LIKE\", " +
            "\"idproduit\", " +
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

    pi.getFormu().getChamp("idclient").setAutre("onChange='"+onChangeParam+";"+onChangeParam1+";"+onChangeParam2+"'");
    pi.getFormu().getChamp("idemission").setAutre("onChange='"+onChangeParam3+"'");

    pi.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idclient;idclientlibelle","id;nom");

    pi.getFormufle().getChamp("avant_0").setLibelle("Quantit&eacute; avant");
    pi.getFormufle().getChamp("apres_0").setLibelle("Quantit&eacute; apres");
    pi.getFormufle().getChamp("pendant_0").setLibelle("Quantit&eacute; pendant");
    pi.getFormufle().getChamp("idproduit_0").setLibelle("Service");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"annexe.ProduitLib","id","PRODUIT_EMISSION");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("idmedia_0").setLibelle("M&eacute;dia");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idmedia"),"media.Media","id","MEDIA");
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("avant"),"0");
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("pendant"),"0");
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("apres"),"0");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idmere"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);

    for (int i = 0; i < nombreLigne; i++) {
        pi.getFormufle().getChamp("idmedia_"+i).setPageAppelInsert("media/media-saisie.jsp","idmedia_"+i+";idmedia_"+i+"libelle","id;description");
    }

    String[] order = {"idproduit", "remarque", "idmedia", "avant", "pendant" ,"apres"};
    pi.getFormufle().setColOrdre(order);

    pi.preparerDataFormu();



    //Variables de navigation
    String classeMere = "emission.ParrainageEmission";
    String classeFille = "emission.ParrainageEmissionDetails";
    String butApresPost = "emission/parrainageemission-fiche.jsp";
    String colonneMere = "idmere";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">

    <h1><%=titre%></h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="PARRAINAGEEMISSIONDETAILS">
        </form>
    </div>
</div>
<%if (request.getParameter("idEmission")!=null){%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        <%=onChangeParam3%>
    })
</script>
<%}%>
<%if (request.getParameter("idClient")!=null){%>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        <%=onChangeParam+";"+onChangeParam1+";"+onChangeParam2%>
    })
</script>
<%}%>

<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>
