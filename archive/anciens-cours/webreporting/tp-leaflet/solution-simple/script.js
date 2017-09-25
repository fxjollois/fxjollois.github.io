/*global L, Papa, $, google*/

// - améliorer l'affichage des informations en créant une fenêtre `tooltip` affichant toutes les informations dont on dispose
// - donner la possibilité de choisir l'indicateur permettant la coloration des départements
//    - dans ce cas, il serait judicieux de faire une échelle commune à tous les indicateurs, du genre de celle de l'INSEE
// - s'intéresser aux autres tuiles disponibles via Open Street Map, et les autres fournisseurs
var geoDep;


google.load('visualization', '1.0', {'packages': ['corechart']});

// on créé une fonction prenant la valeur du an15trim2 et qui renvoie une couleur (entre blanc (min) et rouge (max))
function couleur(val) {
    "use strict";
    var min = 5,
        max = 15,
        r = 255,
        g = Math.floor((1 - (val - min) / (max - min)) * 255),
        b = Math.floor((1 - (val - min) / (max - min)) * 255);
    return "rgb(" + r + ", " + g + ", " + b + ")";
}

// Création du graphique du tooltip
function creationGraph(info) {
    "use strict";
    
    var data = new google.visualization.DataTable();
    data.addColumn('string', 'Trimestre');
    data.addColumn('number', 'Taux');
    data.addRows([
        ['2014 T2', info.an14trim2],
        ['2015 T1', info.an15trim1],
        ['2015 T2', info.an15trim2]
    ]);
    
    var chart = new google.visualization.LineChart(document.getElementById('graph'));
    chart.draw(data,
        {
            'title': 'Evolution du taux de chômage',
            'width': 250,
            'height': 150,
            'vAxis': { viewWindow: { min: 5, max: 15 } },
            'legend': { position: 'none' }
        });
}

// Focntion de changement du choix de taux
function changeTaux() {
    geoDep.setStyle(function (feature) {
        var col, choix = document.getElementsByName("choixTaux");
        console.log(choix[0].checked, choix[1].checked, choix[2].checked);
        if (choix[0].checked) {
            col = couleur(feature.properties.an14trim2);
        } else {
            if (choix[1].checked) {
                col = couleur(feature.properties.an15trim1);
            } else {
                col = couleur(feature.properties.an15trim2);
            }
        }  
        console.log(col);
        return {
            fillColor: col,
            fillOpacity: 0.5,
            weight: 1,
            color: "#777",
            opacity: 1
        }
    });
}


// Création de la carte
var map = L.map('map', {
    center: [46.3, 2.3],
    zoom: 6,
    minZoom: 6,
    maxZoom: 9
});

L.tileLayer('http://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
	subdomains: 'abcd',
    opacity: 0.8
}).addTo(map);


// Ajout de la légende
//  5 -> 15
// 43.8 -> 45.8
for (tx = 5, lat = 43.8; tx <= 15; tx = tx + 1, lat += 0.2) {
    L.rectangle([[lat + 0.2, -5], [lat, -4]], {fillColor: couleur(tx), fillOpacity: 1, weight: 0}).addTo(map);
    if (tx % 2 > 0) {
        L.marker([lat + 0.1, -3.8], {
            html: "test",
            style: { fillOpacity: 0 },
            icon: L.divIcon({ className: "legend-icon", html: tx + "%"})
        }).addTo(map);
    }
}


Papa.parse("../departements-chomage.tsv", {
    download: true,
    header: true,
    complete: function (results) {
        "use strict";
        var chomage = results.data;
        chomage.forEach(function (c) {
            c.an14trim2 = +c.an14trim2;
            c.an15trim1 = +c.an15trim1;
            c.an15trim2 = +c.an15trim2;
        });

        $.getJSON("../departements.geojson", function (data) {

            // Ici, à chaque département, on lui associe les valeurs du chômage
            data.features.forEach(function (d) {
                var ch = chomage.filter(function (c) { if (c.code === d.properties.code) { return true; } return false; })[0];
                d.properties.an14trim2 = ch.an14trim2;
                d.properties.an15trim1 = ch.an15trim1;
                d.properties.an15trim2 = ch.an15trim2;
            });

            // Ajout des départements, avec un remplissage en fonction de la variable an15trim2
            geoDep = L.geoJson(data, {
                // option de style à mettre ici
                style: function (feature) {
                    return {
                        fillColor: couleur(feature.properties.an15trim2),
                        fillOpacity: 0.5,
                        weight: 1,
                        color: "#777",
                        opacity: 1
                    };
                },
                // option pour gestion des événements
                onEachFeature: function (feature, layer) {
                    layer.on({
                        mouseover: function (e) {
                            var layer = e.target,
                                prop = layer.feature.properties,
                                souris = e.originalEvent,
                                tooltip = document.getElementById("tooltip");
                            
                            layer.setStyle({
                                fillOpacity: 1,
                                color: "#000"
                            });
                            
                            // Affichage des infos dans le tooltip
                            document.getElementById("nom").innerHTML = prop.nom;
                            document.getElementById("code").innerHTML = prop.code;
                            document.getElementById("txA").innerHTML = prop.an14trim2;
                            document.getElementById("txB").innerHTML = prop.an15trim1;
                            document.getElementById("txC").innerHTML = prop.an15trim2;
                            
                            // Création du graphique du tooltip
                            creationGraph(prop);
                            
                            // Affichage du tooltip
                            tooltip.style.display = "initial";

                            // Déplacement du tooltip en fonction de la souris
                            if (souris.pageY + 125 > window.innerHeight) {
                                tooltip.style.top = souris.pageY - 250 + "px";
                            } else {
                                tooltip.style.top = souris.pageY - 125 + "px";
                            }
                            tooltip.style.left = souris.pageX + 10 + "px";
                            
                            // Graphique à mettre ici !
                        },
                        mouseout : function (e) {
                            geoDep.resetStyle(e.target);
                            document.getElementById("tooltip").style.display = "none";
                        }
                    });
                }
            }).addTo(map);

        });
    }
});


