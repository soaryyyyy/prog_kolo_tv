

<%@page import="caisse.ReportCaisseCpl"%>
<%@page import="affichage.PageRecherche"%>
<%@ page import="java.util.Map" %> 
<%@ page import="java.util.HashMap" %>

<% try{ 
    ReportCaisseCpl t = new ReportCaisseCpl();
    String listeCrt[] = {"id","idCaisseLib","montant","daty"};
    String listeInt[] = {"daty"};
    String libEntete[] = {"id","idCaisseLib","montant","daty", "etatLib"};
    String etat = request.getParameter("etat");
    if(etat == null) etat = "";
    t.setNomTable( t.getNomTable().concat(etat) );
    PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setTitre("Liste report caisse");
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    pr.setApres("caisse/report/reportCaisse-liste.jsp");
    String[] colSomme = null;
    pr.getFormu().getChamp("idCaisseLib").setLibelle("Caisse");
    pr.getFormu().getChamp("daty1").setLibelle("Date min");
    pr.getFormu().getChamp("daty1").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.getFormu().getChamp("daty2").setLibelle("Date max");
    pr.getFormu().getChamp("daty2").setDefaut(utilitaire.Utilitaire.dateDuJour());
    pr.creerObjetPage(libEntete, colSomme);
    
    Map<String,String> lienTab=new HashMap();
    lienTab.put("modifier",pr.getLien() + "?but=caisse/report/reportCaisse-modif.jsp");  
    pr.getTableau().setLienClicDroite(lienTab);

    String lienTableau[] = {pr.getLien() + "?but=caisse/report/reportCaisse-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);
    String libEnteteAffiche[] = {"id", "Caisse","montant","date", "&Eacute;tat"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String[] etatAffiche = {"Tous","Annul&eacute;","Cr&eacute;e","Valid&eacute;e"};
    String[] etatPasse = {"","_annule","_cree","_valider"};
%>

<div class="content-wrapper">
    <section class="content-header">
        <h1><%= pr.getTitre() %></h1>
    </section>
    <section class="content">
        <form action="<%=pr.getLien()%>?but=<%= pr.getApres() %>" method="post">
            <%
                out.println(pr.getFormu().getHtmlEnsemble());
            %>
        </form>
        <div class="row col-md-12">
            <div class="col-lg-6 col-md-6">
                <form action="<%= pr.getLien() %>?but=<%= pr.getApres() %>" method="post">
                    Etat
                    <select name="etat" class="champ form-control">
                        <%
                            for( int i = 0; i < etatAffiche.length; i++ ){ %>
                                <option value="<%= etatPasse[i] %>"> <%= etatAffiche[i] %> </option>
                        <%    }
                        %>
                    </select>
                    <input type="submit" value="Consultez" class="btn btn-primary my-2" />
                </form>
            </div>
        </div>
        <%
            out.println(pr.getTableauRecap().getHtml());
        %>
        <br>
        <%
            out.println(pr.getTableau().getHtml());
            out.println(pr.getBasPage());
        %>
    </section>
</div>
    <%
    }catch(Exception e){

        e.printStackTrace();
    }
%>



