<%-- 
    Document   : as-commande-modif.jsp
    Created on : 29 d�c. 2016, 19:50:47
    Author     : Joe
--%>
<%@ page import="user.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="bean.*" %>
<%@ page import="affichage.*"%>
<%@page import="produits.Ingredients"%>
<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Ingredients  a = new Ingredients();
    PageUpdate pi = new PageUpdate(a, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    UserEJB u = (UserEJB) session.getAttribute("u");

    affichage.Champ[] liste = new affichage.Champ[2];

    TypeObjet op = new TypeObjet();
    op.setNomTable("as_unite");
    liste[0] = new Liste("unite", op, "VAL", "id");
    TypeObjet op1 = new TypeObjet();
    op1.setNomTable("CATEGORIEINGREDIENT");
    liste[1] = new Liste("categorieIngredient", op1, "val", "id");

    pi.getFormu().changerEnChamp(liste);
	
	pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
    pi.getFormu().getChamp("photo").setLibelle("Photo");
    pi.getFormu().getChamp("libelle").setLibelle("Ingredients");
    pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pi.getFormu().getChamp("unite").setLibelle("Unit&eacute;");
    pi.getFormu().getChamp("quantiteParPack").setLibelle("Qt&eacute; par pack");
    pi.getFormu().getChamp("compose").setLibelle("Compos&eacute;");
    pi.getFormu().getChamp("categorieIngredient").setLibelle("Categorie ingredients");
    pi.getFormu().getChamp("idFournisseur").setLibelle("Fournisseur");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("qteLimite").setLibelle("Qt&eacute; limite");
    pi.getFormu().getChamp("libelleVente").setLibelle("Libell&eacute; vente");
    pi.getFormu().getChamp("compte_vente").setLibelle("Compte associ&eacute ventes");
    pi.getFormu().getChamp("compte_achat").setLibelle("Compte associ&eacute achats");
    pi.preparerDataFormu();
    
%>
<div class="content-wrapper">
    <h1 class="box-title">Modification ingredients</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="appro" id="appro">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="acte" value="update">
        <input name="bute" type="hidden" id="bute" value="produits/as-ingredients-fiche.jsp">
        <input name="classe" type="hidden" id="classe" value="produits.Ingredients">
    </form>
</div>

<%} catch(Exception ex){
    ex.printStackTrace();
}%>