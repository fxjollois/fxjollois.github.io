<style>
  button {
    font-size: 1.25em;
    padding: 5px 10px;
  }
</style>

<script src="https://use.fontawesome.com/32d8325004.js"></script>
<script src="https://d3js.org/d3.v7.min.js"></script>
<script>
bouton = function(lien, info, icon, nouv = false) {
  var a = d3.create("a").attr("href", lien),
      b = a.append("button");
  if (nouv == true) a.attr("target", "_blank");
  b.append("i").attr("class", icon),
  b.append("span").html(info);
  return a.node();
}
</script>

<a href="https://github.com/fxjollois" target="_blank" alt="profil Github"><i class="fa fa-github fa-2x"></i></a>
<a href="http://fr.linkedin.com/in/fxjollois" target="_blank" alt="profil LinkedIn"><i class="fa fa-linkedin fa-2x"></i></a>
<a href="fxjollois#7460" target="_blank" alt="Discord"><i class="fa fa-discord fa-2x"></i></a>
<a href="https://observablehq.com/@fxjollois" target="_blank" alt="profil Observable"><svg role="img" viewBox="0 0 25 28" width="25" height="28" aria-label="Observable" fill="currentColor" class="near-black" style="width: 22px;"><path d="M12.5 22.6667C11.3458 22.6667 10.3458 22.4153 9.5 21.9127C8.65721 21.412 7.98339 20.7027 7.55521 19.8654C7.09997 18.9942 6.76672 18.0729 6.56354 17.1239C6.34796 16.0947 6.24294 15.0483 6.25 14C6.25 13.1699 6.30417 12.3764 6.41354 11.6176C6.52188 10.8598 6.72292 10.0894 7.01563 9.30748C7.30833 8.52555 7.68542 7.84763 8.14479 7.27274C8.62304 6.68378 9.24141 6.20438 9.95208 5.87163C10.6979 5.51244 11.5458 5.33333 12.5 5.33333C13.6542 5.33333 14.6542 5.58467 15.5 6.08733C16.3428 6.588 17.0166 7.29733 17.4448 8.13459C17.8969 8.99644 18.2271 9.9103 18.4365 10.8761C18.6448 11.841 18.75 12.883 18.75 14C18.75 14.8301 18.6958 15.6236 18.5865 16.3824C18.4699 17.1702 18.2639 17.9446 17.9719 18.6925C17.6698 19.4744 17.2948 20.1524 16.8427 20.7273C16.3906 21.3021 15.7927 21.7692 15.0479 22.1284C14.3031 22.4876 13.4542 22.6667 12.5 22.6667ZM14.7063 16.2945C15.304 15.6944 15.6365 14.864 15.625 14C15.625 13.1073 15.326 12.3425 14.7292 11.7055C14.1313 11.0685 13.3885 10.75 12.5 10.75C11.6115 10.75 10.8688 11.0685 10.2708 11.7055C9.68532 12.3123 9.36198 13.1405 9.375 14C9.375 14.8927 9.67396 15.6575 10.2708 16.2945C10.8688 16.9315 11.6115 17.25 12.5 17.25C13.3885 17.25 14.124 16.9315 14.7063 16.2945ZM12.5 27C19.4031 27 25 21.1792 25 14C25 6.82075 19.4031 1 12.5 1C5.59687 1 0 6.82075 0 14C0 21.1792 5.59687 27 12.5 27Z" fill="currentColor"></path></svg></a>
<a href="http://rpubs.com/fxjolloisUPD" target="_blank" alt="profil RPubs"><i class="fa fa-user-circle fa-2x"></i></a>
<a href="https://codepen.io/fxjollois/" target="_blank" alt="profil CodePen"><i class="fa fa-codepen fa-2x"></i></a>
<a href="https://plnkr.co/users/fxjollois" target="_blank" alt="profil Plnkr"><i class="fa fa-external-link fa-2x"></i></a>
<a href="https://plot.ly/~fxjollois#/" target="_blank" alt="profil Plotly"><i class="fa fa-external-link fa-2x"></i></a>

## Présentation

Enseignant-chercheur en informatique, mon domaine de compétence se situe à la frontière entre l'informatique et la statistique.

<p id="liens_pres"></p>
<script>
d3.select("#liens_pres").html("")
  .selectAll("bouton")
  .data([{ lien: "contact.html", info: " Contact", icon: "fa fa-user", nouv: false },
         { lien: "CV_Jollois.docx", info: " CV", icon: "fa fa-id-card", nouv: false },
         { lien: "talks/", info: " Talks", icon: "fa fa-desktop", nouv: true }])
  .enter()
      .append(d => bouton(d.lien, d.info, d.icon, d.nouv));
</script>

### Enseignement

J'enseigne dans le département [STID](http://www.stid-paris.fr/) de l'[IUT Paris Descartes](http://www.iut.parisdescartes.fr).

<p id="liens_cours"></p>
<script>
d3.select("#liens_cours").html("")
  .selectAll("button") 
  .data([2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022].reverse()) 
  .enter() 
  .append(d => bouton("http://fxjollois.github.io/cours-" + d + "-" + (d+1), 
                      " Supports " + d + "-" + (d+1),
                     "fa fa-file", true));
</script>

### Recherche

J'effectue ma recherche au [LIPADE](http://www.lipade.fr), dans l'équipe [diNo](http://dino.mi.parisdescartes.fr/). 

<a href="recherche.html">
    <button>
        <i class="fa fa-institution"></i> Recherche
    </button>
</a>
<a href="publications.html">
    <button>
        <i class="fa fa-file-text"></i> Publications
    </button>
</a>


## BUT Science des données

Site web présentant le Programme National du **BUT Science des données** :

<a href="https://github.com/fxjollois/but-sd" target="_blank">
    <button>
        <i class="fa fa-github"></i> Voir sur Github
    </button>
</a>
<a href="http://fxjollois.github.io/but-sd" target="_blank">
    <button>
        <i class="fa fa-desktop"></i> Site web
    </button>
</a>


## explore-data

Interface web dédiée à l'enseignement de la **Statistique descriptive**

### Avec R et Shiny

Créée avec [`R`](http://www.r-project.org) et [`shiny`](http://shiny.rstudio.com).

<a href="https://github.com/fxjollois/explore-data-shiny" target="_blank">
    <button>
        <i class="fa fa-github"></i> Voir sur Github
    </button>
</a>
<a href="http://fxjollois.shinyapps.io/explore-data" target="_blank">
    <button>
        <i class="fa fa-desktop"></i> Application (sur serveur Shinyapps)
    </button>
</a>

### En Javascript

<a href="https://github.com/fxjollois/explore-data" target="_blank">
    <button>
        <i class="fa fa-github"></i> Voir sur Github
    </button>
</a>
<a href="http://fxjollois.github.io/explore-data" target="_blank">
    <button>
        <i class="fa fa-desktop"></i> Application
    </button>
</a>

## cours-sql

Interface web dédiée à l'enseignement de **`SQL`**, créée en en `JavaScript`.

<a href="https://github.com/fxjollois/cours-sql" target="_blank">
    <button>
        <i class="fa fa-github"></i> Voir sur Github
    </button>
</a>
<a href="http://fxjollois.github.io/cours-sql" target="_blank">
    <button>
        <i class="fa fa-desktop"></i> Application
    </button>
</a>

## 50 ans pour STID Paris

Dans le cadre des 50 ans de l'IUT Paris Descartes, j'ai réalisé quelques dataviz concernant le département STID

<a href="https://github.com/fxjollois/50ans-stid-paris" target="_blank">
    <button>
        <i class="fa fa-github"></i> Voir sur Github
    </button>
</a>
<a href="http://fxjollois.github.io/50ans-stid-paris" target="_blank">
    <button>
        <i class="fa fa-external-link"></i> Site web avec les dataviz
    </button>
</a>

## WikipediaR

Package `R` permettant d'accéder aux données de [Wikipedia](http://www.wikipedia.org/)

<a href="https://cran.r-project.org/package=WikipediaR" target="_blank">
    <button>
        <i class="fa fa-external-link"></i>Voir sur le CRAN
    </button>
</a>

## compare-dataviz-méthodologiques (en cours)

Comparaison de différents outils (`R`, `Python`, `JavaScript`, ...) pour la réalisation d'une même dataviz.

<a href="https://github.com/fxjollois/compare-dataviz-tools" target="_blank">
    <button>
        <i class="fa fa-github"></i> Voir sur Github
    </button>
</a>
<a href="http://fxjollois.github.io/compare-dataviz-tools" target="_blank">
    <button>
        <i class="fa fa-desktop"></i> Page web
    </button>
</a>

## Quelques liens intéressants

- [Données](donnees) : données que j'utilise dans mes cours
- [Données intégrées](donnees-integrees-r.html) : informations sur des données présentes dans R

- [ECAIS](https://sites.google.com/site/groupeecais/) : groupe de travail de l'IUT Paris
Descartes, regroupant des informaticiens et des statisticiens
- [STID-France](http://www.stid-france.fr/) : ensemble des départements STID de France
- [Groupe Méthodes & Logiciels](http://methodes-et-logiciels.sfds.asso.fr/) :
séminaires d'échanges sur différentes thématiques autour de la statistique, intégrant des
aspects méthodologiques et pratiques
