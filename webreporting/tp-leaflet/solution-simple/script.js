/*global L, Papa*/

// - jouer sur l'opacité lors du passage de la souris pour que le département soit bien visible
// - améliorer l'affichage des informations en créant une fenêtre `tooltip` affichant toutes les informations dont on dispose
// - donner la possibilité de choisir l'indicateur permettant la coloration des départements
//    - dans ce cas, il serait judicieux de faire une échelle commune à tous les indicateurs, du genre de celle de l'INSEE
// - s'intéresser aux autres tuiles disponibles via Open Street Map, et les autres fournisseurs


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


Papa.parse("../departements-chomage.tsv", {
    download: true,
    header: true,
    complete: function(results) {
        var chomage = results.data;
        chomage.forEach(function(c) {
            c.an14trim2 = +c.an14trim2;
            c.an15trim1 = +c.an15trim1;
            c.an15trim2 = +c.an15trim2;
        });

        $.getJSON("../departements.geojson", function (data) {
            var geoDep;

            // on cherche le min et le max pour le chômage (2015 trimestre 2) pour le domaine des couleurs
            var maxchomage = chomage.reduce(function(o, n) { if (n.an15trim2 > o.an15trim2) return n; return o; }).an15trim2;
            var minchomage = chomage.reduce(function(o, n) { if (n.an15trim2 < o.an15trim2) return n; return o; }).an15trim2;
            // on créé une fonction prenant la valeur du an15trim2 et qui renvoie une couleur (entre blanc (min) et rouge (max))
            function couleur (val, min, max) {
                var r = 255,
                    g = Math.floor((1 - (val - min) / (max - min)) * 255),
                    b = Math.floor((1 - (val - min) / (max - min)) * 255);
                return "rgb(" + r + ", " + g + ", " + b + ")";
            }

            // Ici, à chaque département, on lui associe les valeurs du chômage
            data.features.forEach(function (d) {
                var ch = chomage.filter(function(c) { if (c.code === d.properties.code) return true; return false; })[0];
                d.properties.an14trim2 = ch.an14trim2;
                d.properties.an15trim1 = ch.an15trim1;
                d.properties.an15trim2 = ch.an15trim2;
            });

            // Ajout des départements, avec un remplissage en fonction de la variable an15trim2
            geoDep = L.geoJson(data, {
                // option de style à mettre ici
                style: function (feature) {
                    return { 
                        fillColor: couleur(feature.properties.an15trim2, minchomage, maxchomage),
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
                            })
                            
                            // Affichage des infos dans le tooltip
                            document.getElementById("nom").innerHTML = prop.nom;
                            document.getElementById("code").innerHTML = prop.code;
                            document.getElementById("txA").innerHTML = prop.an14trim2;
                            document.getElementById("txB").innerHTML = prop.an15trim1;
                            document.getElementById("txC").innerHTML = prop.an15trim2;
                            
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
                    })
                }
            }).addTo(map);

        });
    }
});


/*
     
     
var svg = d3.select(map.getPanes().overlayPane).append("svg"),
    g = svg.append("g").attr("class", "leaflet-zoom-hide");

var color = d3.scale.linear()
            .range(["white", "red"]);

function createGraph(data) {
    "use strict";
    d3.select("#graph").html("");

    var w = 200,
        h = 150,
        margin = 20,
        y = d3.scale.linear().domain([5, 15]).range([margin, h - margin]),
        x = d3.scale.linear().domain([0.8, data.length + 0.2]).range([margin, w - margin]),
        
        vis = d3.select("#graph")
            .append("svg")
            .attr("width", w)
            .attr("height", h),
        
        g = vis.append("g")
            .attr("transform", "translate(0, " + h + ")"),
        
        line = d3.svg.line()
            .x(function (d, i) { return x(i + 1); })
            .y(function (d) { return -1 * y(d); });
			
    g.append("svg:path").attr("d", line(data));
    
    g.selectAll(".xLabel")
        .data(["2014-Q2", "2015-Q1", "2105-Q2"])
        .enter().append("text")
        .attr("class", "xLabel")
        .text(function (d) { return d; })
        .attr("x", function (d, i) { return x(i + 1); })
        .attr("y", 0)
        .attr("text-anchor", "middle");
    
    g.selectAll(".yLabel")
        .data(y.ticks(5))
        .enter().append("text")
        .attr("class", "yLabel")
        .text(String)
        .attr("x", 0)
        .attr("y", function (d) { return -1 * y(d); })
        .attr("text-anchor", "right")
        .attr("dy", 4);
		
    g.selectAll(".yTicks")
        .data(y.ticks(4))
        .enter().append("svg:line")
        .attr("class", "yTicks")
        .attr("y1", function (d) { return -1 * y(d); })
        .attr("x1", x(0.85))
        .attr("y2", function (d) { return -1 * y(d); })
        .attr("x2", x(0.95));
}

function generateTooltip(dep) {
    
    createGraph([dep.properties.an14trim2, dep.properties.an15trim1, dep.properties.an15trim2]);

    
    if (d3.event.pageY + 125 > window.innerHeight) {
        tooltip.style("top", d3.event.pageY - 250 + "px");
    } else {
        tooltip.style("top", d3.event.pageY - 125 + "px");
    }
    tooltip.style("left", d3.event.pageX + 10 + "px");
}


d3.tsv("../departements-chomage.tsv", function (error, chomage) {

    d3.json("../departements.geojson", function (error, data) {
        
        function reset() {
            var bounds = path.bounds(data),
                topLeft = bounds[0],
                bottomRight = bounds[1];

            svg.attr("width", bottomRight[0] - topLeft[0])
                .attr("height", bottomRight[1] - topLeft[1])
                .style("left", topLeft[0] + "px")
                .style("top", topLeft[1] + "px");
            g.attr("transform", "translate(" + -topLeft[0] + "," + -topLeft[1] + ")");

            feature.attr("d", path);

            // Légende à ajouter
            var legend = svg.append("g").attr("id", "legend"),
                valeurs = [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15].reverse();
            legend.selectAll("rect")
                .data(valeurs)
                .enter().append("rect")
                .attr("x", "0px")
                .attr("y", function (d, i) { return 400 + i * 10 + "px"; })
                .attr("width", 50 + "px")
                .attr("height", 10 + "px")
                .attr("fill", function (d) { return color(d); });
            legend.selectAll("text")
                .data(valeurs)
                .enter().append("text")
                .attr("x", 60 + "px")
                .attr("y", function (d, i) { return 400 + (i + 1) * 10 + "px"; })
                .attr("text-anchor", "right")
                .text(function (d) { if (d % 2 === 1) { return d + " %"; } });
        }

        map.on("viewreset", reset);
        reset();
        
    });
});
*/