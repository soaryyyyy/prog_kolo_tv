<%@page import="faturefournisseur.As_BonDeCommande"%>
<%@page import="vente.BonDeCommandeCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>
<%@ page import="faturefournisseur.ModePaiement" %>

<% try{
    BonDeCommandeCpl f = new BonDeCommandeCpl();
    f.setNomTable("BONDECOMMANDE_ETAT_GLOBAL");
    String listeCrt[] = {"id","daty","designation","idclientlib","modepaiementlib","reference", "etat","etatFacturation"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","remarque","designation","modepaiementlib","idclientlib","reference","etatlib","etatFacturationLib"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des bons de commande");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("vente/bondecommande/bondecommande-liste.jsp");

    Champ[] liste = new Champ[3];
    Liste listeEtat = new Liste("etat");
    String[] aff = {"TOUS","CR&Eacute;E", "VALID&Eacute;E"};
    String[] val = {"%", "1", "11"};
    listeEtat.ajouterValeur(val, aff);
    liste[0] = listeEtat;
    Liste listeEtatFacture = new Liste("etatFacturation");
    String[] aff2 = {"TOUS","Facturer", "Non facturer"};
    String[] val2 = {"%", "1", "0"};
    listeEtatFacture.ajouterValeur(val2, aff2);
    liste[1] = listeEtatFacture;
    ModePaiement mp = new ModePaiement();
    liste[2] = new Liste("modepaiementlib",mp,"val","id");

    pr.getFormu().changerEnChamp(liste);

    if (request.getParameter("IAaWhere")!=null){
        pr.setAWhere(request.getParameter("IAaWhere"));
    }

    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("modepaiementlib").setLibelle("Mode de paiement");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("etat").setLibelle("&Eacute;tat");
    pr.getFormu().getChamp("etatFacturation").setLibelle("&Eacute;tat de facturation");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=vente/bondecommande/bondecommande-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Date","Remarque","D&eacute;signation","Mode de paiement","Client","R&eacute;f&eacute;rence","&Eacute;tat","&Eacute;tat de facturation"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setLienFille("vente/bondecommande/inc/bondecommande-detail.jsp&id=");
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
