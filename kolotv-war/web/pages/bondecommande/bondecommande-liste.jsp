<%@page import="faturefournisseur.As_BonDeCommande"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>
<%@ page import="affichage.Liste" %>
<%@ page import="faturefournisseur.ModePaiement" %>

<% try{ 
    As_BonDeCommande f = new As_BonDeCommande();
    f.setNomTable("AS_BONDECOMMANDE_MERECPL");
    String listeCrt[] = {"id","daty","designation","fournisseurlib","modepaiementlib","reference"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","daty","etat","remarque","designation","modepaiementlib","fournisseurlib","reference"};
    PageRecherche pr = new PageRecherche(f, request, listeCrt, listeInt, 3, libEntete, libEntete.length);

    Liste[] liste = new Liste[1];
    ModePaiement mp = new ModePaiement();
    liste[0] = new Liste("modepaiementlib",mp,"val","id");
    pr.getFormu().changerEnChamp(liste);

    pr.setTitre("Liste des bons de commandes");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("bondecommande/bondecommande-liste.jsp");
    pr.getFormu().getChamp("designation").setLibelle("D&eacute;signation");
    pr.getFormu().getChamp("fournisseurlib").setLibelle("Fournisseur");
    pr.getFormu().getChamp("modepaiementlib").setLibelle("Mode de paiement");
    pr.getFormu().getChamp("reference").setLibelle("R&eacute;f&eacute;rence");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap(); 
        lienTab.put("modifier",pr.getLien() + "?but=bondecommande/bondecommande-modif.jsp"); 
    pr.getTableau().setLienClicDroite(lienTab);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=bondecommande/bondecommande-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"Id","Date","etat","Remarque","Designation","Mode de paiement","Fournisseur","Reference"};
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
