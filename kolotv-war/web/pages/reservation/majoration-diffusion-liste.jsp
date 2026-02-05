<%@page import="affichage.PageRecherche"%>
<%@page import="reservation.MajorationDiffusion"%>

<% try{
    MajorationDiffusion t = new MajorationDiffusion();
    String listeCrt[] = {"id","jour","heureDebut","heureFin","tauxMajoration"};
    String listeInt[] = {};
    String libEntete[] = {"id","jour","heureDebut","heureFin","tauxMajoration"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des majorations de diffusion");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("reservation/majoration-diffusion-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("jour").setLibelle("Jour");
    pr.getFormu().getChamp("heureDebut").setLibelle("Heure d&eacute;but");
    pr.getFormu().getChamp("heureDebut").setType("time");
    pr.getFormu().getChamp("heureFin").setLibelle("Heure fin");
    pr.getFormu().getChamp("heureFin").setType("time");
    pr.getFormu().getChamp("tauxMajoration").setLibelle("Taux de majoration (%)");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {pr.getLien() + "?but=reservation/majoration-diffusion-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID", "Jour", "Heure d&eacute;but", "Heure fin", "Majoration (%)"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
        <div style="margin-top: 10px;">
            <a class="btn btn-success" href="<%=pr.getLien()%>?but=reservation/majoration-diffusion-saisie.jsp">
                <i class="fa fa-plus"></i>&nbsp;Nouvelle majoration
            </a>
        </div>
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
