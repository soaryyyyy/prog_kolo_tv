<%@page import="user.*"%>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@ page import="annexe.Produit" %>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="fabrication.FabricationFille" %>
<%@ page import="fabrication.OfFille" %>
<%@ page import="fabrication.OfFilleCpl" %>
<%@ page import="utilitaire.Utilitaire" %>
<%
    try{
        System.out.println("JSP was successfully forwarded to!");
        UserEJB u = null;
        String idof = null;
        OfFilleCpl[] ofFille = null;
        u = (UserEJB) session.getValue("u");
        Fabrication mere = new Fabrication();
        FabricationFille fille = new FabricationFille();
        int nombreLigne = 10;
        PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request, nombreLigne, u);
        FabricationFille[] fillesIA = (FabricationFille[])session.getAttribute("fillesIA");
        pi.setLien((String) session.getValue("lien"));
        if(request.getParameter("idOF")!=null  && !request.getParameter("idOF").equalsIgnoreCase("")){
            idof = request.getParameter("idOF");
            OfFilleCpl filles = new OfFilleCpl();
            filles.setNomTable("OFFILLELIBQTERESTE");
            filles.setIdMere(idof);
            ofFille = (OfFilleCpl[]) CGenUtil.rechercher(filles,null,null, "");
            pi.getFormu().getChamp("idOf").setDefaut(idof);
            pi.getFormu().getChamp("idOf").setAutre("readOnly");
            String rajout="";
            if(ofFille.length>0) rajout= ofFille[0].getLibelleMere();
            pi.getFormu().getChamp("libelle").setDefaut("Fabrication de : "+request.getParameter("idOF")+" "+rajout);
        }else{
            pi.getFormu().getChamp("idOf").setPageAppelComplete("fabrication.Of","id","Ofab");
        }
        pi.getFormu().getChamp("idOf").setLibelle(" Ordre de fabrication associ&eacute;");
        pi.getFormu().getChamp("lancePar").setPageAppelCompleteInsert("annexe.Point", "id", "POINT", "annexe/point/point-saisie.jsp", "id;val");

        pi.getFormu().getChamp("cible").setLibelle("Cible");
        pi.getFormu().getChamp("cible").setPageAppelCompleteInsert("annexe.Point", "id", "POINT", "annexe/point/point-saisie.jsp", "id;val");
        pi.getFormu().getChamp("remarque").setLibelle("Remarque");
        pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("libelle").setLibelle("D&eacute;signation");
        pi.getFormu().getChamp("besoin").setDefaut(Utilitaire.formatterDaty(Utilitaire.ajoutJourDate(Utilitaire.dateDuJour(),7)));
        pi.getFormu().getChamp("besoin").setVisible(false);

        Liste[] listeDeroulante=new Liste[2];
        listeDeroulante[0]=new Liste("lancePar",new bean.TypeObjet("POINT"),"val","id");
        listeDeroulante[1]=new Liste("cible",new bean.TypeObjet("POINT"),"val","id");
        listeDeroulante[1].setDefaut("PNT000084");
        pi.getFormu().changerEnChamp(listeDeroulante);
        pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute; par");
        // pi.getFormu().getChamp("etat").setVisible(false);
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().setNbColonne(2);

        if(fillesIA!=null && fillesIA.length > 0){
            System.out.println("atoooo");
            pi.setDefautFille(fillesIA);
        }
        session.removeAttribute("fillesIA");
        if(ofFille!=null && ofFille.length > 0){
            pi.setDefautFille(ofFille);
            /*for(int i = 0 ; i < ofFille.length; i++){
                pi.getFormufle().getChamp("idIngredients_" + i).setDefaut(ofFille[i].getIdIngredients());
                pi.getFormufle().getChamp("qte_" + i).setDefaut(String.valueOf(ofFille[i].getQte()));
                pi.getFormufle().getChamp("remarque_" + i).setDefaut(ofFille[i].getRemarque());
                pi.getFormufle().getChamp("idunite_" + i).setDefaut(ofFille[i].getIdunite());
            }*/
        }
        pi.getFormufle().getChamp("idIngredients_0").setLibelle("Ingr&eacute;dients");
        pi.getFormufle().getChamp("remarque_0").setLibelle("Remarque");
        pi.getFormufle().getChamp("qte_0").setLibelle("Quantit&eacute;");
        pi.getFormufle().getChamp("idunite_0").setLibelle("Unit&eacute;");
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("id").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("libelle").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("idmere").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("datybesoin").getListeChamp(),false);
        affichage.Champ.setVisible(pi.getFormufle().getChampMulitple("pu").getListeChamp(),false);
        affichage.Champ.setAutre(pi.getFormufle().getChampMulitple("idunite").getListeChamp(),"readonly");
        affichage.Champ.setPageAppelComplete(pi.getFormufle().getChampMulitple("idIngredients").getListeChamp(), "produits.IngredientsLib", "id", "as_ingredients_lib", "unite","idunite");
        pi.preparerDataFormu();

        //Variables de navigation
        String classeMere = "fabrication.Fabrication";
        String classeFille = "fabrication.FabricationFille";
        String butApresPost = "fabrication/fabrication-fiche.jsp";
        String colonneMere = "idmere";
        //Preparer les affichages
        pi.getFormu().makeHtmlInsertTabIndex();
        pi.getFormufle().makeHtmlInsertTableauIndex();

%>
<div class="content-wrapper">
    <!-- A modifier -->
    <h1>Cr&eacute;ation Fabrication</h1>
    <!--  -->
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
    </form>

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

