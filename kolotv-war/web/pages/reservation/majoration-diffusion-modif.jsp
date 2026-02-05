<%@page import="affichage.*"%>
<%@page import="reservation.MajorationDiffusion"%>

<%
    MajorationDiffusion t = new MajorationDiffusion();
    String mapping = "reservation.MajorationDiffusion",
            nomtable = "MAJORATION_DIFFUSION",
            apres = "reservation/majoration-diffusion-fiche.jsp",
            titre = "Modification de majoration de diffusion";

    PageUpdate pu = new PageUpdate(t, request, (user.UserEJB) session.getValue("u"));
    pu.setLien((String) session.getValue("lien"));
    pu.setTitre(titre);

    affichage.Champ[] liste = new affichage.Champ[1];
    Liste jours = new Liste("jour");
    jours.makeListeString(MajorationDiffusion.JOURS_SEMAINE, MajorationDiffusion.JOURS_SEMAINE);
    liste[0] = jours;
    pu.getFormu().changerEnChamp(liste);

    pu.getFormu().getChamp("id").setAutre("readonly");
    pu.getFormu().getChamp("jour").setLibelle("Jour");
    pu.getFormu().getChamp("heureDebut").setLibelle("Heure d&eacute;but");
    pu.getFormu().getChamp("heureDebut").setType("time");
    pu.getFormu().getChamp("heureDebut").setAutre("step=\"1\"");
    pu.getFormu().getChamp("heureFin").setLibelle("Heure fin");
    pu.getFormu().getChamp("heureFin").setType("time");
    pu.getFormu().getChamp("heureFin").setAutre("step=\"1\"");
    pu.getFormu().getChamp("tauxMajoration").setLibelle("Taux de majoration (%)");
    pu.getFormu().getChamp("tauxMajoration").setType("number");
    pu.getFormu().getChamp("tauxMajoration").setAutre("step=\"0.01\" min=\"0\"");

    String lien = (String) session.getValue("lien");
    String id = pu.getBase().getTuppleID();
    pu.preparerDataFormu();
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title">
                            <a href="<%= lien + "?but=reservation/majoration-diffusion-fiche.jsp&id=" + id%>">
                                <i class="fa fa-arrow-circle-left"></i>
                            </a>
                            <%=pu.getTitre()%>
                        </h1>
                    </div>
                    <form action="<%= lien %>?but=apresTarif.jsp&id=<%=request.getParameter("id")%>" method="post">
                        <%
                            out.println(pu.getFormu().getHtmlInsert());
                        %>
                        <div class="row">
                            <div class="col-md-11">
                                <button class="btn btn-primary pull-right" name="Submit2" type="submit">Valider</button>
                            </div>
                            <br><br>
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
