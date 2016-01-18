/*global L, d3*/
var map = L.map('map', {
    center: [46.3, 2.3],
    zoom: 6,
    minZoom: 6,
    maxZoom: 9
});//.setView([46.3, 2.3], 6);

L.tileLayer('http://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>',
	subdomains: 'abcd',
    opacity: 0.8
}).addTo(map);
     
     
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
    "use strict";
    var tooltip = d3.select("#tooltip"),
        nom = tooltip.select("#nom"),
        code = tooltip.select("#code"),
        tx1 = tooltip.select("#txA"),
        tx2 = tooltip.select("#txB"),
        tx3 = tooltip.select("#txC");
    
    nom.html(dep.properties.nom);
    code.html(dep.properties.code);
    tx1.html(dep.properties.an14trim2);
    tx2.html(dep.properties.an15trim1);
    tx3.html(dep.properties.an15trim2);
    
    createGraph([dep.properties.an14trim2, dep.properties.an15trim1, dep.properties.an15trim2]);

    tooltip.style("display", "initial");
    
    if (d3.event.pageY + 125 > window.innerHeight) {
        tooltip.style("top", d3.event.pageY - 250 + "px");
    } else {
        tooltip.style("top", d3.event.pageY - 125 + "px");
    }
    tooltip.style("left", d3.event.pageX + 10 + "px");
}

function hideTooltip() {
    "use strict";
    var tooltip = d3.select("#tooltip");

    tooltip.style("display", "none");
}

d3.tsv("../departements-chomage.tsv", function (error, chomage) {
    "use strict";
    
    if (error) {
        throw error;
    }

    chomage.forEach(function (c) {
        c.an14trim2 = +c.an14trim2;
        c.an15trim1 = +c.an15trim1;
        c.an15trim2 = +c.an15trim2;
    });

    d3.json("../departements.geojson", function (error, data) {
        
        if (error) {
            throw error;
        }

        color.domain([
            chomage.reduce(function (o, n) { if (n.an15trim2 < o.an15trim2) { return n; } return o; }).an15trim2,
            chomage.reduce(function (o, n) { if (n.an15trim2 > o.an15trim2) { return n; } return o; }).an15trim2
        ]);

        data.features.forEach(function (d) {
            var ch = chomage.filter(function (c) { if (c.code === d.properties.code) { return true; } return false; })[0];
            d.properties.an14trim2 = ch.an14trim2;
            d.properties.an15trim1 = ch.an15trim1;
            d.properties.an15trim2 = ch.an15trim2;
        });

        // Use Leaflet to implement a D3 geometric transformation.
        function projectPoint(x, y) {
            var point = map.latLngToLayerPoint(new L.LatLng(y, x));
            this.stream.point(point.x, point.y);
        }

        var transform = d3.geo.transform({point: projectPoint}),
            path = d3.geo.path().projection(transform),
            
            feature = g.selectAll("path")
                .data(data.features)
                .enter().append("path")
                .classed({"departement": true})
                .style("fill", function (d) { return color(d.properties.an15trim2); })
                .property("nom", function (d) { return d.properties.nom; })
                .property("code", function (d) { return d.properties.code; })
                .property("an14trim2", function (d) { return d.properties.an14trim2; })
                .property("an15trim1", function (d) { return d.properties.an15trim1; })
                .property("an15trim2", function (d) { return d.properties.an15trim2; })
                .on("mouseover", generateTooltip)
                .on("mouseout", hideTooltip);

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