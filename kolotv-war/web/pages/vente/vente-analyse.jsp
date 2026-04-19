<%--
    Document   : as-commande-analyse
    Created on : 30 d�c. 2016, 04:57:15
    Author     : Joe
--%>
<%@page import="vente.VenteDetailsLib"%>
<%@page import="utilitaire.*"%>
<%@page import="affichage.*"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedHashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page import="support.Support" %>
<%@ page import="produits.CategorieIngredient" %>

<%
try{
    VenteDetailsLib mvt = new VenteDetailsLib();
    String nomTable = "VENTE_DETAILS_CPL_2_VISEE";
    mvt.setNomTable(nomTable);

    String listeCrt[] = {"idProduitLib","daty","idSupport","idCategorie"};
    String listeInt[] = {"daty"};
    String[] pourcentage = {};
    String[] colGr = {"idProduitLib"};
    String[] colGrCol = {"idDeviseLib"};
    //String somDefaut[] = {"qte", "puTotal", "puRevient"};
    String somDefaut[] = {"qte", "puTotal"};

    PageRechercheGroupe pr = new PageRechercheGroupe(mvt, request, listeCrt, listeInt, 3, colGr, somDefaut, pourcentage, colGr.length , somDefaut.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String apreswhere = "";
    String debutSem=Utilitaire.formatterDaty(Utilitaire.getDebutSemaine(Utilitaire.dateDuJourSql())) ;
    Calendar calendar = Calendar.getInstance();
    int month = calendar.get(Calendar.MONTH) + 1; // January is 0
    int year = calendar.get(Calendar.YEAR);
    String dateDebut = String.format("01/%02d/%04d", month, year);
    String dateFin = Utilitaire.dateDuJour();

    if(request.getParameter("daty1")==null&&request.getParameter("daty2")==null)
    apreswhere= "and daty >= TO_DATE('"+dateDebut+"','DD/MM/YYYY') and daty <= TO_DATE('"+dateFin+"','DD/MM/YYYY')";

    String order = "";
    if(request.getParameter("order")!=null && request.getParameter("order").compareToIgnoreCase("")!=0){
        order+= (" "+ request.getParameter("order"));
    }
    String[] grouper = new String[1];
    if(request.getParameter("grouper")!=null && request.getParameter("grouper").compareToIgnoreCase("")!=0){
        grouper[0]=request.getParameter("grouper");
        pr.setColGroupeDefaut(grouper);
    }
    pr.setOrdre(order);
    pr.setAWhere(apreswhere);
    Liste [] listes = new Liste[2];
    Support support = new Support();
    listes[0] = new Liste("idSupport",support,"val","id");
    CategorieIngredient cat = new CategorieIngredient();
    listes[1] = new Liste("idCategorie",cat,"val","id");
    pr.getFormu().changerEnChamp(listes);
    pr.getFormu().getChamp("daty1").setDefaut(dateDebut);
    pr.getFormu().getChamp("daty2").setDefaut(dateFin);
    pr.getFormu().getChamp("daty1").setLibelle("Date Min");
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("idCategorie").setLibelle("Type de service");
    pr.getFormu().getChamp("idSupport").setLibelle("Support");
    pr.getFormu().getChamp("idProduitLib").setLibelle("Nom de service");
    pr.getFormu().getChamp("idProduitLib").setVisible(false);

    pr.setNpp(500);
    pr.setApres("vente/vente-analyse.jsp");
    pr.creerObjetPageCroise(colGrCol,pr.getLien()+"?but=");

    String datyMin = request.getParameter("daty1");
    String datyMax = request.getParameter("daty2");
    if (datyMin != null) {
        datyMin = datyMin.trim();
    }
    if (datyMax != null) {
        datyMax = datyMax.trim();
    }

    if (datyMin != null && datyMin.matches("\\d{4}-\\d{2}-\\d{2}")) {
        String[] dtIsoMin = datyMin.split("-");
        datyMin = dtIsoMin[2] + "/" + dtIsoMin[1] + "/" + dtIsoMin[0];
    }
    if (datyMax != null && datyMax.matches("\\d{4}-\\d{2}-\\d{2}")) {
        String[] dtIsoMax = datyMax.split("-");
        datyMax = dtIsoMax[2] + "/" + dtIsoMax[1] + "/" + dtIsoMax[0];
    }

    if (datyMin == null || datyMin.trim().compareTo("") == 0) {
        datyMin = dateDebut;
    }
    if (datyMax == null || datyMax.trim().compareTo("") == 0) {
        datyMax = dateFin;
    }

    List<String> moisColonnes = new ArrayList<String>();
    LinkedHashMap<String, LinkedHashMap<String, Double>> totauxParLigne = new LinkedHashMap<String, LinkedHashMap<String, Double>>();
    LinkedHashMap<String, String[]> libellesLigne = new LinkedHashMap<String, String[]>();
    LinkedHashMap<String, Double> totalGeneralParMois = new LinkedHashMap<String, Double>();
    String erreurVentilation = null;

    Calendar calDebut = Calendar.getInstance();
    Calendar calFin = Calendar.getInstance();
    try {
        String[] dtMin = datyMin.split("/");
        String[] dtMax = datyMax.split("/");
        calDebut.set(Calendar.YEAR, Integer.parseInt(dtMin[2]));
        calDebut.set(Calendar.MONTH, Integer.parseInt(dtMin[1]) - 1);
        calDebut.set(Calendar.DAY_OF_MONTH, 1);

        calFin.set(Calendar.YEAR, Integer.parseInt(dtMax[2]));
        calFin.set(Calendar.MONTH, Integer.parseInt(dtMax[1]) - 1);
        calFin.set(Calendar.DAY_OF_MONTH, 1);
    } catch (Exception exDate) {
        datyMin = dateDebut;
        datyMax = dateFin;
        calDebut = Calendar.getInstance();
        calDebut.set(Calendar.DAY_OF_MONTH, 1);
        calFin = Calendar.getInstance();
        calFin.set(Calendar.DAY_OF_MONTH, 1);
    }

    if (calDebut.after(calFin)) {
        Calendar temp = calDebut;
        calDebut = calFin;
        calFin = temp;
        String datyTemp = datyMin;
        datyMin = datyMax;
        datyMax = datyTemp;
    }

    Calendar curseur = (Calendar) calDebut.clone();
    while (!curseur.after(calFin)) {
        String mois = String.format("%02d/%04d", curseur.get(Calendar.MONTH) + 1, curseur.get(Calendar.YEAR));
        moisColonnes.add(mois);
        totalGeneralParMois.put(mois, 0.0);
        curseur.add(Calendar.MONTH, 1);
    }

    String filtreSupport = request.getParameter("idSupport");
    String filtreCategorie = request.getParameter("idCategorie");
    String filtreProduit = request.getParameter("idProduitLib");

    if (filtreSupport != null) {
        filtreSupport = filtreSupport.trim();
    }
    if (filtreCategorie != null) {
        filtreCategorie = filtreCategorie.trim();
    }
    if (filtreProduit != null) {
        filtreProduit = filtreProduit.trim();
    }

    boolean filtreSupportActif = (filtreSupport != null
            && filtreSupport.length() > 0
            && filtreSupport.compareTo("0") != 0
            && filtreSupport.compareTo("-") != 0
            && filtreSupport.compareTo("%") != 0
            && filtreSupport.compareTo("*") != 0
            && filtreSupport.compareToIgnoreCase("null") != 0
            && filtreSupport.compareToIgnoreCase("tous") != 0
            && filtreSupport.compareToIgnoreCase("all") != 0);
    boolean filtreCategorieActif = (filtreCategorie != null
            && filtreCategorie.length() > 0
            && filtreCategorie.compareTo("0") != 0
            && filtreCategorie.compareTo("-") != 0
            && filtreCategorie.compareTo("%") != 0
            && filtreCategorie.compareTo("*") != 0
            && filtreCategorie.compareToIgnoreCase("null") != 0
            && filtreCategorie.compareToIgnoreCase("tous") != 0
            && filtreCategorie.compareToIgnoreCase("all") != 0);
    boolean filtreProduitActif = (filtreProduit != null
            && filtreProduit.length() > 0
            && filtreProduit.compareTo("0") != 0
            && filtreProduit.compareTo("-") != 0
            && filtreProduit.compareTo("%") != 0
            && filtreProduit.compareTo("*") != 0
            && filtreProduit.compareToIgnoreCase("null") != 0
            && filtreProduit.compareToIgnoreCase("tous") != 0
            && filtreProduit.compareToIgnoreCase("all") != 0);

    StringBuilder requeteVentilation = new StringBuilder();
    requeteVentilation.append("SELECT NVL(idProduitLib, '-') AS service, ");
    requeteVentilation.append("NVL(idDeviseLib, '-') AS devise, ");
    requeteVentilation.append("TO_CHAR(daty, 'MM/YYYY') AS mois, ");
    requeteVentilation.append("SUM(NVL(puTotal, 0)) AS total ");
    requeteVentilation.append("FROM ").append(nomTable).append(" ");
    requeteVentilation.append("WHERE daty >= TO_DATE(?, 'DD/MM/YYYY') AND daty < TO_DATE(?, 'DD/MM/YYYY') + 1 ");
    if (filtreSupportActif) {
        requeteVentilation.append("AND idSupport = ? ");
    }
    if (filtreCategorieActif) {
        requeteVentilation.append("AND idCategorie = ? ");
    }
    if (filtreProduitActif) {
        requeteVentilation.append("AND UPPER(idProduitLib) LIKE ? ");
    }
    requeteVentilation.append("GROUP BY NVL(idProduitLib, '-'), NVL(idDeviseLib, '-'), TO_CHAR(daty, 'MM/YYYY') ");
    requeteVentilation.append("ORDER BY 1, 2, 3");

    Connection connectionVentilation = null;
    PreparedStatement psVentilation = null;
    ResultSet rsVentilation = null;

    try {
        connectionVentilation = new UtilDB().GetConn();
        psVentilation = connectionVentilation.prepareStatement(requeteVentilation.toString());
        int indexParam = 1;
        psVentilation.setString(indexParam++, datyMin);
        psVentilation.setString(indexParam++, datyMax);

        if (filtreSupportActif) {
            psVentilation.setString(indexParam++, filtreSupport);
        }
        if (filtreCategorieActif) {
            psVentilation.setString(indexParam++, filtreCategorie);
        }
        if (filtreProduitActif) {
            psVentilation.setString(indexParam++, "%" + filtreProduit.toUpperCase() + "%");
        }

        rsVentilation = psVentilation.executeQuery();
        while (rsVentilation.next()) {
            String service = rsVentilation.getString("service");
            String devise = rsVentilation.getString("devise");
            String mois = rsVentilation.getString("mois");
            double total = rsVentilation.getDouble("total");

            String cleLigne = service + "||" + devise;
            LinkedHashMap<String, Double> detailLigne = totauxParLigne.get(cleLigne);
            if (detailLigne == null) {
                detailLigne = new LinkedHashMap<String, Double>();
                for (String moisColonne : moisColonnes) {
                    detailLigne.put(moisColonne, 0.0);
                }
                totauxParLigne.put(cleLigne, detailLigne);
                libellesLigne.put(cleLigne, new String[]{service, devise});
            }

            if (!detailLigne.containsKey(mois)) {
                detailLigne.put(mois, 0.0);
            }
            detailLigne.put(mois, detailLigne.get(mois) + total);

            if (!totalGeneralParMois.containsKey(mois)) {
                totalGeneralParMois.put(mois, 0.0);
                moisColonnes.add(mois);
            }
            totalGeneralParMois.put(mois, totalGeneralParMois.get(mois) + total);
        }
    } catch (Exception exVentilation) {
        erreurVentilation = exVentilation.getMessage();
    } finally {
        if (rsVentilation != null) {
            try {
                rsVentilation.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        if (psVentilation != null) {
            try {
                psVentilation.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        if (connectionVentilation != null) {
            try {
                connectionVentilation.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
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
    function alignTableCells() {
        const tbody = document.querySelector('tbody');
        if (!tbody) return;

        const rows = tbody.querySelectorAll('tr');

        rows.forEach((row) => {
            const cells = row.querySelectorAll('td');
            if (cells.length > 0) {
                cells[0].style.textAlign = 'center';
                cells[0].style.verticalAlign = 'middle';
            }
            if (cells.length > 1) {
                cells[1].style.textAlign = 'right';
            }
        });
    }
    document.addEventListener('DOMContentLoaded', alignTableCells);
</script>
<div class="content-wrapper">
    <section class="content-header">
        <h1>Analyse de rentabilit&eacute; de service de diffusion</h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=vente/vente-analyse.jsp" method="post" name="analyse" id="analyse">
            <%out.println(pr.getFormu().getHtmlEnsemble());%>
        </form>
        <ul>
            <li>La premi&egrave;re ligne correspond &agrave; la quantit&eacute;</li>
            <li>La 2&egrave;me ligne correspond au montant total</li>
        </ul>
           <%
            String lienTableau[] = {};
            pr.getTableau().setLien(lienTableau);
            pr.getTableau().setColonneLien(somDefaut);%>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
        <br>
        <h3>Ventilation mensuelle des totaux (MM/yyyy)</h3>
        <p>
            P&eacute;riode : <strong><%=datyMin%></strong> &agrave; <strong><%=datyMax%></strong>
        </p>
        <% if (erreurVentilation != null) { %>
            <div class="alert alert-danger">
                Erreur lors du chargement de la ventilation mensuelle : <%=erreurVentilation%>
            </div>
        <% } else { %>
            <div class="table-responsive">
                <table class="table table-bordered table-striped">
                    <thead>
                    <tr>
                        <th>Service</th>
                        <th>Devise</th>
                        <% for (String mois : moisColonnes) { %>
                            <th style="text-align:right;"><%=mois%></th>
                        <% } %>
                        <th style="text-align:right;">Total</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (totauxParLigne.isEmpty()) { %>
                    <tr>
                        <td colspan="<%=moisColonnes.size() + 3%>" style="text-align:center;">
                            Aucune donn&eacute;e trouv&eacute;e pour la p&eacute;riode s&eacute;lectionn&eacute;e.
                        </td>
                    </tr>
                    <% } else {
                        for (Map.Entry<String, LinkedHashMap<String, Double>> entree : totauxParLigne.entrySet()) {
                            String cle = entree.getKey();
                            String[] labels = libellesLigne.get(cle);
                            String service = (labels != null && labels[0] != null) ? labels[0] : "-";
                            String devise = (labels != null && labels[1] != null) ? labels[1] : "-";
                            LinkedHashMap<String, Double> ligne = entree.getValue();
                            double totalLigne = 0.0;
                    %>
                    <tr>
                        <td><%=service%></td>
                        <td><%=devise%></td>
                        <% for (String mois : moisColonnes) {
                            Double valeurObj = ligne.get(mois);
                            double valeur = (valeurObj != null) ? valeurObj : 0.0;
                            totalLigne += valeur;
                        %>
                            <td style="text-align:right;"><%=Utilitaire.formaterAr(valeur)%></td>
                        <% } %>
                        <td style="text-align:right;"><strong><%=Utilitaire.formaterAr(totalLigne)%></strong></td>
                    </tr>
                    <% } } %>
                    </tbody>
                    <tfoot>
                    <tr>
                        <th colspan="2">Total g&eacute;n&eacute;ral</th>
                        <%
                            double grandTotal = 0.0;
                            for (String mois : moisColonnes) {
                                Double totalMoisObj = totalGeneralParMois.get(mois);
                                double totalMois = (totalMoisObj != null) ? totalMoisObj : 0.0;
                                grandTotal += totalMois;
                        %>
                        <th style="text-align:right;"><%=Utilitaire.formaterAr(totalMois)%></th>
                        <% } %>
                        <th style="text-align:right;"><%=Utilitaire.formaterAr(grandTotal)%></th>
                    </tr>
                    </tfoot>
                </table>
            </div>
        <% } %>
    </section>
</div>
<%
    }catch(Exception e){
        e.printStackTrace();
    }
%>
