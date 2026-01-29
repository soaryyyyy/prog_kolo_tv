<%-- 
    Document   : support-liste
    Created on : 21 mars 2024, 12:15:28
    Author     : Toky20
--%>


<%@page import="support.SupportCpl"%>
<%@page import="affichage.PageRecherche"%>

<% try{ 
    SupportCpl t = new SupportCpl();
    t.setNomTable("SUPPORT_CPL");
    String listeCrt[] = {"id", "val","desce","idPointLib"};
    String listeInt[] = {};
    String libEntete[] = {"id", "val", "desce","idPointLib"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des Supports ");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("support/support-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("val").setLibelle("libell&eacute;");
    pr.getFormu().getChamp("desce").setLibelle("Description");
    pr.getFormu().getChamp("idPointLib").setLibelle("Point");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=support/support-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "D&eacute;signation", "Description", "Point"};
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