<%--
  Created by IntelliJ IDEA.
  User: Toky20
  Date: 04/06/2025
--%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="reservation.ReservationDetailsAvecDiffusion" %>
<%@ page import="utilisateurstation.UtilisateurStation" %>
<%@ page import="affichage.Champ" %>
<%@ page import="affichage.Liste" %>

<% try{
    ReservationDetailsAvecDiffusion bc = new ReservationDetailsAvecDiffusion();
    bc.setNomTable("reservationsansdiffusion");
    String listeCrt[] = {"id", "idmere","daty","libelleproduit", "idSupportLib"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id", "idmere","daty","libelleproduit", "idSupportLib","remarque"};
    String libEnteteAffiche[] = {"ID", "ID Mere","Date","Services M&eacute;dia", "Support","Remarque"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste des R&eacute;servations sans diffusion");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("reservation/reporter-reservation.jsp");
    String[] colSomme = {};

    pr.getFormu().getChamp("daty1").setLibelle("Date de R&eacute;servation Min");
//    pr.getFormu().getChamp("daty1").setDefaut(UtilisateurStation.getDateDebutSemaine());
    pr.getFormu().getChamp("daty2").setLibelle("Date de R&eacute;servation Max");
    pr.getFormu().getChamp("daty2").setDefaut(UtilisateurStation.getDateFinSemaine());

    pr.getFormu().getChamp("id").setLibelle("ID");
    pr.getFormu().getChamp("idmere").setLibelle("ID Mere");
    pr.getFormu().getChamp("idmere").setLien("?but=reservation/reservation-fiche.jsp", "id=");
    pr.getFormu().getChamp("libelleproduit").setLibelle("Services M&eacute;dia");
    pr.getFormu().getChamp("idSupportLib").setLibelle("Support");
    pr.creerObjetPage(libEntete, colSomme);

    //Definition des lienTableau et des colonnes de lien
    String lienTableau[] = {pr.getLien() + "?but=reservation/reservation-details-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    //pr.getTableau().setLienFille("reservation/inc/reservation-details.jsp&id=");
//    pr.getTableau().setModalOnClick(true);
%>
<script>
    function changerDesignation() {
        document.vente.submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post" name="reservation" id="reservation">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <%
            out.println(pr.getTableauRecap().getHtml());%>
        <br>
        <form>
            <%
                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
        </form>
        <%
            out.println(pr.getBasPage());
        %>
    </section>
</div>
<%=pr.getModalHtml("modalContent")%>

<script>
document.addEventListener("DOMContentLoaded", function() {
    let checkboxes = document.querySelectorAll('input[type="checkbox"][name="id"]');

    const bouton = document.querySelector('button[name="Submit2"]');

    if (bouton) {
        // Supprimer l'attribut onclick
        bouton.removeAttribute('onclick');
        // Supprimer l'attribut type
        bouton.removeAttribute('type');
        bouton.setAttribute('type', 'button');

        // Changer le texte du bouton
        bouton.textContent = "Reporter la diffusion";
    }

    function updateOnclickFromCheckboxes() {
        let selectedValues = [];

        checkboxes.forEach(function(checkbox) {
            if (checkbox.checked) {
                console.log("Valeur cochée :", checkbox.value);
                selectedValues.push(encodeURIComponent(checkbox.value));
            }
        });

        console.log("Valeurs sélectionnées :", selectedValues);

        if (selectedValues.length > 0) {
            const queryString = selectedValues.map(v => 'ids='+v).join('&');
            const url = 'moduleLeger.jsp?but=reservation/inc/reservation-report.jsp&'+queryString;
            console.log("Query string :", queryString);
            console.log("URL finale :", url);
            bouton.setAttribute('onclick', "ouvrirModal(event, '"+url+"', 'modalContent')");
        } else {
            bouton.removeAttribute('onclick');
        }
    }

    checkboxes.forEach(function(checkbox) {
        checkbox.addEventListener('change', updateOnclickFromCheckboxes);
    });

    // Appel initial pour gérer le cas où des cases sont pré-cochées
    updateOnclickFromCheckboxes();
});
</script>

<%
    }catch(Exception e){

        e.printStackTrace();
    }
%>
