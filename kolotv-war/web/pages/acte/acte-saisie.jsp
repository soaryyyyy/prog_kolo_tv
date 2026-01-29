
<%@page import="produits.Acte"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="reservation.Check" %>
<%@ page import="bean.CGenUtil" %>
<%@ page import="affichage.Champ" %>
<%@ page import="reservation.CheckInSansCheckOutCPL" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="support.Support" %>

<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "produits.Acte",
            nomtable = "ACTE",
            apres = "acte/acte-fiche.jsp",
            titre = "Saisie de la Diffusion";

    Acte unite = new Acte();
    unite.setNomTable("Acte");
    PageInsert pi = new PageInsert(unite, request, u);
    pi.setLien((String) session.getValue("lien"));
    String idresa =request.getParameter("idresa");
    String idclient =request.getParameter("idclient");

    String duree = "00:00:00";
    String heure = Utilitaire.heureCouranteHMS();
    if (request.getParameter("duree")!=null && !request.getParameter("duree").isEmpty()){
        duree = request.getParameter("duree");
    }
    if (request.getParameter("heure")!=null && !request.getParameter("heure").isEmpty()){
        heure = request.getParameter("heure");
    }

    pi.getFormu().getChamp("idproduit").setPageAppelComplete("annexe.ProduitLib","id","PRODUIT_VENTE_LIB");
    pi.getFormu().getChamp("idproduit").setLibelle("Services M&eacute;dia");

    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idclient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        pi.getFormu().getChamp("pu").setLibelle("Prix unitaire");
        pi.getFormu().getChamp("pu").setVisible(false);
        pi.getFormu().getChamp("pu").setDefaut("1");
//    pi.getFormu().getChamp("pu").setAutre("onChange='calculerMontant()'");
    pi.getFormu().getChamp("qte").setLibelle("Quantit&eacute;");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("libelle").setDefaut("Location");
    pi.getFormu().getChamp("idMedia").setLibelle("M&eacute;dia");
    pi.getFormu().getChamp("idMedia").setPageAppelComplete("media.MediaCpl", "id", "MEDIA_CPL", "","");
    pi.getFormu().getChamp("idSupport").setLibelle("Support");
//    pi.getFormu().getChamp("idSupport").setPageAppelComplete("support.Support", "id", "Support", "","");
    pi.getFormu().getChamp("idReservationFille").setLibelle("R&eacute;servation");
    pi.getFormu().getChamp("idReservationFille").setPageAppelComplete("reservation.ReservationDetails", "id", "reservationdetails", "","");
    pi.getFormu().getChamp("duree").setDefaut(duree);
        pi.getFormu().getChamp("duree").setType("time");
        pi.getFormu().getChamp("heure").setType("time");
    pi.getFormu().getChamp("heure").setDefaut(heure);
        pi.getFormu().getChamp("duree").setAutre("step=\"1\"");
        pi.getFormu().getChamp("heure").setAutre("step=\"1\"");
    pi.getFormu().getChamp("idreservation").setVisible(false);
    String apresWh="";
    if(idresa!=null&&idresa.compareToIgnoreCase("")!=0)apresWh=" and reservation='"+idresa+"'";
    pi.getFormu().getChamp("idreservation").setLibelle("R&eacute;servation");
    pi.getFormu().getChamp("idreservation").setPageAppelCompleteAWhere("reservation.CheckInSansCheckOutCPL", "idproduit", "CHECKINSANSCHEKOUTCPL", "id", "idreservation",apresWh);
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("idemission").setLibelle("&Eacute;mission");
    pi.getFormu().getChamp("idemission").setPageAppelComplete("emission.Emission", "id","Emission");
    pi.getFormu().setNbColonne(2);
    if(idresa!=null&&idclient!=null){
        pi.getFormu().getChamp("idclient").setDefaut(idclient);
        pi.getFormu().getChamp("idclient").setAutre("readonly");
//        pi.getFormu().getChamp("idreservation").setDefaut(checkin[0].getId());
//        pi.getFormu().getChamp("idreservation").setAutre("readonly");
    }

    affichage.Champ[] liste = new affichage.Champ[1];
    Support typeMed= new Support();
    liste[0] = new Liste("idSupport", typeMed, "val", "id");
    liste[0].setLibelle("Support");
    pi.getFormu().changerEnChamp(liste);


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
    %>
    <input name="acte" type="hidden" id="nature" value="insert">
    <input name="bute" type="hidden" id="bute" value="<%=apres%>">
    <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
    <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>
<script>
    function calculerMontant() {
        var val = 0;
            $('input[id^="qte_"]').each(function() {
                var quantite =  parseFloat($("#"+$(this).attr('id').replace("qte","pu")).val());
                var montant = parseFloat($(this).val());
                if(!isNaN(quantite) && !isNaN(montant)){
                    var value =quantite * montant;
                    val += value;
                }
            });
            $("#montanttotal").html(Intl.NumberFormat('fr-FR', {
                minimumFractionDigits: 2,
                maximumFractionDigits: 2
            }).format(val));
    }
</script>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>
