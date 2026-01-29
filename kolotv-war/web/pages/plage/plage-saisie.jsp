<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@ page import="plage.Plage" %>
<%@ page import="affichage.Liste" %>
<%@ page import="categorieheure.CategorieHeure" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="support.Support" %>
<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String  mapping = "plage.Plage",
                nomtable = "PLAGE",
                apres = "plage/plage-fiche.jsp",
                titre = "Insertion de plage";

        Plage client = new Plage();
        PageInsert pi = new PageInsert(client, request, u);
        pi.setLien((String) session.getValue("lien"));

        pi.getFormu().getChamp("heureDebut").setLibelle("Heure de d&eacute;but");
        pi.getFormu().getChamp("heureDebut").setType("time");
        pi.getFormu().getChamp("heureFin").setLibelle("Heure de fin");
        pi.getFormu().getChamp("heureFin").setType("time");
        pi.getFormu().getChamp("daty").setLibelle("Date");
        pi.getFormu().getChamp("daty").setVisible(false);
        pi.getFormu().getChamp("daty").setDefaut(Utilitaire.dateDuJour());
        pi.getFormu().getChamp("idSupport").setLibelle("Support");
        pi.getFormu().getChamp("idCategorieHeure").setLibelle("Cat&eacute;gorie de l'heure");

        pi.getFormu().getChamp("heureDebut").setDefaut(Utilitaire.heureCouranteHM());
        pi.getFormu().getChamp("heureFin").setDefaut(Utilitaire.heureCouranteHM());

        Liste[] liste = new Liste[3];
        CategorieHeure mp = new CategorieHeure();
        liste[0] = new Liste("idCategorieHeure", mp,"desce","id");
        liste[0].setLibelle("Cat&eacute;gorie de l'heure");
        liste[1]=new Liste("jour");
        String[] joursString = new String[] {"Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi","Dimanche"};
        liste[1].makeListeString( joursString,  joursString);
        Support suppLs = new Support();
        liste[2] = new Liste("idSupport", suppLs,"val","id");
        liste[2].setLibelle("Support");
        pi.getFormu().changerEnChamp(liste);

        if (request.getParameter("idSupport")!=null){
            pi.getFormu().getChamp("idSupport").setDefaut(request.getParameter("idSupport"));
        }

        String[] ordre = {"daty"};
        pi.getFormu().setOrdre(ordre);
        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>

<%
} catch (Exception e) {
    e.printStackTrace();

    }%>
