<%--
    Document   : dureemaxspot-modif
    Created on : 21 mars 2024, 12:15:19
    Author     : Toky20
--%>

<%@page import="duree.DureeMaxSpot"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>
<%@ page import="support.Support" %>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    DureeMaxSpot t = new DureeMaxSpot();

    String  mapping = "duree.DureeMaxSpot",
          nomtable = "DureeMaxSpot",
          apres = "duree/dureemaxspot-fiche.jsp",
          titre = "Modification de disponiibilit&eacute; de diffusion";


    PageUpdate pu = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pu.setLien((String) session.getValue("lien"));
    pu.setTitre("Modification duree max spot");

    affichage.Champ[] liste = new affichage.Champ[3];
    Liste jours=new Liste("jour");
    String[] joursString = new String[] {"Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"};
    jours.makeListeString( joursString,  joursString);
    liste[0] = jours;
    Support typeMed= new Support();
    liste[1] = new Liste("idSupport", typeMed, "val", "id");
    TypeObjet catIngr = new TypeObjet();
    catIngr.setNomTable("CATEGORIEINGREDIENT");
    liste[2] = new Liste("idCategorieIngredient", catIngr, "VAL", "id");

    pu.getFormu().changerEnChamp(liste);


    pu.getFormu().getChamp("id").setAutre("readonly");
    pu.getFormu().getChamp("heureDebut").setLibelle("Heure d&eacute;but");
    pu.getFormu().getChamp("heureFin").setLibelle("Heure de fin");
    pu.getFormu().getChamp("heureDebut").setType("time");
    pu.getFormu().getChamp("heureFin").setType("time");

    pu.getFormu().getChamp("jour").setLibelle("Jour");
    pu.getFormu().getChamp("max").setLibelle("Dur&eacute;e Maximum (s)");
    pu.getFormu().getChamp("idSupport").setLibelle("Support");
    pu.getFormu().getChamp("idCategorieIngredient").setLibelle("Cat&eacute;gorie de service");

    pu.getFormu().getChamp("daty").setVisible(false);


    String lien = (String) session.getValue("lien");
    String id=pu.getBase().getTuppleID();
    pu.preparerDataFormu();
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=duree/dureemaxspot-fiche.jsp&id="+id%> <i class="fa fa-arrow-circle-left"></i></a><%=pu.getTitre()%></h1>
                    </div>
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
                        <%
                            out.println(pu.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-11">
                                <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                            </div>
                            <br><br>
                        </div>
                        <input name="acte" type="hidden" id="acte" value="update">
                        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
                        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
                        <input name="rajoutLien" type="hidden" id="rajoutLien" value="id-<%out.print(request.getParameter("id"));%>" >
                        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
