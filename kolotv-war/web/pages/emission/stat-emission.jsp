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
<%@ page import="emission.StatActiviteEmission" %>
<%@ page import="affichage.PageRechercheGroupe" %>
<%@ page import="java.util.Calendar" %>

<% try{
    StatActiviteEmission bdc = new StatActiviteEmission();
    String listeCrt[] = {"idSupport","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {};
    PageRecherche pr = new PageRecherche(bdc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("emission/stat-emission.jsp");

    Liste [] listes = new Liste[1];
    Support support = new Support();
    listes[0] = new Liste("idSupport",support,"val","id");
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("idSupport").setLibelle("Support");
    pr.getFormu().getChamp("daty1").setLibelle("Date debut");
    pr.getFormu().getChamp("daty2").setLibelle("Date fin");

    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    String lienTableau[] = {};
    String colonneLien[] = {};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);

    Calendar calendar = Calendar.getInstance();
    int month = calendar.get(Calendar.MONTH) + 1; // January is 0
    int year = calendar.get(Calendar.YEAR);

    String dateDebut = String.format("01/%02d/%04d", month, year);
    String dateFin = Utilitaire.dateDuJour();

    if (request.getParameter("daty1")!=null && request.getParameter("daty1").isEmpty()==false){
        dateDebut = request.getParameter("daty1");
    }
    if (request.getParameter("daty2")!=null && request.getParameter("daty2").isEmpty()==false){
        dateFin = request.getParameter("daty2");
    }
    pr.getFormu().getChamp("daty1").setDefaut(dateDebut);
    pr.getFormu().getChamp("daty2").setDefaut(dateFin);
    bdc.setIdSupport(request.getParameter("idSupport"));
    StatActiviteEmission [] statActivitePlateauEmissions = bdc.getSatistiqueEmission(dateDebut,dateFin,1,null);
    StatActiviteEmission [] statActiviteParrainageEmissions = bdc.getSatistiqueEmission(dateDebut,dateFin,0,null);
//    pr.getTableau().setData(new StatActiviteEmission[]{});
%>
<script>
    function changerDesignation() {
        document.getElementById("bdc-liste--form").submit();
    }
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Analyse d'&eacute;mission</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" id="bdc-liste--form" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <br>
        <div class="row mt-4" style="margin-top: 20px;width: 100%;display: flex;justify-content: center;gap: 15px">
            <div class="col-md-4 mb-4" style="width: 50%">
                <div class="card h-100" style="
                        border-radius: 10px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        border: 1px solid #e0e0e0;
                        background-color: white;
                        padding: 1em">
                    <div class="card-body">
                        <h5 class="card-title text-center">Statistique de parrainage</h5>
                        <canvas id="graph_cheese1"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4" style="width: 50%">
                <div class="card h-100" style="
                        border-radius: 10px;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                        border: 1px solid #e0e0e0;
                        background-color: white;
                        padding: 1em">
                    <div class="card-body">
                        <h5 class="card-title text-center">Statistique d'intervention sur plateau</h5>
                        <canvas id="graph_cheese2"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </section>
<%
        String colAbs1 = "nom";
        String[] colOrd1 = {"nbParrainage"};
        String[] colAff1 = {""};

        Map<String, Double>[] data1 = new Map[]{StatActiviteEmission.getDataChart(AdminGen.getDataChart(statActiviteParrainageEmissions, "nom", "nbParrainage"))};

        Graphe g1 = new Graphe(data1, colAbs1, colOrd1, colAff1, "graph_cheese1", "");
        g1.setTypeGraphe("bar");
        out.println(g1.getHtml("ctx1",true));
        String colAbs2 = "nom";
        String[] colOrd2 = {"nbPlateau"};
        String[] colAff2 = {""};

        Map<String, Double>[] data2 = new Map[]{StatActiviteEmission.getDataChart(AdminGen.getDataChart(statActivitePlateauEmissions, "nom", "nbPlateau"))};
        Graphe g2 = new Graphe(data2, colAbs2, colOrd2, colAff2, "graph_cheese2", "");
        g2.setTypeGraphe("bar");
        out.println(g2.getHtml("ctx2",true)); %>

<%
        StatActiviteEmission mvt = new StatActiviteEmission();
        String nomTable = "emission_vente";
        mvt.setNomTable(nomTable);

        String listeCrt2[] = {};
        String listeInt2[] = {};
        String[] pourcentage = {};
        String[] colGr = {"nom"};
        String[] colGrCol = {"idDevise"};
        String somDefaut[] = {"montantttc","montantpaye", "montantreste"};

        PageRechercheGroupe prG = new PageRechercheGroupe(mvt, request, listeCrt2, listeInt2, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
        prG.setUtilisateur((user.UserEJB) session.getValue("u"));
        prG.setLien((String) session.getValue("lien"));
        String apreswhere = " and daty >= '"+dateDebut+"' and daty <= '"+dateFin+"'";
        if (request.getParameter("idSupport")!=null && request.getParameter("idSupport").equals("%")==false){
            apreswhere += " and idSupport='"+request.getParameter("idSupport")+"'";
        }
        prG.setAWhere(apreswhere);

        prG.setNpp(500);
        prG.setApres("emission/stat-emission.jsp");

        prG.creerObjetPageCroise(colGrCol,prG.getLien()+"?but=");
%>
<script>
    function changerDesignation() {
        document.analyse.submit();
    }
    $(document).ready(function() {
        $('.box table tr').each(function() {
            $(this).find('td:last, th:last').hide();
        });
    });
</script>
    <section class="content">
        <ul>
            <li><strong>La premi&egrave;re ligne repr&eacute;sente la somme des factures.</strong> </li>
            <li><strong>La deuxi&egrave;me ligne repre&eacute;sente la somme des montants pay&eacute;s.</strong></li>
            <li><strong>La troisi&egrave;me ligne repr&eacute;sente la somme impay&eacute;e.</strong></li>
        </ul>
        <%
            String lienTableau2[] = {};
            prG.getTableau().setLien(lienTableau2);
            prG.getTableau().setColonneLien(somDefaut);%>
        <br>
        <%
            out.println(prG.getTableau().getHtml());
            out.println(prG.getBasPage());
        %>
    </section>
</div>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>

