/*global $, converter, hljs, showdown */

function createCodeBlock(tool, div, liste) {
    "use strict";
    var nav = $("#" + div);
    liste.forEach(function (number) {
        var divCode = $("<div>").addClass("myCodeDIV"),
            refCode = $("<a>").addClass("myCodeA");
        $.ajax({
            url: tool + "/" + number + "/index.md",
            dataType: "text",
            success: function (file) {
                divCode.text(file.split("\n")[0].split('#')[1]);
                refCode.attr("href", "?tool=" + tool + "&example=" + number);
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
            // est-ce un diaporama (oui si deuxième ligne === type: slides
            if (md.split("\n")[1] === "type: slides") {
                md = md.replace("type: slides\n", "");
                $.getScript("https://gnab.github.io/remark/downloads/remark-latest.min.js", function() {
                    var text = '<textarea id="source">' + md + '</textarea>';
                    $("#content").html(text);    
                    $("header").css("float", "left");
                    $("header").html($("header").html().replace(/\|/g, "<br>"));
                    remark.create();
                });
            } else {
                $("#content").html(html);
                $("pre code").each(function (i, block) {
                    hljs.highlightBlock(block);
                });
            }
            if (home !== undefined) {
                $("#content a").each(function (i, a) {
                    href = a.href.split('/');
                    a.href = "?tool=" + href[href.length - 1];
                });
            }
        },
        error: function (error) {
            $("#content").html("<h1>Page non trouv&eacute;e</h1><p>La page demand&eacute;e n'est pas disponible.</p>");
        }
    });
}

var tool = getParameterByName('tool'),
    example = getParameterByName('example'),
    converter = new showdown.Converter();

if (tool === "") {
    // on affiche la page principale
    insertMdIntoHtml("index.md", true);
} else {
    $("header").append(" | retour au <a href='?'>menu</a>");
    if (example === "") {
        // on affiche la page sommaire du tool
        insertMdIntoHtml(tool + "/index.md");
        // ajout d'un lien vers la home page de prog
    } else {
        $("header").append(" | retour &agrave; <a href='?tool=" + tool + "'>" + tool + "</a>");
        // on affiche la page de l'exemple
        insertMdIntoHtml(tool + "/" + example + "/index.md");
    }
}