<%-- 
    Document   : as-produits-saisie
    Created on : 1 d�c. 2016, 10:39:11
    Author     : Joe
--%>
<%@page import="produits.Ingredients"%>
<%@page import="user.*"%> 
<%@ page import="bean.TypeObjet" %>
<%@page import="affichage.*"%>
<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Ingredients  a = new Ingredients();
    PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));    
    
    affichage.Champ[] liste = new affichage.Champ[5];
    
    TypeObjet op = new TypeObjet();
    op.setNomTable("as_unite");
    liste[0] = new Liste("unite", op, "VAL", "id");
    
    TypeObjet catIngr = new TypeObjet();
    catIngr.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("categorieingredient", catIngr, "VAL", "id");

    Liste compose=new Liste("compose");
    compose.makeListeOuiNon();
    liste[2] = compose;
    Liste isAchat=new Liste("isAchat");
    isAchat.makeListeOuiNon();
    liste[3] = isAchat;
    Liste isVente=new Liste("isVente");
    isVente.makeListeOuiNon();
    liste[4] = isVente;
    
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("isAchat").setLibelle("Produit achet&eacute;");
    pi.getFormu().getChamp("isVente").setLibelle("Produit commercialis&eacute;");
    pi.getFormu().getChamp("libelleextacte").setLibelle("Libell&eacute; exacte");
    pi.getFormu().getChamp("actif").setVisible(false);
    pi.getFormu().getChamp("calorie").setVisible(false);
    pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
    pi.getFormu().getChamp("quantiteparpack").setLibelle("Quantit&eacute; par pack");
	pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("quantiteparpack").setDefaut("1");
	pi.getFormu().getChamp("seuil").setDefaut("100");
    pi.getFormu().getChamp("photo").setVisible(false);
    pi.getFormu().getChamp("compose").setLibelle("Est compos&eacute;");
    pi.getFormu().getChamp("categorieingredient").setLibelle("Cat&eacute;gorie d'ingr&eacute;dient");
    pi.getFormu().getChamp("idfournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("qtelimite").setLibelle("Quantit&eacute; limite");
    pi.getFormu().getChamp("pv").setLibelle("Prix de vente");
    pi.getFormu().getChamp("libellevente").setVisible(false);
    pi.getFormu().getChamp("compte_vente").setLibelle("Compte de vente");
    pi.getFormu().getChamp("compte_achat").setLibelle("Compte d'achat");
    pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pi.getFormu().getChamp("duree").setLibelle("Dur&eacute;e");
    pi.getFormu().getChamp("tva").setLibelle("TVA");
    pi.getFormu().getChamp("pu1").setLibelle("Prix Unitaire 1");
    pi.getFormu().getChamp("pu2").setLibelle("Prix Unitaire 2");
    pi.getFormu().getChamp("pu3").setLibelle("Prix Unitaire 3");
    pi.getFormu().getChamp("pu4").setLibelle("Prix Unitaire 4");
    pi.getFormu().getChamp("pu5").setLibelle("Prix Unitaire 5");
    pi.getFormu().getChamp("idSupport").setLibelle("Support");
    pi.getFormu().getChamp("dureeMax").setLibelle("Dur&eacute;e Maximum");


    pi.getFormu().getChamp("compte_vente").setPageAppelComplete("mg.cnaps.compta.ComptaCompte","compte","COMPTA_COMPTE");
    pi.getFormu().getChamp("compte_vente").setPageAppelInsert("compta/compte/compte-saisie.jsp", "compte_vente;compte_ventelibelle", "id;compte");

    pi.getFormu().getChamp("compte_achat").setPageAppelComplete("mg.cnaps.compta.ComptaCompte","compte","COMPTA_COMPTE");
    pi.getFormu().getChamp("compte_achat").setPageAppelInsert("compta/compte/compte-saisie.jsp","compte_achat;compte_achatlibelle", "id;compte");

    String[] ordre = {"daty"};
    pi.getFormu().setOrdre(ordre);
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1>Enregistrer des Produits / Services</h1>
    <!--  -->
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="starticle" id="starticle">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
        out.println(pi.getHtmlAddOnPopup());
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-fiche.jsp">
    <input name="classe" type="hidden" id="classe" value="produits.Ingredients">
    </form>
</div>