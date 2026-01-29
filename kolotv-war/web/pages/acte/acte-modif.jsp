<%@page import="produits.Acte"%>
<%@ page import="user.*"%>
<%@ page import="bean.*"%>
<%@ page import="utilitaire.*"%>
<%@ page import="affichage.*"%>
<%@ page import="support.Support" %>

<%
    String autreparsley = "data-parsley-range='[8, 40]' required";
    Acte t =new Acte();
    PageUpdate pi = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().getChamp("idproduit").setPageAppelComplete("annexe.ProduitLib","id","PRODUIT_VENTE_LIB");
    pi.getFormu().getChamp("idproduit").setLibelle("Services M&eacute;dia");
    pi.getFormu().getChamp("idclient").setLibelle("Client");
    pi.getFormu().getChamp("idclient").setPageAppelComplete("client.Client","id","Client");
    pi.getFormu().getChamp("idclient").setPageAppelInsert("client/client-saisie.jsp","idClient;idClientlibelle","id;nom");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("libelle").setLibelle("Libell&eacute;");
    pi.getFormu().getChamp("libelle").setDefaut("Location");
    pi.getFormu().getChamp("idMedia").setLibelle("M&eacute;dia");
    pi.getFormu().getChamp("idMedia").setPageAppelComplete("media.MediaCpl", "id", "MEDIA_CPL", "","");
    pi.getFormu().getChamp("idSupport").setLibelle("Support");
//    pi.getFormu().getChamp("idSupport").setPageAppelComplete("support.Support", "id", "Support", "","");
    pi.getFormu().getChamp("idReservationFille").setLibelle("Reservation");
    pi.getFormu().getChamp("idReservationFille").setPageAppelComplete("reservation.ReservationDetails", "id", "reservationdetails", "","");
    pi.getFormu().getChamp("duree").setDefaut("00:00:00");
    pi.getFormu().getChamp("duree").setType("time");
    pi.getFormu().getChamp("heure").setDefaut(Utilitaire.heureCouranteHMS());
    pi.getFormu().getChamp("heure").setType("time");
    pi.getFormu().getChamp("duree").setAutre("step=\"1\"");
    pi.getFormu().getChamp("heure").setAutre("step=\"1\"");
    pi.getFormu().getChamp("idemission").setLibelle("ID &eacute;mission");
    pi.getFormu().getChamp("idemission").setPageAppelComplete("emission.Emission", "id","Emission");

    affichage.Champ[] liste = new affichage.Champ[1];
    Support typeMed= new Support();
    liste[0] = new Liste("idSupport", typeMed, "val", "id");
    liste[0].setLibelle("Support");
    pi.getFormu().changerEnChamp(liste);


    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("id").setVisible(false);
    pi.getFormu().getChamp("pu").setAutre("readonly");
    pi.setLien((String) session.getValue("lien"));
    pi.getFormu().setNbColonne(2);
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
       <div class="row">
              <div class="col-md-3"></div>
              <div class="col-md-6">
                     <div class="box-fiche">
                            <div class="box">
                                   <div class="box-title with-border">
                                        <h1>Modification de Diffusion</h1>
                                   </div>
                                   <div class="box-body">
                                        <form action="<%=(String) session.getValue("lien")%>?but=apresTarif.jsp&id=<%out.print(request.getParameter("id"));%>" method="post">
                                            <%
                                                out.println(pi.getFormu().getHtmlInsert());
                                            %>
                                            <div class="row">
                                                <div class="col-md-11">
                                                    <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                                                </div>
                                                <br><br>
                                            </div>
                                            <input name="bute" type="hidden" id="bute" value="acte/acte-fiche.jsp"/>
                                            <input name="acte" type="hidden" id="acte" value="update">
                                            <input name="classe" type="hidden" id="classe" value="produits.Acte">
                                            <input name="nomtable" type="hidden" id="nomtable" value="ACTE">
                                        </form>
                                   </div>
                            </div>
                     </div>
              </div>
       </div>
</div>
