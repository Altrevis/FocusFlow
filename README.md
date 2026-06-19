# FocusFlow

Application mobile Flutter de gestion de concentration et de productivité basée sur la méthode Pomodoro.

---

# Présentation

FocusFlow est une application pensée pour les étudiants, développeurs et freelances souhaitant améliorer leur concentration pendant leurs sessions de travail.

L’objectif du projet est de proposer une expérience moderne, fluide et minimaliste permettant de :

* lancer des sessions de concentration
* suivre sa productivité
* consulter ses statistiques
* sauvegarder ses données localement
* fonctionner même hors-ligne

Le projet a été conçu comme un prototype réaliste pouvant être publié sur les stores mobiles.

---

# Fonctionnalités

## Home Screen

* Affichage des statistiques du jour
* Citation motivationnelle via API REST
* Accès rapide à une session de concentration

## Focus Screen

* Timer Pomodoro
* Start / Pause / Reset
* Animation circulaire
* Affichage du temps restant

## Stats Screen

* Temps total travaillé
* Nombre de sessions réalisées
* Historique des sessions
* Graphiques de progression

## Settings Screen

* Mode sombre
* Personnalisation du temps des sessions
* Réinitialisation des données locales

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

* `sessionProvider`
* `statsProvider`
* `quoteProvider`
* `themeProvider`

---

# Gestion réseau

L’application consomme une API REST afin de récupérer des citations motivationnelles affichées sur l’écran d’accueil.

Fonctionnalités mises en place :

* requêtes HTTP avec Dio
* gestion des erreurs réseau
* sérialisation JSON
* fallback hors-ligne

---

# Persistance locale

Les données utilisateur sont sauvegardées localement grâce à Hive.

Données stockées :

* sessions de travail
* statistiques utilisateur
* préférences de thème
* durée des sessions

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
* Headspace

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
