majoration-diffusion-liste# Guide Complet du Projet KoloTV

## Table des Matières
1. [Vue d'ensemble](#vue-densemble)
2. [Architecture du Projet](#architecture-du-projet)
3. [Technologies Utilisées](#technologies-utilisées)
4. [Installation et Configuration](#installation-et-configuration)
5. [Guide d'Utilisation](#guide-dutilisation)
6. [Structure du Code](#structure-du-code)
7. [Modules Fonctionnels](#modules-fonctionnels)
8. [Base de Données](#base-de-données)
9. [Compilation et Déploiement](#compilation-et-déploiement)

---

## Vue d'ensemble

**KoloTV** est un système de gestion d'entreprise (ERP) complet conçu spécifiquement pour les **stations de télévision et entreprises de diffusion média**. Le système gère l'ensemble du cycle de vie des réservations publicitaires, de la prospection client jusqu'à la facturation et la comptabilité.

### Fonctionnalités Principales
- Gestion des réservations de spots publicitaires TV/Radio
- Planification des émissions et programmes
- Gestion des clients et contacts
- Système de vente (bons de commande, factures, avoirs)
- Gestion de la caisse et des paiements
- Module comptable complet
- Gestion des médias et contenus
- Chatbot IA intégré
- Génération de rapports et exports

---

## Architecture du Projet

### Type d'Architecture
**Java EE Enterprise Application** avec architecture multi-modules EJB (Enterprise JavaBeans)

### Structure des Répertoires
```
kolotv/
├── kolotv-ejb/              # Module EJB - Couche métier
│   └── src/java/            # Code Java backend (300+ classes)
│       ├── reservation/     # Gestion des réservations
│       ├── vente/          # Gestion des ventes
│       ├── client/         # Gestion des clients
│       ├── emission/       # Gestion des émissions TV
│       ├── media/          # Gestion des médias
│       ├── caisse/         # Gestion de caisse
│       ├── stock/          # Gestion de stock
│       ├── user/           # Authentification
│       ├── notification/   # Système de notifications
│       └── chatbot/        # IA Chatbot
│
├── kolotv-war/             # Module WAR - Couche présentation
│   └── web/                # Application web (549+ fichiers JSP)
│       ├── pages/          # Pages de l'application
│       │   ├── reservation/    # Interface réservations
│       │   ├── vente/          # Interface ventes
│       │   ├── client/         # Interface clients
│       │   ├── emission/       # Interface émissions
│       │   └── compta/         # Interface comptabilité
│       ├── resources/      # CSS, JS, images
│       └── WEB-INF/        # Configuration web
│
├── bdd/                    # Scripts SQL et schémas
│   ├── 2025/              # Migrations 2025
│   └── 2026/              # Migrations 2026
│
├── build-file/            # Fichiers de build
├── build.xml              # Configuration Apache Ant
└── Dockerfile             # Configuration Docker
```

### Modèle d'Architecture

**Architecture 3-tiers :**
1. **Couche Présentation** (kolotv-war) : JSP, Servlets, HTML/CSS/JavaScript
2. **Couche Métier** (kolotv-ejb) : EJB, Business Logic
3. **Couche Données** : Oracle Database

---

## Technologies Utilisées

### Backend
- **Java EE / Jakarta EE** - Framework d'application d'entreprise
- **EJB 3.x** - Enterprise JavaBeans pour la logique métier
- **JSP** (JavaServer Pages) - Templates côté serveur
- **Servlets** - Traitement des requêtes HTTP
- **JDBC** - Connectivité base de données

### Serveur d'Application
- **WildFly 10.0.0.Final** (JBoss)
- Port HTTP : 8080
- Port Management : 9990

### Base de Données
- **Oracle Database**
- URL : `jdbc:oracle:thin:@localhost:1521:ORCL`
- Schéma : `KOLO0107`

### Frontend
- **Bootstrap** - Framework UI responsive
- **jQuery** - Bibliothèque JavaScript
- **Font Awesome** - Icônes
- **CKEditor** - Éditeur de texte enrichi
- **DataTables** - Tableaux interactifs
- **FullCalendar** - Interface calendrier
- **Handsontable** - Interface type tableur
- **Chart.js** - Visualisation de données
- **AdminLTE** - Template d'administration (skin-yellow-light)

### Build & Déploiement
- **Apache Ant** - Automatisation du build
- **Docker** - Containerisation
- **Git** - Contrôle de version

### Bibliothèques Principales (127 JARs)
- **Apache POI** - Génération de fichiers Excel
- **iText/Lowagie** - Génération PDF
- **Barcode4j** - Génération de codes-barres
- **Apache Commons** (FileUpload, CSV, Codec, IO, Collections)
- **apj-core** - Framework personnalisé

---

## Installation et Configuration

### Prérequis
1. **JDK 8** ou supérieur
2. **Oracle Database** (version 11g ou supérieure)
3. **WildFly 10.x** ou serveur d'application Java EE compatible
4. **Apache Ant** pour le build
5. **Git** pour le versioning

### Étapes d'Installation

#### 1. Configuration de la Base de Données

```sql
-- Créer le schéma Oracle
CREATE USER KOLO0107 IDENTIFIED BY votre_mot_de_passe;
GRANT CONNECT, RESOURCE, DBA TO KOLO0107;

-- Importer le dump de base de données
imp KOLO0107/votre_mot_de_passe@ORCL file=export_20260122.dmp full=y
```

Ou exécuter les scripts SQL dans l'ordre :
```bash
cd bdd/2025/
# Exécuter chaque script dans l'ordre chronologique
```

#### 2. Configuration des Propriétés

Éditer `kolotv-ejb/src/java/apj.properties` :
```properties
# Configuration Base de Données
jdbcdriver=oracle.jdbc.driver.OracleDriver
jdbcurl=jdbc:oracle:thin:@localhost:1521:ORCL
jdbclogin=KOLO0107
jdbcpassword=votre_mot_de_passe
```

#### 3. Configuration du Serveur WildFly

Éditer `build.xml` pour spécifier le chemin WildFly :
```xml
<property name="deploy.dir"
          value="CHEMIN_VERS_WILDFLY/standalone/deployments"/>
```

#### 4. Build du Projet

```bash
# Se placer à la racine du projet
cd kolotv

# Nettoyer le build précédent
ant clean

# Compiler et déployer
ant deploy
```

#### 5. Démarrer le Serveur

```bash
cd CHEMIN_VERS_WILDFLY/bin

# Windows
standalone.bat

# Linux/Mac
./standalone.sh
```

#### 6. Accéder à l'Application

Ouvrir un navigateur et accéder à :
```
http://localhost:8080/kolotv
```

### Configuration Docker (Alternative)

```bash
# Build de l'image Docker
docker build -t kolotv:latest .

# Lancer le conteneur
docker run -d -p 8080:8080 -p 9990:9990 --name kolotv kolotv:latest
```

---

## Guide d'Utilisation

### Connexion au Système

1. **Page de Login**
   - URL : `http://localhost:8080/kolotv`
   - Entrer identifiant et mot de passe
   - Le système vérifie les credentials via `UserEJBClient`

2. **Session**
   - Durée : 60 heures
   - Le système charge la configuration utilisateur
   - Redirection vers le tableau de bord selon le rôle

### Navigation Principale

#### Tableau de Bord (Accueil)
- **Utilisateur Standard** : Redirigé vers le calendrier des réservations
- **Diffuseur** : Accès au planning de diffusion
- Menu latéral avec accès à tous les modules

### Modules Principaux

#### 1. Module Réservations (CŒUR DU SYSTÈME)

**Chemin** : Menu > Réservations

##### Création d'une Réservation Individuelle
1. Cliquer sur "Nouvelle Réservation"
2. Remplir le formulaire :
   - Sélectionner le client
   - Choisir le type de support (TV/Radio)
   - Sélectionner le produit/service
   - Définir date, heure et durée
   - Attribuer un média (spot publicitaire)
   - Saisir prix unitaire et quantité
3. Sauvegarder

##### Création de Réservation de Groupe (Fonction Avancée)
**Fichier** : `pages/reservation/reservation-groupe-saisie.jsp`

1. Accéder à "Réservation Groupe"
2. Interface calendrier interactif (Handsontable)
3. Sélectionner plusieurs dates dans le calendrier
4. Définir les paramètres communs :
   - Produit/Service
   - Heure de diffusion
   - Durée
   - Prix unitaire
   - Média associé
5. Valider : crée automatiquement une réservation pour chaque date sélectionnée

**Avantages** :
- Gain de temps pour campagnes publicitaires multi-dates
- Vue d'ensemble visuelle du planning
- Duplication automatique des paramètres

##### Vue Calendrier des Réservations
**Fichier** : `pages/reservation/reservation-details-calendrier.jsp`
- Visualisation mensuelle/hebdomadaire des réservations
- Filtrage par client, support, produit
- Code couleur par statut
- Modification directe par glisser-déposer

##### Planning Diffuseur
**Fichier** : `pages/reservation/planning-diffuseur.jsp`
- Vue dédiée pour les équipes de diffusion
- Ordre de passage des spots
- Gestion des actes de diffusion
- Confirmation de diffusion

#### 2. Module Ventes

**Chemin** : Menu > Ventes

##### Bon de Commande
**Fichier** : `pages/vente/bondecommande/bondecommande-saisie.jsp`

1. Créer un nouveau bon de commande
2. Sélectionner le client
3. Ajouter les lignes de commande :
   - Produits/Services
   - Quantités
   - Prix unitaires
   - TVA
4. Le système calcule automatiquement :
   - Total HT
   - Montant TVA
   - Total TTC
5. Lier aux réservations existantes si applicable
6. Générer le document PDF

##### Facture Client
1. Transformer un bon de commande en facture
2. Ou créer une facture directe
3. Suivre l'état de facturation (en cours, payée, en retard)
4. Export PDF pour envoi client

##### Bon de Livraison
- Généré depuis un bon de commande
- Suivi des livraisons
- Signature électronique possible

##### Avoir (Note de Crédit)
- Créer un avoir suite à retour/annulation
- Lier à la facture d'origine
- Mise à jour automatique des comptes

#### 3. Module Clients

**Chemin** : Menu > Clients

##### Gestion des Clients
1. **Liste des Clients** : `pages/client/client-liste.jsp`
   - Recherche et filtrage
   - Vue d'ensemble avec statistiques
   - Export Excel/PDF

2. **Fiche Client** : `pages/client/client-saisie.jsp`
   - Informations générales (nom, téléphone, adresse)
   - Type de client (Entreprise, Particulier)
   - Catégorie client
   - Historique des transactions
   - Réservations associées
   - Statistiques (CA, nombre de réservations)

#### 4. Module Émissions TV

**Chemin** : Menu > Programmes > Émissions

##### Création d'Émission
1. Définir le nom de l'émission
2. Choisir le genre (Divertissement, Info, Sport, etc.)
3. Sélectionner le support (chaîne TV)
4. Programmer les horaires :
   - Jours de diffusion
   - Heure de début
   - Heure de fin
   - Récurrence (hebdomadaire, etc.)

##### Parrainage d'Émission
**Fichier** : `emission/ParrainageEmission.java`
- Lier un client sponsor à une émission
- Définir le montant du parrainage
- Nombre de spots publicitaires :
  - Avant l'émission
  - Pendant l'émission
  - Après l'émission

##### Gestion du Plateau
- Enregistrer les invités
- Associer clients/personnalités aux émissions
- Tarification des apparitions

#### 5. Module Caisse

**Chemin** : Menu > Caisse

##### Opérations de Caisse
1. **Ouverture de Caisse**
   - Définir le fond de caisse initial
   - Sélectionner la caisse physique
   - Date et responsable

2. **Encaissements**
   - Lier à une facture
   - Sélectionner mode de paiement
   - Gestion multi-devises
   - Calcul automatique du change

3. **Décaissements**
   - Enregistrer les sorties
   - Justificatifs

4. **Clôture de Caisse**
   - Comptage physique
   - Comparaison avec théorique
   - Gestion des écarts
   - Édition du rapport de caisse

##### Change de Devises
- Conversion automatique
- Taux de change configurables
- Historique des transactions

#### 6. Module Comptabilité

**Chemin** : Menu > Comptabilité

##### Plan Comptable
- Définition des comptes
- Hiérarchie des comptes
- Classes : 1 à 7 (standard comptable)

##### Saisie d'Écritures
1. Choisir le journal (Achat, Vente, Banque, OD)
2. Saisir date et référence
3. Ajouter les lignes :
   - Compte débit
   - Compte crédit
   - Montant
   - Libellé
4. Équilibrage automatique débit/crédit

##### Grand Livre
- Vue par compte
- Soldes débiteurs et créditeurs
- Filtrage par période
- Export Excel/PDF

##### Balance
- Balance générale
- Balance auxiliaire (clients/fournisseurs)
- Balance âgée
- Export comptable

##### Clôture
- Clôture mensuelle
- Clôture annuelle
- Report à nouveau
- Édition des états financiers

#### 7. Module Stock

**Chemin** : Menu > Stock

##### Gestion des Articles
- Création de produits
- Catégorisation
- Prix d'achat et de vente
- Unités de mesure

##### Mouvements de Stock
- Entrées (achats, retours)
- Sorties (ventes, pertes)
- Transferts entre sites
- Inventaires

##### États de Stock
- Stock disponible
- Valorisation du stock
- Alertes de rupture
- Historique des mouvements

#### 8. Chatbot IA

**Fichiers** :
- `servlet/chatbot/QueryGeneratorServlet.java`
- `servlet/chatbot/ResponseBuilderServlet.java`

##### Utilisation
1. Icône de chat en bas à droite de l'interface
2. Poser des questions en langage naturel :
   - "Quelles sont les réservations du jour ?"
   - "Montrer les factures impayées"
   - "Quel est le CA de ce mois ?"
3. Le chatbot :
   - Analyse la question
   - Génère la requête SQL appropriée
   - Retourne les résultats formatés
   - Propose des actions contextuelles

### Fonctionnalités Transversales

#### Exports
- **PDF** : Tous les documents (factures, BL, rapports)
- **Excel** : Listes, états, analyses
- **CSV** : Pour traitement externe

#### Signature Électronique
- Signature des documents
- Capture via tablette/écran tactile
- Stockage sécurisé

#### Notifications
- Alertes système
- Rappels (factures échues, etc.)
- Notifications en temps réel

#### Multi-Langue
- Français (par défaut)
- Chinois (text_zh.properties)
- Extension possible

---

## Structure du Code

### Module EJB (kolotv-ejb)

#### Package `reservation/`
**Fichiers principaux** :
```
Reservation.java                    # Entité réservation principale
ReservationDetails.java             # Ligne de détail réservation
ReservationDetailsGroupe.java       # Template réservation groupe
ReservationEJB.java                 # Business logic réservations
ReservationEJBClient.java          # Interface client
```

**Classe Reservation.java** (simplifié) :
```java
public class Reservation {
    private Long id;
    private Long idclient;           // Client
    private Date daty;               // Date de création
    private String remarque;         // Observations
    private Long idbc;               // Lien vers bon de commande
    private Long idsupport;          // Support (TV/Radio)
    private String source;           // Origine réservation
    private Integer etat;            // Statut
    private Integer etatfacturation; // État facturation

    // Relations
    private List<ReservationDetails> details;

    // Méthodes métier
    public double getMontantTotal() { ... }
    public boolean isFacturee() { ... }
    public void valider() { ... }
}
```

**Classe ReservationDetails.java** :
```java
public class ReservationDetails {
    private Long id;
    private Long idmere;      // Lien vers Reservation
    private Long idproduit;   // Produit/Service
    private Double qte;       // Quantité
    private Double pu;        // Prix unitaire
    private Date daty;        // Date de diffusion
    private String heure;     // Heure de diffusion (HH:mm)
    private Double duree;     // Durée en secondes
    private Long idmedia;     // Média (spot publicitaire)
    private String remarque;

    public double getMontantLigne() {
        return (qte != null && pu != null) ? qte * pu : 0.0;
    }
}
```

**Classe ReservationDetailsGroupe.java** :
```java
public class ReservationDetailsGroupe {
    // Template pour créer plusieurs réservations
    private Long idproduit;
    private String heure;
    private Double duree;
    private Double pu;
    private Long idmedia;
    private List<Date> datesDiffusion; // Dates sélectionnées

    public List<ReservationDetails> genererDetails() {
        // Crée une ReservationDetails pour chaque date
    }
}
```

**Classe ReservationEJB.java** (Business Logic) :
```java
@Stateless
public class ReservationEJB {
    @PersistenceContext
    private EntityManager em;

    public Reservation creer(Reservation reservation) {
        // Validation
        // Calcul des montants
        // Persistance
        em.persist(reservation);
        return reservation;
    }

    public List<Reservation> listerParPeriode(Date debut, Date fin) {
        // Requête JPQL
    }

    public void validerReservation(Long id) {
        // Change statut
        // Crée actes de diffusion
        // Notifications
    }

    public Reservation creerDepuisGroupe(
        Reservation reservation,
        ReservationDetailsGroupe groupe
    ) {
        // Génère les détails pour chaque date
        for (Date date : groupe.getDatesDiffusion()) {
            ReservationDetails detail = new ReservationDetails();
            detail.setDaty(date);
            detail.setHeure(groupe.getHeure());
            detail.setDuree(groupe.getDuree());
            detail.setPu(groupe.getPu());
            // ...
            reservation.addDetail(detail);
        }
        return creer(reservation);
    }
}
```

#### Package `vente/`
**Structure** :
```
bondecommande/
├── BonDeCommande.java
├── BonDeCommandeFille.java
└── BonDeCommandeEJB.java

facture/
├── Facture.java
├── FactureClient.java
└── FactureEJB.java

avoir/
├── Avoir.java
└── AvoirEJB.java
```

**Classe BonDeCommande.java** :
```java
public class BonDeCommande {
    private Long id;
    private Long idclient;
    private Date daty;
    private String reference;
    private Integer etat;         // Statut (brouillon, validé, etc.)
    private Date datelivraison;
    private String remarque;
    private Double totalht;
    private Double totaltva;
    private Double totalttc;

    private List<BonDeCommandeFille> lignes;
    private List<Reservation> reservations; // Lien avec réservations

    public void calculerTotaux() {
        totalht = 0.0;
        totaltva = 0.0;
        for (BonDeCommandeFille ligne : lignes) {
            totalht += ligne.getMontantHT();
            totaltva += ligne.getMontantTVA();
        }
        totalttc = totalht + totaltva;
    }
}
```

#### Package `client/`
```java
public class Client {
    private Long id;
    private String nom;
    private String telephone;
    private String adresse;
    private String email;
    private String remarque;
    private Integer type;         // Particulier/Entreprise
    private Date daty;

    // Relations
    private List<Reservation> reservations;
    private List<Facture> factures;

    // Méthodes calculées
    public Double getChiffreAffaires() { ... }
    public Integer getNombreReservations() { ... }
    public Double getSoldeClient() { ... }
}
```

#### Package `emission/`
```java
public class Emission {
    private Long id;
    private String nom;
    private Long idgenre;         // Type d'émission
    private Long idsupport;       // Chaîne TV
    private Long idreservation;   // Lien réservation parrain
    private Date datedebut;
    private Date datefin;

    private List<EmissionDetails> horaires;
    private List<ParrainageEmission> parrainages;
    private List<Plateau> invites;
}

public class EmissionDetails {
    private Long id;
    private Long idmere;          // Lien vers Emission
    private Integer jour;         // 1=Lundi, 7=Dimanche
    private String heuredebut;    // HH:mm
    private String heurefin;      // HH:mm
}

public class ParrainageEmission {
    private Long id;
    private Long idclient;
    private Long idemission;
    private Double montant;       // Montant du parrainage
    private Integer qteavant;     // Spots avant émission
    private Integer qtependant;   // Spots pendant émission
    private Integer qteapres;     // Spots après émission
}
```

#### Package `user/`
```java
@Stateless
public class UserEJB {
    public User authenticate(String login, String password) {
        // Vérification credentials
        // Chargement profil
        // Droits d'accès
    }

    public boolean hasPermission(User user, String resource, String action) {
        // Vérification RBAC (Role-Based Access Control)
    }
}

public class User {
    private Long id;
    private String login;
    private String password;      // Hashé
    private String nom;
    private String email;
    private Long idrole;
    private Long iddirection;     // Service/Direction
    private Boolean actif;
}
```

#### Package `chatbot/`
```java
public class ClassIA {
    public String analyserQuestion(String question) {
        // NLP - Analyse de la question
        // Détection de l'intention
        // Extraction des entités
    }

    public String genererRequeteSQL(String intention, Map entities) {
        // Construction de la requête SQL
        // Sécurisation contre injection SQL
    }

    public String formaterReponse(List results, String intention) {
        // Formatage des résultats
        // Génération réponse naturelle
    }
}
```

### Module WAR (kolotv-war)

#### Structure JSP
```
pages/
├── index.jsp                   # Page login
├── testLogin.jsp              # Traitement authentification
├── accueil.jsp                # Tableau de bord
├── module.jsp                 # Template principal
│
├── elements/
│   ├── header.jsp             # Entête
│   ├── footer.jsp             # Pied de page
│   ├── menu/
│   │   └── module.jsp         # Menu latéral
│   └── security-login.jsp     # Vérification session
│
├── reservation/
│   ├── reservation-liste.jsp
│   ├── reservation-saisie.jsp
│   ├── reservation-groupe-saisie.jsp      # ★ Fonction avancée
│   ├── reservation-fiche.jsp
│   └── reservation-details-calendrier.jsp
│
├── vente/
│   └── bondecommande/
│       └── bondecommande-saisie.jsp       # ★ Fonction importante
│
├── client/
│   ├── client-liste.jsp
│   └── client-saisie.jsp
│
└── chatbot/
    └── chat.jsp
```

#### Exemple JSP : reservation-groupe-saisie.jsp

**Structure HTML/JSP** :
```jsp
<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="reservation.*, client.*, java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Réservation de Groupe</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="../../resources/css/bootstrap.min.css">
    <!-- Handsontable pour le calendrier -->
    <link rel="stylesheet" href="../../resources/css/handsontable.full.min.css">
</head>

<body>
<div class="container">
    <h2>Réservation de Groupe avec Calendrier</h2>

    <!-- Formulaire paramètres -->
    <form id="formReservationGroupe">
        <div class="row">
            <div class="col-md-6">
                <label>Client</label>
                <select name="idclient" class="form-control" required>
                    <option value="">-- Sélectionner --</option>
                    <%
                        List<Client> clients = ClientEJBClient.listerTous();
                        for (Client c : clients) {
                    %>
                    <option value="<%=c.getId()%>"><%=c.getNom()%></option>
                    <%
                        }
                    %>
                </select>
            </div>

            <div class="col-md-6">
                <label>Support</label>
                <select name="idsupport" class="form-control" required>
                    <!-- TV, Radio, etc. -->
                </select>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4">
                <label>Produit/Service</label>
                <select name="idproduit" class="form-control" required>
                    <!-- Liste produits -->
                </select>
            </div>

            <div class="col-md-2">
                <label>Heure</label>
                <input type="time" name="heure" class="form-control" required>
            </div>

            <div class="col-md-2">
                <label>Durée (sec)</label>
                <input type="number" name="duree" class="form-control" required>
            </div>

            <div class="col-md-2">
                <label>Prix Unitaire</label>
                <input type="number" name="pu" class="form-control"
                       step="0.01" required>
            </div>

            <div class="col-md-2">
                <label>Média</label>
                <select name="idmedia" class="form-control">
                    <!-- Spots publicitaires -->
                </select>
            </div>
        </div>

        <!-- Calendrier interactif Handsontable -->
        <div class="row mt-3">
            <div class="col-md-12">
                <h4>Sélectionner les dates de diffusion</h4>
                <div id="calendrier-handsontable"></div>
                <p class="text-muted">
                    Cliquez sur les dates pour sélectionner/désélectionner
                </p>
            </div>
        </div>

        <div class="row mt-3">
            <div class="col-md-12">
                <button type="submit" class="btn btn-primary">
                    Créer les Réservations
                </button>
                <span id="nbDatesSelectionnees" class="ml-2"></span>
            </div>
        </div>
    </form>
</div>

<script src="../../resources/js/jquery.min.js"></script>
<script src="../../resources/js/handsontable.full.min.js"></script>

<script>
    // Configuration Handsontable pour calendrier
    var datesSelectionnees = [];
    var aujourdhui = new Date();
    var moisCourant = aujourdhui.getMonth();
    var anneeCourante = aujourdhui.getFullYear();

    // Générer données calendrier
    var donneesMois = genererDonneesCalendrier(anneeCourante, moisCourant);

    var container = document.getElementById('calendrier-handsontable');
    var hot = new Handsontable(container, {
        data: donneesMois,
        colHeaders: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
        columns: [
            { data: 'lun', type: 'date', dateFormat: 'DD/MM' },
            { data: 'mar', type: 'date', dateFormat: 'DD/MM' },
            { data: 'mer', type: 'date', dateFormat: 'DD/MM' },
            { data: 'jeu', type: 'date', dateFormat: 'DD/MM' },
            { data: 'ven', type: 'date', dateFormat: 'DD/MM' },
            { data: 'sam', type: 'date', dateFormat: 'DD/MM' },
            { data: 'dim', type: 'date', dateFormat: 'DD/MM' }
        ],
        cells: function(row, col) {
            var cellProperties = {};
            cellProperties.renderer = rendererDateCalendrier;
            return cellProperties;
        },
        afterOnCellMouseDown: function(event, coords, TD) {
            toggleSelectionDate(coords.row, coords.col);
        }
    });

    function rendererDateCalendrier(instance, td, row, col, prop, value, cellProperties) {
        // Rendu personnalisé des cellules
        if (value) {
            td.innerHTML = value.getDate();

            // Highlight si sélectionné
            if (isDateSelectionnee(value)) {
                td.style.backgroundColor = '#5cb85c';
                td.style.color = 'white';
            } else {
                td.style.backgroundColor = 'white';
            }
        } else {
            td.innerHTML = '';
            td.style.backgroundColor = '#f0f0f0';
        }

        return td;
    }

    function toggleSelectionDate(row, col) {
        var date = hot.getDataAtRowProp(row, getColProperty(col));
        if (!date) return;

        var index = datesSelectionnees.findIndex(d =>
            d.getTime() === date.getTime()
        );

        if (index > -1) {
            datesSelectionnees.splice(index, 1); // Désélectionner
        } else {
            datesSelectionnees.push(date); // Sélectionner
        }

        hot.render(); // Rafraîchir affichage
        mettreAJourCompteur();
    }

    function mettreAJourCompteur() {
        var nb = datesSelectionnees.length;
        $('#nbDatesSelectionnees').text(
            nb + ' date(s) sélectionnée(s)'
        );
    }

    // Soumission formulaire
    $('#formReservationGroupe').on('submit', function(e) {
        e.preventDefault();

        if (datesSelectionnees.length === 0) {
            alert('Veuillez sélectionner au moins une date');
            return;
        }

        // Préparer données
        var formData = $(this).serializeArray();
        formData.push({
            name: 'dates',
            value: JSON.stringify(datesSelectionnees.map(d =>
                d.toISOString().split('T')[0]
            ))
        });

        // Envoi AJAX
        $.ajax({
            url: '../../servlet/reservation/CreerReservationGroupeServlet',
            method: 'POST',
            data: $.param(formData),
            success: function(response) {
                alert('Réservations créées avec succès !');
                window.location.href = 'reservation-liste.jsp';
            },
            error: function() {
                alert('Erreur lors de la création');
            }
        });
    });
</script>
</body>
</html>
```

#### Servlets
```
servlet/
├── reservation/
│   ├── CreerReservationServlet.java
│   ├── CreerReservationGroupeServlet.java    # ★ Traite le formulaire groupe
│   ├── ModifierReservationServlet.java
│   └── SupprimerReservationServlet.java
│
├── vente/
│   ├── BonDeCommandeServlet.java
│   ├── FactureServlet.java
│   └── ExportPDFServlet.java
│
└── chatbot/
    ├── QueryGeneratorServlet.java             # ★ IA Chatbot
    └── ResponseBuilderServlet.java
```

**Exemple : CreerReservationGroupeServlet.java**
```java
@WebServlet("/servlet/reservation/CreerReservationGroupeServlet")
public class CreerReservationGroupeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Récupération paramètres
            Long idclient = Long.parseLong(request.getParameter("idclient"));
            Long idsupport = Long.parseLong(request.getParameter("idsupport"));
            Long idproduit = Long.parseLong(request.getParameter("idproduit"));
            String heure = request.getParameter("heure");
            Double duree = Double.parseDouble(request.getParameter("duree"));
            Double pu = Double.parseDouble(request.getParameter("pu"));
            String idmediaStr = request.getParameter("idmedia");
            Long idmedia = (idmediaStr != null && !idmediaStr.isEmpty())
                ? Long.parseLong(idmediaStr) : null;

            // Récupération dates sélectionnées (JSON)
            String datesJson = request.getParameter("dates");
            JSONArray datesArray = new JSONArray(datesJson);

            // Création réservation mère
            Reservation reservation = new Reservation();
            reservation.setIdclient(idclient);
            reservation.setIdsupport(idsupport);
            reservation.setDaty(new Date());
            reservation.setEtat(1); // En cours

            // Création des détails pour chaque date
            for (int i = 0; i < datesArray.length(); i++) {
                String dateStr = datesArray.getString(i);
                Date dateDiffusion = new SimpleDateFormat("yyyy-MM-dd")
                    .parse(dateStr);

                ReservationDetails detail = new ReservationDetails();
                detail.setIdproduit(idproduit);
                detail.setQte(1.0);
                detail.setPu(pu);
                detail.setDaty(dateDiffusion);
                detail.setHeure(heure);
                detail.setDuree(duree);
                detail.setIdmedia(idmedia);

                reservation.addDetail(detail);
            }

            // Sauvegarde via EJB
            ReservationEJB ejb = ReservationEJBClient
                .lookupReservationEJBBeanLocal();
            ejb.creer(reservation);

            // Réponse succès
            response.setContentType("application/json");
            response.getWriter().write(
                "{\"success\": true, \"id\": " + reservation.getId() + "}"
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

---

## Modules Fonctionnels

### 1. Module Réservations
**Objectif** : Gérer les réservations de spots publicitaires TV/Radio

**Tables** :
- `RESERVATION` - Réservation principale
- `RESERVATIONDETAILS` - Lignes de diffusion
- `RESERVATIONDETAILSGROUPE` - Template groupe
- `ACTE` - Actes de diffusion réalisés

**Flux de travail** :
1. Client contacte pour campagne publicitaire
2. Création réservation (simple ou groupe)
3. Validation et planification
4. Génération actes de diffusion
5. Confirmation après diffusion
6. Facturation

### 2. Module Ventes
**Objectif** : Gérer cycle de vente complet

**Documents** :
- Bon de commande → Bon de livraison → Facture
- Avoir (retours/annulations)

**Tables** :
- `BONDECOMMANDE` / `BONDECOMMANDEFILLE`
- `BONDELIVRAISON` / `BONDELIVRAISONFILLE`
- `FACTURE` / `FACTUREFILLE`
- `AVOIR` / `AVOIRFILLE`

**Statuts** :
- Brouillon → Validé → En cours → Livré → Facturé → Payé

### 3. Module Émissions
**Objectif** : Planifier grille des programmes

**Fonctionnalités** :
- Création émissions récurrentes
- Gestion horaires
- Parrainage (sponsoring)
- Gestion du plateau (invités)

**Tables** :
- `EMISSION`
- `EMISSIONDETAILS`
- `PARRAINAGEEMISSION`
- `PLATEAU`

### 4. Module Caisse
**Objectif** : Gestion quotidienne des encaissements

**Fonctionnalités** :
- Ouverture/clôture caisse
- Encaissements multi-modes
- Gestion devises
- Rapports de caisse

**Tables** :
- `CAISSE`
- `MOUVEMENTCAISSE`
- `DEVISE`
- `MODEPAIEMENT`

### 5. Module Comptabilité
**Objectif** : Comptabilité générale

**Fonctionnalités** :
- Plan comptable
- Saisie écritures
- Grand livre
- Balance
- États financiers

**Tables** :
- `COMPTACOMPTE`
- `COMPTAECRITURE`
- `COMPTASOUSECRITURE`
- `JOURNAL`

---

## Base de Données

### Schéma Principal : KOLO0107

#### Tables Principales

**RESERVATION** (Réservations)
```sql
CREATE TABLE RESERVATION (
    ID NUMBER PRIMARY KEY,
    IDCLIENT NUMBER REFERENCES CLIENT(ID),
    DATY DATE,
    REMARQUE VARCHAR2(500),
    IDBC NUMBER REFERENCES BONDECOMMANDE(ID),
    IDSUPPORT NUMBER REFERENCES SUPPORT(ID),
    SOURCE VARCHAR2(50),
    ETAT NUMBER(1),                -- 0=Brouillon, 1=Validé, 2=Facturé
    ETATFACTURATION NUMBER(1)
);
```

**RESERVATIONDETAILS** (Détails réservation)
```sql
CREATE TABLE RESERVATIONDETAILS (
    ID NUMBER PRIMARY KEY,
    IDMERE NUMBER REFERENCES RESERVATION(ID),
    IDPRODUIT NUMBER REFERENCES AS_INGREDIENTS(ID),
    QTE NUMBER(10,2),
    PU NUMBER(15,2),
    DATY DATE,                     -- Date de diffusion
    HEURE VARCHAR2(5),             -- Format HH:mm
    DUREE NUMBER(10,2),            -- Durée en secondes
    IDMEDIA NUMBER REFERENCES MEDIA(ID),
    REMARQUE VARCHAR2(500)
);
```

**RESERVATIONDETAILSGROUPE** (Template groupe)
```sql
CREATE TABLE RESERVATIONDETAILSGROUPE (
    ID NUMBER PRIMARY KEY,
    IDPRODUIT NUMBER,
    HEURE VARCHAR2(5),
    DUREE NUMBER(10,2),
    PU NUMBER(15,2),
    IDMEDIA NUMBER,
    DATESJSON CLOB                 -- JSON des dates sélectionnées
);
```

**CLIENT** (Clients)
```sql
CREATE TABLE CLIENT (
    ID NUMBER PRIMARY KEY,
    NOM VARCHAR2(200),
    TELEPHONE VARCHAR2(50),
    ADRESSE VARCHAR2(500),
    EMAIL VARCHAR2(100),
    REMARQUE VARCHAR2(500),
    TYPE NUMBER(1),                -- 1=Particulier, 2=Entreprise
    DATY DATE
);
```

**EMISSION** (Programmes TV)
```sql
CREATE TABLE EMISSION (
    ID NUMBER PRIMARY KEY,
    NOM VARCHAR2(200),
    IDGENRE NUMBER REFERENCES TYPEEMISSION(ID),
    IDSUPPORT NUMBER REFERENCES SUPPORT(ID),
    IDRESERVATION NUMBER,
    DATEDEBUT DATE,
    DATEFIN DATE
);
```

**EMISSIONDETAILS** (Horaires émission)
```sql
CREATE TABLE EMISSIONDETAILS (
    ID NUMBER PRIMARY KEY,
    IDMERE NUMBER REFERENCES EMISSION(ID),
    JOUR NUMBER(1),                -- 1=Lundi, 7=Dimanche
    HEUREDEBUT VARCHAR2(5),
    HEUREFIN VARCHAR2(5)
);
```

**PARRAINAGEEMISSION** (Sponsoring)
```sql
CREATE TABLE PARRAINAGEEMISSION (
    ID NUMBER PRIMARY KEY,
    IDCLIENT NUMBER REFERENCES CLIENT(ID),
    IDEMISSION NUMBER REFERENCES EMISSION(ID),
    MONTANT NUMBER(15,2),
    QTEAVANT NUMBER(3),            -- Spots avant émission
    QTEPENDANT NUMBER(3),          -- Spots pendant émission
    QTEAPRES NUMBER(3)             -- Spots après émission
);
```

**AS_INGREDIENTS** (Produits/Services)
```sql
CREATE TABLE AS_INGREDIENTS (
    ID NUMBER PRIMARY KEY,
    LIBELLE VARCHAR2(200),
    PU NUMBER(15,2),               -- Prix unitaire
    PV NUMBER(15,2),               -- Prix de vente
    UNITE VARCHAR2(20),
    CATEGORIEINGREDIENT NUMBER,
    TVA NUMBER(5,2),
    ISVENTE NUMBER(1),
    ISACHAT NUMBER(1)
);
```

**BONDECOMMANDE** (Bons de commande)
```sql
CREATE TABLE BONDECOMMANDE (
    ID NUMBER PRIMARY KEY,
    IDCLIENT NUMBER REFERENCES CLIENT(ID),
    DATY DATE,
    REFERENCE VARCHAR2(50),
    ETAT NUMBER(1),
    DATELIVRAISON DATE,
    REMARQUE VARCHAR2(500),
    TOTALHT NUMBER(15,2),
    TOTALTVA NUMBER(15,2),
    TOTALTTC NUMBER(15,2)
);
```

#### Tables de Référence

**SUPPORT** (TV, Radio, etc.)
```sql
CREATE TABLE SUPPORT (
    ID NUMBER PRIMARY KEY,
    LIBELLE VARCHAR2(100)
);

-- Données exemple
INSERT INTO SUPPORT VALUES (1, 'TV');
INSERT INTO SUPPORT VALUES (2, 'Radio');
INSERT INTO SUPPORT VALUES (3, 'Web');
```

**TYPEEMISSION** (Genres)
```sql
CREATE TABLE TYPEEMISSION (
    ID NUMBER PRIMARY KEY,
    LIBELLE VARCHAR2(100)
);

-- Données exemple
INSERT INTO TYPEEMISSION VALUES (1, 'Information');
INSERT INTO TYPEEMISSION VALUES (2, 'Divertissement');
INSERT INTO TYPEEMISSION VALUES (3, 'Sport');
INSERT INTO TYPEEMISSION VALUES (4, 'Série/Film');
INSERT INTO TYPEEMISSION VALUES (5, 'Débat');
```

### Migrations SQL

Fichiers dans `bdd/2025/` et `bdd/2026/` :
- Scripts DDL (CREATE TABLE, ALTER TABLE)
- Scripts DML (INSERT données de référence)
- Ordre chronologique par date

**Exécution des migrations** :
```sql
-- Se connecter en tant que KOLO0107
sqlplus KOLO0107/password@ORCL

-- Exécuter dans l'ordre
@bdd/2025/01_creation_tables.sql
@bdd/2025/02_donnees_reference.sql
@bdd/2026/01_alter_tables.sql
-- etc.
```

### Vues Importantes

**V_RESERVATION_COMPLETE** (Vue réservations complètes)
```sql
CREATE OR REPLACE VIEW V_RESERVATION_COMPLETE AS
SELECT
    r.ID,
    r.DATY,
    c.NOM AS CLIENT,
    s.LIBELLE AS SUPPORT,
    COUNT(rd.ID) AS NB_DIFFUSIONS,
    SUM(rd.QTE * rd.PU) AS MONTANT_TOTAL,
    r.ETAT,
    r.ETATFACTURATION
FROM RESERVATION r
JOIN CLIENT c ON r.IDCLIENT = c.ID
JOIN SUPPORT s ON r.IDSUPPORT = s.ID
LEFT JOIN RESERVATIONDETAILS rd ON rd.IDMERE = r.ID
GROUP BY r.ID, r.DATY, c.NOM, s.LIBELLE, r.ETAT, r.ETATFACTURATION;
```

### Séquences

```sql
CREATE SEQUENCE SEQ_RESERVATION START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_RESERVATIONDETAILS START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_CLIENT START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE SEQ_EMISSION START WITH 1 INCREMENT BY 1;
-- etc.
```

---

## Compilation et Déploiement

### Prérequis Système

**Développement** :
- JDK 8+ (JAVA_HOME configuré)
- Apache Ant 1.9+
- WildFly 10.x
- Oracle Database 11g+
- IDE recommandé : NetBeans, Eclipse, IntelliJ IDEA

### Configuration Ant (build.xml)

**Propriétés principales** :
```xml
<!-- Chemins sources -->
<property name="ejb.src.dir" value="kolotv-ejb/src/java"/>
<property name="war.src.dir" value="kolotv-war/src/java"/>
<property name="web.dir" value="kolotv-war/web"/>

<!-- Répertoires build -->
<property name="build.dir" value="build-file"/>
<property name="ejb.classes.dir" value="${build.dir}/kolotv_jar"/>
<property name="war.classes.dir" value="${build.dir}/kolotv_war/WEB-INF/classes"/>

<!-- Déploiement -->
<property name="deploy.dir" value="D:\SOARY\Music\wildfly-10.0.0.Final\wildfly-10.0.0.Final\standalone\deployments"/>

<!-- Noms artefacts -->
<property name="kolotv-warname" value="kolotv.war"/>
<property name="kolotv-jarname" value="kolotv-ejb.jar"/>
<property name="kolotv-earname" value="kolotv.ear"/>

<!-- Base de données -->
<property name="db.driver" value="oracle.jdbc.driver.OracleDriver"/>
<property name="db.url" value="jdbc:oracle:thin:@localhost:1521:ORCL"/>
<property name="db.user" value="KOLO0107"/>
<property name="db.password" value="votre_mot_de_passe"/>

<!-- Classpath (127 JARs) -->
<path id="compile.classpath">
    <fileset dir="build-file/lib">
        <include name="**/*.jar"/>
    </fileset>
    <fileset dir="${jboss.home}/modules/system/layers/base">
        <include name="**/*.jar"/>
    </fileset>
</path>
```

### Targets Ant

#### 1. Clean
```bash
ant clean
```
```xml
<target name="clean">
    <delete dir="${build.dir}"/>
    <delete file="${deploy.dir}/${kolotv-warname}"/>
    <delete file="${deploy.dir}/${kolotv-warname}.dodeploy"/>
</target>
```

#### 2. Init
```bash
ant init
```
```xml
<target name="init" depends="clean">
    <mkdir dir="${build.dir}"/>
    <mkdir dir="${ejb.classes.dir}"/>
    <mkdir dir="${war.classes.dir}"/>

    <!-- Timestamp build -->
    <tstamp>
        <format property="build.timestamp"
                pattern="dd/MM/yyyy hh:mm aa"/>
    </tstamp>
    <echo file="${web.dir}/dateBuild.txt">${build.timestamp}</echo>
</target>
```

#### 3. Compile EJB
```bash
ant compile
```
```xml
<target name="compile" depends="init">
    <javac srcdir="${ejb.src.dir}"
           destdir="${ejb.classes.dir}"
           classpathref="compile.classpath"
           includeantruntime="false"
           encoding="UTF-8"
           debug="true">
        <compilerarg value="-Xlint:unchecked"/>
    </javac>

    <!-- Copier fichiers ressources -->
    <copy todir="${ejb.classes.dir}">
        <fileset dir="${ejb.src.dir}">
            <include name="**/*.properties"/>
            <include name="**/*.xml"/>
        </fileset>
    </copy>
</target>
```

#### 4. Build EJB JAR
```bash
ant BuildEjbJar
```
```xml
<target name="BuildEjbJar" depends="compile">
    <jar destfile="${build.dir}/${kolotv-jarname}">
        <fileset dir="${ejb.classes.dir}"/>
        <metainf dir="kolotv-ejb/src/conf">
            <include name="persistence.xml"/>
            <include name="ejb-jar.xml"/>
        </metainf>
    </jar>
</target>
```

#### 5. Compile WAR
```bash
ant CompileWar
```
```xml
<target name="CompileWar" depends="BuildEjbJar">
    <javac srcdir="${war.src.dir}"
           destdir="${war.classes.dir}"
           classpathref="compile.classpath"
           includeantruntime="false"
           encoding="UTF-8">
        <classpath>
            <pathelement location="${build.dir}/${kolotv-jarname}"/>
        </classpath>
    </javac>
</target>
```

#### 6. Copier Ressources i18n
```bash
ant CopieProperties
```
```xml
<target name="CopieProperties" depends="CompileWar">
    <copy todir="${war.classes.dir}">
        <fileset dir="${war.src.dir}">
            <include name="**/text.properties"/>
            <include name="**/text_*.properties"/>
        </fileset>
    </copy>
</target>
```

#### 7. Déploiement
```bash
ant deploy
```
```xml
<target name="deploy" depends="CopieProperties">
    <!-- Créer structure WAR exploded -->
    <mkdir dir="${deploy.dir}/${kolotv-warname}"/>

    <!-- Copier contenu web -->
    <copy todir="${deploy.dir}/${kolotv-warname}">
        <fileset dir="${web.dir}">
            <exclude name="WEB-INF/classes/**"/>
        </fileset>
    </copy>

    <!-- Copier classes compilées -->
    <copy todir="${deploy.dir}/${kolotv-warname}/WEB-INF/classes">
        <fileset dir="${war.classes.dir}"/>
    </copy>

    <!-- Copier EJB JAR -->
    <copy file="${build.dir}/${kolotv-jarname}"
          todir="${deploy.dir}/${kolotv-warname}/WEB-INF/lib"/>

    <!-- Copier bibliothèques -->
    <copy todir="${deploy.dir}/${kolotv-warname}/WEB-INF/lib">
        <fileset dir="build-file/lib/utilisateur">
            <include name="*.jar"/>
        </fileset>
    </copy>

    <!-- Créer marqueur de déploiement -->
    <touch file="${deploy.dir}/${kolotv-warname}.dodeploy"/>

    <echo>Déploiement terminé !</echo>
</target>
```

### Commandes Complètes

**Build complet et déploiement** :
```bash
ant deploy
```

**Build uniquement (sans déploiement)** :
```bash
ant BuildEjbJar
ant CompileWar
```

**Redéploiement rapide (après modifications)** :
```bash
# Recompiler seulement les classes modifiées
ant -Dbuild.compiler.fulldepend=false deploy
```

### Vérification du Déploiement

**Console WildFly** :
```
[Server] Deployed "kolotv.war" (runtime-name : "kolotv.war")
```

**Console d'administration** :
```
http://localhost:9990/console
```
Username: admin
Password: (configuré lors de l'installation WildFly)

**Accès application** :
```
http://localhost:8080/kolotv
```

### Logs

**Logs applicatifs** :
```
WILDFLY_HOME/standalone/log/server.log
```

**Erreurs de déploiement** :
```bash
# Chercher "ERROR" ou "FAILED"
tail -f WILDFLY_HOME/standalone/log/server.log | grep -i error
```

### Déploiement Docker

**Build image** :
```bash
docker build -t kolotv:1.0 .
```

**Lancer conteneur** :
```bash
docker run -d \
  --name kolotv \
  -p 8080:8080 \
  -p 9990:9990 \
  -e DB_HOST=host.docker.internal \
  -e DB_PORT=1521 \
  -e DB_SID=ORCL \
  -e DB_USER=KOLO0107 \
  -e DB_PASSWORD=votre_mot_de_passe \
  kolotv:1.0
```

**Vérifier logs** :
```bash
docker logs -f kolotv
```

**Accès application** :
```
http://localhost:8080/kolotv
```

### Troubleshooting

**Erreur : "Could not find or load main class"**
- Vérifier JAVA_HOME
- Vérifier classpath dans build.xml

**Erreur : "ClassNotFoundException: oracle.jdbc.driver.OracleDriver"**
- Ajouter ojdbc8.jar dans WildFly : `WILDFLY_HOME/standalone/deployments/`
- Ou configurer datasource dans standalone.xml

**Erreur : "Unable to deploy"**
- Vérifier logs : `standalone/log/server.log`
- Supprimer marqueur `.failed` : `rm kolotv.war.failed`
- Supprimer WAR et redéployer

**Erreur : "Port 8080 already in use"**
```bash
# Windows
netstat -ano | findstr :8080
taskkill /PID <PID> /F

# Linux/Mac
lsof -i :8080
kill -9 <PID>
```

**Application ne se connecte pas à la DB**
- Vérifier apj.properties (login, password, URL)
- Tester connexion :
```bash
sqlplus KOLO0107/password@localhost:1521/ORCL
```

---

## Conclusion

**KoloTV** est une solution ERP complète et moderne pour la gestion d'une station de télévision ou entreprise de diffusion média. Le système couvre l'ensemble des processus métier, de la réservation de spots publicitaires à la comptabilité, en passant par la gestion des émissions, des clients et de la caisse.

### Points Forts
- Architecture robuste Java EE avec EJB
- Interface utilisateur moderne avec Bootstrap et composants avancés
- Gestion de réservations en masse avec calendrier interactif
- Module comptable complet
- Chatbot IA intégré
- Export PDF/Excel
- Système multi-devises
- Déploiement Docker

### Technologies Modernes
- Backend : Java EE, EJB, JSP
- Frontend : Bootstrap, jQuery, Handsontable, FullCalendar
- Base de données : Oracle
- Serveur : WildFly
- Build : Apache Ant

### Support
Pour toute question ou assistance :
- Documentation technique : Voir fichiers sources
- Base de données : Scripts SQL dans `/bdd`
- Configuration : `apj.properties` et `build.xml`

---

**Date de génération** : 28 Janvier 2026
**Version système** : KoloTV 1.0
**Build actuel** : Voir `dateBuild.txt`
