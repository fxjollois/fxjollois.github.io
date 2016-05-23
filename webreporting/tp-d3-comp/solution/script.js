/*global console,d3*/
function remplissageTableau(data) {
    "use strict";
    
    function td(cont) {
        if (isNaN(cont)) {
            cont = "";
        }
        return ["<td>", cont, "</td>"].join("");
    }
    var tab = d3.select("#tab tbody").selectAll("tr")
        .data(data).enter().append("tr").html(function (d) {
            var chaine = [td(d.arr), td(d.stations), td(d["entrées"]),
                          td(d["stationsMétro"]), td(d["entréesMétro"]),
                          td(d.stationsRER), td(d["entréesRER"])].join("");
            return chaine;
        });
}

function creationDiagBar(data, type) {
    "use strict";
    
    var indicateur = "entrées",
        marges = {haut: 20, droite: 20, bas: 20, gauche: 20},
        largeur = 800,
        hauteur = 600,
        
        x = d3.scale.ordinal()
            .domain(data.map(function (d) { return d.arr; }))
            .rangeBands([marges.gauche, largeur - marges.droite], 0.2),
        
        y = d3.scale.linear()
            .range([hauteur - marges.bas, marges.haut]),
        
        svg = d3.select("#bar").append("svg").attr("width", largeur).attr("height", hauteur);
    
    svg.append("rect").attr("width", largeur).attr("height", hauteur)
        .style("stroke", "red").style("stroke-width", 2).style("fill", "transparent");
    
    if (type === "métro") {
        indicateur = "entréesMétro";
    }
    if (type === "rer") {
        indicateur = "entréesRER";
    }
    
    y.domain([0, d3.max(data.map(function (d) { return d[indicateur]; }))]);
    console.log(y.range());
    svg.selectAll(".bar").data(data).enter()
        .append("rect")
        .classed({"bar": true})
        .attr("x", function (d) { return x(d.arr); })
        .attr("width", x.rangeBand())
        .attr("y", function (d) { return y(d[indicateur]); })
        .attr("height", function (d) { return hauteur - marges.bas - y(d[indicateur]); });
}

function go() {
    "use strict";
    
    // Lecture des données
    d3.dsv(";", "text/plain")("../../../donnees/RATP-trafic-entrant-2015/trafic-annuel-entrant-par-station-du-reseau-ferre-2015-resume.csv", function (data) {
        data.forEach(function (d) {
            d["entrées"] = +d["entrées"];
            d["stations"] = +d["stations"];
            d["entréesMétro"] = +d["entréesMétro"];
            d["stationsMétro"] = +d["stationsMétro"];
            d["entréesRER"] = +d["entréesRER"];
            d["stationsRER"] = +d["stationsRER"];
        });
        console.log(data[1]);
        remplissageTableau(data);
        creationDiagBar(data, "rer");
    });
}