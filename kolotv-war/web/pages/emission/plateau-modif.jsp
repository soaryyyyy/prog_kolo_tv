<%--
    Document   : participantemission-saisie.jsp
    Author     : Toky20
--%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="emission.ParticipantEmission"%>
<%@page import="affichage.PageInsert"%>
<%@page import="user.UserEJB"%>
<%@page import="bean.TypeObjet"%>
<%@page import="affichage.Liste"%>
<%@ page import="emission.Plateau" %>
<%@ page import="affichage.PageUpdate" %>

<%
    try {
        String autreparsley = "data-parsley-range='[8, 40]' required";
        UserEJB u = (user.UserEJB) session.getValue("u");
        String mapping = "emission.Plateau",
                nomtable = "PLATEAU",
                apres = "emission/plateau-fiche.jsp",
                titre = "Modification de plateau";

        Plateau t = new Plateau();
        t.setNomTable("PLATEAU");
        PageUpdate pu = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
        String lien = (String) session.getValue("lien");
        pu.setLien(lien);

        pu.setTitre(titre);
        pu.getFormu().getChamp("id").setVisible(false);
        pu.getFormu().getChamp("idReservation").setVisible(false);
        pu.getFormu().getChamp("etat").setVisible(false);
        pu.getFormu().getChamp("idClient").setLibelle("Client");
        pu.getFormu().getChamp("idClient").setPageAppelComplete("client.Client","id","Client");
        pu.getFormu().getChamp("idClient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
        pu.getFormu().getChamp("idEmission").setLibelle("Emission");
        pu.getFormu().getChamp("idEmission").setPageAppelComplete("emission.EmissionLib", "id","EMISSION_LIB","tarifplateau","montant");
        pu.getFormu().getChamp("daty").setLibelle("Date");
        pu.getFormu().getChamp("heure").setPageAppelComplete("emission.EmissionDetails","heureDebut","EmissionDetails");

        String ac_affiche_val = "null";
        String ac_valeur_val = "heureDebut";
        String ac_colFiltre_val = "null";
        String ac_nomTable_val = "EmissionDetails";
        String ac_classe_val = "emission.EmissionDetails";
        String ac_useMotcle_val = "true";
        String ac_champRetour_val = "";
        String dependentFieldsToMap_str_val = "";

        String onChangeParam = "dynamicAutocompleteDependantForChampSimple(\"idEmission\", " +
                "\"IDMERE\", " +
                "\"LIKE\", " +
                "\"heure\", " +
                "\"" + ac_affiche_val + "\", " +
                "\"" + ac_valeur_val + "\", " +
                "\"" + ac_colFiltre_val + "\", " +
                "\"" + ac_nomTable_val + "\", " +
                "\"" + ac_classe_val + "\", " +
                "\"" + ac_useMotcle_val + "\", " +
                "\"" + ac_champRetour_val + "\", " +
                "\"" + dependentFieldsToMap_str_val + "\"," + // Last parameter
                "\"" + "\"" + // Last parameter
                ")";

        pu.getFormu().getChamp("idEmission").setAutre("onChange='"+onChangeParam+"'");


        pu.preparerDataFormu();
        String id=pu.getBase().getTuppleID();
        pu.preparerDataFormu();

%>

<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href=<%= lien + "?but=emission/plateau-fiche.jsp&id="+id%> <i class="fa fa-arrow-circle-left"></i></a><%=pu.getTitre()%></h1>
                    </div>
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%=request.getParameter("id")%>" method="post">
                        <%= pu.getFormu().getHtmlInsert() %>
                        <div class="row">
                            <div class="col-md-11">
                                <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                            </div><br><br>
                        </div>
                        <input name="acte" type="hidden" value="update">
                        <input name="bute" type="hidden" value="<%=apres%>">
                        <input name="classe" type="hidden" value="<%=mapping%>">
                        <input name="rajoutLien" type="hidden" value="id-<%=request.getParameter("id")%>">
                        <input name="nomtable" type="hidden" value="<%=nomtable%>">
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>


<% } catch (Exception e) {
    e.printStackTrace(); %>
<script language="JavaScript"> alert('<%=e.getMessage()%>'); history.back();</script>
<% } %>
