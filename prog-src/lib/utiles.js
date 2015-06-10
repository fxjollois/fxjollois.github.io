var createCodeBlock = function (div, liste) {
    "use strict";
    var nav = $("#" + div);
    liste.forEach(function (number) {
        var divCode = $("<div>").addClass("myCodeDIV"),
            refCode = $("<a>").addClass("myCodeA");
        $.ajax({
            url: number + "/index.md",
            dataType: "text",
            success: function (file) {
                divCode.text(file.split("\n")[0]);
                refCode.attr("href", number + "/");
                refCode.append(divCode);
                nav.append(refCode);
            }
        });
    });
};