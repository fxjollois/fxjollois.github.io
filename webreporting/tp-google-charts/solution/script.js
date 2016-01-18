/*global console, google, $ */
// Fonction permettant la création des graphiques
var creationRendu = function (donnees) {
    "use strict";
    
    var colGroupe, colTous,
        regroupementNombre, regroupementSomme,
        regroupement,
        vue,
        pie, pieOptions,
        table, tabOptions,
        colChart, colOptions,
        barChart, barOptions,
        bNombre, bSomme;
    
    // Couleur des deux groupes
    colGroupe = ["C3F800", "FF4F00"];
    // Couleur pour tous si pas de sélection de groupe
    colTous = "CFCFCF";
    
    // Calcul d'agrégat sur le groupe : COUNT
    regroupementNombre = google.visualization.data.group(
        donnees,
        [2],
        [{'column': 1, 'aggregation': google.visualization.data.count, 'type': 'number'}]
    );
    // calcul d'agrégat sur le groupe : SUM
    regroupementSomme = google.visualization.data.group(
        donnees,
        [2],
        [{'column': 1, 'aggregation': google.visualization.data.sum, 'type': 'number'}]
    );
    regroupement = regroupementNombre;
    
    
    // Création de la vue pour diagrammes
    vue = new google.visualization.DataView(donnees);
    vue.hideColumns([2]);
    
    // Création du diagramme circulaire
    pie = new google.visualization.PieChart(document.getElementById('pieChart'));
    pieOptions = {
        title: "Répartition des groupes",
        colors: colGroupe,
        pieSliceTextStyle: { color: '#222' }
    };
    
    // Création du tableau
    table = new google.visualization.Table(document.getElementById('tab'));
    tabOptions = {
        showRowNumber: true,
        sort: 'disable'
    };
    
    // Création du diagramme en barres verticales
    colChart = new google.visualization.ColumnChart(document.getElementById("columnChart"));
    colOptions = {
        title: 'Répartition des valeurs selon les modalités',
        legend: 'none',
        colors: [colTous]
    };
  
    // Création du diagramme en barres horizontales
    barChart = new google.visualization.BarChart(document.getElementById("barChart"));
    barOptions = {
        legend: 'none',
        colors: [colTous]
    };
    
    // Affichage de tous les graphiques à l'état initial (sans sélection et selon le regroupement choisi)
    function initialisation() {
        pie.draw(regroupement, pieOptions);
        table.draw(donnees, tabOptions);
        barOptions.colors = [colTous];
        barChart.draw(vue, barOptions);
        colOptions.title = "Répartition des valeurs selon les modalités";
        colOptions.colors = [colTous];
        colChart.draw(vue, colOptions);
    }
    
    // Procédure de sélection des modalités dans chaque graphique (ou de déselection si undefined)
    function selection(modalite) {
        // console.log(modalite);
        if (modalite !== undefined) {
            table.setSelection([{row: modalite, column: null}]);
            colChart.setSelection([{row: modalite, column: 1}]);
            barChart.setSelection([{row: modalite, column: 1}]);
        } else {
            table.setSelection([]);
            colChart.setSelection([]);
            barChart.setSelection([]);
        }
    }
    
    function selectionCellule() {
        var cellule = table.getSelection()[0];
        if (cellule) {
            selection(cellule.row);
        } else {
            selection();
        }
    }
    google.visualization.events.addListener(table, 'select', selectionCellule);

    function selectionVBarre() {
        var barre = colChart.getSelection()[0];
        if (barre) {
            selection(barre.row);
        } else {
            selection();
        }
    }
    google.visualization.events.addListener(colChart, 'select', selectionVBarre);
    
    function selectionHBarre() {
        var barre = barChart.getSelection()[0];
        if (barre) {
            selection(barre.row);
        } else {
            selection();
        }
    }
    google.visualization.events.addListener(barChart, 'select', selectionHBarre);
  
    // Gestion des boutons pour passage de Nombre à Somme dans la répartition
    bNombre =  document.getElementById("repNombre");
    bSomme = document.getElementById("repSomme");
    bNombre.onclick = function () {
        // on change le regroupement
        regroupement = regroupementNombre;
        initialisation();
    };
    bSomme.onclick = function () {
        // on change le regroupement
        regroupement = regroupementSomme;
        initialisation();
    };

    // Gestion de la sélection d'un groupe sur le diagramme circulaire
    function selectionGroupe() {
        var selection =  pie.getSelection()[0],
            groupe,
            modalitesGroupe,
            vueGroupe;
        if (selection) {
            groupe = regroupement.getValue(selection.row, 0);
            modalitesGroupe = donnees.getFilteredRows([{column: 2, value: groupe}]);
            vueGroupe = new google.visualization.DataView(donnees);
            vueGroupe.setRows(modalitesGroupe);
            table.draw(vueGroupe, tabOptions);
            vueGroupe.hideColumns([2]);
            barOptions.colors = [colGroupe[selection.row]];
            barChart.draw(vueGroupe, barOptions);
            colOptions.title = "Modalités du groupe " + groupe;
            colOptions.colors = [colGroupe[selection.row]];
            colChart.draw(vueGroupe, colOptions);
        } else {
            initialisation();
        }
    }
    google.visualization.events.addListener(pie, 'select', selectionGroupe);
    
    // on affiche tout ca
    initialisation();

};

// Fonction permettant de charger les données puis de créer les graphiques
function go() {
    "use strict";
    
    // Chargement des données
    $.getJSON("donnees.json", function (data) {
        // Création d'une DataTable compatible pour Google Charts
        var don = new google.visualization.DataTable();
        don.addColumn('string', 'Modalite');
        don.addColumn('number', 'Valeur');
        don.addColumn('string', 'Groupe');
        data.valeurs.forEach(function (v, i) {
            don.addRows([[data.modalites[i], v, data.groupe[i]]]);
        });
        // Appel de la fonction créant les graphiques
        creationRendu(don);
    });
}
