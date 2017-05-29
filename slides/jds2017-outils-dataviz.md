class: middle, center, inverse, title

# Outils de dataviz pour l'enseignement

## Le cas à STID Paris

### François-Xavier Jollois

### JdS2017 - Avignon - 30 mai 2017

---

# Introduction

- Contexte : enseignements de la dataviz du département STID

- Formations concernées :
    - **DU Dataviz** : Formation continue à destination de professionnels voulant acquérir des compétences en stastiques et en visualisation
    - **DUT Statistique et Informatique Décisionnelle** (*STID*) : Formation initiale 

- But : savoir créer une **dataviz interactive** 

- Choix global : utiliser des outils orientés *web* (*i.e* permettant la consultation via un navigateur)

- Présentation des trois outils et discussion sur leur positionnement


---

# Quels outils ?

- Trois types d'outils permettant la réalisation de dataviz **interactive**

Type | Logiciel choisi
-----|------------------
*Clic boutons* | **Tableau**
Orienté statistique | **R** avec le package **`shiny`**
Orienté web | **Javascript**

- Chacun correspondant à un mode de développement distinct

- Interactivité voulue donc périmètre moins large que l'éventail des possibles

---

# Tableau 

- Logiciel créée par la société du même nom

- Outil propriétaire

- Connexion à différentes sources de données
    - Travail sur des données de types individus décrits par des variables

- Ensemble de graphiques et tableaux à disposition assez large
    - Création aisée de cartes géographiques (choroplèthes ou avec des marqueurs)

- Plusieurs possibilités de calculs (nouvelles variables, de statistiques, ...)


---

# Tableau (suite)

### Utilisation

- développement sur le logiciel complet, partage du fichier produit et lecture avec un visionneur gratuit (sans modification possible)
- version serveur permettant le développement, le délpoiement et la diffusion

### Avantages 

- Facilité de développement
    - pas de programmation
    - création rapide de liens et d'interaction
- Présence de cartes simples à créer et manipuler

### Inconvénients

- Limite des visualisations
- Interaction limitée aussi
- Coût non négligeable (particulièrement en mode serveur)

---

# R 

- Langage orienté traitement statistique

- Beaucoup de librairies permettant de 
    - se connecter à toutes sortes de données
    - manipuler tout type de données (tableau, matrice, liste, ...)
    - réaliser tous les calculs imaginables, notemment des analyses statistiques poussées
    
- Librairie `shiny`
    - création d'application web (accessible via un navigateur)
    - outil `shiny server` permettant la diffusion de ces applications 
        - version pro permettant l'authentification et donc le contrôle des accès aux applications 

- Nombreuses librairies pour la visualisation de données (notemment `ggplot2`)

---

# R (suite)

### Utilisation

- Développement de l'application en local et déploiement simple sur le serveur

### Avantages

- Pas de limites dans les rendus
- Interaction simple à mettre en place avec l'utilisateur

### Inconvénients

- Développement parfois un peu lourd
- Coût de la licence *Shiny Server Pro*

---

# Javascript

- Langage orienté web, puisque dédié initalement à la programmation côté client des navigateurs

- Côté client
    - Nombreuses librairies utiles : 
        - `d3.js` : visualisation de données
        - `leaflet.js` : cartographie
    - Programmation possible de méthodes spécifiques
    - Interaction native

- Côté serveur
    - différents outils pour le contrôle d'authentification
    - pré-calculs à faire éventuellement 

---

# Javascript (suite)

### Utilisation

- Développement en local et intégration à réaliser (potentiellement complexe)

### Avantages

- Pas de limites dans les rendus
- Pas de limites dans les interactions, utilisation de toutes les interfaces possibles (même analyse des mouvements des yeux via une capture video)
- Solution totalement *open source* et gratuite (au niveau logiciel)

### Inconvénients

- Développement lourd
- Compétences assez poussées en informatique à avoir

---

# Pourquoi aborder les trois ?

- Trois *philosophies* différentes
    - Répartition des coûts logiciel/développement orthogonale entre les trois
    - Compétences nécessaires 

### Estimation *personnelle* de la répartition du coût des solutions

<div id="chart_div"></div>


---

# Pourquoi pas d'autres ?

- Difficulté de présenter d'autres solutions

- *Concurrents*
    - solutions *clic boutons* : **QlikView**, **SAS VA**, ...
    - solution *classique* en entreprise : **Excel**
    - langage entre R et Javascript : **Python**
    - ...

- Choix restreint pour ne pas (trop) perturber l'enseignement

---

class: inverse

# Conclusion

- Chaque solution correspond à une situation particulière

- A réaliser évntuellement : comparaison des trois outils pour réaliser la même dataviz

- Les étudiants/apprenants comprennent les différences entre les solutions

--

### Mais

- préfèrent le *clic bouton* pour la plupart

