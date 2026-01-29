<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
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
<%@ page import="vente.BonDeCommande" %>
<%@ page import="support.Support" %>
<%
  try {
    String idbc = request.getParameter("id");
    UserEJB u = null;
    u = (UserEJB) session.getValue("u");
    Reservation mere = new Reservation();
    ReservationDetails fille = new ReservationDetails();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
    BonDeCommandeFille[] bdcfille = null;
    affichage.Champ[] liste = new affichage.Champ[1];
    Support typeMed= new Support();
    liste[0] = new Liste("idSupport", typeMed, "val", "id");
    if (idbc != null && idbc.startsWith("FCBC")) {
      BonDeCommande bcObj = new BonDeCommande();
      bcObj.setNomTable("BONDECOMMANDE_CLIENT");
      bcObj.setId(idbc);
      bcObj = (BonDeCommande) CGenUtil.rechercher(bcObj, null, null, null,"")[0];
      BonDeCommandeFille search = new BonDeCommandeFille();
      search.setNomTable("BONDECOMMANDE_CLIENT_FILLE");
      search.setIdbc(idbc);
      bdcfille = (BonDeCommandeFille[]) CGenUtil.rechercher(search, null, null,"");
      pi.getFormu().getChamp("idclient").setDefaut(bcObj.getIdClient());
      pi.getFormu().getChamp("idbc").setDefaut(idbc);
      String apresWh=" and idpoint='"+bcObj.getIdMagasin()+"'";
      liste[0].setAc_aWhere(apresWh);
    }
    pi.getFormu().changerEnChamp(liste);
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("remarque").setLibelle("Campagne");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelCompleteInsert("client.Client","id","Client", "client/client-saisie.jsp","id;nom");
    pi.getFormu().getChamp("idbc").setLibelle("Bon de commande");
    pi.getFormu().getChamp("idbc").setPageAppelComplete("vente.BonDeCommande","id","BONDECOMMANDE_CLIENT");
    pi.getFormu().getChamp("idSupport").setLibelle("Support");
    pi.getFormu().getChamp("source").setLibelle("Source");

    String ac_affiche_val = "null";
    String ac_valeur_val = "id";
    String ac_colFiltre_val = "null";
    String ac_nomTable_val = "PRODUIT_VENTE_LIB";
    String ac_classe_val = "annexe.ProduitLib";
    String ac_useMotcle_val = "true";
    String ac_champRetour_val = "montant;duree";
    String dependentFieldsToMap_str_val = "pu;duree";
    String columnForCountLine = "pu";

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

    pi.getFormufle().getChamp("idproduit_0").setLibelle("Services M&eacute;dia");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"annexe.ProduitLib","id","PRODUIT_VENTE_LIB","montant;duree","pu;duree");
    pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
    pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
    pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
    pi.getFormufle().getChamp("daty_0").setLibelle("Date de d&eacute;but");
    pi.getFormufle().getChamp("heure_0").setLibelle("Heure de d&eacute;but");
    pi.getFormufle().getChamp("duree_0").setLibelle("Dur&eacute;e");
    pi.getFormufle().getChamp("idBcFille_0").setLibelle("BDC Fille");
    affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idBcFille"),"vente.BonDeCommandeFille","id","BONDECOMMANDE_CLIENT_FILLE","produit;produit;quantite;remise","idproduit;idproduitlibelle;qte;remise");
    pi.getFormufle().getChamp("remise_0").setLibelle("Remise");
    pi.getFormufle().getChamp("isDependant_0").setLibelle("Dans &eacute;mission");
    affichage.Champ.setAutre(pi.getFormufle().getChampFille("heure"),"step=\"1\"");
    affichage.Liste[] listef = new Liste[1];
    Liste isDependant=new Liste("isDependant");
    isDependant.makeListeOuiNon();
    listef[0] = isDependant;
    pi.getFormufle().changerEnChamp(listef);

    String defaultDate = Utilitaire.dateDuJour();
    String heure = Utilitaire.heureCouranteHMS();

    if (request.getParameter("date")!=null && !request.getParameter("date").isEmpty()){
      defaultDate = request.getParameter("date");
    }
    if (request.getParameter("heure")!=null && !request.getParameter("heure").isEmpty()){
      heure = request.getParameter("heure");
    }
    if (request.getParameter("idSupport")!=null && !request.getParameter("idSupport").isEmpty()){
      pi.getFormu().getChamp("idSupport").setDefaut(request.getParameter("idSupport"));
    }

    String duree = "00:00:00";
    if (request.getParameter("duree")!=null && !request.getParameter("duree").isEmpty()){
      duree = request.getParameter("duree");
    }

    for (int i = 0; i < nombreLigne; i++)
    {
      pi.getFormufle().getChamp("qte_"+i).setDefaut("0");
      pi.getFormufle().getChamp("daty_"+i).setDefaut(defaultDate);
      pi.getFormufle().getChamp("heure_"+i).setDefaut(heure);
//      pi.getFormufle().getChamp("duree_"+i).setType("time");
      pi.getFormufle().getChamp("heure_"+i).setType("time");
    }

    if(bdcfille != null && bdcfille.length>0){
      for (int i = 0; i < bdcfille.length; i++) {
        pi.getFormufle().getChamp("idproduit_" + i).setDefaut(bdcfille[i].getProduit());
        pi.getFormufle().getChamp("qte_" + i).setDefaut("" + bdcfille[i].getQuantite());
        pi.getFormufle().getChamp("pu_" + i).setDefaut("" + bdcfille[i].getPu());
        pi.getFormufle().getChamp("idBcFille_" + i).setDefaut("" + bdcfille[i].getId());
        pi.getFormufle().getChamp("remise_" + i).setDefaut("" + bdcfille[i].getRemise());
      }
    }
    pi.preparerDataFormu();
    String[] order = {"idproduit", "daty", "heure","duree","idBcFille", "pu", "qte","remise","remarque","isDependant"};
    pi.getFormufle().setColOrdre(order);
    affichage.Champ.setDefaut(pi.getFormufle().getChampFille("duree"),duree);
    // affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"readonly");
     affichage.Champ.setVisible(pi.getFormufle().getChampFille("idBcFille"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idparrainage"),false);

    //Variables de navigation
    String classeMere = "reservation.Reservation";
    String classeFille = "reservation.ReservationDetails";
    String butApresPost = "reservation/reservation-fiche.jsp";
    String colonneMere = "idmere";
    //Preparer les affichages
    String[] ordreMere = {"daty"};
    pi.getFormu().setOrdre(ordreMere);
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
  <h1>Enregistrement de la R&eacute;servation</h1>
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
      <input name="nomtable" type="hidden" id="nomtable" value="RESERVATIONDETAILS">
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
