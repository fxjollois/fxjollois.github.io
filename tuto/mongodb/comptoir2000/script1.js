// à exécuter avec load("script1.js") sous Mongo (lancé depuis le répertoire contenant ce fichier)

// Commandes de base 
print("Liste des dbs :");
dbs = db.adminCommand('listDatabases').databases;
dbs.forEach(function (db) { printjson(db); });

db = db.getSiblingDB('cpt2000');

print("\nListe des collections de la db :");
printjson(db.getCollectionNames());

print("\nNombre d'éléments dans la collection 'Commandes' :");
print(db.Commandes.count());

print("\nNombre d'éléments dans la collection 'Produits' :");
print(db.Produits.count());

print("\nListe des produits :")
cursor = db.Produits.find();
while ( cursor.hasNext() ) {
   printjson( cursor.next() );
}


// requêtage simple

print("\nListe des produits (Nomprod, Prixunit) :")
cursor = db.Produits.find({}, { Nomprod: 1, PrixUnit: 1, _id: 0 });
while ( cursor.hasNext() ) {
    c = cursor.next();
    print(c.Nomprod + ":\t" + c.PrixUnit + "€");
}

print("\nListe des produits (Nomprod, Prixunit), dont le prix est inférieur à 50€ :")
cursor = db.Produits.find({ PrixUnit: { $lt: 50 } }, { Nomprod: 1, PrixUnit: 1, _id: 0 });
while ( cursor.hasNext() ) {
    c = cursor.next();
    print(c.Nomprod + ":\t" + c.PrixUnit + "€");
}

print("\nListe des produits (Nomprod, Prixunit), dont le prix est inférieur à 100€ et du fournisseur numéro 17 :")
cursor = db.Produits.find({ PrixUnit: { $lt: 100 }, "Fournisseur.NoFour": 17 }, { Nomprod: 1, PrixUnit: 1, "Fournisseur.NoFour": 1, _id: 0 });
while ( cursor.hasNext() ) {
    c = cursor.next();
    print(c.Nomprod + ":\t" + c.PrixUnit + "€ (NoFour = " + c.Fournisseur.NoFour + ")");
}

print("\nListe des produits (Nomprod, Prixunit), dont le prix est inférieur à 100€ et des fournisseurs 17, 18 et 20 :")
cursor = db.Produits.find({ PrixUnit: { $lt: 100 }, "Fournisseur.NoFour": { $in: [ 17, 18, 20] } }, { Nomprod: 1, PrixUnit: 1, "Fournisseur.NoFour": 1, _id: 0 });
while ( cursor.hasNext() ) {
    c = cursor.next();
    print(c.Nomprod + ":\t" + c.PrixUnit + "€ (NoFour = " + c.Fournisseur.NoFour + ")");
}

print("\nListe des catégories")
printjson(db.Produits.distinct( "Categorie.NomCateg" ));


// Calcul d'agrégat

print("\nNombre de produits achetés pour chaque commande")
cursor = db.Commandes.group({ 
    key: { NoCom: 1 }, 
    reduce:  function (c, r) { 
        r.nb = (c.Produits.length ? c.Produits.length : 1);
    }, 
    initial: { nb: 0}
});
printjson(cursor);

print("\nMontant des commandes et nombre de produits achetés");
cursor = db.Commandes.group({ 
    key: { NoCom: 1 }, 
    reduce:  function (c, r) { 
        var total = 0;
        if (c.Produits.length) {
            total = c.Produits.map(function(p) { return p.PrixUnit * p.Qte * (1 - p.Remise); }).reduce(function(o, n) { return o + n; });
        } else {
            total = c.Produits.PrixUnit * c.Produits.Qte * (1 - c.Produits.Remise);
        }
        r.total = total;
        r.nb = (c.Produits.length ? c.Produits.length : 1);
    }, 
    initial: { total: 0, nb: 0 }
});
printjson(cursor);


print("\nMontant des achats et nombre de produits achetés, pour chaque client (avec tri du résultat)");
cursor = db.Commandes.group({ 
    key: { "Client.CodeCli": 1 }, 
    reduce:  function (c, r) { 
        var total = 0;
        if (c.Produits.length) {
            total = c.Produits.map(function(p) { return p.PrixUnit * p.Qte * (1 - p.Remise); }).reduce(function(o, n) { return o + n; });
        } else {
            total = c.Produits.PrixUnit * c.Produits.Qte * (1 - c.Produits.Remise);
        }
        r.total += total;
        r.nb += (c.Produits.length ? c.Produits.length : 1);
    }, 
    initial: { total: 0, nb: 0 }
});
cursorTri = cursor.sort(function (a, b) {
    if (a["Client.CodeCli"] > b["Client.CodeCli"])
      return 1;
    if (a["Client.CodeCli"] < b["Client.CodeCli"])
      return -1;
    // a doit être égale à b
    return 0;
});
printjson(cursorTri);


// Map-Reduce

print("\nChiffre d'affaire de chaque employé");
cursor = db.Commandes.mapReduce(
    function() {
        var a = this.Produits,
            e = this.Employe;
        if (a.length) {
            a.forEach(function(p) {
                emit(e.NoEmp, p.PrixUnit * p.Qte * (1 - p.Remise));
            });
        } else {
            emit(e.NoEmp, a.PrixUnit * a.Qte * (1 - a.Remise));
        }
    },
    function(cle, values) {
        return Array.sum(values);
    },
    {
        out: "map_reduce_example"
    }
);
printjson(cursor);
cursor = db.map_reduce_example.find();
while ( cursor.hasNext() ) {
    printjson(cursor.next());
}
