// Remplissage du tableau
function creationRendu1() {
    "use strict";
    
    var tab = d3.select("#tableau").style("visibility", "visible"),
        tbody = tab.select("tbody").style("text-align", "right"),
        tr = tbody.selectAll("tr")
                .data(donnees.valeurs)
                .enter().append("tr");
    
    tr.append("td").html(function (v, i) { return donnees.modalites[i]; });
    tr.append("td").html(function (v) { return v; });
}