/*global $, converter, hljs, showdown */

function createCodeBlock(language, div, liste) {
    "use strict";
    var nav = $("#" + div);
    liste.forEach(function (number) {
        var divCode = $("<div>").addClass("myCodeDIV"),
            refCode = $("<a>").addClass("myCodeA");
        $.ajax({
            url: language + "/" + number + "/index.md",
            dataType: "text",
            success: function (file) {
                divCode.text(file.split("\n")[0].split('#')[1]);
                refCode.attr("href", "?language=" + language + "&example=" + number);
                refCode.append(divCode);
                nav.append(refCode);
            }
        });
    });
}

function getParameterByName(name) {
    "use strict";
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function insertMdIntoHtml(file, home) {
    "use strict";
    $.ajax({
        url: file,
        dataType: "text",
        success: function (md) {
            var html = converter.makeHtml(md),
                href;
            $("#content").html(html);
            $("pre code").each(function (i, block) {
                hljs.highlightBlock(block);
            });
            if (home !== undefined) {
                $("#content a").each(function (i, a) {
                    href = a.href.split('/');
                    a.href = "?language=" + href[href.length - 1];
                });
            }
        },
        error: function (error) {
            $("#content").html("<h1>Page non trouv&eacute;e</h1><p>La page demand&eacute;e n'est pas disponible.</p>");
        }
    });
}

var language = getParameterByName('language'),
    example = getParameterByName('example'),
    converter = new showdown.Converter();

if (language === "") {
    // on affiche la page principale
    insertMdIntoHtml("index.md", true);
} else {
    $("header").append(" | retour au <a href='?'>menu</a>");
    if (example === "") {
        // on affiche la page sommaire du language
        insertMdIntoHtml(language + "/index.md");
        // ajout d'un lien vers la home page de prog
    } else {
        $("header").append(" | retour &agrave; <a href='?language=" + language + "'>" + language + "</a>");
        // on affiche la page de l'exemple
        insertMdIntoHtml(language + "/" + example + "/index.md");
    }
}