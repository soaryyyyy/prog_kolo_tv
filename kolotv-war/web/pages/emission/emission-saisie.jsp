<%--
    Document   : emission-saisie.jsp
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="emission.Emission"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="support.Support" %>
<%@ page import="affichage.PageInsertMultiple" %>
<%@ page import="emission.EmissionDetails" %>
<%@ page import="emission.TypeEmission" %>
<%@ page import="annexe.Categorie" %>

<%
try {
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "emission.Emission",
           nomtable = "EMISSION",
           apres = "emission/emission-fiche.jsp",
           titre = "";

    String acte = request.getParameter("acte");
    if(acte != null && !acte.isEmpty()){
        titre = "Modification d'&eacute;mission";
    } else{
        titre = "Insertion d'&eacute;mission";
    }

    Emission mere = new Emission();
    EmissionDetails fille = new EmissionDetails();
    int nombreLigne = 10;
    PageInsertMultiple pi = new PageInsertMultiple(mere, fille, request,nombreLigne , u);
    pi.setLien((String) session.getValue("lien"));

    affichage.Champ[] liste = new affichage.Champ[2];
    Support typeMed= new Support();
    liste[0] = new Liste("idSupport", typeMed, "val", "id");
    TypeEmission typeEmission= new TypeEmission();
    liste[1] = new Liste("idGenre", typeEmission, "val", "id");

    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("nom").setLibelle("Nom");
    pi.getFormu().getChamp("idSupport").setLibelle("Support");
    pi.getFormu().getChamp("idGenre").setLibelle("Genre");
    pi.getFormu().getChamp("tarifplateau").setLibelle("Tarif plateau");
    pi.getFormu().getChamp("tarifparainage").setLibelle("Tarif parrainage");
    pi.getFormu().getChamp("secondeparainage").setLibelle("Nombre de spot");
    pi.getFormu().getChamp("secondeparainage").setVisible(false);
    pi.getFormu().getChamp("duree").setLibelle("Dur&eacute;e");
    pi.getFormu().getChamp("duree").setType("time");
    pi.getFormu().getChamp("duree").setAutre("step=\"1\"");

    affichage.Champ[] liste2 = new affichage.Champ[1];
        TypeObjet to = new TypeObjet();
        to.setNomTable("JOUR");
        liste2[0] = new Liste("jour", to, "val", "val");
        pi.getFormufle().changerEnChamp(liste2);

    for (int i = 0; i < nombreLigne; i++) {
        pi.getFormufle().getChamp("heureDebut_"+i).setType("time");
        pi.getFormufle().getChamp("heureFin_"+i).setType("time");
        pi.getFormufle().getChamp("heureDebutCoupure_"+i).setType("time");
        pi.getFormufle().getChamp("heureFinCoupure_"+i).setType("time");
    }

    pi.getFormufle().getChamp("jour_0").setLibelle("Jour");
    pi.getFormufle().getChamp("heureDebut_0").setLibelle("Heure d&eacute;but");
    pi.getFormufle().getChamp("heureFin_0").setLibelle("Heure de fin");
    pi.getFormufle().getChamp("heureDebutCoupure_0").setLibelle("D&eacute;but coupure");
    pi.getFormufle().getChamp("heureFinCoupure_0").setLibelle("Fin Coupure");
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("id"),false);
    affichage.Champ.setVisible(pi.getFormufle().getChampFille("idMere"),false);


    pi.preparerDataFormu();
    //Variables de navigation
    String classeMere = "emission.Emission";
    String classeFille = "emission.EmissionDetails";
    String butApresPost = "emission/emission-fiche.jsp";
    String colonneMere = "idMere";
    //Preparer les affichages
    pi.getFormu().makeHtmlInsertTabIndex();
    pi.getFormufle().makeHtmlInsertTableauIndex();
%>
<div class="content-wrapper">
    <h1><%=titre%></h1>
    <div class="box-body">
        <form class='container' action="<%=pi.getLien()%>?but=apresMultiple.jsp" method="post" >
            <%

                out.println(pi.getFormu().getHtmlInsert());
                out.println(pi.getFormufle().getHtmlTableauInsert());
            %>
            <input name="acte" type="hidden" id="nature" value="insert">
            <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
            <input name="classe" type="hidden" id="classe" value="<%= classeMere %>">
            <input name="classefille" type="hidden" id="classefille" value="<%= classeFille %>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%= nombreLigne %>">
            <input name="colonneMere" type="hidden" id="colonneMere" value="<%= colonneMere %>">
            <input name="nomtable" type="hidden" id="nomtable" value="EMISSIONDETAILS">
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const coupureInput = document.getElementById('coupure');

        coupureInput.addEventListener('input', function() {
            const valeurCoupure = this.value;
            var listChamp = document.querySelectorAll('input[id^="jour_"]');
            for (let i = 0; i <=listChamp.length ; i++) {
                const champTva = document.getElementById('coupure_' + i);
                    champTva.value = valeurCoupure;
            }
        });
    });
</script>
<% } catch (Exception e) {
    e.printStackTrace(); %>
<script language="JavaScript"> alert('<%=e.getMessage()%>'); history.back();</script>
<% } %>
