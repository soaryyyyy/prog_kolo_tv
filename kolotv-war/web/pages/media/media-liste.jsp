<%-- 
    Document   : support-liste
    Created on : 21 mars 2024, 12:15:28
    Author     : Toky20
--%>


<%@page import="media.MediaCpl"%>
<%@page import="affichage.PageRecherche"%>

<% try{ 
    MediaCpl t = new MediaCpl();
    t.setNomTable("Media_Cpl");
    String listeCrt[] = {"id", "duree","idTypeMediaLib","idClientLib"};
    String listeInt[] = {};
    String libEntete[] = {"id", "duree","idTypeMediaLib","idClientLib"};
    
    
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste m&eacute;dia");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("media/media-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("idTypeMediaLib").setLibelle("M&eacute;dia");
    pr.getFormu().getChamp("idClientLib").setLibelle("Client");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=media/media-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id", "Dur&eacute;e","M&eacute;dia","Client"};
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