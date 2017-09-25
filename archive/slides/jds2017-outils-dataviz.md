class: middle, center, inverse, title

# Outils de dataviz pour l'enseignement

## Les choix @ STID Paris

### François-Xavier Jollois

### JdS2017 - Avignon - 30 mai 2017

---

# Introduction

- Contexte : enseignements de la dataviz dans le département STID de l'IUT Paris Descartes

- Formations concernées :
    - **DU Dataviz** : Formation continue à destination de professionnels voulant acquérir des compétences en stastiques et en visualisation
    - **DUT Statistique et Informatique Décisionnelle** (*STID*) : Formation initiale post-Bac sur deux ans

- But : savoir créer une **dataviz interactive** 

- Choix global : utiliser des outils orientés *web* (*i.e* permettant la consultation via un navigateur)

- Présentation des trois outils et discussion sur leur positionnement


---

# Quels outils ?

- Volonté de présenter un aperçu des différentes situations que les étudiants vont rencontrer plus tard (stage, alternance, emploi)

- Trois types d'outils permettant la réalisation de dataviz **interactive**
    - *Clic boutons* : **Tableau**
    - Orienté statistique : **R** avec le package **`shiny`**
    - Orienté web : **Javascript**

- Chacun correspondant à un mode de développement distinct

- Interactivité voulue donc périmètre moins large que l'éventail des possibles sur le sujet

---

# Tableau 

- Logiciel créé par la société du même nom

- Outil propriétaire

- Connexion à différentes sources de données
    - Travail sur des données de types individus décrits par des variables
    - Requêtage possible

- Ensemble de graphiques et tableaux à disposition assez large
    - Création aisée de cartes géographiques (choroplèthes ou avec des marqueurs)

- Plusieurs possibilités de calculs
    - Nouvelles variables
    - Statistiques
    - ...


---

# Tableau (suite)

### Utilisation

- Développement sur le logiciel complet, partage du fichier produit et lecture avec un visionneur gratuit (sans modification possible)
- Version serveur permettant le développement, le déploiement et la diffusion

### Avantages 

- Facilité de développement
    - Pas de programmation : *production rapide*
    - Création rapide de liens et d'interactions
- Présence de cartes simples à créer et manipuler

### Inconvénients

- Limite des visualisations aux choix présents dans le logiciel
- Interaction avec certaines limites aussi
- Coût non négligeable (particulièrement en mode serveur)

---

# R 

- Langage orienté traitement statistique

- Beaucoup de librairies permettant de 
    - Se connecter à toutes sortes de données
    - Manipuler tout type de données (tableau, matrice, liste, ...)
    - Réaliser tous les calculs imaginables, notamment des analyses statistiques poussées
    
- Librairie `shiny`
    - Création d'application web (accessible via un navigateur)
    - Outil *Shiny Server* permettant la diffusion de ces applications 
        - Version pro permettant l'authentification et donc le contrôle des accès aux applications 

- Nombreuses librairies pour la visualisation de données (particulièrement `ggplot2`)

---

# R (suite)

### Utilisation

- Développement de l'application en local et déploiement simple sur le serveur

### Avantages

- Pas de limites dans les rendus
- Interaction assez simple à mettre en place avec l'utilisateur
- Production réalisable par les *statisticiens*

### Inconvénients

- Développement parfois long et fastidieux
- Coût de la licence *Shiny Server Pro*

---

# Javascript

- Langage orienté web, puisque dédié initalement à la programmation côté client des navigateurs

- Côté client
    - Nombreuses librairies utiles dont
        - `d3.js` : visualisation de données
        - `leaflet.js` : cartographie
    - Programmation possible de méthodes spécifiques
    - Interaction native

- Côté serveur
    - différents outils pour le contrôle d'authentification
    - pré-calculs possible en amont
    - possibilité d'intégrer ces visualisations dans un serveur intranet, quelque soit la technologie utilisée

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

# Comment ils sont aborder ?

### DU Dataviz 

- Formation de 150 heures au total (étalée 6 mois)
- **Tableau** : 1 journée (7h)
- **R** : 3 journées (21h)
- **Javascript** : 4 journées (28h - incluant une introduction à HTML/CSS)

### DUT STID

- Formation sur 2 ans (1620 heures)
- **Tableau** : 7h30 (en début de 1ère année)
- **R** : ~50h (en 1ère et 2ème année)
- **Javascript** : ~30h (en 2ème année - sans compter le cours HTML/CSS en 1ère années)

---

# Pourquoi aborder les trois ?

- Trois *philosophies*/*situations* différentes

- Répartition des coûts logiciel/développement/compétences orthogonale entre les trois

| Outil          | Coût logiciel | Temps de<br> développement | Compétences |
|----------------|---------------|----------------------------|-------------|
| **Tableau**    | Important     | Très faible                | Statistique uniquement |
| **R**          | Modéré        | Important                  | Statistique principalement |
| **Javascript** | Très faible   | Très important             | Informatique fortement<br> et statistique |


---

# Pourquoi pas d'autres ?

- Difficulté de présenter d'autres solutions

- *Concurrents*
    - solutions *clic boutons* : **QlikView**, **SAS VA**, ...
    - *framework* web : **BIRT**, ...
    - solution *classique* en entreprise : **Excel**
        - vu par ailleurs dans le DUT STID
    - langage entre R et Javascript : **Python**
        - vu par ailleurs dans le DUT STID
    - sans interaction et orienté statistique
        - **SAS** vu par ailleurs dans le DUT STID
        - ...

- Choix restreint pour ne pas (trop) perturber l'enseignement

---

class: inverse

# Conclusion

- Chaque solution correspond à une situation différente dépendant
    - Des compétences en interne
    - Des besoins 
    - Du temps et du budget disponibles

- Les étudiants/apprenants comprennent les différences entre les solutions
    - Mais préfèrent le *clic bouton* pour la plupart

--

### Exercice intéressant à mettre en oeuvre 

- **Comparaison des trois outils pour réaliser la même dataviz**

- Difficile pour le moment pour des raisons de coordination d'enseignants
