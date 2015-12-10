/*global console, d3, $ */

function creationPie(donnees, type) {
    "use strict";
    
    var pieChart = d3.select("#pieChart");
    pieChart.html("");
    
    /* Création des données pour le pie chart */
    var data = [], groupe = donnees.groupe.slice();
    $.unique(groupe.sort());
    groupe.forEach(function (g, i) {
        var val, info, select = donnees.valeurs.filter(function (v, j) {
            if (donnees.groupe[j] === g) {
                return true;
            }
            return false;
        });
        switch (type) {
            case "count":
                val = select.length;
                info = val;
                break;
            case "sum":
                val = d3.sum(select);
                info = Math.round(val / d3.sum(donnees.valeurs) * 100) + " %";
                break;
            default:
                console.log("ERROR: 'type' doit être égal à 'count' ou 'sum'.");
                val = 0;
        }
        data.push({ groupe: g, valeur: val, info: info })
    });
    
    var width = 200,
        height = 200,
        radius = Math.min(width, height) / 2;
    
    var color = d3.scale.ordinal()
                    .range(["#C3F800", "#FF4F00"])
                    .domain(groupe);
    
    var arc = d3.svg.arc()
                    .outerRadius(radius - 10)
                    .innerRadius(0);
    
    var labelArc = d3.svg.arc()
                    .outerRadius(radius - 40)
                    .innerRadius(radius - 40);
    
    var pie = d3.layout.pie()
        .sort(null)
        .value(function(d) { return d.valeur; });
    
    var svg = pieChart.append("svg")
            .attr("width", width)
            .attr("height", height)
        .append("g")
            .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
    
    var g = svg.selectAll(".arc")
      .data(pie(data))
    .enter().append("g")
      .attr("class", "arc")
        .on("click", function(d) { creationTable(donnees, d.data.groupe); creationBarV(donnees, d.data.groupe);});
    
    g.append("path")
        .attr("d", arc)
        .style("fill", function(d) { return color(d.data.groupe); });
    
    g.append("text")
        .attr("transform", function(d) { return "translate(" + labelArc.centroid(d) + ")"; })
        .style("font-size", "80%")
        .text(function(d) { return d.data.info; });

    // pour la légende
    var legendRectSize = 15,
        legendSpacing = 4;
    
    var legend = svg.selectAll('.legend')
                        .data(color.domain())
                        .enter()
                        .append('g')
                        .attr('class', 'legend')
                        .attr('transform', function(d, i) {
                            var h = legendRectSize + legendSpacing,
                                horz = -width/2,
                                vert = -height/2 + i * h;
                            return 'translate(' + horz + ',' + vert + ')';
                        });
    
    legend.append('rect')
        .attr('width', legendRectSize)
        .attr('height', legendRectSize)
        .style('fill', color)
        .style('stroke', color);
    
    legend.append('text')
        .attr('x', legendRectSize + legendSpacing)
        .attr('y', legendRectSize - legendSpacing)
        .text(function(d) { return d; });
    
    
}


function creationTable(donnees, qui) {
    "use strict";
    
    var tab = $("#tab tbody"), table = $("<table>"), data = [];

    donnees.valeurs.forEach(function (v, i) {
        switch(qui) {
            case "all":
                data.push([donnees.groupe[i], donnees.modalites[i], donnees.valeurs[i]]);
                break;
            default:
                if (qui === donnees.groupe[i]) {
                    data.push([donnees.groupe[i], donnees.modalites[i], donnees.valeurs[i]]);
                }
        }
    });
    
    tab.html("");
    data.forEach(function(d) {
        var tr = $("<tr>");
        d.forEach(function(dd) { 
            var td = $("<td>").html(dd);
            tr.append(td);
        });
        tab.append(tr);
    })

}


function creationBarH(donnees, qui) {
    
}

function creationBarV(donnees, qui) {
    "use strict";
    var couleurBarre, barV = d3.select("#barV"), data = [];
    
    $("#barV").html("");
    
    donnees.valeurs.forEach(function (v, i) {
        switch(qui) {
            case "all":
                data.push({
                    "groupe": donnees.groupe[i],
                    "modalite": donnees.modalites[i],
                    "valeur": donnees.valeurs[i]
                });
                break;
            default:
                if (qui === donnees.groupe[i]) {
                    data.push({
                        "groupe": donnees.groupe[i],
                        "modalite": donnees.modalites[i],
                        "valeur": donnees.valeurs[i]
                    });
                }
        }
    });
    
    switch(qui) {
        case "all":
            couleurBarre = "#CFCFCF";
            break;
        case "A":
            couleurBarre = "#C3F800";
            break;
        case "B":
            couleurBarre = "#FF4F00";
            break;
    }
    
    var margin = {top: 20, right: 20, bottom: 30, left: 40},
        width = $("#barV").width() - margin.left - margin.right,
        height = 300 - margin.top - margin.bottom;

    var x = d3.scale.ordinal()
    .rangeRoundBands([0, width], .1);

    var y = d3.scale.linear()
    .range([height, 0]);
    
    var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

    var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left")
    .ticks(10, " ");
    
    var svg = barV.append("svg").attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
    x.domain(data.map(function(d) { return d.modalite; }));
    y.domain([0, d3.max(data, function(d) { return d.valeur; })]);
    
    svg.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);
    
    svg.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end")
        .text("Occurences");
    
    svg.selectAll(".bar")
        .data(data)
        .enter().append("rect")
        .style("fill", couleurBarre)
        .attr("x", function(d) { return x(d.modalite); })
        .attr("width", x.rangeBand())
        .attr("y", function(d) { return y(d.valeur); })
        .attr("height", function(d) { return height - y(d.valeur); });
    
}

function creationRendu(donnees) {
    "use strict";
    
    creationPie(donnees, 'count');
    $("#repNombre").click(function() { creationPie(donnees, 'count'); });
    $("#repSomme").click(function() {creationPie(donnees, 'sum'); });
    
    creationTable(donnees, 'all');
    
    creationBarV(donnees, 'all');
}

function go() {
    "use strict";
    
    // Lecture des données
    d3.json("donnees.json", function (data) {
        console.log(data.valeurs);
        console.log(data.modalites);
        console.log(data.groupe);
        creationRendu(data);
    });
}