var test = db.Commandes.find({  }, { _id:0, Produits: 1} ).map( function (p) { return p.Produits });
printjson(test);

var test2 = test.reduce(function(o, n) { return o.concat(n) });
printjson(test2);

var montant = test2.map(function(p) { return p.PrixUnit * p.Qte * (1 - p.Remise); }).reduce(function (o, n) { return o + n; });

printjson(montant);
