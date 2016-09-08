---
title: Logiciels stats - SAS - TP2
---

## Base de données utilisée

Nous allons utiliser dans ce TP une base de données classique, `Gymnase2000`. Cette base de données concernent des sportifs, des sports et des gymnases. Un sportif peut jouer, arbitrer et/ou entraîner un ou plusieurs sports (ou aucun). Dans un gymnase, il peut y avoir une ou plusieurs séances d'un sport, avec un entraîneur spécifié.

Vous pouvez accéder aux tables de cette base de données via l'utilisation d'une librairie sous SAS. Le code ci-dessous permettra d'utiliser les tables avec le formalisme `gym.nom_table`.

```sas
libname gym '/courses/dee4fb65ba27fe300/Gymnase2000';
```

Dans les questions suivantes, vous allez être amener à trier les tables pour effectuer les jointures. Puisque vous n'avez pas les droits de modifications sur ces tables et surtout pour éviter que nous travaillions tous sur les mêmes tables, il vous faut les copier dans un répertoire à vous (soit dans la librairie `work` temporaire, soit dans une autre librairie précédemment créée). Pour effectuer cette copie, vous pouvez utiliser le code ci-dessous, qui copie le contenu de la librairie `gym` pour le mettre dans la librairie `work`.

```sas
proc copy out = work in = gym;
run;
```

## Exemples 

Nous allons ici stocker les résultats des demandes dans une table. Si vous souhaitez afficher le contenu de celle-ci, vous pouvez ajouter le code suivant :

```sas
proc print data = ex1;
run;
```

### Sportifs (identifiant, nom et prénom) entre 20 et 30 ans ?

```sas
data ex1;
	set Sportifs;
	if (age >= 20 and age <= 30) then output;
	keep idSportif Nom Prenom;
run;
* ou ;
data ex1;
	set Sportifs;
	where age between 20 and 30;
	keep idSportif Nom Prenom;
run;
* ou ;
data ex1;
	set Sportifs (where= (age between 20 and 30));
	keep idSportif Nom Prenom;
run;
* voire ;
data ex1;
	set Sportifs (where= (age between 20 and 30) keep= age idSportif Nom Prenom);
	drop age;
run;
```

### Gymnases avec des séances le dimanche

```sas
* a. jointure entre Gymnases et Séances ;
proc sort data = Gymnases; by idGymnase;
proc sort data = Seances; by idGymnase;
data ex2a;
	merge Gymnases (in=A) Seances (in=B);
	by idGymnase;
	if (A & B);
	if (Jour = "dimanche") then output;
	keep NomGymnase Ville;
run;
* b. suppression des doublons dans les résultats ;
proc sort data = ex2a nodupkey; by Ville NomGymnase;
run;

```

### Nom et prénom du conseiller de "Kervadec"

```sas
data ex3a;
	set Sportifs (where= (Nom = "KERVADEC"));
	rename idSportifConseiller=idSp;
	keep idSportifConseiller;
run;
* b. jointure entre cette table et Sportifs (pour le conseiller) ;
proc sort data = ex3a; by idSp;
proc sort data = Sportifs; by idSportif;
data ex3b;
	merge 
		ex3a (in=A) 
		Sportifs (in=B rename= (idSportif=idSp));
	by idSp;
	if (A & B);
	keep Nom Prenom;
run;
```

### Dans quels gymnases et quels jours y a t-il des séances de hand ball ?

```sas
* a. jointure des tables Seances, Sports (pour connaître les séances de Hand ball) ;
proc sort data = Seances; by idSport;
proc sort data = Sports; by idSport;
data ex4a;
	merge Seances (in=A) Sports (in=B where= (Libelle = "Hand ball")); by idSport;
	if (A & B);
run;
* b. jointure du résultat avec Gymnase (pour avoir les informations des gymnases) ;
proc sort data = ex4a; by idGymnase;
proc sort data = Gymnases; by idGymnase;
data ex4b;
	merge ex4a (in=A) Gymnases (in=B);
	if (A & B);
	keep NomGymnase Ville Jour Horaire;
run;
* c. affichage amélioré ;
proc sort data = ex4b; by Ville NomGymnase Jour Horaire;
proc print data = ex4b;
	id Ville NomGymnase;
	by Ville;
	var Jour Horaire;
run;
```

### Gymnases avec la plus petite superficie

```sas
* a. calcul de la superficie minimale des gymnases ;
proc summary data = Gymnases;
	var Surface;
	output out = ex5a min=minSurface;
run;
* b. jointure des deux, avec répétition de la valeur minimale obtenue précédemment ;
data ex5b;
	retain min;
	merge Gymnases ex5a;
	if (minSurface ^= .) then min = minSurface;
	if (Surface = min) then output;
	keep NomGymnase Ville;
run;
```

## Questions

### Récupération de données simples

1. Quels sont les gymnases de "Villetaneuse" ou de "Sarcelles" qui ont une surface de plus de 400 m2 ?
2. Quels sportifs n'ont pas de conseillers ?
3. Quels sportifs (identifiant et nom) ne jouent aucun sport ?
4. Quels sont les sportifs qui sont aussi des conseillers ?
5. Quels sont les entraîneurs qui sont aussi joueurs ?
6. Quels sont les sportifs (identifiant et nom) qui jouent du hand ball ?
7. Dans quels gymnases peut-on jouer au hockey le mercredi apres 15H ?

### Calcul d'agrégats

1. Quelle est la moyenne d'âge des sportives qui jouent du basket ball ?
2. Pour chaque sportif donner le nombre de sports qu'il joue.
2. Pour chaque gymnase de Montmorency : quel est le nombre de séances journalières de chaque sport propose ?
3. Pour chaque entraîneurs de hand ball quel est le nombre de séances journalières qu'il assure ?
3. A partir de la réponse à la question 2, ajouter le nombre de sports qu'il arbitre et qu'il entraîne. On veut avoir tous les sportifs dans le tableau final.
2. Quels sont les sportifs les plus jeunes ?
1. Pour chaque gymnase de Stains donner par jour d'ouverture les horaires des premières et dernières séances
