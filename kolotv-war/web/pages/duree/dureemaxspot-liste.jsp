<%--
    Document   : support-liste
    Created on : 21 mars 2024, 12:15:28
    Author     : Toky20
--%>


<%@page import="duree.DureeMaxSpotCpl"%>
<%@page import="affichage.PageRecherche"%>

<% try{
    DureeMaxSpotCpl t = new DureeMaxSpotCpl();
    t.setNomTable("DureeMaxSpot_Cpl");
    String listeCrt[] = {"id","jour","max","idSupportLib"};
    String listeInt[] = {"max"};
    String libEntete[] = {"id", "heureDebut","heureFin","jour","max","idSupportLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des heures disponibles de diffusion");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("duree/dureemaxspot-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("jour").setLibelle("Jour");
    pr.getFormu().getChamp("max1").setLibelle("Seconde min");
    pr.getFormu().getChamp("max2").setLibelle("Seconde max");
    pr.getFormu().getChamp("idSupportLib").setLibelle("Support");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=duree/dureemaxspot-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id", "Heure d&eacute;but","Heure de fin","Jour","Dur&eacute;e Maximum","Support"};

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
