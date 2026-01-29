
<%@page import="affichage.PageRecherche"%>
<%@page import="produits.*"%>
<%@ page import="notification.Notification" %>
<%@ page import="user.UserEJB" %>
<%@ page import="affichage.Liste" %>

<% try{
    UserEJB ue = (UserEJB) session.getValue("u");
    Notification t = new Notification();
    String listeCrt[] = {"daty","objet","message","etat"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","objet","message","daty","heure"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste Notifications");
    Liste[] liste = new Liste[1];
    liste[0]=new Liste("etat");
    liste[0].makeListeString(new String[]{"Tous","Lu","Non Lu"},new String[] {"%","1","11"});
    pr.getFormu().changerEnChamp(liste);
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("historique/notification-liste.jsp");
    pr.setAWhere(" AND IDUSER_RECEVANT='"+ue.getUser().getRefuser()+"'");
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=historique/notification-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    //Definition des libelles à afficher
    String libEnteteAffiche[] = {"ID","Objet","Message","Date","Heure"};
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



