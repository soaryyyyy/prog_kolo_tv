<%--
  Created by IntelliJ IDEA.
  User: tokiniaina_judicael
  Date: 2025-04-01
  Time: 15:59
  To change this template use File | Settings | File Templates.
--%>

<%@page import="affichage.PageRecherche"%>
<%@ page import="fabrication.Of" %>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<% try{
    Of t = new Of();
    t.setNomTable("OFABLIB");
    String listeCrt[] = {"id", "lancepar", "cible", "remarque", "libelle", "besoin", "daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "lancepar", "cible", "remarque", "libelle", "besoin", "daty"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste Ordre de Fabrication");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("fabrication/ordre-fabrication-liste.jsp");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("lancepar").setLibelle("Lanc&eacute; par");
    pr.getFormu().getChamp("libelle").setLibelle("libell&eacute;");
    String[] colSomme = null;
    
    pr.creerObjetPage(libEntete, colSomme);
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=fabrication/ordre-fabrication-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=fabrication/ordre-fabrication-fiche.jsp"};
    String colonneLien[] = {"id"}; // Colonne contenant un lien, passé comme paramètre dans l'URL
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Remplacer le nom de l'attribut passé dans l'URL, par exemple passer 'idObjet' au lieu de 'id' du colonneLien
    String[] attributLien = {"id"};
    pr.getTableau().setAttLien(attributLien);

    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID", "Lanc&eacute; par", "Cible", "Remarque", "D&eacute;signation", "Besoin", "Date"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("fabrication/inc/ordre-fabrication-details.jsp&id=");
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



