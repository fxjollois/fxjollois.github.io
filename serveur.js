/*global require, console */
/* fonctionnement via serveur node */
var http = require('http'),
    dvt = require("./dvt");

http.createServer(function (req, res) {
    "use strict";
    var page = req.url,
        html;
    res.writeHead(200, {'Content-Type': 'text/html'});
    //res.end('Hello World\n');
    if ((page !== "/favicon.ico") || (page.indexOf(".css") > -1)) {
        if (page.length === 1) {
            page = "";
        } else {
            if (page[page.length - 1] !== "/") {
                page = page + "/";
            }
            page = page.slice(1);
        }
        console.log(page + "index.md");
        html = dvt.createHtmlFile(dvt.getDataFromFile(page + "index.md"));
        res.write(html);
    }
    res.end();
}).listen(1337, "127.0.0.1");

console.log('Server running at http://127.0.0.1:1337/');