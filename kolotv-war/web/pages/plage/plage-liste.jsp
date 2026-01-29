<%@page import="affichage.PageRecherche"%>
<%@ page import="plage.PlageCpl" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    PlageCpl t = new PlageCpl();
    String listeCrt[] = {"id","heureDescription","heureDebut", "heureFin", "daty", "idSupportLib","jour"};
    String listeInt[] = {"daty","heureDebut","heureFin"};
    String libEntete[] = {"id","heureDebut", "heureFin", "heureDescription", "idSupportLib","jour"};

    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des plages");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("plage/plage-liste.jsp");
    pr.getFormu().getChamp("id").setLibelle("Id");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
//    pr.getFormu().getChamp("heureDebut").setLibelle("Heure de debut");
//    pr.getFormu().getChamp("heureFin").setLibelle("Heure de fin");
    pr.getFormu().getChamp("heureDebut1").setLibelle("Heure d&eacute;but min");
    pr.getFormu().getChamp("heureDebut1").setType("time");
    pr.getFormu().getChamp("heureDebut2").setLibelle("Heure d&eacute;but max");
    pr.getFormu().getChamp("heureDebut2").setType("time");
    pr.getFormu().getChamp("heureFin1").setLibelle("Heure fin min");
    pr.getFormu().getChamp("heureFin1").setType("time");
    pr.getFormu().getChamp("heureFin2").setLibelle("Heure fin max");
    pr.getFormu().getChamp("heureFin2").setType("time");
    pr.getFormu().getChamp("heureDescription").setLibelle("Cat&eacute;gorie de l'heure");
    pr.getFormu().getChamp("idSupportLib").setLibelle("Support");
    pr.getFormu().getChamp("jour").setLibelle("Jour");

    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    String lienTableau[] = {pr.getLien() + "?but=plage/plage-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"ID","Heure de d&eacute;but", "heure de fin", "Cat&eacute;gorie de l'heure", "Support", "Jour"};

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




