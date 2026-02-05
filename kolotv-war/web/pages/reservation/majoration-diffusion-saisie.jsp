<%@page import="affichage.PageInsert"%>
<%@page import="affichage.Liste"%>
<%@page import="reservation.MajorationDiffusion"%>
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.Utilitaire"%>

<%
    try{
        UserEJB u = (user.UserEJB) session.getValue("u");
        String mapping = "reservation.MajorationDiffusion",
                nomtable = "MAJORATION_DIFFUSION",
                apres = "reservation/majoration-diffusion-fiche.jsp",
                titre = "Insertion de majoration de diffusion";

        MajorationDiffusion objet = new MajorationDiffusion();
        PageInsert pi = new PageInsert(objet, request, u);
        pi.setLien((String) session.getValue("lien"));

        affichage.Champ[] liste = new affichage.Champ[1];
        Liste jours = new Liste("jour");
        jours.makeListeString(MajorationDiffusion.JOURS_SEMAINE, MajorationDiffusion.JOURS_SEMAINE);
        liste[0] = jours;
        pi.getFormu().changerEnChamp(liste);

        pi.getFormu().getChamp("jour").setLibelle("Jour");
        pi.getFormu().getChamp("heureDebut").setLibelle("Heure d&eacute;but");
        pi.getFormu().getChamp("heureDebut").setType("time");
        pi.getFormu().getChamp("heureDebut").setAutre("step=\"1\"");
        pi.getFormu().getChamp("heureDebut").setDefaut(Utilitaire.heureCouranteHM());

        pi.getFormu().getChamp("heureFin").setLibelle("Heure fin");
        pi.getFormu().getChamp("heureFin").setType("time");
        pi.getFormu().getChamp("heureFin").setAutre("step=\"1\"");
        pi.getFormu().getChamp("heureFin").setDefaut(Utilitaire.heureCouranteHM());

        pi.getFormu().getChamp("tauxMajoration").setLibelle("Taux de majoration (%)");
        pi.getFormu().getChamp("tauxMajoration").setType("number");
        pi.getFormu().getChamp("tauxMajoration").setAutre("step=\"0.01\" min=\"0\"");
        pi.getFormu().getChamp("tauxMajoration").setDefaut("0");

        pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>

    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" value="insert">
        <input name="bute" type="hidden" value="<%=apres%>">
        <input name="classe" type="hidden" value="<%=mapping%>">
        <input name="nomtable" type="hidden" value="<%=nomtable%>">
    </form>
</div>

<%
    } catch (Exception e) {
        e.printStackTrace();
%>
<script language="JavaScript">
    alert('<%=e.getMessage()%>');
    history.back();
</script>
<%
    }
%>
