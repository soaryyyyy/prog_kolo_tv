
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="vente.BonDeCommandeFille" %>
<%@ page import="vente.BonDeCommandeFIlleCpl" %>
<%@ page import="vente.BonDeCommande" %>
<%
    try{
        BonDeCommandeFIlleCpl t = new BonDeCommandeFIlleCpl();
        t.setNomTable("BC_CLIENT_FILLE_CPL_LIB2");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"produit","remarque","produitlib","quantite","pu","tva","montantHt","montantTva","montantTtc","reference"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            pr.setAWhere(" and idbc='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        BonDeCommandeFIlleCpl[] listeFille=(BonDeCommandeFIlleCpl[]) pr.getTableau().getData();
        if(listeFille.length>0) {
            BonDeCommande o = new BonDeCommande();
            o.setFille(listeFille);
            o.calculerRevient(null);
            
        }
        pr.getTableau().transformerDataString();
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"produit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        String libEnteteAffiche[] =   {"ID","D&eacute;signation","Produit","Quantit&eacute;","Prix unitaire","Tva (%)","Montant HT","Valeur Tva","Montant TTC","R&eacute;f&eacute;rence"};

        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Total HT:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantHt")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Total TVA:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantTva")) %> Ar</b></td>
            </tr>
            <tr>
                <td><b>Total TTC:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantTtc")) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>
