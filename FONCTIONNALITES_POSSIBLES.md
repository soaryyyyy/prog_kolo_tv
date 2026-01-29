# Fonctionnalités Possibles à Implémenter (3-4h)

## Guide de Préparation pour Session Imprévisible

Ce document liste les fonctionnalités qui pourraient vous être demandées lors de la session de développement, organisées par module et complexité.

**Légende Complexité :**
- 🟢 FACILE (1-2h) - Modification mineure, peu de fichiers
- 🟡 MOYEN (2-3h) - Logique métier simple, plusieurs fichiers
- 🟠 AVANCÉ (3-4h) - Logique complexe, base de données + backend + frontend
- 🔴 DIFFICILE (4h+) - Architecture complète, risqué en 4h

---

## MODULE RÉSERVATION (Priorité Haute)

### 1. Gestion des Conflits de Planning 🟡 (2-3h)
**Problème** : Deux réservations au même créneau horaire (même date, même heure, même support)

**Ce qui sera demandé** :
- Détecter automatiquement les conflits lors de la création/modification
- Afficher une alerte visuelle
- Proposer des créneaux alternatifs

**Fichiers à modifier** :
- `kolotv-ejb/src/java/reservation/ReservationEJB.java`
- `kolotv-war/web/pages/reservation/reservation-saisie.jsp`
- `kolotv-war/web/pages/reservation/reservation-groupe-saisie.jsp`

**Code à ajouter** :

```java
// Dans ReservationEJB.java

public List<ReservationDetails> verifierConflits(Date date, String heure, Long idsupport) {
    String jpql = "SELECT rd FROM ReservationDetails rd " +
                  "JOIN rd.reservation r " +
                  "WHERE rd.daty = :date " +
                  "AND rd.heure = :heure " +
                  "AND r.idsupport = :idsupport " +
                  "AND r.etat != 3"; // 3 = Annulé

    return em.createQuery(jpql, ReservationDetails.class)
             .setParameter("date", date)
             .setParameter("heure", heure)
             .setParameter("idsupport", idsupport)
             .getResultList();
}

public List<String> proposerCreneauxAlternatifs(Date date, Long idsupport) {
    List<String> creneauxOccupes = new ArrayList<>();

    // Récupérer tous les créneaux occupés
    String jpql = "SELECT DISTINCT rd.heure FROM ReservationDetails rd " +
                  "JOIN rd.reservation r " +
                  "WHERE rd.daty = :date AND r.idsupport = :idsupport";

    creneauxOccupes = em.createQuery(jpql, String.class)
                        .setParameter("date", date)
                        .setParameter("idsupport", idsupport)
                        .getResultList();

    // Créneaux standards (30 min d'intervalle)
    List<String> tousCreneaux = new ArrayList<>();
    for (int h = 6; h < 24; h++) {
        for (int m : new int[]{0, 30}) {
            tousCreneaux.add(String.format("%02d:%02d", h, m));
        }
    }

    // Retourner créneaux disponibles
    tousCreneaux.removeAll(creneauxOccupes);
    return tousCreneaux;
}

// Modifier la méthode creer() pour vérifier
public Reservation creer(Reservation reservation) throws ConflitPlanningException {
    // Vérifier chaque détail
    for (ReservationDetails detail : reservation.getDetails()) {
        List<ReservationDetails> conflits = verifierConflits(
            detail.getDaty(),
            detail.getHeure(),
            reservation.getIdsupport()
        );

        if (!conflits.isEmpty()) {
            throw new ConflitPlanningException(
                "Conflit détecté le " + detail.getDaty() +
                " à " + detail.getHeure(),
                conflits
            );
        }
    }

    // Suite de la création...
    em.persist(reservation);
    return reservation;
}
```

```java
// Créer ConflitPlanningException.java
package reservation;

public class ConflitPlanningException extends Exception {
    private List<ReservationDetails> conflits;

    public ConflitPlanningException(String message, List<ReservationDetails> conflits) {
        super(message);
        this.conflits = conflits;
    }

    public List<ReservationDetails> getConflits() {
        return conflits;
    }
}
```

```jsp
<!-- Dans reservation-saisie.jsp - Ajouter validation AJAX -->
<script>
$('#heure, #daty, #idsupport').on('change', function() {
    var date = $('#daty').val();
    var heure = $('#heure').val();
    var support = $('#idsupport').val();

    if (date && heure && support) {
        $.ajax({
            url: '../../servlet/reservation/VerifierConflitServlet',
            method: 'POST',
            data: { date: date, heure: heure, idsupport: support },
            success: function(response) {
                if (response.conflit) {
                    // Afficher alerte
                    $('#alert-conflit').html(
                        '<div class="alert alert-danger">' +
                        '<strong>CONFLIT !</strong> Ce créneau est déjà réservé.<br>' +
                        'Réservations existantes : ' + response.conflits.length +
                        '<br><a href="#" onclick="afficherAlternatifs()">Voir créneaux disponibles</a>' +
                        '</div>'
                    ).show();
                } else {
                    $('#alert-conflit').hide();
                }
            }
        });
    }
});

function afficherAlternatifs() {
    var date = $('#daty').val();
    var support = $('#idsupport').val();

    $.ajax({
        url: '../../servlet/reservation/CreneauxAlternatifsServlet',
        method: 'POST',
        data: { date: date, idsupport: support },
        success: function(response) {
            var html = '<h4>Créneaux disponibles :</h4><ul>';
            response.creneaux.forEach(function(creneau) {
                html += '<li><a href="#" onclick="selectCreneau(\'' + creneau + '\')">' +
                        creneau + '</a></li>';
            });
            html += '</ul>';
            $('#creneaux-alternatifs').html(html).show();
        }
    });
}

function selectCreneau(heure) {
    $('#heure').val(heure);
    $('#creneaux-alternatifs').hide();
    $('#alert-conflit').hide();
}
</script>

<div id="alert-conflit" style="display:none;"></div>
<div id="creneaux-alternatifs" style="display:none;"></div>
```

---

### 2. Système de Tarification Dégressive Automatique 🟡 (2h)
**Problème** : Appliquer automatiquement des remises selon le volume

**Ce qui sera demandé** :
- X spots → Y% de remise
- Calcul automatique lors de la saisie
- Affichage prix avant/après remise

**Tables à créer** :
```sql
CREATE TABLE GRILLE_TARIFAIRE (
    ID NUMBER PRIMARY KEY,
    IDPRODUIT NUMBER REFERENCES AS_INGREDIENTS(ID),
    QUANTITE_MIN NUMBER,
    QUANTITE_MAX NUMBER,
    REMISE_POURCENT NUMBER(5,2),
    ACTIF NUMBER(1) DEFAULT 1
);

-- Exemple de données
INSERT INTO GRILLE_TARIFAIRE VALUES (1, 100, 1, 5, 0, 1);      -- 1-5 spots: 0%
INSERT INTO GRILLE_TARIFAIRE VALUES (2, 100, 6, 10, 5, 1);     -- 6-10 spots: 5%
INSERT INTO GRILLE_TARIFAIRE VALUES (3, 100, 11, 20, 10, 1);   -- 11-20 spots: 10%
INSERT INTO GRILLE_TARIFAIRE VALUES (4, 100, 21, 999, 15, 1);  -- 21+ spots: 15%
```

**Code Java** :
```java
// Créer GrilleTarifaire.java
public class GrilleTarifaire {
    private Long id;
    private Long idproduit;
    private Integer quantiteMin;
    private Integer quantiteMax;
    private Double remisePourcent;
    private Boolean actif;

    // Getters/Setters
}

// Dans ReservationEJB.java
public Double calculerPrixAvecRemise(Long idproduit, Integer quantite, Double prixUnitaire) {
    String jpql = "SELECT g FROM GrilleTarifaire g " +
                  "WHERE g.idproduit = :idproduit " +
                  "AND :quantite BETWEEN g.quantiteMin AND g.quantiteMax " +
                  "AND g.actif = true";

    try {
        GrilleTarifaire grille = em.createQuery(jpql, GrilleTarifaire.class)
                                   .setParameter("idproduit", idproduit)
                                   .setParameter("quantite", quantite)
                                   .getSingleResult();

        Double remise = grille.getRemisePourcent();
        Double prixRemise = prixUnitaire * (1 - remise / 100);

        return prixRemise;
    } catch (NoResultException e) {
        return prixUnitaire; // Pas de remise applicable
    }
}

// Dans la création de réservation
for (ReservationDetails detail : reservation.getDetails()) {
    // Compter le nombre total de spots pour ce produit
    Integer totalSpots = reservation.getDetails().stream()
        .filter(d -> d.getIdproduit().equals(detail.getIdproduit()))
        .mapToInt(d -> d.getQte().intValue())
        .sum();

    // Calculer prix avec remise
    Double prixRemise = calculerPrixAvecRemise(
        detail.getIdproduit(),
        totalSpots,
        detail.getPu()
    );

    detail.setPu(prixRemise); // Appliquer le nouveau prix
}
```

**JSP** :
```jsp
<script>
function calculerRemise() {
    var idproduit = $('#idproduit').val();
    var totalSpots = 0;

    // Compter spots dans le formulaire (si multi-lignes)
    $('.ligne-reservation').each(function() {
        if ($(this).find('.produit').val() == idproduit) {
            totalSpots += parseInt($(this).find('.quantite').val() || 0);
        }
    });

    $.ajax({
        url: '../../servlet/reservation/CalculerRemiseServlet',
        data: { idproduit: idproduit, quantite: totalSpots },
        success: function(response) {
            if (response.remise > 0) {
                $('#info-remise').html(
                    '<span class="text-success">' +
                    'Remise appliquée : ' + response.remise + '%<br>' +
                    'Prix avant remise : ' + response.prixAvant + ' Ar<br>' +
                    'Prix après remise : ' + response.prixApres + ' Ar<br>' +
                    '<strong>Économie : ' + response.economie + ' Ar</strong>' +
                    '</span>'
                ).show();
            }
        }
    });
}

$('.quantite, .produit').on('change', calculerRemise);
</script>

<div id="info-remise" style="display:none;"></div>
```

---

### 3. Notifications Automatiques Avant Diffusion 🟠 (3h)
**Problème** : Envoyer des rappels automatiques X heures avant la diffusion

**Tables à créer** :
```sql
CREATE TABLE NOTIFICATION (
    ID NUMBER PRIMARY KEY,
    TYPE VARCHAR2(50),           -- 'RAPPEL_DIFFUSION', 'FACTURE_ECHEANCE', etc.
    DESTINATAIRE VARCHAR2(200),  -- Email ou téléphone
    TITRE VARCHAR2(200),
    MESSAGE CLOB,
    DATY DATE,
    HEURE VARCHAR2(5),
    STATUT VARCHAR2(20),         -- 'EN_ATTENTE', 'ENVOYE', 'ERREUR'
    IDREFERENCE NUMBER,          -- ID de la réservation, facture, etc.
    DATE_ENVOI TIMESTAMP
);

CREATE TABLE PARAMETRAGE_NOTIFICATION (
    ID NUMBER PRIMARY KEY,
    TYPE VARCHAR2(50),
    DELAI_HEURES NUMBER,         -- Combien d'heures avant
    ACTIF NUMBER(1) DEFAULT 1,
    DESTINATAIRES VARCHAR2(500)  -- Emails séparés par virgule
);

-- Exemple
INSERT INTO PARAMETRAGE_NOTIFICATION
VALUES (1, 'RAPPEL_DIFFUSION', 24, 1, 'diffusion@kolotv.mg,technique@kolotv.mg');
```

**Code Java** :
```java
// Créer NotificationEJB.java
@Stateless
public class NotificationEJB {

    @PersistenceContext
    private EntityManager em;

    @Schedule(hour = "*", minute = "*/15") // Toutes les 15 minutes
    public void verifierNotificationsAEnvoyer() {
        // Récupérer paramétrage
        ParametrageNotification param = em.find(ParametrageNotification.class, 1L);

        if (!param.getActif()) return;

        // Date limite = maintenant + délai
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.HOUR, param.getDelaiHeures());
        Date dateLimite = cal.getTime();

        // Récupérer réservations à venir
        String jpql = "SELECT rd FROM ReservationDetails rd " +
                     "WHERE rd.daty BETWEEN :maintenant AND :limite " +
                     "AND rd.notificationEnvoyee = false";

        List<ReservationDetails> aNotifier = em.createQuery(jpql, ReservationDetails.class)
            .setParameter("maintenant", new Date())
            .setParameter("limite", dateLimite)
            .getResultList();

        // Créer notifications
        for (ReservationDetails detail : aNotifier) {
            creerNotification(detail);
            detail.setNotificationEnvoyee(true);
        }
    }

    private void creerNotification(ReservationDetails detail) {
        Notification notif = new Notification();
        notif.setType("RAPPEL_DIFFUSION");

        Reservation res = detail.getReservation();
        Client client = em.find(Client.class, res.getIdclient());

        notif.setDestinataire(client.getEmail());
        notif.setTitre("Rappel : Diffusion programmée demain");

        String message = String.format(
            "Bonjour,\n\n" +
            "Nous vous rappelons que votre spot publicitaire sera diffusé :\n\n" +
            "Date : %s\n" +
            "Heure : %s\n" +
            "Durée : %d secondes\n" +
            "Support : %s\n\n" +
            "Cordialement,\n" +
            "L'équipe KoloTV",
            detail.getDaty(),
            detail.getHeure(),
            detail.getDuree().intValue(),
            res.getSupport().getLibelle()
        );

        notif.setMessage(message);
        notif.setDaty(new Date());
        notif.setStatut("EN_ATTENTE");
        notif.setIdreference(detail.getId());

        em.persist(notif);

        // Envoyer immédiatement
        envoyerEmail(notif);
    }

    private void envoyerEmail(Notification notif) {
        try {
            // Configuration JavaMail
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Session session = Session.getInstance(props, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(
                        "votre_email@kolotv.mg",
                        "votre_mot_de_passe"
                    );
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("noreply@kolotv.mg"));
            message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(notif.getDestinataire())
            );
            message.setSubject(notif.getTitre());
            message.setText(notif.getMessage());

            Transport.send(message);

            notif.setStatut("ENVOYE");
            notif.setDateEnvoi(new Timestamp(System.currentTimeMillis()));

        } catch (Exception e) {
            notif.setStatut("ERREUR");
            e.printStackTrace();
        }

        em.merge(notif);
    }
}
```

**Ajouter colonne** :
```sql
ALTER TABLE RESERVATIONDETAILS ADD NOTIFICATION_ENVOYEE NUMBER(1) DEFAULT 0;
```

---

### 4. Export Planning PDF avec Vue Calendrier 🟢 (1-2h)
**Problème** : Générer un PDF du planning hebdomadaire/mensuel

**Code Java** :
```java
// Créer ExportPlanningServlet.java
@WebServlet("/servlet/reservation/ExportPlanningPDFServlet")
public class ExportPlanningPDFServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String periode = request.getParameter("periode"); // 'semaine' ou 'mois'
        String dateDebut = request.getParameter("dateDebut");

        try {
            // Récupérer données
            ReservationEJB ejb = ReservationEJBClient.lookupReservationEJBBeanLocal();
            List<ReservationDetails> reservations = ejb.listerParPeriode(
                parseDate(dateDebut),
                calculerDateFin(dateDebut, periode)
            );

            // Générer PDF
            Document document = new Document(PageSize.A4.rotate()); // Paysage
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter.getInstance(document, baos);

            document.open();

            // Titre
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
            Paragraph title = new Paragraph("Planning des Diffusions", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            document.add(new Paragraph(" ")); // Espace

            // Tableau planning
            PdfPTable table = new PdfPTable(8); // Heure + 7 jours
            table.setWidthPercentage(100);

            // En-têtes
            table.addCell("Heure");
            String[] jours = {"Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi", "Dimanche"};
            for (String jour : jours) {
                PdfPCell cell = new PdfPCell(new Phrase(jour));
                cell.setBackgroundColor(BaseColor.LIGHT_GRAY);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);
            }

            // Créer grille horaire
            for (int h = 6; h < 24; h++) {
                for (int m : new int[]{0, 30}) {
                    String heure = String.format("%02d:%02d", h, m);
                    table.addCell(heure);

                    // Pour chaque jour de la semaine
                    Calendar cal = Calendar.getInstance();
                    cal.setTime(parseDate(dateDebut));

                    for (int j = 0; j < 7; j++) {
                        // Chercher réservations à cette heure ce jour
                        final Date jourCourant = cal.getTime();
                        final String heureCourante = heure;

                        List<ReservationDetails> resJour = reservations.stream()
                            .filter(r -> isSameDay(r.getDaty(), jourCourant) &&
                                        r.getHeure().equals(heureCourante))
                            .collect(Collectors.toList());

                        PdfPCell cell = new PdfPCell();

                        if (!resJour.isEmpty()) {
                            // Afficher infos réservation
                            StringBuilder sb = new StringBuilder();
                            for (ReservationDetails res : resJour) {
                                Client client = ejb.getClient(res.getReservation().getIdclient());
                                sb.append(client.getNom()).append("\n");
                                sb.append(res.getDuree().intValue()).append("s\n");
                            }
                            cell.setPhrase(new Phrase(sb.toString(), new Font(Font.FontFamily.HELVETICA, 8)));
                            cell.setBackgroundColor(BaseColor.YELLOW);
                        }

                        table.addCell(cell);
                        cal.add(Calendar.DAY_OF_MONTH, 1);
                    }
                }
            }

            document.add(table);
            document.close();

            // Envoyer PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition",
                "attachment; filename=planning_" + dateDebut + ".pdf");
            response.setContentLength(baos.size());

            OutputStream os = response.getOutputStream();
            baos.writeTo(os);
            os.flush();
            os.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
```

**Bouton dans JSP** :
```jsp
<a href="../../servlet/reservation/ExportPlanningPDFServlet?periode=semaine&dateDebut=2026-01-27"
   class="btn btn-primary" target="_blank">
    <i class="fa fa-file-pdf-o"></i> Exporter Planning PDF
</a>
```

---

## MODULE VENTE / FACTURATION (Priorité Haute)

### 5. Transformation Automatique Devis → BC → Facture 🟡 (2-3h)
**Problème** : Workflow automatisé de transformation

**Tables à créer** :
```sql
CREATE TABLE DEVIS (
    ID NUMBER PRIMARY KEY,
    IDCLIENT NUMBER REFERENCES CLIENT(ID),
    DATY DATE,
    REFERENCE VARCHAR2(50),
    VALIDITE_JOURS NUMBER DEFAULT 30,
    ETAT VARCHAR2(20),           -- 'EN_ATTENTE', 'ACCEPTE', 'REFUSE', 'EXPIRE'
    TOTALHT NUMBER(15,2),
    TOTALTVA NUMBER(15,2),
    TOTALTTC NUMBER(15,2),
    DATE_ACCEPTATION DATE,
    IDBC NUMBER REFERENCES BONDECOMMANDE(ID),  -- Lien si transformé
    IDFACTURE NUMBER REFERENCES FACTURE(ID)
);

CREATE TABLE DEVISFILLE (
    ID NUMBER PRIMARY KEY,
    IDMERE NUMBER REFERENCES DEVIS(ID),
    IDPRODUIT NUMBER REFERENCES AS_INGREDIENTS(ID),
    QTE NUMBER(10,2),
    PU NUMBER(15,2),
    REMISE NUMBER(5,2),
    TVA NUMBER(5,2)
);
```

**Code Java** :
```java
// Dans VenteEJB.java

public BonDeCommande transformerDevisEnBC(Long idDevis) throws Exception {
    Devis devis = em.find(Devis.class, idDevis);

    if (!"ACCEPTE".equals(devis.getEtat())) {
        throw new Exception("Le devis doit être accepté pour être transformé");
    }

    if (devis.getIdbc() != null) {
        throw new Exception("Ce devis a déjà été transformé");
    }

    // Créer BC
    BonDeCommande bc = new BonDeCommande();
    bc.setIdclient(devis.getIdclient());
    bc.setDaty(new Date());
    bc.setReference("BC-" + System.currentTimeMillis());
    bc.setEtat(1); // Validé

    // Copier lignes
    for (DevisFille ligneDevis : devis.getLignes()) {
        BonDeCommandeFille ligneBC = new BonDeCommandeFille();
        ligneBC.setIdproduit(ligneDevis.getIdproduit());
        ligneBC.setQte(ligneDevis.getQte());
        ligneBC.setPu(ligneDevis.getPu());
        ligneBC.setRemise(ligneDevis.getRemise());
        ligneBC.setTva(ligneDevis.getTva());

        bc.addLigne(ligneBC);
    }

    bc.calculerTotaux();
    em.persist(bc);

    // Mettre à jour devis
    devis.setIdbc(bc.getId());
    em.merge(devis);

    return bc;
}

public Facture transformerBCEnFacture(Long idBC) throws Exception {
    BonDeCommande bc = em.find(BonDeCommande.class, idBC);

    if (bc.getEtat() != 1) {
        throw new Exception("Le bon de commande doit être validé");
    }

    // Vérifier si déjà facturé
    String jpql = "SELECT COUNT(f) FROM Facture f WHERE f.idbc = :idbc";
    Long count = em.createQuery(jpql, Long.class)
                   .setParameter("idbc", idBC)
                   .getSingleResult();

    if (count > 0) {
        throw new Exception("Ce bon de commande est déjà facturé");
    }

    // Créer facture
    Facture facture = new Facture();
    facture.setIdclient(bc.getIdclient());
    facture.setIdbc(idBC);
    facture.setDaty(new Date());
    facture.setReference(genererNumeroFacture());
    facture.setEtat("EMISE");

    // Calculer échéance (30 jours par défaut)
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DAY_OF_MONTH, 30);
    facture.setDateEcheance(cal.getTime());

    // Copier lignes
    for (BonDeCommandeFille ligneBC : bc.getLignes()) {
        FactureFille ligneFacture = new FactureFille();
        ligneFacture.setIdproduit(ligneBC.getIdproduit());
        ligneFacture.setQte(ligneBC.getQte());
        ligneFacture.setPu(ligneBC.getPu());
        ligneFacture.setRemise(ligneBC.getRemise());
        ligneFacture.setTva(ligneBC.getTva());

        facture.addLigne(ligneFacture);
    }

    facture.calculerTotaux();
    em.persist(facture);

    // Mettre à jour BC
    bc.setEtat(2); // Facturé
    em.merge(bc);

    return facture;
}

private String genererNumeroFacture() {
    // Format : FAC-2026-00001
    int annee = Calendar.getInstance().get(Calendar.YEAR);

    String jpql = "SELECT MAX(f.numero) FROM Facture f " +
                  "WHERE f.daty >= :debutAnnee";

    Calendar cal = Calendar.getInstance();
    cal.set(Calendar.MONTH, Calendar.JANUARY);
    cal.set(Calendar.DAY_OF_MONTH, 1);

    Integer maxNumero = em.createQuery(jpql, Integer.class)
                         .setParameter("debutAnnee", cal.getTime())
                         .getSingleResult();

    int prochain = (maxNumero != null) ? maxNumero + 1 : 1;

    return String.format("FAC-%d-%05d", annee, prochain);
}
```

**JSP - Boutons d'action** :
```jsp
<!-- Dans bondecommande-liste.jsp -->
<c:if test="${bc.etat == 1}">
    <button onclick="transformerEnFacture(${bc.id})" class="btn btn-success btn-sm">
        <i class="fa fa-file-text"></i> Créer Facture
    </button>
</c:if>

<script>
function transformerEnFacture(idBC) {
    if (confirm('Voulez-vous créer une facture depuis ce bon de commande ?')) {
        $.ajax({
            url: '../../servlet/vente/TransformerBCEnFactureServlet',
            method: 'POST',
            data: { idbc: idBC },
            success: function(response) {
                alert('Facture créée avec succès : ' + response.reference);
                location.href = '../facture/facture-fiche.jsp?id=' + response.id;
            },
            error: function(xhr) {
                alert('Erreur : ' + xhr.responseJSON.message);
            }
        });
    }
}
</script>
```

---

### 6. Gestion des Acomptes et Paiements Partiels 🟡 (2-3h)
**Problème** : Suivre les paiements partiels d'une facture

**Tables** :
```sql
CREATE TABLE PAIEMENT (
    ID NUMBER PRIMARY KEY,
    IDFACTURE NUMBER REFERENCES FACTURE(ID),
    DATY DATE,
    MONTANT NUMBER(15,2),
    MODEPAIEMENT VARCHAR2(50),   -- 'ESPECE', 'CHEQUE', 'VIREMENT', 'MOBILE_MONEY'
    REFERENCE VARCHAR2(100),     -- Numéro chèque, référence virement
    REMARQUE VARCHAR2(500)
);

ALTER TABLE FACTURE ADD MONTANT_PAYE NUMBER(15,2) DEFAULT 0;
ALTER TABLE FACTURE ADD SOLDE_RESTANT NUMBER(15,2);
ALTER TABLE FACTURE ADD STATUT_PAIEMENT VARCHAR2(20); -- 'NON_PAYE', 'PARTIEL', 'PAYE'
```

**Code Java** :
```java
// Créer Paiement.java
public class Paiement {
    private Long id;
    private Long idfacture;
    private Date daty;
    private Double montant;
    private String modepaiement;
    private String reference;
    private String remarque;

    // Getters/Setters
}

// Dans FactureEJB.java
public Paiement enregistrerPaiement(Long idfacture, Double montant,
                                    String modePaiement, String reference) throws Exception {

    Facture facture = em.find(Facture.class, idfacture);

    if (facture == null) {
        throw new Exception("Facture introuvable");
    }

    // Vérifier que le montant ne dépasse pas le solde
    Double soldeRestant = facture.getSoldeRestant();
    if (montant > soldeRestant) {
        throw new Exception("Le montant (" + montant + ") dépasse le solde restant (" + soldeRestant + ")");
    }

    // Créer paiement
    Paiement paiement = new Paiement();
    paiement.setIdfacture(idfacture);
    paiement.setDaty(new Date());
    paiement.setMontant(montant);
    paiement.setModepaiement(modePaiement);
    paiement.setReference(reference);

    em.persist(paiement);

    // Mettre à jour facture
    Double nouveauMontantPaye = facture.getMontantPaye() + montant;
    Double nouveauSolde = facture.getTotalttc() - nouveauMontantPaye;

    facture.setMontantPaye(nouveauMontantPaye);
    facture.setSoldeRestant(nouveauSolde);

    if (nouveauSolde <= 0.01) { // Tolérance pour les arrondis
        facture.setStatutPaiement("PAYE");
        facture.setDatePaiement(new Date());
    } else {
        facture.setStatutPaiement("PARTIEL");
    }

    em.merge(facture);

    // Créer écriture comptable
    creerEcritureComptablePaiement(facture, paiement);

    return paiement;
}

public List<Paiement> listerPaiements(Long idfacture) {
    String jpql = "SELECT p FROM Paiement p WHERE p.idfacture = :idfacture ORDER BY p.daty DESC";
    return em.createQuery(jpql, Paiement.class)
             .setParameter("idfacture", idfacture)
             .getResultList();
}

public Double calculerSoldeFacture(Long idfacture) {
    Facture facture = em.find(Facture.class, idfacture);

    String jpql = "SELECT COALESCE(SUM(p.montant), 0) FROM Paiement p WHERE p.idfacture = :idfacture";
    Double totalPaye = em.createQuery(jpql, Double.class)
                         .setParameter("idfacture", idfacture)
                         .getSingleResult();

    return facture.getTotalttc() - totalPaye;
}
```

**JSP - Interface paiement** :
```jsp
<!-- Dans facture-fiche.jsp -->
<div class="box box-success">
    <div class="box-header">
        <h3 class="box-title">Paiements</h3>
    </div>
    <div class="box-body">
        <div class="row">
            <div class="col-md-4">
                <div class="info-box bg-aqua">
                    <span class="info-box-icon"><i class="fa fa-money"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Total Facture</span>
                        <span class="info-box-number"><%=facture.getTotalttc()%> Ar</span>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="info-box bg-green">
                    <span class="info-box-icon"><i class="fa fa-check"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Montant Payé</span>
                        <span class="info-box-number"><%=facture.getMontantPaye()%> Ar</span>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="info-box bg-yellow">
                    <span class="info-box-icon"><i class="fa fa-clock-o"></i></span>
                    <div class="info-box-content">
                        <span class="info-box-text">Solde Restant</span>
                        <span class="info-box-number"><%=facture.getSoldeRestant()%> Ar</span>
                    </div>
                </div>
            </div>
        </div>

        <% if (facture.getSoldeRestant() > 0) { %>
        <button class="btn btn-primary" data-toggle="modal" data-target="#modalPaiement">
            <i class="fa fa-plus"></i> Enregistrer un Paiement
        </button>
        <% } %>

        <!-- Historique des paiements -->
        <h4 class="mt-3">Historique des Paiements</h4>
        <table class="table table-striped">
            <thead>
                <tr>
                    <th>Date</th>
                    <th>Montant</th>
                    <th>Mode</th>
                    <th>Référence</th>
                    <th>Remarque</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Paiement> paiements = FactureEJBClient.listerPaiements(facture.getId());
                    for (Paiement p : paiements) {
                %>
                <tr>
                    <td><%=formatDate(p.getDaty())%></td>
                    <td><strong><%=p.getMontant()%> Ar</strong></td>
                    <td><%=p.getModepaiement()%></td>
                    <td><%=p.getReference()%></td>
                    <td><%=p.getRemarque()%></td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Modal Paiement -->
<div class="modal fade" id="modalPaiement">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Enregistrer un Paiement</h4>
            </div>
            <form id="formPaiement">
                <input type="hidden" name="idfacture" value="<%=facture.getId()%>">

                <div class="modal-body">
                    <div class="form-group">
                        <label>Montant</label>
                        <input type="number" name="montant" class="form-control"
                               step="0.01" max="<%=facture.getSoldeRestant()%>" required>
                        <small class="text-muted">Maximum : <%=facture.getSoldeRestant()%> Ar</small>
                    </div>

                    <div class="form-group">
                        <label>Mode de Paiement</label>
                        <select name="modepaiement" class="form-control" required>
                            <option value="ESPECE">Espèces</option>
                            <option value="CHEQUE">Chèque</option>
                            <option value="VIREMENT">Virement Bancaire</option>
                            <option value="MOBILE_MONEY">Mobile Money</option>
                            <option value="CARTE">Carte Bancaire</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Référence (N° Chèque, N° Transaction...)</label>
                        <input type="text" name="reference" class="form-control">
                    </div>

                    <div class="form-group">
                        <label>Remarque</label>
                        <textarea name="remarque" class="form-control" rows="2"></textarea>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
$('#formPaiement').on('submit', function(e) {
    e.preventDefault();

    $.ajax({
        url: '../../servlet/facture/EnregistrerPaiementServlet',
        method: 'POST',
        data: $(this).serialize(),
        success: function(response) {
            alert('Paiement enregistré avec succès');
            location.reload();
        },
        error: function(xhr) {
            alert('Erreur : ' + xhr.responseJSON.message);
        }
    });
});
</script>
```

---

### 7. Relance Automatique Factures Impayées 🟠 (3h)
**Problème** : Envoyer automatiquement des emails de relance

**Tables** :
```sql
CREATE TABLE RELANCE (
    ID NUMBER PRIMARY KEY,
    IDFACTURE NUMBER REFERENCES FACTURE(ID),
    NIVEAU NUMBER,               -- 1=Première, 2=Deuxième, 3=Dernière/Mise en demeure
    DATY DATE,
    TYPE VARCHAR2(50),           -- 'EMAIL', 'SMS', 'COURRIER'
    DESTINATAIRE VARCHAR2(200),
    MESSAGE CLOB,
    STATUT VARCHAR2(20)          -- 'ENVOYE', 'ERREUR'
);

CREATE TABLE PARAMETRAGE_RELANCE (
    ID NUMBER PRIMARY KEY,
    NIVEAU NUMBER,
    DELAI_JOURS_APRES_ECHEANCE NUMBER,
    MODELE_MESSAGE CLOB,
    ACTIF NUMBER(1) DEFAULT 1
);

-- Configuration par défaut
INSERT INTO PARAMETRAGE_RELANCE VALUES (1, 1, 7,
    'Bonjour,\n\nVotre facture {NUMERO} d''un montant de {MONTANT} Ar est échue depuis le {ECHEANCE}.\n\nMerci de régulariser votre situation.',
    1);
INSERT INTO PARAMETRAGE_RELANCE VALUES (2, 2, 15,
    'RELANCE : Votre facture {NUMERO} ({MONTANT} Ar) est toujours impayée.\n\nMerci de nous contacter rapidement.',
    1);
INSERT INTO PARAMETRAGE_RELANCE VALUES (3, 3, 30,
    'DERNIERE RELANCE : Facture {NUMERO} ({MONTANT} Ar) impayée.\n\nSans règlement sous 48h, nous serons contraints de suspendre nos services.',
    1);
```

**Code Java** :
```java
// Dans FactureEJB.java

@Schedule(hour = "9", minute = "0") // Tous les jours à 9h
public void verifierFacturesARelancer() {
    List<Facture> factures = listerFacturesImpayees();

    for (Facture facture : factures) {
        verifierEtEnvoyerRelance(facture);
    }
}

private List<Facture> listerFacturesImpayees() {
    String jpql = "SELECT f FROM Facture f " +
                  "WHERE f.statutPaiement IN ('NON_PAYE', 'PARTIEL') " +
                  "AND f.dateEcheance < :maintenant";

    return em.createQuery(jpql, Facture.class)
             .setParameter("maintenant", new Date())
             .getResultList();
}

private void verifierEtEnvoyerRelance(Facture facture) {
    // Calculer nombre de jours depuis échéance
    long diff = System.currentTimeMillis() - facture.getDateEcheance().getTime();
    int joursRetard = (int) (diff / (24 * 60 * 60 * 1000));

    // Déterminer niveau de relance à envoyer
    List<ParametrageRelance> parametrages = em.createQuery(
        "SELECT p FROM ParametrageRelance p WHERE p.actif = true ORDER BY p.niveau",
        ParametrageRelance.class
    ).getResultList();

    for (ParametrageRelance param : parametrages) {
        if (joursRetard >= param.getDelaiJoursApresEcheance()) {
            // Vérifier si ce niveau n'a pas déjà été envoyé
            Long count = em.createQuery(
                "SELECT COUNT(r) FROM Relance r " +
                "WHERE r.idfacture = :idfacture AND r.niveau = :niveau",
                Long.class
            )
            .setParameter("idfacture", facture.getId())
            .setParameter("niveau", param.getNiveau())
            .getSingleResult();

            if (count == 0) {
                envoyerRelance(facture, param);
            }
        }
    }
}

private void envoyerRelance(Facture facture, ParametrageRelance param) {
    Client client = em.find(Client.class, facture.getIdclient());

    // Préparer message
    String message = param.getModeleMessage()
        .replace("{NUMERO}", facture.getReference())
        .replace("{MONTANT}", facture.getSoldeRestant().toString())
        .replace("{ECHEANCE}", formatDate(facture.getDateEcheance()))
        .replace("{CLIENT}", client.getNom());

    // Créer relance
    Relance relance = new Relance();
    relance.setIdfacture(facture.getId());
    relance.setNiveau(param.getNiveau());
    relance.setDaty(new Date());
    relance.setType("EMAIL");
    relance.setDestinataire(client.getEmail());
    relance.setMessage(message);

    try {
        // Envoyer email
        envoyerEmailRelance(client.getEmail(),
            "Relance Facture " + facture.getReference(),
            message
        );

        relance.setStatut("ENVOYE");
    } catch (Exception e) {
        relance.setStatut("ERREUR");
        e.printStackTrace();
    }

    em.persist(relance);
}
```

---

### 8. Tableau de Bord Statistiques Ventes 🟢 (1-2h)
**Problème** : Afficher KPIs et graphiques

**JSP** :
```jsp
<!-- dashboard-ventes.jsp -->
<%@ page import="vente.*, java.util.*" %>

<div class="row">
    <!-- CA du mois -->
    <div class="col-lg-3 col-xs-6">
        <div class="small-box bg-aqua">
            <div class="inner">
                <%
                    Double caMois = VenteEJBClient.calculerCAMois();
                %>
                <h3><%=String.format("%.0f", caMois)%> Ar</h3>
                <p>CA du Mois</p>
            </div>
            <div class="icon">
                <i class="fa fa-money"></i>
            </div>
        </div>
    </div>

    <!-- Factures impayées -->
    <div class="col-lg-3 col-xs-6">
        <div class="small-box bg-red">
            <div class="inner">
                <%
                    Integer nbImpayees = FactureEJBClient.compterFacturesImpayees();
                    Double montantImpaye = FactureEJBClient.calculerMontantImpaye();
                %>
                <h3><%=nbImpayees%></h3>
                <p>Factures Impayées (<%=String.format("%.0f", montantImpaye)%> Ar)</p>
            </div>
            <div class="icon">
                <i class="fa fa-exclamation-triangle"></i>
            </div>
        </div>
    </div>

    <!-- Réservations du jour -->
    <div class="col-lg-3 col-xs-6">
        <div class="small-box bg-green">
            <div class="inner">
                <%
                    Integer nbResaJour = ReservationEJBClient.compterReservationsDuJour();
                %>
                <h3><%=nbResaJour%></h3>
                <p>Réservations Aujourd'hui</p>
            </div>
            <div class="icon">
                <i class="fa fa-calendar"></i>
            </div>
        </div>
    </div>

    <!-- Nouveaux clients -->
    <div class="col-lg-3 col-xs-6">
        <div class="small-box bg-yellow">
            <div class="inner">
                <%
                    Integer nbNouveauxClients = ClientEJBClient.compterNouveauxClientsMois();
                %>
                <h3><%=nbNouveauxClients%></h3>
                <p>Nouveaux Clients ce Mois</p>
            </div>
            <div class="icon">
                <i class="fa fa-users"></i>
            </div>
        </div>
    </div>
</div>

<!-- Graphique CA mensuel -->
<div class="row">
    <div class="col-md-8">
        <div class="box box-primary">
            <div class="box-header">
                <h3 class="box-title">Évolution du CA (12 derniers mois)</h3>
            </div>
            <div class="box-body">
                <canvas id="graphiqueCA" height="100"></canvas>
            </div>
        </div>
    </div>

    <div class="col-md-4">
        <div class="box box-success">
            <div class="box-header">
                <h3 class="box-title">Top 5 Clients</h3>
            </div>
            <div class="box-body">
                <table class="table table-striped">
                    <%
                        List<Map<String,Object>> topClients = VenteEJBClient.getTop5Clients();
                        for (Map<String,Object> client : topClients) {
                    %>
                    <tr>
                        <td><%=client.get("nom")%></td>
                        <td class="text-right"><strong><%=client.get("ca")%> Ar</strong></td>
                    </tr>
                    <%
                        }
                    %>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="../../resources/js/chart.min.js"></script>
<script>
    // Données CA 12 mois
    <%
        List<Map<String,Object>> donnees CA = VenteEJBClient.getCAParMois(12);
        String labels = "[";
        String valeurs = "[";
        for (int i = 0; i < donneesCA.size(); i++) {
            Map<String,Object> mois = donneesCA.get(i);
            labels += "\"" + mois.get("mois") + "\"";
            valeurs += mois.get("montant");
            if (i < donneesCA.size() - 1) {
                labels += ",";
                valeurs += ",";
            }
        }
        labels += "]";
        valeurs += "]";
    %>

    var ctx = document.getElementById('graphiqueCA').getContext('2d');
    var chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: <%=labels%>,
            datasets: [{
                label: 'Chiffre d\'Affaires (Ar)',
                data: <%=valeurs%>,
                backgroundColor: 'rgba(54, 162, 235, 0.2)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 2,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
</script>
```

---

## MODULE CLIENT

### 9. Score de Fiabilité Client (Credit Score) 🟡 (2h)
**Problème** : Évaluer automatiquement la fiabilité de paiement

**Table** :
```sql
ALTER TABLE CLIENT ADD SCORE_FIDELITE NUMBER(5,2) DEFAULT 0;
ALTER TABLE CLIENT ADD CREDIT_SCORE NUMBER(3) DEFAULT 50; -- 0-100
ALTER TABLE CLIENT ADD CATEGORIE VARCHAR2(20); -- 'VIP', 'GOLD', 'SILVER', 'BRONZE', 'RISQUE'
```

**Code Java** :
```java
// Dans ClientEJB.java

public void calculerScoreClient(Long idClient) {
    Client client = em.find(Client.class, idClient);

    int score = 50; // Score de base

    // 1. Historique de paiement (40 points max)
    Double tauxPaiementATemps = calculerTauxPaiementATemps(idClient);
    score += (int) (tauxPaiementATemps * 0.4); // 0-40 points

    // 2. Ancienneté client (20 points max)
    long joursDepuisCreation = (System.currentTimeMillis() - client.getDaty().getTime())
                                / (24 * 60 * 60 * 1000);
    int anciennetePoints = Math.min(20, (int) (joursDepuisCreation / 30)); // 1 point par mois, max 20
    score += anciennetePoints;

    // 3. Volume d'affaires (20 points max)
    Double caTotal = calculerCAClient(idClient);
    if (caTotal > 10000000) score += 20;  // > 10M Ar
    else if (caTotal > 5000000) score += 15;
    else if (caTotal > 1000000) score += 10;
    else if (caTotal > 500000) score += 5;

    // 4. Régularité (10 points max)
    Integer nbCommandesDernier6Mois = compterCommandes(idClient, 180);
    if (nbCommandesDernier6Mois >= 10) score += 10;
    else if (nbCommandesDernier6Mois >= 5) score += 5;

    // 5. Pénalités (retirer points)
    Integer nbFacturesEnRetard = compterFacturesEnRetard(idClient);
    score -= (nbFacturesEnRetard * 5); // -5 points par facture en retard

    // Limiter entre 0 et 100
    score = Math.max(0, Math.min(100, score));

    client.setCreditScore(score);

    // Définir catégorie
    if (score >= 80) client.setCategorie("VIP");
    else if (score >= 65) client.setCategorie("GOLD");
    else if (score >= 50) client.setCategorie("SILVER");
    else if (score >= 30) client.setCategorie("BRONZE");
    else client.setCategorie("RISQUE");

    em.merge(client);
}

private Double calculerTauxPaiementATemps(Long idClient) {
    String jpql = "SELECT " +
                  "COUNT(CASE WHEN f.datePaiement <= f.dateEcheance THEN 1 END) as aTemps, " +
                  "COUNT(f.id) as total " +
                  "FROM Facture f " +
                  "WHERE f.idclient = :idclient AND f.statutPaiement = 'PAYE'";

    Object[] result = (Object[]) em.createQuery(jpql)
                                   .setParameter("idclient", idClient)
                                   .getSingleResult();

    Long aTemps = (Long) result[0];
    Long total = (Long) result[1];

    if (total == 0) return 50.0; // Nouveau client = score neutre

    return (aTemps.doubleValue() / total.doubleValue()) * 100;
}

@Schedule(hour = "2", minute = "0") // Tous les jours à 2h du matin
public void recalculerTousLesScores() {
    List<Client> clients = em.createQuery("SELECT c FROM Client c", Client.class)
                            .getResultList();

    for (Client client : clients) {
        calculerScoreClient(client.getId());
    }
}
```

**JSP - Affichage score** :
```jsp
<!-- Dans client-fiche.jsp -->
<div class="box box-primary">
    <div class="box-header">
        <h3 class="box-title">Score de Fiabilité</h3>
    </div>
    <div class="box-body">
        <div class="row">
            <div class="col-md-6">
                <h2>
                    <span class="badge badge-<%=client.getCreditScore() >= 50 ? "success" : "danger"%>">
                        <%=client.getCreditScore()%> / 100
                    </span>
                </h2>
                <div class="progress">
                    <div class="progress-bar
                        <% if (client.getCreditScore() >= 80) { %>progress-bar-success
                        <% } else if (client.getCreditScore() >= 50) { %>progress-bar-warning
                        <% } else { %>progress-bar-danger<% } %>"
                        style="width: <%=client.getCreditScore()%>%">
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <h3>Catégorie :
                    <span class="label label-<%=getCouleurCategorie(client.getCategorie())%>">
                        <%=client.getCategorie()%>
                    </span>
                </h3>
                <p class="text-muted">
                    <% if ("VIP".equals(client.getCategorie())) { %>
                        Client premium - Conditions préférentielles
                    <% } else if ("GOLD".equals(client.getCategorie())) { %>
                        Excellent client - Bon historique
                    <% } else if ("RISQUE".equals(client.getCategorie())) { %>
                        ⚠️ Client à risque - Vigilance requise
                    <% } %>
                </p>
            </div>
        </div>

        <button onclick="recalculerScore(<%=client.getId()%>)" class="btn btn-sm btn-default">
            <i class="fa fa-refresh"></i> Recalculer
        </button>
    </div>
</div>
```

---

## MODULE ÉMISSION

### 10. Calcul d'Audience Estimée 🟠 (3h)
**Problème** : Estimer l'audience selon créneau/émission

**Tables** :
```sql
CREATE TABLE STATISTIQUE_AUDIENCE (
    ID NUMBER PRIMARY KEY,
    IDEMISSION NUMBER REFERENCES EMISSION(ID),
    JOUR NUMBER(1),              -- 1-7
    HEURE VARCHAR2(5),
    AUDIENCE_ESTIMEE NUMBER(10), -- Nombre de téléspectateurs
    PART_MARCHE NUMBER(5,2),     -- Pourcentage
    PERIODE_REFERENCE DATE,
    SOURCE VARCHAR2(100)         -- 'MESURE_REELLE', 'ESTIMATION', 'EXTRAPOLATION'
);

CREATE TABLE TRANCHE_HORAIRE_AUDIENCE (
    ID NUMBER PRIMARY KEY,
    HEURE_DEBUT VARCHAR2(5),
    HEURE_FIN VARCHAR2(5),
    COEFFICIENT_AUDIENCE NUMBER(5,2), -- Multiplicateur
    CATEGORIE VARCHAR2(50)       -- 'PRIME_TIME', 'DAY_TIME', 'LATE_NIGHT'
);

-- Configuration par défaut
INSERT INTO TRANCHE_HORAIRE_AUDIENCE VALUES
    (1, '06:00', '09:00', 0.8, 'MORNING');
INSERT INTO TRANCHE_HORAIRE_AUDIENCE VALUES
    (2, '09:00', '12:00', 0.6, 'DAY_TIME');
INSERT INTO TRANCHE_HORAIRE_AUDIENCE VALUES
    (3, '12:00', '14:00', 1.0, 'LUNCH_TIME');
INSERT INTO TRANCHE_HORAIRE_AUDIENCE VALUES
    (4, '14:00', '18:00', 0.7, 'AFTERNOON');
INSERT INTO TRANCHE_HORAIRE_AUDIENCE VALUES
    (5, '18:00', '22:00', 1.5, 'PRIME_TIME'); -- Pic d'audience
INSERT INTO TRANCHE_HORAIRE_AUDIENCE VALUES
    (6, '22:00', '06:00', 0.3, 'LATE_NIGHT');
```

**Code Java** :
```java
// Dans EmissionEJB.java

public Integer estimerAudience(Long idemission, Date date, String heure) {
    Emission emission = em.find(Emission.class, idemission);

    // 1. Base d'audience moyenne de la chaîne
    Integer audienceBase = 100000; // À configurer

    // 2. Coefficient tranche horaire
    Double coeffTranche = getCoefficientTrancheHoraire(heure);

    // 3. Coefficient jour de semaine
    Calendar cal = Calendar.getInstance();
    cal.setTime(date);
    int jourSemaine = cal.get(Calendar.DAY_OF_WEEK);
    Double coeffJour = getCoefficientJour(jourSemaine);

    // 4. Coefficient genre émission
    Double coeffGenre = getCoefficientGenre(emission.getIdgenre());

    // 5. Historique si disponible
    Integer audienceHistorique = getAudienceHistorique(idemission, jourSemaine, heure);

    Integer audienceEstimee;
    if (audienceHistorique != null) {
        // Moyenne pondérée (70% historique, 30% calcul)
        int audienceCalculee = (int) (audienceBase * coeffTranche * coeffJour * coeffGenre);
        audienceEstimee = (int) (audienceHistorique * 0.7 + audienceCalculee * 0.3);
    } else {
        audienceEstimee = (int) (audienceBase * coeffTranche * coeffJour * coeffGenre);
    }

    // Sauvegarder estimation
    StatistiqueAudience stat = new StatistiqueAudience();
    stat.setIdemission(idemission);
    stat.setJour(jourSemaine);
    stat.setHeure(heure);
    stat.setAudienceEstimee(audienceEstimee);
    stat.setPeriodeReference(new Date());
    stat.setSource("ESTIMATION");

    em.persist(stat);

    return audienceEstimee;
}

private Double getCoefficientTrancheHoraire(String heure) {
    String jpql = "SELECT t.coefficientAudience FROM TrancheHoraireAudience t " +
                  "WHERE :heure BETWEEN t.heureDebut AND t.heureFin";

    try {
        return em.createQuery(jpql, Double.class)
                 .setParameter("heure", heure)
                 .getSingleResult();
    } catch (NoResultException e) {
        return 1.0; // Par défaut
    }
}

private Double getCoefficientJour(int jour) {
    // 1=Dimanche, 2=Lundi, ..., 7=Samedi (Calendar.DAY_OF_WEEK)
    switch (jour) {
        case 1: return 1.3; // Dimanche
        case 7: return 1.2; // Samedi
        case 6: return 1.1; // Vendredi
        default: return 1.0; // Semaine
    }
}

private Double getCoefficientGenre(Long idgenre) {
    // Popularité par genre
    Map<Long, Double> coefficients = new HashMap<>();
    coefficients.put(1L, 1.2); // Information - populaire
    coefficients.put(2L, 1.5); // Divertissement - très populaire
    coefficients.put(3L, 1.4); // Sport - très populaire
    coefficients.put(4L, 1.1); // Série/Film
    coefficients.put(5L, 0.9); // Débat - moins populaire

    return coefficients.getOrDefault(idgenre, 1.0);
}

// Recommandation de prix selon audience
public Double calculerPrixRecommande(Integer audienceEstimee) {
    // Prix de base : 1000 Ar pour 10000 téléspectateurs
    // CPM (Coût Pour Mille) = 100 Ar
    return (audienceEstimee / 1000.0) * 100;
}
```

**JSP - Affichage dans réservation** :
```jsp
<script>
$('#idemission, #daty, #heure').on('change', function() {
    var emission = $('#idemission').val();
    var date = $('#daty').val();
    var heure = $('#heure').val();

    if (emission && date && heure) {
        $.ajax({
            url: '../../servlet/emission/EstimerAudienceServlet',
            data: { idemission: emission, date: date, heure: heure },
            success: function(response) {
                $('#info-audience').html(
                    '<div class="alert alert-info">' +
                    '<i class="fa fa-users"></i> ' +
                    '<strong>Audience estimée :</strong> ' +
                    formatNumber(response.audience) + ' téléspectateurs<br>' +
                    '<strong>Prix recommandé :</strong> ' +
                    formatNumber(response.prixRecommande) + ' Ar' +
                    '</div>'
                ).show();

                // Pré-remplir prix unitaire
                $('#pu').val(response.prixRecommande);
            }
        });
    }
});
</script>

<div id="info-audience" style="display:none;"></div>
```

---

## AUTRES MODULES

### 11. Rapprochement Bancaire Automatique (Compta) 🔴 (4h)
**Complexité élevée** - Matching automatique relevé/écritures

```sql
CREATE TABLE RELEVEBANCAIRE (
    ID NUMBER PRIMARY KEY,
    IDCOMPTEBANQUE NUMBER,
    DATY DATE,
    LIBELLE VARCHAR2(500),
    REFERENCE VARCHAR2(100),
    DEBIT NUMBER(15,2),
    CREDIT NUMBER(15,2),
    SOLDE NUMBER(15,2),
    STATUT VARCHAR2(20),         -- 'NON_RAPPROCHE', 'RAPPROCHE', 'MANUEL'
    IDECRITURE NUMBER            -- Lien vers COMPTAECRITURE
);
```

**Algorithme** :
1. Import CSV relevé bancaire
2. Pour chaque ligne : chercher écriture correspondante (montant, date ±3 jours, référence)
3. Si match trouvé : lier automatiquement
4. Sinon : proposer suggestions
5. Interface manuelle pour valider

---

### 12. Gestion Stock : Calcul Stock Optimal 🟡 (2-3h)
**Formule Wilson** : Quantité Économique de Commande

```java
public Double calculerStockOptimal(Long idProduit) {
    // D = Demande annuelle
    Double demandeAnnuelle = calculerDemandeAnnuelle(idProduit);

    // K = Coût de passation commande
    Double coutCommande = 5000.0; // À configurer

    // h = Coût possession stock (% du prix achat)
    Double tauxPossession = 0.20; // 20%

    Produit produit = em.find(Produit.class, idProduit);
    Double prixAchat = produit.getPu();
    Double coutPossession = prixAchat * tauxPossession;

    // Formule de Wilson : Q* = √(2DK/h)
    Double quantiteOptimale = Math.sqrt(
        (2 * demandeAnnuelle * coutCommande) / coutPossession
    );

    // Point de commande = (D / 365) * délai livraison
    int delaiLivraison = 7; // jours
    Double pointCommande = (demandeAnnuelle / 365) * delaiLivraison;

    // Stocker résultats
    produit.setStockOptimal(quantiteOptimale.intValue());
    produit.setPointCommande(pointCommande.intValue());
    em.merge(produit);

    return quantiteOptimale;
}
```

---

### 13. Export Données pour BI (Business Intelligence) 🟢 (1-2h)
**Export JSON pour Power BI / Tableau**

```java
@WebServlet("/api/export/ventes")
public class ExportVentesAPIServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String format = request.getParameter("format"); // 'json' ou 'csv'
        String dateDebut = request.getParameter("dateDebut");
        String dateFin = request.getParameter("dateFin");

        List<Map<String,Object>> donnees = VenteEJBClient.exporterDonnees(
            parseDate(dateDebut),
            parseDate(dateFin)
        );

        if ("json".equals(format)) {
            response.setContentType("application/json");
            JSONArray json = new JSONArray(donnees);
            response.getWriter().write(json.toString());
        } else if ("csv".equals(format)) {
            response.setContentType("text/csv");
            response.setHeader("Content-Disposition", "attachment; filename=export.csv");

            PrintWriter out = response.getWriter();

            // En-têtes
            out.println("Date,Client,Produit,Quantite,PrixUnitaire,Total");

            // Données
            for (Map<String,Object> ligne : donnees) {
                out.printf("%s,%s,%s,%s,%s,%s\n",
                    ligne.get("date"),
                    ligne.get("client"),
                    ligne.get("produit"),
                    ligne.get("quantite"),
                    ligne.get("prixUnitaire"),
                    ligne.get("total")
                );
            }
        }
    }
}
```

---

### 14. Système de Workflow/Validation Multi-niveaux 🟠 (3-4h)
**Approbation hiérarchique des documents**

```sql
CREATE TABLE WORKFLOW (
    ID NUMBER PRIMARY KEY,
    TYPE_DOCUMENT VARCHAR2(50),  -- 'DEVIS', 'BC', 'FACTURE', etc.
    IDDOCUMENT NUMBER,
    ETAPE NUMBER,
    VALIDATEUR_REQUIS NUMBER REFERENCES USER(ID),
    STATUT VARCHAR2(20),         -- 'EN_ATTENTE', 'APPROUVE', 'REJETE'
    DATE_VALIDATION TIMESTAMP,
    COMMENTAIRE VARCHAR2(500)
);

CREATE TABLE REGLE_WORKFLOW (
    ID NUMBER PRIMARY KEY,
    TYPE_DOCUMENT VARCHAR2(50),
    CONDITION_SQL CLOB,          -- Ex: "montant > 1000000"
    ETAPE NUMBER,
    VALIDATEUR_ROLE VARCHAR2(50)
);

-- Exemple : BC > 1M Ar = validation directeur
INSERT INTO REGLE_WORKFLOW VALUES
    (1, 'BONDECOMMANDE', 'totalttc > 1000000', 1, 'DIRECTEUR');
```

---

## RÉSUMÉ RAPIDE - ORDRE DE PRIORITÉ

### Si 3-4h disponibles, implémenter dans cet ordre :

1. **🟢 FACILE (1-2h)** - Commencer par :
   - Export Planning PDF (Réservation)
   - Tableau de Bord Statistiques (Ventes)
   - Export Données BI

2. **🟡 MOYEN (2-3h)** - Si plus de temps :
   - Gestion Conflits Planning (Réservation) ⭐
   - Tarification Dégressive (Réservation)
   - Transformation Devis→BC→Facture (Ventes) ⭐
   - Gestion Acomptes (Facturation) ⭐
   - Score Client (Client)

3. **🟠 AVANCÉ (3-4h)** - Si confiant :
   - Notifications Automatiques (Réservation)
   - Relances Factures (Facturation)
   - Calcul Audience (Émission)

4. **🔴 DIFFICILE (4h+)** - Éviter si possible :
   - Rapprochement Bancaire
   - Workflow Multi-niveaux

---

## CONSEILS STRATÉGIQUES

### Avant la Session
1. **Lire ce document** entièrement
2. **Tester la compilation** : `ant deploy`
3. **Avoir templates prêts** : Servlet de base, JSP de base
4. **Base de données** : Vérifier connexion fonctionne

### Pendant la Session
1. **Clarifier immédiatement** : Demander exemples concrets
2. **Simplifier** : MVP (Minimum Viable Product) first
3. **Backend d'abord** : Logique métier avant interface
4. **Tester au fur et à mesure** : Ne pas attendre la fin
5. **Commiter régulièrement** : En cas de rollback nécessaire

### Pièges à Éviter
- ❌ Sur-engineering (fonctionnalités non demandées)
- ❌ Perfectionnisme UI (simple mais fonctionnel suffit)
- ❌ Oublier les exceptions (gestion erreurs basique minimum)
- ❌ Ne pas tester avant présentation

### Templates à Avoir Prêts

**Servlet de base** :
```java
@WebServlet("/servlet/module/ActionServlet")
public class ActionServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Récupérer paramètres
            String param = request.getParameter("param");

            // Appeler EJB
            ModuleEJB ejb = ModuleEJBClient.lookupModuleEJBBeanLocal();
            ResultatType resultat = ejb.faireAction(param);

            // Réponse JSON
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\": true, \"data\": " + resultat.toJSON() + "}"
            );
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                "{\"success\": false, \"error\": \"" + e.getMessage() + "\"}"
            );
        }
    }
}
```

**JSP avec AJAX** :
```jsp
<form id="monFormulaire">
    <input type="text" name="param" class="form-control" required>
    <button type="submit" class="btn btn-primary">Valider</button>
</form>

<div id="resultat"></div>

<script>
$('#monFormulaire').on('submit', function(e) {
    e.preventDefault();

    $.ajax({
        url: '../../servlet/module/ActionServlet',
        method: 'POST',
        data: $(this).serialize(),
        success: function(response) {
            $('#resultat').html('<div class="alert alert-success">Succès !</div>');
        },
        error: function(xhr) {
            $('#resultat').html('<div class="alert alert-danger">Erreur : ' +
                xhr.responseJSON.error + '</div>');
        }
    });
});
</script>
```

---

**Bonne chance pour demain ! 🚀**
