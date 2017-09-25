/*global d3, donnees */

// Création et remplissage du diagramme en barre verticales à base de div
function popMove() {
    "use strict";
    
    var newPop = d3.select("#newPop"),
        width = newPop.style("width").replace("px", ""),
        height = newPop.style("height").replace("px", ""),
        mouse = d3.event;
    if (mouse.clientX > (window.innerWidth - width - 50)) {
        newPop.style("left", mouse.clientX - width - 10 + "px");
    } else {
        newPop.style("left", mouse.clientX + 10 + "px");
    }
    if (mouse.clientY > (window.innerHeight - height - 50)) {
        newPop.style("top", mouse.clientY - height - 10 + "px");
    } else {
        newPop.style("top", mouse.clientY + "px");
    }
}

function popUp(mouse) {
    "use strict";
    
    var newPop = d3.select("#newPop"),
        mod = this.modalite,
        val = this.valeur;
    
    newPop.html("<div class='modalite'>" + mod + "</div>" + "<div class='valeur'>" + val + "</div>");
    newPop.style("display", "block");
    popMove();
}

function popDown() {
    "use strict";
    
    var newPop = d3.select("#newPop");
    newPop.style("display", "none");
}

function creationRendu3() {
    "use strict";
    
    var newGraph = d3.select("#newGraph"), newPop, w, wBar, group, visibility;

    if (!newGraph.empty()) {
        visibility = newGraph.style("visibility");
        if (visibility === "visible") {
            newGraph.style("visibility", "hidden");
        } else {
            newGraph.style("visibility", "visible");
        }
    } else {
        newGraph = d3.select("body").append("div").attr("id", "newGraph");
        
        w = newGraph.style("width").replace("px", "");
        wBar = Math.floor(w / donnees.modalites.length);
        
        group = newGraph.selectAll("div")
            .data(donnees.valeurs)
            .enter().append("div")
                .classed({"newGroup": true})
                .style("width", wBar + "px");
        group.append("div").classed({"newVal": true}).html(function (v) { return v; });
        group.append("div").classed({"newBar": true})
            .style("height", function (v) { return (v * 10) + "px"; })
            .property("modalite", function (v, i) { return donnees.modalites[i]; })
            .property("valeur", function (v) { return v; })
            .on("mouseover", popUp)
            .on("mouseout", popDown)
            .on("mousemove", popMove);
        group.append("div").classed({"newMod": true}).html(function (v, i) { return donnees.modalites[i]; });

        newPop = newGraph.append("div").attr("id", "newPop");

    }
}