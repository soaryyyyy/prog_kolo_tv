<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 11/04/2025
  Time: 10:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="reservation.*" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="support.Support" %>

<%
    try {
        //Variable de navigation
        String classeMere = "reservation.Reservation";
        String classeFille = "reservation.ReservationDetails";
        String butApresPost = "reservation/reservation-fiche.jsp";
        String colonneMere = "idmere";
        //Definition de l'affichage
        String id = request.getParameter("id");
        Reservation  mere = new Reservation();
        ReservationDetails fille = new ReservationDetails();
        fille.setIdmere(id);
        ReservationDetails[] details = (ReservationDetails[])CGenUtil.rechercher(fille, null, null, "");
        PageUpdateMultiple pi = new PageUpdateMultiple(mere, fille, details, request, (user.UserEJB) session.getValue("u"), 2);
        //Information globale
        pi.setLien((String) session.getValue("lien"));
        //Modification affichage mère
        affichage.Liste[] listef = new Liste[1];
        Liste isDependant=new Liste("isDependant");
        isDependant.makeListeOuiNon();
        listef[0] = isDependant;
        pi.getFormufle().changerEnChamp(listef);


        affichage.Champ[] liste = new affichage.Champ[1];
        Support typeMed= new Support();
        liste[0] = new Liste("idSupport", typeMed, "val", "id");
        pi.getFormu().changerEnChamp(liste);
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("remarque").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("daty").setLibelle("Date de r&eacute;servation");
        pi.getFormu().getChamp("idclient").setLibelle("Client");
        pi.getFormu().getChamp("idclient").setPageAppelCompleteInsert("client.Client","id","Client", "client/client-saisie.jsp","id;nom");
        pi.getFormu().getChamp("idbc").setLibelle("Bon de commande");
        pi.getFormu().getChamp("idbc").setVisible(false);
//        pi.getFormu().getChamp("idbc").setPageAppelComplete("vente.BonDeCommande","id","BONDECOMMANDE_CLIENT");
        pi.getFormu().getChamp("idSupport").setLibelle("Support");
        pi.getFormu().getChamp("source").setLibelle("Source");
//        pi.getFormu().getChamp("idSupport").setPageAppelComplete("support.Support","id","SUPPORT");
        pi.getFormufle().getChamp("idproduit_0").setLibelle("Services M&eacute;dia");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idproduit"),"annexe.ProduitLib","id","PRODUIT_VENTE_LIB","montant;duree","pu;duree");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("id_0").setLibelle("ID");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("pu_0").setLibelle("Prix unitaire");
        pi.getFormufle().getChamp("daty_0").setLibelle("Date");
        pi.getFormufle().getChamp("heure_0").setLibelle("Heure");
        pi.getFormufle().getChamp("duree_0").setLibelle("Dur&eacute;e");
        pi.getFormufle().getChamp("remise_0").setLibelle("Remise");
        pi.getFormufle().getChamp("idBcFille_0").setLibelle("ID BC Fille");
        pi.getFormufle().getChamp("idmere_0").setLibelle("Reservation Mere");
        pi.getFormufle().getChamp("isDependant_0").setLibelle("Dans &eacute;mission");
        pi.getFormufle().getChamp("idMedia_0").setLibelle("M&eacute;dia");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampFille("idMedia"),"media.Media","id","MEDIA","duree","duree");
        pi.getFormufle().getChamp("source_0").setLibelle("Source");

        affichage.Champ.setVisible(pi.getFormufle().getChampFille("remise"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("qte"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idBcFille"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("etat"),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampFille("idparrainage"),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("id"), "readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("idmere"), "readonly");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("heure"),"step=\"1\"");
        affichage.Champ.setAutre(pi.getFormufle().getChampFille("duree"),"step=\"1\"");


        //Preparer affichage
        pi.preparerDataFormu();

        for (int i = 0; i < pi.getFormufle().getChampFille("heure").length; i++)
        {
            pi.getFormufle().getChamp("daty_"+i).setType("date");
            pi.getFormufle().getChamp("duree_"+i).setType("time");
            pi.getFormufle().getChamp("heure_"+i).setType("time");
        }

        affichage.Champ.setAutre(pi.getFormufle().getChampFille("pu"),"readonly");

        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <h1>Modification R&eacute;servation</h1>
    <form action="<%=(String) session.getValue("lien")%>?but=apresMultiple.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <%
                    out.println(pi.getFormu().getHtmlInsert());
                %>
            </div>
        </div>
        <div class="row">
            <div class="col-md-10 col-md-offset-1">
                <%
                    out.println(pi.getFormufle().getHtmlTableauInsert());
                %>
            </div>
        </div>
        <input name="acte" type="hidden" id="acte" value="updateInsert">
        <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
        <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
        <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%out.print(request.getParameter("id"));%>" >
        <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
        <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=pi.getNombreLigne()%>">
        <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
    </form>
</div>
<%
    }catch(Exception e)
    {
        System.out.println(e.getMessage());
        e.printStackTrace();
    }
%>
