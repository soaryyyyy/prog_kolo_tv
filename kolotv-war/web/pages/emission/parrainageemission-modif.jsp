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
<%@ page import="affichage.PageUpdateMultiple" %>
<%@ page import="emission.EmissionDetails" %>
<%@ page import="bean.CGenUtil" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String titre = "Modification de parrainage &eacute;mission";

        String id = request.getParameter("id");
        ParrainageEmission mere = new ParrainageEmission();
        ParrainageEmissionDetails fille = new ParrainageEmissionDetails();
        fille.setIdmere(id);
        ParrainageEmissionDetails[] details = (ParrainageEmissionDetails[]) CGenUtil.rechercher(fille, null, null, "");
        int nombreLigne = 10;
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), 2);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("idreservation").setVisible(false);
        pi.getFormu().getChamp("idclient").setLibelle("Client");
        pi.getFormu().getChamp("idclient").setPageAppelComplete("client.Client","id","Client");
        pi.getFormu().getChamp("idemission").setLibelle("&eacute;mission");
        pi.getFormu().getChamp("idemission").setPageAppelComplete("emission.EmissionLib", "id","EMISSION_LIB","tarifparainage","montant");
        pi.getFormu().getChamp("datedebut").setLibelle("Date de d&eacute;but");
        pi.getFormu().getChamp("datefin").setLibelle("Date de fin");
        pi.getFormu().getChamp("remise").setLibelle("Remise");
        pi.getFormu().getChamp("montant").setLibelle("Montant");
        pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("qteAvant").setLibelle("Quantit&eacute; avant");
        pi.getFormu().getChamp("dureeAvant").setLibelle("Duree avant");
        pi.getFormu().getChamp("qtePendant").setLibelle("Quantit&eacute; pendant");
        pi.getFormu().getChamp("dureePendant").setLibelle("Duree pendant");
        pi.getFormu().getChamp("qteApres").setLibelle("Quantit&eacute; apr&egrave;s");
        pi.getFormu().getChamp("dureeApres").setLibelle("Duree apres");

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

        pi.getFormu().getChamp("idclient").setAutre("onChange='"+onChangeParam+"'");

        pi.getFormufle().getChamp("avant_0").setLibelle("Quantite avant");
        pi.getFormufle().getChamp("apres_0").setLibelle("Quantite apres");
        pi.getFormufle().getChamp("pendant_0").setLibelle("Quantite pendant");
        pi.getFormufle().getChamp("idproduit_0").setLibelle("Services");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"annexe.ProduitLib","id","PRODUIT_VENTE_LIB");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("idmedia_0").setLibelle("M&eacute;dia");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idmedia"),"media.Media","id","MEDIA");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("avant"),"0");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("pendant"),"0");
        affichage.Champ.setDefaut(pi.getFormufle().getChampFille("apres"),"0");
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idmere"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);
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
            <input name="acte" type="hidden" id="acte" value="updateInsert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%out.print(request.getParameter("id"));%>" >
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=pi.getNombreLigne()%>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
        </form>
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
