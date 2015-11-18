/*global console, d3 */

function creationRendu(donnees) {
    "use strict";
    
    /* Création du diagramme circulaire */
}

function go() {
    "use strict";
    
    // Lecture des données
    d3.json("donnees.json", function (data) {
        console.log(data);
        creationRendu(data);
    });
}