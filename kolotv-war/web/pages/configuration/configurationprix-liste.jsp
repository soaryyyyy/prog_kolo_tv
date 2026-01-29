<%-- 
    Document   : configurationprix-liste
    Author     : Toky20
--%>

<%@page import="prix.ConfigurationPrixCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="utilitaire.Utilitaire" %>

<% try{ 
    ConfigurationPrixCpl t = new ConfigurationPrixCpl();
    t.setNomTable("CONFIGURATIONPRIX_CPL");
    String listeCrt[] = {"id","daty","idIngredientLib","etatLib"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","idIngredientLib","pu","pv","pu1","pu2","pu3","pu4","pu5","etatLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des configurations de prix");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("configuration/configurationprix-liste.jsp");
    
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idIngredientLib").setLibelle("Service M&eacute;dia");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=configuration/configurationprix-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID","Date","Services M&eacute;dia","PU hors prime time commercial","Prix de vente","PU prime time commercial","PU emission commercial","PU hors prime time institutionnel","PU prime time institutionnel","PU &eacute;mission institutionnel","Etat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
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




