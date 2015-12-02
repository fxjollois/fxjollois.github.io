---
title: Reporting - TP2
---

<style>
img {
    margin: 10px auto;
}
em {
    background-color: #f4f4f4;
    padding: 0 5px;
    font-style: normal;
}
</style>

Dans **Tableau Public**, ouvrez le résultat obtenu suite au TP1 ([workbook téléchargeable](reporting-tp2/Reporting - TP1.twbx)). Vous noterez que tous les graphiques sont présents avec une couleur dans l'onglet en bas, permettant de repérer quels graphiques sont pour quels tableaux. Les données sont intégrées dans le fichier.

## Utilisation d'un graphique comme filtre

- Reprenez le *dashboard* nommé *Reporting 1*.
- Faites un clic-droit dans le graphique *Répartition DUT*, puis cliquer sur *Use as filter*.
- Une fois cela fait, lorsque vous cliquez sur un département, les autres graphiques (*Répartition Sexe* et carte *Origine Etudiants*) sont mis à jour. Elles ne concernent que les étudiants du département sélectionné.
- La carte est fixe, car elle est dite *épinglée* (cf le dessin d'épingle quand on passe la souris dessus). Ceci permet que son affichage ne change pas à chaque clic de souris. Ce n'est pas le comportement par défaut. Pour l'obtenir (ou revenir à l'état initial), il suffit de cliquer sur l'épingle. Si vous faites cela, en cliquant sur `INFO`, on remarque que la carte est zoomée par rapport aux autres départements.

Il est aussi possible de créer des filtres permettant le choix de plusieurs modalités (clic-droit puis *Quick filters*).

## Utilisation du mode *Story*

Ce mode permet d'intégrer plusieurs *dashboards* (ou *sheets* mais c'est peut-être moins intéressant) et d'avoir un menu permettant de naviguer parmi ceux-ci.

- Aller dans le menu, cliquer sur *Story* puis *New story*.
- Double-cliquer sur `Titre de l'histoire` puis écrire *Enquête DUT + 2,5 ans*.
- Glisser le tableau *Reporting 1* dans le grand cadre.
- Double-cliquer sur *Add legend* pour écrire *Origine*.
- Ensuite, cliquer sur *New ??*.
- Glisser le tableau *Reporting 2* et donner comme légende *Devenir*.
- Comme vous pouvez le voir, ainsi, il est possible de naviguer entre les deux tableaux :
    - soit en cliquant directement sur la légende associée,
    - soit avec les flèches gauche et droite pour naviguer.

    
## A FAIRE

Reprendre les données de base (cf [TP1](reporting-tp1.html)), et programmer une *story* intégrant les éléments suivants (avec pour chaque item la possibilité de faire un focus sur un des départements) :

1. **Origine des étudiants**
    - Typologie des répondants (âge, sexe, classement du bac, situation initiale)
    - Origine géographique
2. **Quelques détails**
    - Boursier
    - Nationalité
    - Série et mention du bac, oral ou non, année du bac
3. **Poursuite ou emploi ?**
    - Parcours après le DUT
    - A regarder en fonction du sexe, de l'âge, du classement du bac et de la situation initiale
4. **Quelle intégration professionnelle avec un DUT ?**
    - Travail
    - Type d'emploi
    - Nombre d'emploi
    - Chômage ou non, durée si oui
    - Salaires et primes
    - Adéquation salaire et emploi avec le DUT
    - A regarder éventuellement en fonction du sexe, de l'âge, du classement du bac et de la situation initiale

Vous êtes libres des représentations à mettre en oeuvre, de la mise en page des tableaux et du nombre de tableaux à obtenir au final dans votre *story*.
