# Fonctionnalités PAIEMENT FLEXIBLE & HORAIRE

## 🎯 FOCUS SESSION : Paiement Flexible + Gestion Horaire

Ce document se concentre exclusivement sur les fonctionnalités liées à :
1. **PAIEMENT FLEXIBLE** - Modalités de paiement variées et personnalisées
2. **GESTION HORAIRE** - Planification et optimisation des créneaux

---

# 🏦 PARTIE 1 : PAIEMENT FLEXIBLE

## Fonctionnalité 1 : Plan de Paiement Échelonné 🟡 (2-3h)

### Description
Permettre au client de payer en plusieurs tranches avec des échéances définies.

**Exemple** :
- Facture de 10,000,000 Ar
- 30% à la commande (3,000,000 Ar)
- 40% à 30 jours (4,000,000 Ar)
- 30% à 60 jours (3,000,000 Ar)

### Tables SQL à créer

```sql
-- Table principale des plans de paiement
CREATE TABLE PLAN_PAIEMENT (
    ID NUMBER PRIMARY KEY,
    IDFACTURE NUMBER REFERENCES FACTURE(ID),
    DATY_CREATION DATE DEFAULT SYSDATE,
    STATUT VARCHAR2(20) DEFAULT 'ACTIF',        -- 'ACTIF', 'COMPLETE', 'DEFAUT'
    MONTANT_TOTAL NUMBER(15,2),
    MONTANT_PAYE NUMBER(15,2) DEFAULT 0,
    NB_ECHEANCES NUMBER(2),
    REMARQUE VARCHAR2(500)
);

-- Détails des échéances
CREATE TABLE ECHEANCE_PAIEMENT (
    ID NUMBER PRIMARY KEY,
    IDPLAN NUMBER REFERENCES PLAN_PAIEMENT(ID),
    NUMERO_ECHEANCE NUMBER(2),                  -- 1, 2, 3...
    MONTANT NUMBER(15,2),
    POURCENTAGE NUMBER(5,2),
    DATE_ECHEANCE DATE,
    DATE_PAIEMENT DATE,
    MONTANT_PAYE NUMBER(15,2) DEFAULT 0,
    STATUT VARCHAR2(20) DEFAULT 'EN_ATTENTE',   -- 'EN_ATTENTE', 'PAYE', 'RETARD', 'PARTIEL'
    IDPAIEMENT NUMBER REFERENCES PAIEMENT(ID),
    REMARQUE VARCHAR2(500)
);

-- Templates de plans prédéfinis
CREATE TABLE TEMPLATE_PLAN_PAIEMENT (
    ID NUMBER PRIMARY KEY,
    NOM VARCHAR2(100),                          -- '3x sans frais', '30-60-90', etc.
    DESCRIPTION VARCHAR2(500),
    NB_ECHEANCES NUMBER(2),
    APPLICABLE_SI VARCHAR2(200),                -- Condition : 'montant > 1000000'
    ACTIF NUMBER(1) DEFAULT 1
);

CREATE TABLE TEMPLATE_ECHEANCE (
    ID NUMBER PRIMARY KEY,
    IDTEMPLATE NUMBER REFERENCES TEMPLATE_PLAN_PAIEMENT(ID),
    NUMERO NUMBER(2),
    POURCENTAGE NUMBER(5,2),
    DELAI_JOURS NUMBER(3)                       -- Jours après émission facture
);

-- Données exemple
INSERT INTO TEMPLATE_PLAN_PAIEMENT VALUES (1, '3x sans frais', 'Paiement en 3 fois égales', 3, 'montant > 500000', 1);
INSERT INTO TEMPLATE_ECHEANCE VALUES (1, 1, 1, 33.33, 0);    -- 33% immédiat
INSERT INTO TEMPLATE_ECHEANCE VALUES (2, 1, 2, 33.33, 30);   -- 33% à 30j
INSERT INTO TEMPLATE_ECHEANCE VALUES (3, 1, 3, 33.34, 60);   -- 33% à 60j

INSERT INTO TEMPLATE_PLAN_PAIEMENT VALUES (2, 'Acompte 30%', 'Acompte 30% puis solde à livraison', 2, 'montant > 1000000', 1);
INSERT INTO TEMPLATE_ECHEANCE VALUES (4, 2, 1, 30, 0);       -- 30% acompte
INSERT INTO TEMPLATE_ECHEANCE VALUES (5, 2, 2, 70, 45);      -- 70% à 45j

INSERT INTO TEMPLATE_PLAN_PAIEMENT VALUES (3, '30-60-90', 'Paiement étalé sur 3 mois', 3, 'montant > 2000000', 1);
INSERT INTO TEMPLATE_ECHEANCE VALUES (6, 3, 1, 25, 30);
INSERT INTO TEMPLATE_ECHEANCE VALUES (7, 3, 2, 35, 60);
INSERT INTO TEMPLATE_ECHEANCE VALUES (8, 3, 3, 40, 90);
```

### Code Java - PlanPaiementEJB.java

```java
package vente;

import javax.ejb.*;
import javax.persistence.*;
import java.util.*;

@Stateless
public class PlanPaiementEJB {

    @PersistenceContext
    private EntityManager em;

    /**
     * Créer un plan de paiement depuis un template
     */
    public PlanPaiement creerPlanDepuisTemplate(Long idfacture, Long idtemplate)
            throws Exception {

        Facture facture = em.find(Facture.class, idfacture);
        if (facture == null) {
            throw new Exception("Facture introuvable");
        }

        TemplatePlanPaiement template = em.find(TemplatePlanPaiement.class, idtemplate);
        if (template == null || !template.getActif()) {
            throw new Exception("Template invalide");
        }

        // Vérifier condition d'application
        if (!verifierConditionTemplate(facture, template)) {
            throw new Exception("Cette facture ne remplit pas les conditions pour ce plan");
        }

        // Créer plan
        PlanPaiement plan = new PlanPaiement();
        plan.setIdfacture(idfacture);
        plan.setDatyCreation(new Date());
        plan.setStatut("ACTIF");
        plan.setMontantTotal(facture.getTotalttc());
        plan.setMontantPaye(0.0);
        plan.setNbEcheances(template.getNbEcheances());

        em.persist(plan);

        // Créer échéances
        List<TemplateEcheance> templatesEcheances = getTemplateEcheances(idtemplate);

        Calendar cal = Calendar.getInstance();
        cal.setTime(facture.getDaty());

        for (TemplateEcheance te : templatesEcheances) {
            EcheancePaiement echeance = new EcheancePaiement();
            echeance.setIdplan(plan.getId());
            echeance.setNumeroEcheance(te.getNumero());
            echeance.setPourcentage(te.getPourcentage());
            echeance.setMontant((facture.getTotalttc() * te.getPourcentage()) / 100);

            // Calculer date échéance
            Calendar calEch = (Calendar) cal.clone();
            calEch.add(Calendar.DAY_OF_MONTH, te.getDelaiJours());
            echeance.setDateEcheance(calEch.getTime());

            echeance.setStatut("EN_ATTENTE");
            echeance.setMontantPaye(0.0);

            em.persist(echeance);
        }

        // Mettre à jour facture
        facture.setIdplanPaiement(plan.getId());
        facture.setModePaiement("ECHELONNE");
        em.merge(facture);

        return plan;
    }

    /**
     * Créer un plan de paiement personnalisé
     */
    public PlanPaiement creerPlanPersonnalise(Long idfacture,
                                               List<EcheanceDTO> echeances)
            throws Exception {

        Facture facture = em.find(Facture.class, idfacture);

        // Valider que la somme = 100%
        double sommePourcentages = echeances.stream()
            .mapToDouble(EcheanceDTO::getPourcentage)
            .sum();

        if (Math.abs(sommePourcentages - 100.0) > 0.01) {
            throw new Exception("La somme des pourcentages doit égaler 100%");
        }

        // Créer plan
        PlanPaiement plan = new PlanPaiement();
        plan.setIdfacture(idfacture);
        plan.setDatyCreation(new Date());
        plan.setStatut("ACTIF");
        plan.setMontantTotal(facture.getTotalttc());
        plan.setMontantPaye(0.0);
        plan.setNbEcheances(echeances.size());

        em.persist(plan);

        // Créer échéances
        int numero = 1;
        for (EcheanceDTO dto : echeances) {
            EcheancePaiement ech = new EcheancePaiement();
            ech.setIdplan(plan.getId());
            ech.setNumeroEcheance(numero++);
            ech.setPourcentage(dto.getPourcentage());
            ech.setMontant((facture.getTotalttc() * dto.getPourcentage()) / 100);
            ech.setDateEcheance(dto.getDateEcheance());
            ech.setStatut("EN_ATTENTE");
            ech.setMontantPaye(0.0);

            em.persist(ech);
        }

        facture.setIdplanPaiement(plan.getId());
        facture.setModePaiement("ECHELONNE_PERSONNALISE");
        em.merge(facture);

        return plan;
    }

    /**
     * Enregistrer un paiement sur une échéance
     */
    public void payerEcheance(Long idecheance, Double montant,
                              String modePaiement, String reference)
            throws Exception {

        EcheancePaiement echeance = em.find(EcheancePaiement.class, idecheance);
        if (echeance == null) {
            throw new Exception("Échéance introuvable");
        }

        if ("PAYE".equals(echeance.getStatut())) {
            throw new Exception("Cette échéance est déjà payée");
        }

        Double montantRestant = echeance.getMontant() - echeance.getMontantPaye();

        if (montant > montantRestant) {
            throw new Exception("Montant supérieur au solde de l'échéance");
        }

        // Créer paiement
        Paiement paiement = new Paiement();
        paiement.setIdfacture(getPlanPaiement(echeance.getIdplan()).getIdfacture());
        paiement.setDaty(new Date());
        paiement.setMontant(montant);
        paiement.setModepaiement(modePaiement);
        paiement.setReference(reference);
        paiement.setRemarque("Paiement échéance #" + echeance.getNumeroEcheance());

        em.persist(paiement);

        // Mettre à jour échéance
        Double nouveauMontantPaye = echeance.getMontantPaye() + montant;
        echeance.setMontantPaye(nouveauMontantPaye);

        if (Math.abs(nouveauMontantPaye - echeance.getMontant()) < 0.01) {
            // Échéance totalement payée
            echeance.setStatut("PAYE");
            echeance.setDatePaiement(new Date());
            echeance.setIdpaiement(paiement.getId());
        } else {
            echeance.setStatut("PARTIEL");
        }

        em.merge(echeance);

        // Mettre à jour plan
        mettreAJourPlan(echeance.getIdplan());
    }

    private void mettreAJourPlan(Long idplan) {
        PlanPaiement plan = em.find(PlanPaiement.class, idplan);

        // Calculer total payé
        String jpql = "SELECT COALESCE(SUM(e.montantPaye), 0) " +
                     "FROM EcheancePaiement e WHERE e.idplan = :idplan";

        Double totalPaye = em.createQuery(jpql, Double.class)
                            .setParameter("idplan", idplan)
                            .getSingleResult();

        plan.setMontantPaye(totalPaye);

        // Vérifier si plan complet
        if (Math.abs(totalPaye - plan.getMontantTotal()) < 0.01) {
            plan.setStatut("COMPLETE");
        }

        // Vérifier échéances en retard
        String jpqlRetard = "SELECT COUNT(e) FROM EcheancePaiement e " +
                           "WHERE e.idplan = :idplan " +
                           "AND e.statut IN ('EN_ATTENTE', 'PARTIEL') " +
                           "AND e.dateEcheance < :maintenant";

        Long nbRetard = em.createQuery(jpqlRetard, Long.class)
                         .setParameter("idplan", idplan)
                         .setParameter("maintenant", new Date())
                         .getSingleResult();

        if (nbRetard > 0 && !"COMPLETE".equals(plan.getStatut())) {
            plan.setStatut("DEFAUT");
        }

        em.merge(plan);

        // Mettre à jour facture
        Facture facture = em.find(Facture.class, plan.getIdfacture());
        facture.setMontantPaye(totalPaye);
        facture.setSoldeRestant(facture.getTotalttc() - totalPaye);

        if (Math.abs(totalPaye - facture.getTotalttc()) < 0.01) {
            facture.setStatutPaiement("PAYE");
        } else if (totalPaye > 0) {
            facture.setStatutPaiement("PARTIEL");
        }

        em.merge(facture);
    }

    /**
     * Lister les templates applicables pour une facture
     */
    public List<TemplatePlanPaiement> getTemplatesApplicables(Long idfacture) {
        Facture facture = em.find(Facture.class, idfacture);

        String jpql = "SELECT t FROM TemplatePlanPaiement t WHERE t.actif = true";
        List<TemplatePlanPaiement> templates = em.createQuery(jpql, TemplatePlanPaiement.class)
                                                 .getResultList();

        // Filtrer selon conditions
        List<TemplatePlanPaiement> applicables = new ArrayList<>();
        for (TemplatePlanPaiement t : templates) {
            if (verifierConditionTemplate(facture, t)) {
                applicables.add(t);
            }
        }

        return applicables;
    }

    private boolean verifierConditionTemplate(Facture facture, TemplatePlanPaiement template) {
        String condition = template.getApplicableSi();
        if (condition == null || condition.isEmpty()) {
            return true;
        }

        // Parser condition simple (ex: "montant > 1000000")
        try {
            if (condition.contains("montant")) {
                String[] parts = condition.split(" ");
                String operateur = parts[1];
                Double valeur = Double.parseDouble(parts[2]);
                Double montantFacture = facture.getTotalttc();

                switch (operateur) {
                    case ">": return montantFacture > valeur;
                    case ">=": return montantFacture >= valeur;
                    case "<": return montantFacture < valeur;
                    case "<=": return montantFacture <= valeur;
                    case "==": return Math.abs(montantFacture - valeur) < 0.01;
                    default: return true;
                }
            }
        } catch (Exception e) {
            return true; // En cas d'erreur parsing, autoriser
        }

        return true;
    }

    /**
     * Vérifier échéances en retard (job automatique)
     */
    @Schedule(hour = "8", minute = "0") // Tous les jours à 8h
    public void verifierEcheancesEnRetard() {
        String jpql = "SELECT e FROM EcheancePaiement e " +
                     "WHERE e.statut IN ('EN_ATTENTE', 'PARTIEL') " +
                     "AND e.dateEcheance < :maintenant";

        List<EcheancePaiement> enRetard = em.createQuery(jpql, EcheancePaiement.class)
                                            .setParameter("maintenant", new Date())
                                            .getResultList();

        for (EcheancePaiement e : enRetard) {
            e.setStatut("RETARD");
            em.merge(e);

            // Envoyer notification
            envoyerNotificationRetard(e);
        }
    }

    private void envoyerNotificationRetard(EcheancePaiement echeance) {
        PlanPaiement plan = em.find(PlanPaiement.class, echeance.getIdplan());
        Facture facture = em.find(Facture.class, plan.getIdfacture());
        Client client = em.find(Client.class, facture.getIdclient());

        String message = String.format(
            "Rappel : L'échéance #%d de %,.0f Ar pour la facture %s était due le %s",
            echeance.getNumeroEcheance(),
            echeance.getMontant(),
            facture.getReference(),
            formatDate(echeance.getDateEcheance())
        );

        // TODO: Envoyer email/SMS
        System.out.println("Notification retard : " + message);
    }

    // Méthodes utilitaires
    private List<TemplateEcheance> getTemplateEcheances(Long idtemplate) {
        return em.createQuery(
            "SELECT te FROM TemplateEcheance te WHERE te.idtemplate = :id ORDER BY te.numero",
            TemplateEcheance.class
        )
        .setParameter("id", idtemplate)
        .getResultList();
    }

    private PlanPaiement getPlanPaiement(Long id) {
        return em.find(PlanPaiement.class, id);
    }

    private String formatDate(Date date) {
        return new java.text.SimpleDateFormat("dd/MM/yyyy").format(date);
    }
}

// DTO pour échéance personnalisée
class EcheanceDTO {
    private Double pourcentage;
    private Date dateEcheance;
    private String remarque;

    // Getters/Setters
    public Double getPourcentage() { return pourcentage; }
    public void setPourcentage(Double pourcentage) { this.pourcentage = pourcentage; }
    public Date getDateEcheance() { return dateEcheance; }
    public void setDateEcheance(Date dateEcheance) { this.dateEcheance = dateEcheance; }
    public String getRemarque() { return remarque; }
    public void setRemarque(String remarque) { this.remarque = remarque; }
}
```

### Servlet - CreerPlanPaiementServlet.java

```java
package servlet.vente;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.util.*;
import vente.*;

@WebServlet("/servlet/vente/CreerPlanPaiementServlet")
public class CreerPlanPaiementServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            Long idfacture = Long.parseLong(request.getParameter("idfacture"));
            String type = request.getParameter("type"); // 'template' ou 'personnalise'

            PlanPaiementEJB ejb = PlanPaiementEJBClient.lookupPlanPaiementEJBBeanLocal();
            PlanPaiement plan;

            if ("template".equals(type)) {
                Long idtemplate = Long.parseLong(request.getParameter("idtemplate"));
                plan = ejb.creerPlanDepuisTemplate(idfacture, idtemplate);

            } else if ("personnalise".equals(type)) {
                // Récupérer échéances JSON
                String echeancesJson = request.getParameter("echeances");
                List<EcheanceDTO> echeances = parseEcheances(echeancesJson);
                plan = ejb.creerPlanPersonnalise(idfacture, echeances);

            } else {
                throw new Exception("Type invalide");
            }

            out.write("{\"success\": true, \"idplan\": " + plan.getId() + "}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\": false, \"error\": \"" + e.getMessage() + "\"}");
        }
    }

    private List<EcheanceDTO> parseEcheances(String json) throws Exception {
        // Parse JSON simple - adapter selon votre librairie JSON
        List<EcheanceDTO> list = new ArrayList<>();
        // TODO: Parser le JSON
        return list;
    }
}
```

### JSP - Interface Plan de Paiement (facture-plan-paiement.jsp)

```jsp
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="vente.*, java.util.*" %>

<%
    Long idfacture = Long.parseLong(request.getParameter("id"));
    Facture facture = FactureEJBClient.getFacture(idfacture);
    PlanPaiementEJB planEJB = PlanPaiementEJBClient.lookupPlanPaiementEJBBeanLocal();
%>

<div class="box box-primary">
    <div class="box-header">
        <h3 class="box-title">Plan de Paiement Échelonné</h3>
    </div>
    <div class="box-body">
        <% if (facture.getIdplanPaiement() == null) { %>
            <!-- Création du plan -->
            <div class="alert alert-info">
                Cette facture n'a pas encore de plan de paiement.
                Montant total : <strong><%=String.format("%,.0f", facture.getTotalttc())%> Ar</strong>
            </div>

            <h4>Choisir un plan prédéfini</h4>
            <div class="row">
                <%
                    List<TemplatePlanPaiement> templates = planEJB.getTemplatesApplicables(idfacture);
                    for (TemplatePlanPaiement tpl : templates) {
                %>
                <div class="col-md-4">
                    <div class="box box-success">
                        <div class="box-body">
                            <h4><%=tpl.getNom()%></h4>
                            <p><%=tpl.getDescription()%></p>
                            <p><strong><%=tpl.getNbEcheances()%> échéances</strong></p>

                            <%
                                List<TemplateEcheance> echs = planEJB.getTemplateEcheances(tpl.getId());
                                for (TemplateEcheance e : echs) {
                            %>
                            <div class="small">
                                - Échéance #<%=e.getNumero()%> : <%=e.getPourcentage()%>%
                                (<%=String.format("%,.0f", (facture.getTotalttc() * e.getPourcentage() / 100))%> Ar)
                                à J+<%=e.getDelaiJours()%>
                            </div>
                            <%
                                }
                            %>

                            <button class="btn btn-primary btn-sm mt-2"
                                    onclick="creerPlanTemplate(<%=tpl.getId()%>)">
                                Choisir ce plan
                            </button>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>

            <hr>
            <h4>Ou créer un plan personnalisé</h4>
            <button class="btn btn-info" data-toggle="modal" data-target="#modalPlanPerso">
                <i class="fa fa-plus"></i> Plan Personnalisé
            </button>

        <% } else { %>
            <!-- Affichage du plan existant -->
            <%
                PlanPaiement plan = planEJB.getPlanPaiement(facture.getIdplanPaiement());
                List<EcheancePaiement> echeances = planEJB.getEcheances(plan.getId());
            %>

            <div class="row">
                <div class="col-md-4">
                    <div class="info-box bg-aqua">
                        <span class="info-box-icon"><i class="fa fa-money"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">Montant Total</span>
                            <span class="info-box-number"><%=String.format("%,.0f", plan.getMontantTotal())%> Ar</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-box bg-green">
                        <span class="info-box-icon"><i class="fa fa-check"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">Déjà Payé</span>
                            <span class="info-box-number"><%=String.format("%,.0f", plan.getMontantPaye())%> Ar</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-box bg-yellow">
                        <span class="info-box-icon"><i class="fa fa-clock-o"></i></span>
                        <div class="info-box-content">
                            <span class="info-box-text">Restant</span>
                            <span class="info-box-number">
                                <%=String.format("%,.0f", plan.getMontantTotal() - plan.getMontantPaye())%> Ar
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <h4>Échéances du Plan</h4>
            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Montant</th>
                        <th>Date Échéance</th>
                        <th>Montant Payé</th>
                        <th>Statut</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (EcheancePaiement ech : echeances) {
                            String badgeClass = "default";
                            if ("PAYE".equals(ech.getStatut())) badgeClass = "success";
                            else if ("RETARD".equals(ech.getStatut())) badgeClass = "danger";
                            else if ("PARTIEL".equals(ech.getStatut())) badgeClass = "warning";
                    %>
                    <tr>
                        <td><strong>#<%=ech.getNumeroEcheance()%></strong></td>
                        <td><%=String.format("%,.0f", ech.getMontant())%> Ar</td>
                        <td><%=formatDate(ech.getDateEcheance())%></td>
                        <td><%=String.format("%,.0f", ech.getMontantPaye())%> Ar</td>
                        <td>
                            <span class="label label-<%=badgeClass%>"><%=ech.getStatut()%></span>
                        </td>
                        <td>
                            <% if (!"PAYE".equals(ech.getStatut())) { %>
                            <button class="btn btn-sm btn-primary"
                                    onclick="payerEcheance(<%=ech.getId()%>, <%=ech.getMontant() - ech.getMontantPaye()%>)">
                                <i class="fa fa-money"></i> Payer
                            </button>
                            <% } else { %>
                            <span class="text-success"><i class="fa fa-check"></i> Payée</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>

        <% } %>
    </div>
</div>

<!-- Modal Plan Personnalisé -->
<div class="modal fade" id="modalPlanPerso">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Créer un Plan Personnalisé</h4>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning">
                    Montant total : <strong><%=String.format("%,.0f", facture.getTotalttc())%> Ar</strong><br>
                    La somme des pourcentages doit égaler 100%
                </div>

                <div id="echeances-container">
                    <div class="echeance-ligne row mb-2">
                        <div class="col-md-1">
                            <strong>#1</strong>
                        </div>
                        <div class="col-md-3">
                            <input type="number" class="form-control pourcentage" placeholder="%" step="0.01" required>
                        </div>
                        <div class="col-md-3">
                            <input type="number" class="form-control montant" placeholder="Montant Ar" readonly>
                        </div>
                        <div class="col-md-4">
                            <input type="date" class="form-control date-echeance" required>
                        </div>
                        <div class="col-md-1">
                            <button type="button" class="btn btn-danger btn-sm" onclick="supprimerEcheance(this)">
                                <i class="fa fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <button type="button" class="btn btn-success btn-sm" onclick="ajouterEcheance()">
                    <i class="fa fa-plus"></i> Ajouter Échéance
                </button>

                <div class="mt-3">
                    <strong>Total : <span id="total-pourcent">0</span>%</strong>
                    <span id="validation-msg" class="ml-3"></span>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-primary" onclick="creerPlanPersonnalise()">
                    Créer le Plan
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var montantTotal = <%=facture.getTotalttc()%>;
var nbEcheances = 1;

function creerPlanTemplate(idtemplate) {
    if (confirm('Créer ce plan de paiement ?')) {
        $.ajax({
            url: '../../servlet/vente/CreerPlanPaiementServlet',
            method: 'POST',
            data: {
                idfacture: <%=idfacture%>,
                type: 'template',
                idtemplate: idtemplate
            },
            success: function(response) {
                alert('Plan de paiement créé avec succès !');
                location.reload();
            },
            error: function(xhr) {
                alert('Erreur : ' + xhr.responseJSON.error);
            }
        });
    }
}

function ajouterEcheance() {
    nbEcheances++;
    var html = `
        <div class="echeance-ligne row mb-2">
            <div class="col-md-1"><strong>#${nbEcheances}</strong></div>
            <div class="col-md-3">
                <input type="number" class="form-control pourcentage" placeholder="%" step="0.01" required>
            </div>
            <div class="col-md-3">
                <input type="number" class="form-control montant" placeholder="Montant Ar" readonly>
            </div>
            <div class="col-md-4">
                <input type="date" class="form-control date-echeance" required>
            </div>
            <div class="col-md-1">
                <button type="button" class="btn btn-danger btn-sm" onclick="supprimerEcheance(this)">
                    <i class="fa fa-trash"></i>
                </button>
            </div>
        </div>
    `;
    $('#echeances-container').append(html);
}

function supprimerEcheance(btn) {
    if ($('.echeance-ligne').length > 1) {
        $(btn).closest('.echeance-ligne').remove();
        recalculer();
    } else {
        alert('Il faut au moins une échéance');
    }
}

$(document).on('input', '.pourcentage', function() {
    var ligne = $(this).closest('.echeance-ligne');
    var pourcent = parseFloat($(this).val()) || 0;
    var montant = (montantTotal * pourcent / 100).toFixed(2);
    ligne.find('.montant').val(montant);

    recalculer();
});

function recalculer() {
    var total = 0;
    $('.pourcentage').each(function() {
        total += parseFloat($(this).val()) || 0;
    });

    $('#total-pourcent').text(total.toFixed(2));

    if (Math.abs(total - 100) < 0.01) {
        $('#validation-msg').html('<span class="text-success"><i class="fa fa-check"></i> Valide</span>');
    } else {
        $('#validation-msg').html('<span class="text-danger"><i class="fa fa-times"></i> Doit égaler 100%</span>');
    }
}

function creerPlanPersonnalise() {
    var total = 0;
    $('.pourcentage').each(function() {
        total += parseFloat($(this).val()) || 0;
    });

    if (Math.abs(total - 100) > 0.01) {
        alert('La somme des pourcentages doit égaler 100%');
        return;
    }

    // Collecter échéances
    var echeances = [];
    $('.echeance-ligne').each(function() {
        echeances.push({
            pourcentage: parseFloat($(this).find('.pourcentage').val()),
            dateEcheance: $(this).find('.date-echeance').val()
        });
    });

    $.ajax({
        url: '../../servlet/vente/CreerPlanPaiementServlet',
        method: 'POST',
        data: {
            idfacture: <%=idfacture%>,
            type: 'personnalise',
            echeances: JSON.stringify(echeances)
        },
        success: function(response) {
            alert('Plan personnalisé créé avec succès !');
            location.reload();
        },
        error: function(xhr) {
            alert('Erreur : ' + xhr.responseJSON.error);
        }
    });
}

function payerEcheance(idecheance, montantRestant) {
    // Modal paiement
    var html = `
        <div class="modal fade" id="modalPaiementEcheance">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4>Paiement Échéance</h4>
                    </div>
                    <form id="formPaiementEcheance">
                        <div class="modal-body">
                            <input type="hidden" name="idecheance" value="${idecheance}">

                            <div class="form-group">
                                <label>Montant</label>
                                <input type="number" name="montant" class="form-control"
                                       value="${montantRestant}" max="${montantRestant}" step="0.01" required>
                                <small>Maximum : ${montantRestant.toFixed(2)} Ar</small>
                            </div>

                            <div class="form-group">
                                <label>Mode de Paiement</label>
                                <select name="modepaiement" class="form-control" required>
                                    <option value="ESPECE">Espèces</option>
                                    <option value="CHEQUE">Chèque</option>
                                    <option value="VIREMENT">Virement</option>
                                    <option value="MOBILE_MONEY">Mobile Money</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Référence</label>
                                <input type="text" name="reference" class="form-control">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                            <button type="submit" class="btn btn-primary">Valider Paiement</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    `;

    $('body').append(html);
    $('#modalPaiementEcheance').modal('show');

    $('#formPaiementEcheance').on('submit', function(e) {
        e.preventDefault();

        $.ajax({
            url: '../../servlet/vente/PayerEcheanceServlet',
            method: 'POST',
            data: $(this).serialize(),
            success: function() {
                alert('Paiement enregistré !');
                location.reload();
            },
            error: function(xhr) {
                alert('Erreur : ' + xhr.responseJSON.error);
            }
        });
    });
}
</script>
```

---

## Fonctionnalité 2 : Paiement Mixte Multi-Modes 🟢 (1-2h)

### Description
Permettre de payer une facture avec plusieurs modes de paiement simultanés.

**Exemple** :
- Facture 5,000,000 Ar
- 2,000,000 Ar en espèces
- 2,000,000 Ar par chèque
- 1,000,000 Ar par virement

### Table SQL

```sql
-- Modifier table PAIEMENT existante
ALTER TABLE PAIEMENT ADD TYPE_PAIEMENT VARCHAR2(20) DEFAULT 'UNIQUE'; -- 'UNIQUE' ou 'MIXTE'
ALTER TABLE PAIEMENT ADD IDPAIEMENT_PARENT NUMBER REFERENCES PAIEMENT(ID);

-- Pour paiement mixte, il y aura :
-- 1 ligne parent avec TYPE_PAIEMENT='MIXTE' et montant = somme
-- N lignes enfants avec IDPAIEMENT_PARENT renseigné et détails par mode
```

### Code Java - Dans PaiementEJB.java

```java
/**
 * Enregistrer un paiement mixte (plusieurs modes)
 */
public Paiement enregistrerPaiementMixte(Long idfacture, List<DetailPaiementDTO> details)
        throws Exception {

    Facture facture = em.find(Facture.class, idfacture);

    // Calculer total
    Double totalPaiement = details.stream()
        .mapToDouble(DetailPaiementDTO::getMontant)
        .sum();

    // Vérifier solde
    if (totalPaiement > facture.getSoldeRestant()) {
        throw new Exception("Montant total dépasse le solde restant");
    }

    // Créer paiement parent
    Paiement paiementParent = new Paiement();
    paiementParent.setIdfacture(idfacture);
    paiementParent.setDaty(new Date());
    paiementParent.setMontant(totalPaiement);
    paiementParent.setTypePaiement("MIXTE");
    paiementParent.setModepaiement("MIXTE");
    paiementParent.setRemarque("Paiement mixte - " + details.size() + " modes");

    em.persist(paiementParent);

    // Créer détails
    for (DetailPaiementDTO detail : details) {
        Paiement paiementDetail = new Paiement();
        paiementDetail.setIdfacture(idfacture);
        paiementDetail.setIdpaiementParent(paiementParent.getId());
        paiementDetail.setDaty(new Date());
        paiementDetail.setMontant(detail.getMontant());
        paiementDetail.setModepaiement(detail.getMode());
        paiementDetail.setReference(detail.getReference());
        paiementDetail.setRemarque(detail.getRemarque());
        paiementDetail.setTypePaiement("DETAIL_MIXTE");

        em.persist(paiementDetail);
    }

    // Mettre à jour facture
    mettreAJourFacture(idfacture, totalPaiement);

    return paiementParent;
}
```

### JSP - Interface Paiement Mixte

```jsp
<button class="btn btn-warning" data-toggle="modal" data-target="#modalPaiementMixte">
    <i class="fa fa-credit-card"></i> Paiement Mixte
</button>

<div class="modal fade" id="modalPaiementMixte">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h4>Paiement Mixte (Plusieurs Modes)</h4>
            </div>
            <div class="modal-body">
                <div class="alert alert-info">
                    Solde à payer : <strong id="solde-restant"><%=facture.getSoldeRestant()%></strong> Ar
                </div>

                <table class="table table-bordered" id="tablePaiementMixte">
                    <thead>
                        <tr>
                            <th>Mode Paiement</th>
                            <th>Montant</th>
                            <th>Référence</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr class="ligne-paiement">
                            <td>
                                <select class="form-control mode-paiement" required>
                                    <option value="ESPECE">Espèces</option>
                                    <option value="CHEQUE">Chèque</option>
                                    <option value="VIREMENT">Virement</option>
                                    <option value="MOBILE_MONEY">Mobile Money</option>
                                    <option value="CARTE">Carte Bancaire</option>
                                </select>
                            </td>
                            <td>
                                <input type="number" class="form-control montant-paiement"
                                       step="0.01" required>
                            </td>
                            <td>
                                <input type="text" class="form-control reference-paiement"
                                       placeholder="N° chèque, réf...">
                            </td>
                            <td>
                                <button type="button" class="btn btn-danger btn-sm"
                                        onclick="supprimerLignePaiement(this)">
                                    <i class="fa fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <button type="button" class="btn btn-success btn-sm"
                        onclick="ajouterLignePaiement()">
                    <i class="fa fa-plus"></i> Ajouter un mode
                </button>

                <div class="mt-3">
                    <div class="row">
                        <div class="col-md-6">
                            <strong>Total saisi :</strong>
                            <span id="total-saisi">0.00</span> Ar
                        </div>
                        <div class="col-md-6">
                            <strong>Reste à répartir :</strong>
                            <span id="reste-repartir"><%=facture.getSoldeRestant()%></span> Ar
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-primary"
                        onclick="validerPaiementMixte()">
                    Valider le Paiement
                </button>
            </div>
        </div>
    </div>
</div>

<script>
var soldeRestant = <%=facture.getSoldeRestant()%>;

$(document).on('input', '.montant-paiement', function() {
    recalculerTotalMixte();
});

function ajouterLignePaiement() {
    var html = `
        <tr class="ligne-paiement">
            <td>
                <select class="form-control mode-paiement" required>
                    <option value="ESPECE">Espèces</option>
                    <option value="CHEQUE">Chèque</option>
                    <option value="VIREMENT">Virement</option>
                    <option value="MOBILE_MONEY">Mobile Money</option>
                    <option value="CARTE">Carte Bancaire</option>
                </select>
            </td>
            <td>
                <input type="number" class="form-control montant-paiement" step="0.01" required>
            </td>
            <td>
                <input type="text" class="form-control reference-paiement">
            </td>
            <td>
                <button type="button" class="btn btn-danger btn-sm"
                        onclick="supprimerLignePaiement(this)">
                    <i class="fa fa-trash"></i>
                </button>
            </td>
        </tr>
    `;
    $('#tablePaiementMixte tbody').append(html);
}

function supprimerLignePaiement(btn) {
    if ($('.ligne-paiement').length > 1) {
        $(btn).closest('.ligne-paiement').remove();
        recalculerTotalMixte();
    }
}

function recalculerTotalMixte() {
    var total = 0;
    $('.montant-paiement').each(function() {
        total += parseFloat($(this).val()) || 0;
    });

    $('#total-saisi').text(total.toFixed(2));
    $('#reste-repartir').text((soldeRestant - total).toFixed(2));

    if (total > soldeRestant) {
        $('#reste-repartir').css('color', 'red');
    } else {
        $('#reste-repartir').css('color', 'black');
    }
}

function validerPaiementMixte() {
    var total = 0;
    var details = [];

    $('.ligne-paiement').each(function() {
        var montant = parseFloat($(this).find('.montant-paiement').val()) || 0;
        if (montant > 0) {
            total += montant;
            details.push({
                mode: $(this).find('.mode-paiement').val(),
                montant: montant,
                reference: $(this).find('.reference-paiement').val()
            });
        }
    });

    if (details.length === 0) {
        alert('Veuillez saisir au moins un montant');
        return;
    }

    if (total > soldeRestant) {
        alert('Le total dépasse le solde restant');
        return;
    }

    $.ajax({
        url: '../../servlet/vente/EnregistrerPaiementMixteServlet',
        method: 'POST',
        data: {
            idfacture: <%=idfacture%>,
            details: JSON.stringify(details)
        },
        success: function(response) {
            alert('Paiement mixte enregistré avec succès !');
            location.reload();
        },
        error: function(xhr) {
            alert('Erreur : ' + xhr.responseJSON.error);
        }
    });
}
</script>
```

---

# ⏰ PARTIE 2 : GESTION HORAIRE

## Fonctionnalité 3 : Système de Créneaux Horaires (Time Slots) 🟡 (2-3h)

### Description
Gérer des créneaux horaires prédéfinis avec capacité maximale et tarification variable.

**Cas d'usage** :
- Prime time (19h-22h) : tarif élevé, 10 spots max
- Day time (9h-18h) : tarif moyen, 15 spots max
- Late night (22h-6h) : tarif réduit, illimité

### Tables SQL

```sql
CREATE TABLE CRENEAU_HORAIRE (
    ID NUMBER PRIMARY KEY,
    NOM VARCHAR2(100),                   -- 'PRIME_TIME', 'DAY_TIME', etc.
    HEURE_DEBUT VARCHAR2(5),
    HEURE_FIN VARCHAR2(5),
    IDSUPPORT NUMBER REFERENCES SUPPORT(ID),
    CAPACITE_MAX NUMBER(3),              -- NULL = illimité
    TARIF_BASE NUMBER(15,2),
    COEFFICIENT_TARIF NUMBER(5,2),       -- Multiplicateur prix
    COULEUR VARCHAR2(7),                 -- Code couleur HTML pour affichage
    ACTIF NUMBER(1) DEFAULT 1,
    JOURS_APPLICABLES VARCHAR2(20)      -- '1234567' ou '16' (lundi à vendredi ou weekend)
);

CREATE TABLE OCCUPATION_CRENEAU (
    ID NUMBER PRIMARY KEY,
    IDCRENEAU NUMBER REFERENCES CRENEAU_HORAIRE(ID),
    DATY DATE,
    NB_SPOTS_RESERVES NUMBER(3) DEFAULT 0,
    DISPONIBILITE VARCHAR2(20)           -- 'DISPONIBLE', 'LIMITE', 'COMPLET'
);

-- Données exemple
INSERT INTO CRENEAU_HORAIRE VALUES
    (1, 'PRIME TIME', '19:00', '22:00', 1, 10, 100000, 1.5, '#FF5722', 1, '1234567');

INSERT INTO CRENEAU_HORAIRE VALUES
    (2, 'DAY TIME', '09:00', '18:00', 1, 15, 50000, 1.0, '#FFC107', 1, '12345');

INSERT INTO CRENEAU_HORAIRE VALUES
    (3, 'LATE NIGHT', '22:00', '06:00', 1, NULL, 30000, 0.7, '#9E9E9E', 1, '1234567');

INSERT INTO CRENEAU_HORAIRE VALUES
    (4, 'WEEKEND PREMIUM', '14:00', '20:00', 1, 8, 120000, 1.8, '#E91E63', 1, '67');
```

### Code Java - CreneauHoraireEJB.java

```java
package reservation;

import javax.ejb.*;
import javax.persistence.*;
import java.util.*;

@Stateless
public class CreneauHoraireEJB {

    @PersistenceContext
    private EntityManager em;

    /**
     * Trouver le créneau horaire pour une date/heure donnée
     */
    public CreneauHoraire trouverCreneau(Date date, String heure, Long idsupport) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        int jourSemaine = cal.get(Calendar.DAY_OF_WEEK); // 1=Dimanche, 2=Lundi, ..., 7=Samedi

        String jpql = "SELECT c FROM CreneauHoraire c " +
                     "WHERE c.idsupport = :idsupport " +
                     "AND :heure >= c.heureDebut " +
                     "AND :heure < c.heureFin " +
                     "AND c.actif = true " +
                     "AND (c.joursApplicables LIKE :jour OR c.joursApplicables IS NULL)";

        try {
            return em.createQuery(jpql, CreneauHoraire.class)
                    .setParameter("idsupport", idsupport)
                    .setParameter("heure", heure)
                    .setParameter("jour", "%" + jourSemaine + "%")
                    .getSingleResult();
        } catch (NoResultException e) {
            return null; // Pas de créneau défini pour cette heure
        }
    }

    /**
     * Vérifier disponibilité d'un créneau
     */
    public DisponibiliteDTO verifierDisponibilite(Long idcreneau, Date date) {
        CreneauHoraire creneau = em.find(CreneauHoraire.class, idcreneau);

        if (creneau == null || !creneau.getActif()) {
            throw new IllegalArgumentException("Créneau invalide");
        }

        // Récupérer/créer occupation
        OccupationCreneau occupation = getOuCreerOccupation(idcreneau, date);

        DisponibiliteDTO dispo = new DisponibiliteDTO();
        dispo.setIdcreneau(idcreneau);
        dispo.setNomCreneau(creneau.getNom());
        dispo.setDate(date);
        dispo.setCapaciteMax(creneau.getCapaciteMax());
        dispo.setNbSpotRestantes(occupation.getNbSpotsReserves());

        if (creneau.getCapaciteMax() == null) {
            // Capacité illimitée
            dispo.setDisponibilite("DISPONIBLE");
            dispo.setNbPlacesRestantes(9999);
        } else {
            int restantes = creneau.getCapaciteMax() - occupation.getNbSpotsReserves();
            dispo.setNbPlacesRestantes(restantes);

            if (restantes <= 0) {
                dispo.setDisponibilite("COMPLET");
            } else if (restantes <= 3) {
                dispo.setDisponibilite("LIMITE");
            } else {
                dispo.setDisponibilite("DISPONIBLE");
            }
        }

        dispo.setTarifRecommande(creneau.getTarifBase());
        dispo.setCoefficientTarif(creneau.getCoefficientTarif());
        dispo.setCouleur(creneau.getCouleur());

        return dispo;
    }

    /**
     * Réserver un spot dans un créneau
     */
    public void reserverSpotDansCreneau(Long idcreneau, Date date, int nbSpots)
            throws Exception {

        DisponibiliteDTO dispo = verifierDisponibilite(idcreneau, date);

        if ("COMPLET".equals(dispo.getDisponibilite())) {
            throw new Exception("Ce créneau est complet");
        }

        if (dispo.getNbPlacesRestantes() < nbSpots) {
            throw new Exception("Pas assez de places disponibles (" +
                              dispo.getNbPlacesRestantes() + " restantes)");
        }

        // Mettre à jour occupation
        OccupationCreneau occupation = getOuCreerOccupation(idcreneau, date);
        occupation.setNbSpotsReserves(occupation.getNbSpotsReserves() + nbSpots);

        // Mettre à jour disponibilité
        CreneauHoraire creneau = em.find(CreneauHoraire.class, idcreneau);
        if (creneau.getCapaciteMax() != null) {
            int restantes = creneau.getCapaciteMax() - occupation.getNbSpotsReserves();
            if (restantes <= 0) {
                occupation.setDisponibilite("COMPLET");
            } else if (restantes <= 3) {
                occupation.setDisponibilite("LIMITE");
            }
        }

        em.merge(occupation);
    }

    /**
     * Libérer des spots (annulation réservation)
     */
    public void libererSpots(Long idcreneau, Date date, int nbSpots) {
        OccupationCreneau occupation = getOuCreerOccupation(idcreneau, date);

        int nouveauNb = Math.max(0, occupation.getNbSpotsReserves() - nbSpots);
        occupation.setNbSpotsReserves(nouveauNb);
        occupation.setDisponibilite("DISPONIBLE");

        em.merge(occupation);
    }

    /**
     * Calculer prix recommandé selon créneau
     */
    public Double calculerPrixCreneau(Long idcreneau, Double prixBase) {
        CreneauHoraire creneau = em.find(CreneauHoraire.class, idcreneau);

        if (creneau == null) {
            return prixBase;
        }

        // Option 1 : Utiliser tarif base du créneau
        if (creneau.getTarifBase() != null && creneau.getTarifBase() > 0) {
            return creneau.getTarifBase();
        }

        // Option 2 : Appliquer coefficient
        if (creneau.getCoefficientTarif() != null) {
            return prixBase * creneau.getCoefficientTarif();
        }

        return prixBase;
    }

    /**
     * Lister créneaux pour une journée
     */
    public List<DisponibiliteDTO> listerCreneauxJour(Date date, Long idsupport) {
        String jpql = "SELECT c FROM CreneauHoraire c " +
                     "WHERE c.idsupport = :idsupport " +
                     "AND c.actif = true " +
                     "ORDER BY c.heureDebut";

        List<CreneauHoraire> creneaux = em.createQuery(jpql, CreneauHoraire.class)
                                          .setParameter("idsupport", idsupport)
                                          .getResultList();

        List<DisponibiliteDTO> dispos = new ArrayList<>();
        for (CreneauHoraire c : creneaux) {
            dispos.add(verifierDisponibilite(c.getId(), date));
        }

        return dispos;
    }

    // Utilitaires privés
    private OccupationCreneau getOuCreerOccupation(Long idcreneau, Date date) {
        // Normaliser date (00:00:00)
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        Date dateNormalisee = cal.getTime();

        String jpql = "SELECT o FROM OccupationCreneau o " +
                     "WHERE o.idcreneau = :idcreneau AND o.daty = :date";

        try {
            return em.createQuery(jpql, OccupationCreneau.class)
                    .setParameter("idcreneau", idcreneau)
                    .setParameter("date", dateNormalisee)
                    .getSingleResult();
        } catch (NoResultException e) {
            // Créer nouvelle occupation
            OccupationCreneau occ = new OccupationCreneau();
            occ.setIdcreneau(idcreneau);
            occ.setDaty(dateNormalisee);
            occ.setNbSpotsReserves(0);
            occ.setDisponibilite("DISPONIBLE");
            em.persist(occ);
            return occ;
        }
    }
}

// DTO
class DisponibiliteDTO {
    private Long idcreneau;
    private String nomCreneau;
    private Date date;
    private Integer capaciteMax;
    private Integer nbSpotsReserves;
    private Integer nbPlacesRestantes;
    private String disponibilite; // 'DISPONIBLE', 'LIMITE', 'COMPLET'
    private Double tarifRecommande;
    private Double coefficientTarif;
    private String couleur;

    // Getters/Setters
    // ... (à compléter)
}
```

### JSP - Sélection Créneau dans Réservation

```jsp
<!-- Dans reservation-saisie.jsp -->

<div class="form-group">
    <label>Date & Heure</label>
    <div class="row">
        <div class="col-md-6">
            <input type="date" id="daty" name="daty" class="form-control" required>
        </div>
        <div class="col-md-6">
            <input type="time" id="heure" name="heure" class="form-control" required>
        </div>
    </div>
</div>

<div id="info-creneau" style="display:none;" class="alert">
    <h4><i class="fa fa-clock-o"></i> Créneau : <span id="nom-creneau"></span></h4>
    <div class="row">
        <div class="col-md-4">
            <strong>Disponibilité :</strong>
            <span id="dispo-statut" class="label"></span>
        </div>
        <div class="col-md-4">
            <strong>Places restantes :</strong>
            <span id="places-restantes"></span>
        </div>
        <div class="col-md-4">
            <strong>Tarif recommandé :</strong>
            <span id="tarif-recommande"></span> Ar
        </div>
    </div>
</div>

<script>
$('#daty, #heure, #idsupport').on('change', function() {
    var date = $('#daty').val();
    var heure = $('#heure').val();
    var support = $('#idsupport').val();

    if (date && heure && support) {
        $.ajax({
            url: '../../servlet/reservation/VerifierCreneauServlet',
            method: 'POST',
            data: { date: date, heure: heure, idsupport: support },
            success: function(response) {
                if (response.creneau) {
                    afficherInfoCreneau(response.creneau);
                } else {
                    $('#info-creneau').hide();
                }
            }
        });
    }
});

function afficherInfoCreneau(creneau) {
    $('#nom-creneau').text(creneau.nomCreneau);
    $('#places-restantes').text(
        creneau.nbPlacesRestantes === 9999 ? 'Illimité' : creneau.nbPlacesRestantes
    );
    $('#tarif-recommande').text(creneau.tarifRecommande.toLocaleString());

    // Badge statut
    var badgeClass = 'default';
    if (creneau.disponibilite === 'DISPONIBLE') badgeClass = 'success';
    else if (creneau.disponibilite === 'LIMITE') badgeClass = 'warning';
    else if (creneau.disponibilite === 'COMPLET') badgeClass = 'danger';

    $('#dispo-statut').removeClass().addClass('label label-' + badgeClass)
                      .text(creneau.disponibilite);

    // Appliquer couleur et tarif
    $('#info-creneau').css('border-left', '5px solid ' + creneau.couleur).show();
    $('#pu').val(creneau.tarifRecommande);

    // Bloquer si complet
    if (creneau.disponibilite === 'COMPLET') {
        alert('ATTENTION : Ce créneau est complet !');
        $('#pu').prop('disabled', true);
    } else {
        $('#pu').prop('disabled', false);
    }
}
</script>
```

### Vue Calendrier avec Créneaux

```jsp
<!-- planning-creneaux.jsp -->
<div class="box box-primary">
    <div class="box-header">
        <h3 class="box-title">Planning des Créneaux Horaires</h3>
    </div>
    <div class="box-body">
        <div class="row">
            <div class="col-md-3">
                <label>Support</label>
                <select id="filter-support" class="form-control">
                    <option value="1">TV</option>
                    <option value="2">Radio</option>
                </select>
            </div>
            <div class="col-md-6">
                <label>Période</label>
                <input type="date" id="date-debut" class="form-control">
            </div>
            <div class="col-md-3">
                <button onclick="chargerPlanning()" class="btn btn-primary">
                    <i class="fa fa-search"></i> Afficher
                </button>
            </div>
        </div>

        <div id="planning-container" class="mt-3">
            <!-- Généré dynamiquement -->
        </div>
    </div>
</div>

<script>
function chargerPlanning() {
    var support = $('#filter-support').val();
    var dateDebut = $('#date-debut').val();

    $.ajax({
        url: '../../servlet/reservation/PlanningCreneauxServlet',
        data: { idsupport: support, dateDebut: dateDebut, nbJours: 7 },
        success: function(response) {
            afficherPlanning(response);
        }
    });
}

function afficherPlanning(data) {
    var html = '<table class="table table-bordered">';

    // En-têtes : Dates
    html += '<thead><tr><th>Créneau</th>';
    data.dates.forEach(function(date) {
        html += '<th>' + date + '</th>';
    });
    html += '</tr></thead><tbody>';

    // Lignes : Créneaux
    data.creneaux.forEach(function(creneau) {
        html += '<tr>';
        html += '<td><strong>' + creneau.nom + '</strong><br>' +
                '<small>' + creneau.heureDebut + ' - ' + creneau.heureFin + '</small></td>';

        data.dates.forEach(function(date) {
            var dispo = creneau.disponibilites[date];
            var bgColor = dispo.couleur;
            var txtColor = dispo.disponibilite === 'COMPLET' ? '#FFF' : '#000';

            html += '<td style="background-color:' + bgColor + '20; color:' + txtColor + '">';
            html += '<div class="text-center">';
            html += '<span class="label label-' + getBadgeClass(dispo.disponibilite) + '">';
            html += dispo.nbPlacesRestantes === 9999 ? '∞' : dispo.nbPlacesRestantes;
            html += '</span>';
            html += '</div>';
            html += '<small>' + dispo.tarifRecommande.toLocaleString() + ' Ar</small>';
            html += '</td>';
        });

        html += '</tr>';
    });

    html += '</tbody></table>';

    $('#planning-container').html(html);
}

function getBadgeClass(statut) {
    if (statut === 'DISPONIBLE') return 'success';
    if (statut === 'LIMITE') return 'warning';
    if (statut === 'COMPLET') return 'danger';
    return 'default';
}

// Charger au chargement de la page
$(document).ready(function() {
    $('#date-debut').val(new Date().toISOString().split('T')[0]);
    chargerPlanning();
});
</script>
```

---

## Fonctionnalité 4 : Rotation Automatique des Horaires 🟡 (2h)

### Description
Diffuser le même spot à différentes heures pour maximiser l'audience.

**Exemple** :
- Spot X diffusé 3 fois/jour : 8h, 13h, 20h
- Rotation sur la semaine avec horaires variés

### Table SQL

```sql
CREATE TABLE SCHEMA_ROTATION (
    ID NUMBER PRIMARY KEY,
    NOM VARCHAR2(100),
    DESCRIPTION VARCHAR2(500),
    NB_DIFFUSIONS_PAR_JOUR NUMBER(2),
    REPARTITION VARCHAR2(20),        -- 'EQUIREPARTIE', 'PEAK_FOCUS', 'PERSONNALISE'
    ACTIF NUMBER(1) DEFAULT 1
);

CREATE TABLE HORAIRE_ROTATION (
    ID NUMBER PRIMARY KEY,
    IDSCHEMA NUMBER REFERENCES SCHEMA_ROTATION(ID),
    ORDRE NUMBER(2),
    HEURE VARCHAR2(5),
    POIDS NUMBER(3)                  -- Pour rép artition intelligente
);

-- Schémas prédéfinis
INSERT INTO SCHEMA_ROTATION VALUES (1, 'Standard 3x', 'Matin, Midi, Soir', 3, 'EQUIREPARTIE', 1);
INSERT INTO HORAIRE_ROTATION VALUES (1, 1, 1, '08:00', 33);
INSERT INTO HORAIRE_ROTATION VALUES (2, 1, 2, '13:00', 33);
INSERT INTO HORAIRE_ROTATION VALUES (3, 1, 3, '20:00', 34);

INSERT INTO SCHEMA_ROTATION VALUES (2, 'Prime Focus', '2 diffusions en prime time', 2, 'PEAK_FOCUS', 1);
INSERT INTO HORAIRE_ROTATION VALUES (4, 2, 1, '19:30', 50);
INSERT INTO HORAIRE_ROTATION VALUES (5, 2, 2, '21:00', 50);

INSERT INTO SCHEMA_ROTATION VALUES (3, 'Intensif 5x', '5 fois par jour', 5, 'EQUIREPARTIE', 1);
INSERT INTO HORAIRE_ROTATION VALUES (6, 3, 1, '07:00', 20);
INSERT INTO HORAIRE_ROTATION VALUES (7, 3, 2, '10:00', 20);
INSERT INTO HORAIRE_ROTATION VALUES (8, 3, 3, '14:00', 20);
INSERT INTO HORAIRE_ROTATION VALUES (9, 3, 4, '18:00', 20);
INSERT INTO HORAIRE_ROTATION VALUES (10, 3, 5, '22:00', 20);
```

### Code Java

```java
/**
 * Appliquer une rotation d'horaires sur plusieurs dates
 */
public List<ReservationDetails> appliquerRotation(
        Long idreservation,
        Long idschema,
        List<Date> dates
) throws Exception {

    Reservation reservation = em.find(Reservation.class, idreservation);
    SchemaRotation schema = em.find(SchemaRotation.class, idschema);

    if (schema == null || !schema.getActif()) {
        throw new Exception("Schéma de rotation invalide");
    }

    // Récupérer horaires du schéma
    String jpql = "SELECT h FROM HoraireRotation h " +
                 "WHERE h.idschema = :idschema ORDER BY h.ordre";
    List<HoraireRotation> horaires = em.createQuery(jpql, HoraireRotation.class)
                                       .setParameter("idschema", idschema)
                                       .getResultList();

    List<ReservationDetails> nouveauxDetails = new ArrayList<>();

    // Pour chaque date
    for (Date date : dates) {
        // Pour chaque horaire du schéma
        for (HoraireRotation h : horaires) {
            ReservationDetails detail = new ReservationDetails();
            detail.setIdmere(idreservation);
            detail.setIdproduit(reservation.getIdproduit()); // Même produit
            detail.setQte(1.0);
            detail.setDaty(date);
            detail.setHeure(h.getHeure());
            detail.setDuree(reservation.getDuree());
            detail.setIdmedia(reservation.getIdmedia());

            // Calculer prix selon créneau
            CreneauHoraire creneau = trouverCreneau(date, h.getHeure(), reservation.getIdsupport());
            if (creneau != null) {
                detail.setPu(calculerPrixCreneau(creneau.getId(), reservation.getPu()));
            } else {
                detail.setPu(reservation.getPu());
            }

            detail.setRemarque("Rotation " + schema.getNom() + " - Diffusion #" + h.getOrdre());

            em.persist(detail);
            nouveauxDetails.add(detail);
        }
    }

    return nouveauxDetails;
}
```

### JSP - Interface Rotation

```jsp
<!-- Dans reservation-groupe-saisie.jsp - Ajouter option rotation -->

<div class="form-group">
    <label>
        <input type="checkbox" id="activer-rotation">
        Activer rotation d'horaires
    </label>
</div>

<div id="config-rotation" style="display:none;">
    <div class="box box-info">
        <div class="box-header">
            <h4>Configuration Rotation</h4>
        </div>
        <div class="box-body">
            <div class="form-group">
                <label>Schéma de Rotation</label>
                <select id="idschema" class="form-control">
                    <%
                        List<SchemaRotation> schemas = RotationEJBClient.listerSchemas();
                        for (SchemaRotation s : schemas) {
                    %>
                    <option value="<%=s.getId()%>">
                        <%=s.getNom()%> - <%=s.getNbDiffusionsParJour()%> diff/jour
                    </option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div id="preview-rotation"></div>
        </div>
    </div>
</div>

<script>
$('#activer-rotation').on('change', function() {
    if ($(this).is(':checked')) {
        $('#config-rotation').show();
        $('#heure').prop('disabled', true).val('');
    } else {
        $('#config-rotation').hide();
        $('#heure').prop('disabled', false);
    }
});

$('#idschema').on('change', function() {
    var idschema = $(this).val();

    $.ajax({
        url: '../../servlet/reservation/PreviewRotationServlet',
        data: { idschema: idschema },
        success: function(response) {
            var html = '<h5>Aperçu :</h5><ul>';
            response.horaires.forEach(function(h) {
                html += '<li><strong>' + h.heure + '</strong> - ' + h.remarque + '</li>';
            });
            html += '</ul>';
            html += '<p class="text-muted">';
            html += 'Pour chaque date sélectionnée, ' + response.nbDiffusions + ' réservations seront créées';
            html += '</p>';
            $('#preview-rotation').html(html);
        }
    });
});
</script>
```

---

## 📋 RÉSUMÉ TECHNIQUE

### Si on vous demande "Paiement Flexible", implémentez :

**🎯 Priorité 1 (2-3h) :** Plan de Paiement Échelonné
- Tables : `PLAN_PAIEMENT`, `ECHEANCE_PAIEMENT`, `TEMPLATE_PLAN_PAIEMENT`
- EJB : `PlanPaiementEJB.java` avec toutes les méthodes
- Servlets : `CreerPlanPaiementServlet`, `PayerEcheanceServlet`
- JSP : Interface complète avec templates et plan personnalisé

**🎯 Priorité 2 (1h) :** Paiement Mixte
- Modifier table `PAIEMENT`
- Méthode `enregistrerPaiementMixte()`
- Interface multi-modes

### Si on vous demande "Gestion Horaire", implémentez :

**🎯 Priorité 1 (2-3h) :** Système de Créneaux Horaires
- Tables : `CRENEAU_HORAIRE`, `OCCUPATION_CRENEAU`
- EJB : `CreneauHoraireEJB.java` complet
- Intégration dans réservation avec vérification disponibilité
- Planning visuel avec code couleur

**🎯 Priorité 2 (2h) :** Rotation Automatique
- Tables : `SCHEMA_ROTATION`, `HORAIRE_ROTATION`
- Méthode `appliquerRotation()`
- Interface avec templates prédéfinis

---

## 🚀 STRATÉGIE D'IMPLÉMENTATION (3-4h)

### Option A : Focus PAIEMENT (si demandé)
1. **0-30min** : Créer tables SQL, tester connexion
2. **30min-2h** : Coder `PlanPaiementEJB.java` complet
3. **2h-3h** : Servlets et JSP interface
4. **3h-3h30** : Tests et debug
5. **3h30-4h** : Paiement mixte (bonus)

### Option B : Focus HORAIRE (si demandé)
1. **0-30min** : Créer tables créneaux
2. **30min-2h** : Coder `CreneauHoraireEJB.java`
3. **2h-3h** : Intégration dans réservation-saisie.jsp
4. **3h-3h30** : Planning visuel
5. **3h30-4h** : Rotation (bonus)

### Option C : Les DEUX (ambitieux)
1. **0-1h** : Tables + EJB paiement échelonné (simplifié)
2. **1h-2h** : Tables + EJB créneaux horaires (simplifié)
3. **2h-3h** : Interfaces JSP basiques
4. **3h-4h** : Intégration et tests

---

## ✅ CHECKLIST AVANT SESSION

- [ ] Base de données accessible
- [ ] `ant deploy` fonctionne
- [ ] Avoir ce document ouvert
- [ ] Templates servlets/JSP prêts
- [ ] SQL client ouvert (pour créer tables rapidement)
- [ ] Postman ou outil test API

## 🎯 CONSEILS FINAUX

1. **Clarifier immédiatement** : "Paiement flexible" = échelonné ? mixte ? les deux ?
2. **MVP d'abord** : Faire marcher le cas simple avant d'ajouter fonctionnalités
3. **Tester au fur et à mesure** : Ne pas coder 3h sans tester
4. **Commiter régulièrement** : Toutes les 30 min minimum
5. **Interface simple suffit** : Bootstrap basique, pas besoin d'animations
6. **Gérer les erreurs** : try/catch partout, messages clairs

**Bonne chance ! 🍀**
