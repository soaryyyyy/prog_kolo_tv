<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@page import="affichage.PageRecherche"%>
<%@ page import="affichage.Graphe" %>
<%@ page import="bean.AdminGen" %>
<%@ page import="java.util.Map" %>
<%@ page import="utilitaire.Utilitaire" %>
<%@ page import="reservation.StatHoraireReservation" %>
<%@ page import="affichage.Liste" %>
<%@ page import="support.Support" %>
<%@ page import="produits.CategorieIngredient" %>
<%@ page import="java.time.LocalTime" %>

<% try{
    StatHoraireReservation bdc = new StatHoraireReservation();
    String listeCrt[] = {"idSupport","idTypeService","heure","daty"};
    String listeInt[] = {"daty","heure"};
    String libEntete[] = {};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("reservation/stat-plage-horaire.jsp");

    Liste [] listes = new Liste[2];
    Support support = new Support();
    listes[0] = new Liste("idSupport",support,"val","id");
    CategorieIngredient cat = new CategorieIngredient();
    listes[1] = new Liste("idTypeService",cat,"val","id");
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("idSupport").setLibelle("Support");
    pr.getFormu().getChamp("idTypeService").setLibelle("Type de service");
    pr.getFormu().getChamp("daty1").setLibelle("Date debut");
    pr.getFormu().getChamp("daty2").setLibelle("Date fin");
    pr.getFormu().getChamp("heure1").setLibelle("Heure debut");
    pr.getFormu().getChamp("heure2").setLibelle("Heure fin");
    pr.getFormu().getChamp("heure1").setType("time");
    pr.getFormu().getChamp("heure2").setType("time");
    String heureDebut=Utilitaire.heureCouranteHM();
    String heureFin= LocalTime.parse(heureDebut).plusHours(4).toString();
    if (request.getParameter("heure1")!=null && request.getParameter("heure1").isEmpty()==false){
        heureDebut = request.getParameter("heure1");
    }
    if (request.getParameter("heure2")!=null && request.getParameter("heure2").isEmpty()==false){
        heureFin = request.getParameter("heure2");
    }
    pr.getFormu().getChamp("heure1").setDefaut(heureDebut);
    pr.getFormu().getChamp("heure2").setDefaut(heureFin);
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    String titreGraph = "Statistique des plages horaires";

    bdc.setIdSupport(request.getParameter("idSupport"));
    bdc.setIdTypeService(request.getParameter("idTypeService"));
    StatHoraireReservation [] statHoraireReservations = bdc.getSatistiquePlageHoraire(heureDebut,heureFin,request.getParameter("daty1"),request.getParameter("daty1"),null);
    pr.getTableau().setData(statHoraireReservations);
%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1><%= titreGraph %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <div class="row mt-4" style="margin-top: 20px;width: 100%;display: flex;justify-content: center">
            <div class="col-md-4 mb-4" style="width: 80%">
                <div class="card h-100" style="
                        border-radius: 10px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        border: 1px solid #e0e0e0;
                        background-color: white;
                        padding: 1em">
                    <div class="card-body">
                        <h5 class="card-title text-center"><%= titreGraph %></h5>
                        <canvas id="graph_cheese"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </section>

</div>
<%
        String colAbs1 = "heure";
        String[] colOrd1 = {"heure"};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{StatHoraireReservation.getDataChart(AdminGen.getDataChart(pr.getTableau().getData(), "heure", "nbResa"))};
        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese", "");
        g1.setTypeGraphe("bar");
        out.println(g1.getHtml("ctx1"));
    }catch(Exception e){

        e.printStackTrace();
    }
%>
