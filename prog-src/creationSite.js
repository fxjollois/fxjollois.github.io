/* 
    Transformation des index.md en index.html 
    à exécuter avec : "iojs creationSite.js"
*/

var showdown  = require("showdown"),
    fs = require("fs"),
    converter = new showdown.Converter();

// page d'intro
fs.readFile("index.md", "utf-8", function (error, data) {
    "use strict";
    var contentHtml = converter.makeHtml(data),
        titre = "",
        headHtml = "<head><title>" + titre + "</title>" +
            "<link rel='stylesheet' href='prog.css'>" +
            "</head>",
        bodyHtml = "<body>" +
            "<header>à propos de <a href='../'>moi</a></header>" +
            "<div id='content'>" + contentHtml + "</div>" +
            "</body>",
        doc = "<!doctype html>" + headHtml + bodyHtml;
    fs.writeFile('index.html', doc);
});

// pour chaque language (et donc répertoire)
var createRep = function (language) {
    "use strict";
    // copie de la page de sommaire
    
};
createRep("sql");