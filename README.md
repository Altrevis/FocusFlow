# FocusFlow

Application mobile Flutter — le compagnon du développeur au quotidien.

---

# Présentation

FocusFlow est une application pensée pour les développeurs de tous niveaux (junior à senior) souhaitant centraliser leurs ressources, suivre leur progression et gérer leurs problèmes techniques au quotidien.

L'objectif du projet est de proposer une expérience moderne, fluide et minimaliste permettant de :

* consulter des cheatsheets et snippets de code rapidement
* tenir un journal d'apprentissage quotidien
* sauvegarder et retrouver ses solutions de bugs
* fonctionner même hors-ligne
* suivre sa progression dans le temps

Le projet a été conçu comme un prototype réaliste pouvant être publié sur les stores mobiles.

---

# Fonctionnalités

## Home Screen

* Résumé de l'activité récente (logs, bugs résolus)
* Citation / tip dev du jour via API REST
* Accès rapide aux 3 modules principaux

## Ref Screen (Références & Cheatsheets)

* Bibliothèque de cheatsheets organisées par technologie (Git, SQL, Regex, Terminal, Flutter...)
* Snippets de code avec coloration syntaxique
* Recherche rapide par mot-clé ou tag
* Contenu disponible offline (stocké localement)
* Favoris pour accès ultra-rapide

## Log Screen (Journal d'apprentissage)

* Création d'entrées quotidiennes : ce que j'ai appris aujourd'hui
* Tagging par technologie / langage
* Historique navigable avec recherche
* Graphique de progression (régularité d'apprentissage)
* Streak journalier pour encourager la constance

## Bugs Screen (Base de solutions personnelle)

* Saisie d'un bug rencontré : titre, contexte, solution trouvée
* Tags par langage / framework
* Recherche full-text dans ses propres solutions
* Ne plus chercher deux fois la même chose

## Settings Screen

* Mode sombre
* Réinitialisation des données locales
* Gestion des technologies favorites (filtre d'affichage)

---

# Architecture du projet

Le projet suit une architecture modulaire afin de séparer clairement :

* la logique métier
* l’interface utilisateur
* la gestion des données
* les services réseau

Structure :

```bash
/lib
 ├── core/
 │    ├── constants/
 │    ├── services/
 │    └── theme/
 │
 ├── models/
 │
 ├── providers/
 │
 ├── screens/
 │
 ├── widgets/
 │
 └── main.dart
```

---

# Technologies utilisées

| Technologie  | Utilisation             |
| ------------ | ----------------------- |
| Flutter      | Développement mobile    |
| Riverpod     | State management        |
| Dio          | Appels API REST         |
| Hive         | Persistance locale      |
| GoRouter     | Navigation              |
| fl_chart     | Statistiques graphiques |
| Google Fonts | Typographie moderne     |

---

# Gestion de l’état

Le projet utilise Riverpod pour :

* séparer la logique métier de l’UI
* gérer les états asynchrones
* simplifier la maintenance
* rendre l’application scalable

Exemple :

* `refProvider`
* `logProvider`
* `bugProvider`
* `quoteProvider`
* `themeProvider`

---

# Gestion réseau

L'application consomme une API REST afin de récupérer des tips et citations dev affichés sur l'écran d'accueil.

Fonctionnalités mises en place :

* requêtes HTTP avec Dio
* gestion des erreurs réseau
* sérialisation JSON
* fallback hors-ligne sur contenu local

---

# Persistance locale

Les données utilisateur sont sauvegardées localement grâce à Hive.

Données stockées :

* cheatsheets et snippets (Ref Screen)
* entrées du journal d'apprentissage (Log Screen)
* bugs et solutions (Bugs Screen)
* préférences de thème et technologies favorites

L’application reste utilisable sans connexion internet.

---

# Responsive Design

L’interface a été pensée pour :

* smartphones
* tablettes
* différentes tailles d’écran

Widgets utilisés :

* LayoutBuilder
* SliverAppBar
* Stack
* CustomScrollView

---

# UX & UI

Le design s’inspire des applications modernes comme :

* Notion
* Linear
* GitHub

Objectifs :

* expérience fluide
* animations discrètes
* navigation intuitive
* interface minimaliste

L’application inclut :

* loaders
* snackbars d’erreur
* dark mode
* transitions fluides

---

# Installation

## Cloner le projet

```bash
git clone https://github.com/votre-repo/focusflow.git
```

## Installer les dépendances

```bash
flutter pub get
```

## Lancer l’application

```bash
flutter run
```

---

# Dépendances principales

```yaml
flutter_riverpod:
dio:
hive:
hive_flutter:
go_router:
fl_chart:
google_fonts:
```

---

# Difficultés rencontrées

## Gestion du timer

Maintenir le timer actif et synchronisé avec l’interface utilisateur.

## Persistance locale

Sauvegarder automatiquement les sessions et statistiques.

## Responsive Design

Adapter l’interface aux différentes tailles d’écran sans overflow.

## Architecture

Séparer correctement la logique métier de l’interface utilisateur.

---

# Améliorations futures

* Authentification utilisateur
* Synchronisation cloud
* Notifications
* Sons d’ambiance
* IA de recommandations de productivité
* Classement entre utilisateurs

---

# Objectifs pédagogiques

Ce projet permet de travailler :

* Flutter
* Riverpod
* architecture logicielle
* consommation d’API
* persistance locale
* UX/UI mobile
* travail collaboratif Git

---

# Auteur

Projet réalisé dans le cadre d’un projet d’étude Flutter.

Développé avec Flutter & Riverpod.
