[Chiffre d'affaire publicitaire et majoration]

Description courte du systeme
Fonctionnalite integree a un systeme operationnel de television, dedie au suivi des diffusions publicitaires.
Elle consolide le CA par semaine, jour et plage horaire, et applique automatiquement les variations tarifaires.

1. Contexte et objectif
- Problematique : renforcer un systeme de television existant par une vue metier du CA publicitaire, avec impact des variations tarifaires.
- Objectifs principaux :
  - visualiser le CA publicitaire de maniere synthetique ;
  - comparer le montant de base et le montant apres variation ;
  - parametrer des regles de majoration/minoration sans toucher a la base.

2. Perimetre fonctionnel
2.1 Donnees / referentiels
- Reservations avec diffusion : `RESERVATIONDETAILS_DIFFUSION` (date, heure, duree, montantTtc, support, categorie produit).
- Regles de variation : table `MAJORATION_DIFFUSION` (jour, heureDebut, heureFin, tauxMajoration).
- Referentiels de filtre : support et type de service (categorie contenant "pub" par defaut).

2.2 Module 1 - Grille CA publicite
- Fonctionnalites cles :
  - grille hebdomadaire (jours en colonnes, plages horaires en lignes) ;
  - affichage des montants `Ancien` et `Majore` par cellule ;
  - totaux par jour, par plage horaire et total general ;
  - navigation semaine precedente / suivante.
- Actions possibles :
  - filtrer par support ;
  - filtrer par type de service ;
  - choisir une date pivot pour la semaine.

2.3 Module 2 - Majoration diffusion
- Fonctionnalites cles :
  - lister les majorations ;
  - creer, modifier, consulter, supprimer une regle ;
  - regrouper les regles par jour pour le calcul.
- Actions possibles :
  - definir jour, heureDebut, heureFin, tauxMajoration ;
  - activer des minorations via un taux negatif.

3. Logique metier et regles critiques
- Repartition horaire : une reservation est ventilee sur les plages qu'elle chevauche, au prorata des secondes.
- Calcul variation : appliquer le taux uniquement sur la portion chevauchee de la plage.
- Regles de validite :
  - jour obligatoire et parmi les 7 jours ;
  - heureDebut < heureFin ;
  - format horaire HH:mm:ss ;
  - tauxMajoration >= -100 ;
  - pas de chevauchement de regles sur un meme jour.
- Comportements automatiques :
  - si aucune regle ne s'applique, montant final = montant de base ;
  - un taux negatif agit comme une minoration ;
  - si montant de base <= 0, retourner le montant tel quel.

4. Architecture technique
- Stack : Java EE, JSP, Oracle, framework interne de mapping.
- Organisation :
  - presentation : JSP de consultation et saisie ;
  - metier : classe `reservation.MajorationDiffusion` pour validation et calcul ;
  - donnees : `MAJORATION_DIFFUSION` + vues de reservations.
- Flux principaux :
  - Date/Filters -> chargement reservations -> ventilation horaire -> application majorations -> grille CA
  - Saisie regle -> validation -> enregistrement MAJORATION_DIFFUSION -> prise en compte grille

5. Indicateurs / pilotage
- CA hebdomadaire par jour.
- CA par plage horaire (avant / apres variation).
- Impact total des majorations/minorations sur la semaine.
