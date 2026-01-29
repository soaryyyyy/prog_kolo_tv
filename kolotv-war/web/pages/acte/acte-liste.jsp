

<%@page import="produits.ActeLib"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="utilitaire.Utilitaire" %>

<% try{
    ActeLib t = new ActeLib();
    String[] etatVal = {"ACTE_LIB", "ACTE_LIB_C", "ACTE_LIB_V","ACTE_LIB_NONFACT","ACTE_LIB_FACT","ACTE_LIB_A"};
    String[] etatAff = {"Tous", "Cr&eacute;e(s)", "Vis&eacute;e(s)", "Non Facture&eacute;e(s)","Facture&eacute;e(s)","Annul&eacute;e(s)"};

    t.setNomTable(etatVal[0]);
    if (request.getParameter("etat") != null && request.getParameter("etat").compareToIgnoreCase("") != 0) {
        t.setNomTable(request.getParameter("etat"));
    }

    String listeCrt[] = {"idclientlib", "daty","libelleproduit","idmedialib", "idsupportlib", "idreservationfille", "heure", "duree","idemissionlib","libelle"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "libelle","daty","libelleproduit","idclientlib","idmedialib", "idsupportlib", "idreservationfille","idemissionlib","montant","etatlib"};
    String libEnteteAffiche[] = {"id", "d&eacute;signation","date","Services M&eacute;dia","client","M&eacute;dia", "Support", "R&eacute;servation","&Eacute;mission","montant","&eacute;tat"};
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des diffusions");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("acte/acte-liste.jsp");
    pr.getFormu().getChamp("idmedialib").setLibelle("M&eacute;dia");
    pr.getFormu().getChamp("idsupportlib").setLibelle("Support");
    pr.getFormu().getChamp("idreservationfille").setLibelle("R&eacute;servation");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(Utilitaire.dateDuJour());
    pr.getFormu().getChamp("duree").setLibelle("Dur&eacute;e");
    pr.getFormu().getChamp("duree").setType("time");
    pr.getFormu().getChamp("duree").setAutre("step=\"1\"");
    pr.getFormu().getChamp("heure").setType("time");
    pr.getFormu().getChamp("heure").setAutre("step=\"1\"");
    pr.getFormu().getChamp("idclientlib").setLibelle("Client");
    pr.getFormu().getChamp("libelleproduit").setLibelle("Services M&eacute;dia");
    pr.getFormu().getChamp("idemissionlib").setLibelle("&Eacute;mission");
    pr.getFormu().getChamp("libelle").setLibelle("d&eacute;signation");
    String[] colSomme = { "montant" };
    pr.creerObjetPage(libEntete, colSomme);

    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=acte/acte-modif.jsp");
    pr.getTableau().setLienClicDroite(lienTab);
    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=acte/acte-fiche.jsp", pr.getLien() + "?but=caisse/caisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    String[] attributLien = {"id", "id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setAttLien(attributLien);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
%>
<script>
function changerDesignation() {
    document.depense.submit();
}
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="depense" id="depense">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
            <div class="row col-md-12">
                <div class="col-md-4"></div>
                <div class="col-md-4"></div>
            </div>
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



