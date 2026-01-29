<%--
    Document   : apresMultiple
    Created on : Oct 19, 2018, 2:55:36 PM
    Author     : Jerry
--%>
<%@page import="constante.ConstanteEtat"%>
<%@ page import="user.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="bean.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Date" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>
<%@ page import="vente.Carton" %>
<%@ page import="reservation.Reservation" %>
<%@ page import="reservation.ReservationDetails" %>
<%@ page import="reservation.ReservationDetailsGroupe" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="duree.DureeMaxSpot" %>
<%@ page import="plage.Plage" %>
<%@ page import="utils.ConstanteKolo" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<%!
    UserEJB u = null;
    String acte = null;
    String lien = null;
    String bute;
    String nomtable = null;
    String typeBoutton;
    String ben;
    String[] tId;
%>
<%
    try {
        ben = request.getParameter("nomtable");
        nomtable = request.getParameter("nomtable");
        typeBoutton = request.getParameter("type");
        lien = (String) session.getValue("lien");
        u = (UserEJB) session.getAttribute("u");
        acte = request.getParameter("acte");
        bute = request.getParameter("bute");
        Object temp = null;
        String[] rajoutLien = null;
        String classe = request.getParameter("classe");
        ClassMAPTable t = null;
        String tempRajout = request.getParameter("rajoutLien");
        String val = "";
        String id = request.getParameter("id");
        tId = request.getParameterValues("ids");

        String nombreLigneS = request.getParameter("nombreLigne");
        int nombreLigne = Utilitaire.stringToInt(nombreLigneS);

        String idmere = request.getParameter("idmere");
        String classefille = request.getParameter("classefille");
        ClassMAPTable mere = null;
        ClassMAPTable fille = null;
        String colonneMere = request.getParameter("colonneMere");
        String nombreDeLigne = request.getParameter("nombreLigne");
        int nbLine = Utilitaire.stringToInt(nombreDeLigne);


        String rajoutLie = "";
        if (tempRajout != null && tempRajout.compareToIgnoreCase("") != 0) {
            rajoutLien = utilitaire.Utilitaire.split(tempRajout, "-");
        }
        if (bute == null || bute.compareToIgnoreCase("") == 0) {
            bute = "pub/Pub.jsp";
        }

        if (classe == null || classe.compareToIgnoreCase("") == 0) {
            classe = "pub.Montant";
        }

        if (typeBoutton == null || typeBoutton.compareToIgnoreCase("") == 0) {
            typeBoutton = "3"; //par defaut modifier
        }

        int type = Utilitaire.stringToInt(typeBoutton);
        if (acte != null && acte.compareToIgnoreCase("diffuser") == 0) {

            Reservation reservation = new Reservation();
            reservation.setId(request.getParameter("id"));
            reservation.diffuser(String.valueOf(u.getUser().getRefuser()),null);
            %>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("diffuserFille") == 0) {
        ReservationDetails reservationDetails = new ReservationDetails();
        reservationDetails.setId(request.getParameter("id"));
        reservationDetails = (ReservationDetails) CGenUtil.rechercher(reservationDetails,null,null,null,"")[0];
        reservationDetails.diffuser(String.valueOf(u.getUser().getRefuser()),null);
        id = request.getParameter("id");
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("saisieReservationGroupe") == 0) {
    mere = (Reservation) (Class.forName(classe).newInstance());
    fille = (ReservationDetailsGroupe) (Class.forName(classefille).newInstance());
    PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
    Reservation cmere = (Reservation) p.getObjectAvecValeur();
    ReservationDetailsGroupe [] cfille = (ReservationDetailsGroupe[]) p.getObjectFilleAvecValeur();
    List<ReservationDetails> listeFille = new ArrayList<>();
    for (int i = 0; i < cfille.length; i++) {
        cfille[i].setOrdre(i+1);
        ReservationDetails [] rsdt = cfille[i].genererReservationDetails();
        listeFille.addAll(Arrays.asList(rsdt));
    }
    ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, listeFille.toArray(new ReservationDetails[]{}));
    temp = (Object) o;
    if (temp != null) {
        val = temp.toString();
        idmere = o.getTuppleID();
    }
    idmere=cmere.getId();
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("modifReservationGroupe") == 0) {
    mere = (Reservation) (Class.forName(classe).newInstance());
    fille = (ReservationDetailsGroupe) (Class.forName(classefille).newInstance());
    PageInsertMultiple p = new PageInsertMultiple(mere, fille, request, nbLine, tId);
    Reservation cmere = (Reservation) p.getObjectAvecValeur();
    cmere.setId(request.getParameter("idResa"));
    ReservationDetailsGroupe [] cfille = (ReservationDetailsGroupe[]) p.getObjectFilleAvecValeur();
    int lastOrder = Integer.parseInt(request.getParameter("lastOrder"));
    cmere.updateResaV2(String.valueOf(u.getUser().getRefuser()),cfille,lastOrder,null);
    idmere=cmere.getId();
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("dupliquerReservation") == 0) {
    Reservation r = new Reservation();
    r.setId(request.getParameter("idReservation"));
    Reservation cmere = r.dupliquer(request.getParameter("date"),request.getParameter("idSupport"),null);
    System.out.println("Reservation mere apres duplication : "+cmere.getFille().length);
    idmere = r.getId();
//    if (cmere.getFille().length>0){
        ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, cmere.getFille());
        temp = (Object) o;
        if (temp != null) {
            val = temp.toString();
            idmere = o.getTuppleID();
        }
        idmere=cmere.getId();
//    }

%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("dupliquerDureeMaxSpot") == 0) {
    DureeMaxSpot dms = new DureeMaxSpot();
    dms.setId(id);
    dms = (DureeMaxSpot) CGenUtil.rechercher(dms,null,null,null,"")[0];
    String[] lsJours = request.getParameterValues("jours");
    String support = request.getParameter("support");
    dms.dupliquer(String.valueOf(u.getUser().getRefuser()), support,lsJours);
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("dupliquerPlage") == 0) {
    Plage p = new Plage();
    p.setId(id);
    p = (Plage) CGenUtil.rechercher(p,null,null,null,"")[0];
    String[] lsJours = request.getParameterValues("jours");
    String support = request.getParameter("support");
    p.dupliquer(String.valueOf(u.getUser().getRefuser()), support,lsJours);
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("reporterReservation") == 0) {
    String[] ids = request.getParameterValues("ids");
    String date = request.getParameter("date");
    String heure = request.getParameter("heure");

    ReservationDetails.reporter(String.valueOf(u.getUser().getRefuser()),date,heure,ids);
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%} %>


<% if (acte != null && acte.compareToIgnoreCase("diffuserMultiple") == 0) {
    String [] ids = request.getParameterValues("id");
    ReservationDetails.diffuserMultiple(String.valueOf(u.getUser().getRefuser()),ids);
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("insertReservationMultiple") == 0) {
    Reservation cmere = new ReservationDetailsGroupe().genererReservationApresSaisieMultiple(request);
    ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, cmere.getFille());
    temp = (Object) o;
    if (temp != null) {
        val = temp.toString();
        idmere = o.getTuppleID();
    }
    idmere=cmere.getId();
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("insertReservationMultipleForEmission") == 0) {
    Reservation cmere = new ReservationDetailsGroupe().genererReservationApresSaisieMultiplePourEmission(request,null);
    ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, cmere.getFille());
    temp = (Object) o;
    if (temp != null) {
        val = temp.toString();
        idmere = o.getTuppleID();
    }
    idmere=cmere.getId();
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("insertReservationMultipleAmeliorer") == 0) {
    Reservation cmere = new ReservationDetailsGroupe().genererReservationApresSaisieMultipleAmeliorer(request);
    ClassMAPTable o = (ClassMAPTable) u.createObjectMultiple(cmere, colonneMere, cmere.getFille());
    temp = (Object) o;
    if (temp != null) {
        val = temp.toString();
        idmere = o.getTuppleID();
    }
    idmere=cmere.getId();
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("modifReservation") == 0) {
    Reservation cmere = new ReservationDetailsGroupe().genererReservationApresModif(request,null);
    cmere.updateResa(String.valueOf(u.getUser().getRefuser()),request.getParameter("dtDebut"),request.getParameter("dtFin"),null);
    idmere=cmere.getId();
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=idmere%>");</script>
<%} %>

<% if (acte != null && acte.compareToIgnoreCase("suspendre") == 0) {
    Reservation reservation = new Reservation();
    reservation.setId(request.getParameter("id"));
    reservation = (Reservation) CGenUtil.rechercher(reservation,null,null,null,"")[0];
    reservation.changeEtat(ConstanteKolo.etatSuspendu,String.valueOf(u.getUser().getRefuser()),null);
    id = request.getParameter("id");
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%} %>
<% if (acte != null && acte.compareToIgnoreCase("relancer") == 0) {
    Reservation reservation = new Reservation();
    reservation.setId(request.getParameter("id"));
    reservation = (Reservation) CGenUtil.rechercher(reservation,null,null,null,"")[0];
    reservation.changeEtat(utilitaire.ConstanteEtat.getEtatValider(),String.valueOf(u.getUser().getRefuser()),null);
    id = request.getParameter("id");
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%} %>
<% if (acte != null && acte.compareToIgnoreCase("suspendreFille") == 0) {
    ReservationDetails reservationDetails = new ReservationDetails();
    reservationDetails.setId(request.getParameter("id"));
    reservationDetails = (ReservationDetails) CGenUtil.rechercher(reservationDetails,null,null,null,"")[0];
    reservationDetails.changeEtat(ConstanteKolo.etatSuspendu,String.valueOf(u.getUser().getRefuser()),null);
    id = request.getParameter("id");
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%} %>
<% if (acte != null && acte.compareToIgnoreCase("relancerFille") == 0) {
    ReservationDetails reservationDetails = new ReservationDetails();
    reservationDetails.setId(request.getParameter("id"));
    reservationDetails = (ReservationDetails) CGenUtil.rechercher(reservationDetails,null,null,null,"")[0];
    reservationDetails.changeEtat(utilitaire.ConstanteEtat.getEtatValider(),String.valueOf(u.getUser().getRefuser()),null);
    id = request.getParameter("id");
%>
<script language="JavaScript"> document.location.replace("<%=lien%>?but=<%=bute%>&id=<%=id%>");</script>
<%} %>

<%

} catch (Exception ex) {
    ex.printStackTrace();
%>
<script type="text/javascript">alert("<%=ex.getMessage()%>"); history.back();</script>
<%
        return;
    }%>
</html>



