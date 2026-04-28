# Specification technique - Chiffre d'affaire publicitaire et majoration de diffusion

## 1. Objectif du module

Ce module permet de consulter le chiffre d'affaire publicitaire genere par les reservations de diffusion et d'appliquer des variations de prix selon le jour et la plage horaire.

Il sert principalement a :

- visualiser le CA publicitaire par semaine ;
- analyser le CA par jour et par plage horaire ;
- comparer le montant initial avec le montant apres majoration ou minoration ;
- configurer les regles de variation applicables aux diffusions ;
- donner une vue exploitable aux utilisateurs metier pour suivre les revenus lies aux spots publicitaires.

Le module est expose dans le menu lateral par :

- `Grille CA publicite` : consultation du chiffre d'affaire publicitaire ;
- `Majoration diffusion` : gestion des variations appliquees aux diffusions.

## 2. Perimetre fonctionnel

### 2.1 Grille CA publicitaire

Ecran principal : `kolotv-war/web/pages/reservation/chiffre-affaire-publicite-calendrier.jsp`

La grille affiche le chiffre d'affaire des reservations publicitaires sur une semaine. Elle organise les donnees sous forme de tableau :

- lignes : plages horaires de la journee ;
- colonnes : jours de la semaine ;
- cellule : CA de la plage horaire pour le jour donne ;
- derniere colonne : total par plage horaire ;
- derniere ligne : total par jour et total general.

Chaque montant affiche deux valeurs :

- `Ancien` : montant de base, avant application des variations ;
- `Majore` : montant final apres application des majorations ou minorations configurees.

Filtres disponibles :

- `Support` : permet de limiter la grille a un support donne. Par defaut, le support `SUPP002` est utilise si aucun support n'est transmis.
- `Type service` : permet de filtrer par categorie de service. Si aucun type n'est transmis, l'application tente de selectionner automatiquement une categorie contenant le mot `pub`.
- `Date` : sert a choisir la semaine affichee. La grille calcule le debut et la fin de semaine a partir de cette date.

Navigation :

- bouton semaine precedente ;
- bouton semaine suivante ;
- lien direct vers la gestion des majorations.

### 2.2 Gestion des majorations de diffusion

Ecrans concernes :

- liste : `kolotv-war/web/pages/reservation/majoration-diffusion-liste.jsp`
- creation : `kolotv-war/web/pages/reservation/majoration-diffusion-saisie.jsp`
- modification : `kolotv-war/web/pages/reservation/majoration-diffusion-modif.jsp`
- fiche : `kolotv-war/web/pages/reservation/majoration-diffusion-fiche.jsp`

Une majoration de diffusion represente une regle de variation appliquee a une plage horaire d'un jour de la semaine.

Champs geres :

| Champ | Description |
| --- | --- |
| `id` | Identifiant technique de la regle. Genere automatiquement avec le prefixe `MAJ`. |
| `jour` | Jour d'application : Lundi, Mardi, Mercredi, Jeudi, Vendredi, Samedi ou Dimanche. |
| `heureDebut` | Heure de debut de la plage concernee, au format `HH:mm:ss`. |
| `heureFin` | Heure de fin de la plage concernee, au format `HH:mm:ss`. |
| `tauxMajoration` | Pourcentage de variation applique au montant. Une valeur positive augmente le montant, une valeur negative le diminue. |

Exemples :

- `20` signifie +20 % sur la partie de diffusion concernee ;
- `-10` signifie -10 % sur la partie de diffusion concernee ;
- `0` signifie aucune variation.

## 3. Regles de calcul du CA

### 3.1 Donnees sources

Les reservations utilisees par la grille viennent de la vue ou table mappee par :

- classe Java : `reservation.ReservationDetailsAvecDiffusion`
- nom logique : `RESERVATIONDETAILS_DIFFUSION`

L'agregation hebdomadaire est preparee par :

- classe Java : `reservation.EtatReservationDetails`

Cette classe :

- calcule la liste des dates de la periode ;
- recupere les reservations entre la date minimale et la date maximale ;
- filtre eventuellement par support et type de service ;
- construit les plages horaires de la journee ;
- regroupe les reservations par date.

### 3.2 Decoupage horaire

La grille utilise des intervalles horaires generes pour la journee. Chaque reservation est rattachee aux plages horaires qu'elle chevauche.

Une reservation peut donc alimenter plusieurs cellules si sa duree traverse plusieurs plages horaires.

Pour chaque reservation :

1. l'heure de debut est l'heure de reservation ;
2. la duree est lue depuis le champ `duree`, en secondes ;
3. l'heure de fin est calculee avec `heureDebut + duree` ;
4. le montant TTC est reparti proportionnellement au temps passe dans chaque plage horaire touchee.

Formule de repartition :

```text
partBase = montantTTCReservation * dureeChevauchementPlage / dureeTotaleChevauchee
```

### 3.3 Application des variations

Les variations sont portees par la classe :

- `reservation.MajorationDiffusion`

La methode principale de calcul est :

- `MajorationDiffusion.appliquerMajoration(montantBase, debutIntervalle, finIntervalle, majorationsJour)`

La logique appliquee est la suivante :

1. recuperer les majorations du jour concerne ;
2. calculer le chevauchement entre la plage de CA et chaque plage de majoration ;
3. convertir le montant de base en montant par seconde ;
4. appliquer le taux uniquement sur les secondes chevauchees ;
5. additionner le montant de base et les variations calculees.

Formule simplifiee :

```text
montantParSeconde = montantBase / dureeIntervalleEnSecondes
variation = montantParSeconde * secondesChevauchees * tauxMajoration / 100
montantFinal = montantBase + somme(variation)
```

Cas particuliers :

- si le montant de base est nul ou negatif, il est retourne tel quel ;
- si la plage horaire est invalide, le montant de base est retourne tel quel ;
- si aucune majoration ne concerne le jour, le montant final reste egal au montant de base ;
- si le taux est negatif, la regle agit comme une minoration ;
- le taux minimum autorise est `-100`, afin d'eviter un montant negatif issu d'une remise superieure a 100 %.

### 3.4 Totaux calcules

La grille calcule simultanement :

- montant par cellule avant variation ;
- montant par cellule apres variation ;
- total par jour avant variation ;
- total par jour apres variation ;
- total par plage horaire avant variation ;
- total par plage horaire apres variation ;
- total general avant variation ;
- total general apres variation.

## 4. Regles de validation

Les controles metier de majoration sont centralises dans :

- `kolotv-ejb/src/java/reservation/MajorationDiffusion.java`

Regles appliquees :

- le jour est obligatoire ;
- le jour doit faire partie des sept jours reconnus ;
- les heures doivent etre valides et normalisees au format `HH:mm:ss` ;
- l'heure de debut doit etre strictement inferieure a l'heure de fin ;
- le taux de variation doit etre superieur ou egal a `-100` ;
- deux regles du meme jour ne peuvent pas avoir des plages horaires qui se chevauchent ;
- lors d'une modification, la regle en cours est exclue du controle de chevauchement.

Le controle de chevauchement verifie les regles existantes dans `MAJORATION_DIFFUSION` pour le meme jour.

## 5. Modele de donnees

### 5.1 Table MAJORATION_DIFFUSION

Script principal :

- `bdd/2026/2026-02-05-majoration-diffusion.sql`

Structure :

| Colonne | Type | Obligatoire | Role |
| --- | --- | --- | --- |
| `ID` | `VARCHAR2(100)` | Oui | Cle primaire. |
| `JOUR` | `VARCHAR2(20)` | Oui | Jour de la semaine. |
| `HEUREDEBUT` | `VARCHAR2(8)` | Oui | Heure de debut de la regle. |
| `HEUREFIN` | `VARCHAR2(8)` | Oui | Heure de fin de la regle. |
| `TAUXMAJORATION` | `NUMBER(10,4)` | Oui | Pourcentage de variation. |

Contraintes :

- cle primaire sur `ID` ;
- controle du jour parmi les valeurs autorisees ;
- controle du taux avec `TAUXMAJORATION >= -100`.

Generation d'identifiant :

- sequence : `SEQ_MAJORATION_DIFFUSION`
- fonction Oracle : `GETSEQ_MAJORATION_DIFFUSION`
- prefixe applicatif : `MAJ`

### 5.2 Donnees de reservation

La grille s'appuie sur les reservations avec diffusion via le mapping :

- `RESERVATIONDETAILS_DIFFUSION`

Champs importants pour ce module :

| Champ | Role dans le calcul |
| --- | --- |
| `daty` | Date de la reservation ou diffusion planifiee. |
| `heure` | Heure de debut utilisee dans la grille. |
| `duree` | Duree en secondes pour repartir le montant dans les plages horaires. |
| `montantTtc` | Montant de base utilise pour le CA. |
| `idSupport` | Filtre par support. |
| `categorieproduit` | Filtre par type de service. |

## 6. Flux utilisateur

### 6.1 Consultation du CA publicitaire

1. L'utilisateur ouvre `Grille CA publicite`.
2. L'application determine la semaine a afficher.
3. L'utilisateur peut filtrer par support, type de service et date.
4. L'application charge les reservations correspondantes.
5. L'application charge toutes les regles de majoration.
6. Les reservations sont reparties dans la grille horaire.
7. Les variations sont appliquees sur chaque portion de reservation concernee.
8. La grille affiche les montants avant et apres variation.

### 6.2 Creation d'une majoration

1. L'utilisateur ouvre `Majoration diffusion`.
2. Il clique sur `Nouvelle majoration`.
3. Il choisit le jour.
4. Il saisit l'heure de debut, l'heure de fin et le taux.
5. A la validation, l'application controle les donnees.
6. Si aucune plage existante ne chevauche la nouvelle regle, elle est enregistree.
7. La regle devient prise en compte par la grille CA.

### 6.3 Modification d'une majoration

1. L'utilisateur ouvre la fiche d'une majoration.
2. Il lance la modification.
3. Il ajuste le jour, les horaires ou le taux.
4. L'application controle la coherence et les chevauchements.
5. La regle modifiee est appliquee aux prochaines consultations de la grille.

## 7. Architecture technique

### 7.1 Couche presentation

Les ecrans sont implementes en JSP dans :

- `kolotv-war/web/pages/reservation/`

Ils utilisent les composants generiques du framework interne :

- `PageRecherche` pour la liste des majorations ;
- `PageInsert` pour la creation ;
- `PageUpdate` pour la modification ;
- `PageConsulte` pour la fiche.

### 7.2 Couche metier

Classes principales :

| Classe | Responsabilite |
| --- | --- |
| `MajorationDiffusion` | Mapping de la table, validation, groupement des regles, calcul de variation. |
| `EtatReservationDetails` | Chargement et regroupement des reservations par date et plage horaire. |
| `ReservationDetailsAvecDiffusion` | Representation des reservations avec informations de diffusion. |

### 7.3 Acces aux donnees

L'application utilise le framework historique base sur :

- `ClassMAPTable` pour le mapping objet/table ;
- `CGenUtil.rechercher` pour les recherches simples ;
- `CGenUtil.rechercher2D` pour les recherches groupees par date ;
- une base Oracle pour le stockage.

## 8. Points d'attention et limites connues

- Les horaires de majoration ne gerent pas les plages qui traversent minuit. Une plage doit commencer et finir dans la meme journee.
- La grille charge toutes les majorations puis les groupe par jour en memoire. C'est simple et suffisant pour un faible volume de regles.
- Le taux est appele `tauxMajoration`, mais il couvre aussi les minorations lorsque la valeur est negative.
- Le libelle affiche actuellement `Majore`, meme si une minoration est appliquee. Un libelle plus neutre comme `Apres variation` serait plus explicite.
- Les montants sont bases sur `montantTtc`. Si un besoin futur demande une analyse HT, TVA ou devise, le calcul devra etre etendu.
- Le filtre automatique du type de service cherche une categorie contenant `pub`. Cette logique depend du libelle des donnees de reference.
- Le calcul repose sur le champ `duree` en secondes. Une duree absente ou invalide est ramenee a une duree minimale d'une seconde pour eviter une division impossible.