# Comptoir2000 sous MongoDB

Ce tutoriel a pour but de présenter le système d'interrogation de **MongoDB** sur une base de données basique.

## Description des données

La base de données *Comptoir2000* est une base classique relationnelle. Elle provient de la base de données [Northwind](https://www.microsoft.com/en-us/download/details.aspx?id=23654) proposée comme exemple pour **Access** et **SQL Server**. Pour les besoins d'un cours, je l'ai portée au format MongoDB. Vous pouvez récupérer les deux fichiers au format **JSON** :

- [Commandes](mongodb/2/Comptoir2000-commandes.mongodb)
- [Produits](mongodb/2/Comptoir2000-produits.mongodb)

Pour l'importer sous MongoDB, vous devez exécuter les deux commandes suivantes dans un terminal. Il faut bien sûr que le serveur MongoDB soit lancé (avec la commande `mongod` dans un terminal par exemple).

```html
mongoimport --db cpt2000 --collection Commandes --file Comptoir2000-commandes.mongodb
mongoimport --db cpt2000 --collection Produits --file Comptoir2000-produits.mongodb
```

Comme vous pouvez le voir, la BD est composée de deux collections :

- une sur les **commandes**, où appraissent ainsi les informations des commandes, du client, de l'employé, du message et des produits achetés ;
- une sur les **produits**, contenant donc les informations sur les produits, ainsi que sur les fournisseurs et les catégories.


### Collection Commandes

```json
{
	"_id" : ObjectId("557a94a685076b10ddd2831a"),
	"NoCom" : 10248,
	"DateCom" : "04AUG1994:00:00:00",
	"ALivAvant" : "01SEP1994:00:00:00",
	"DateEnv" : "16AUG1994:00:00:00",
	"Port" : "162",
	"Destinataire" : "Vins et alcools Chevalier",
	"AdrLiv" : "59 rue de lAbbaye",
	"VilleLiv" : "Reims",
	"CodepostalLiv" : "51100",
	"PaysLiv" : "France",
	"Client" : {
		"CodeCli" : "VINET",
		"Societe" : "Vins et alcools Chevalier",
		"Contact" : "Paul Henriot",
		"Fonction" : "Chef comptable",
		"Adresse" : "59 rue de lAbbaye",
		"Ville" : "Reims",
		"CodePostal" : "51100",
		"Pays" : "France",
		"Tel" : "26.47.15.10",
		"Fax" : "26.47.15.11"
	},
	"Produits" : [
		{
			"Refprod" : 11,
			"PrixUnit" : 70,
			"Qte" : 12,
			"Remise" : 0
		},
		{
			"Refprod" : 42,
			"PrixUnit" : 49,
			"Qte" : 10,
			"Remise" : 0
		},
		{
			"Refprod" : 72,
			"PrixUnit" : 174,
			"Qte" : 5,
			"Remise" : 0
		}
	],
	"Messager" : {
		"NoMess" : 3,
		"NomMess" : "Federal Shipping",
		"Tel" : "(503) 555-9931"
	},
	"Employe" : {
		"NoEmp" : 5,
		"Nom" : "Buchanan",
		"Prenom" : "Steven",
		"Fonction" : "Chef des ventes",
		"TitreCourtoisie" : "M.",
		"DateNaissance" : "04MAR1955:00:00:00",
		"DateEmbauche" : "17OCT1993:00:00:00",
		"Adresse" : "14 Garrett Hill",
		"Ville" : "London",
		"Codepostal" : "SW1 8JR",
		"Pays" : "Royaume-Uni",
		"TelDom" : "(71) 555-4848",
		"Extension" : "3453",
		"RendCompteA" : 2
	}
}
```

### Collection Produits

```json
{
	"_id" : ObjectId("557a94ae85076b10ddd28658"),
	"Refprod" : 1,
	"Nomprod" : "Chai",
	"QteParUnit" : "10 boîtes x 20 sacs",
	"PrixUnit" : 90,
	"UnitesStock" : 39,
	"UnitesCom" : 0,
	"NiveauReap" : 10,
	"Indisponible" : 0,
	"Fournisseur" : {
		"NoFour" : 1,
		"Societe" : "Exotic Liquids",
		"Contact" : "Charlotte Cooper",
		"Fonction" : "Assistant export",
		"Adresse" : "49 Gilbert St.",
		"Ville" : "London",
		"CodePostal" : "EC1 4SD",
		"Pays" : "Royaume-Uni",
		"Tel" : "(171) 555-2222"
	},
	"Categorie" : {
		"CodeCateg" : 1,
		"NomCateg" : "Boissons",
		"Description" : "Boissons, cafés, thés, bières"
	}
}
```

## Requêtage

Bien évidemment, puisque les données ne sont plus au format relationnel, un langage comme **SQL** n'est plus d'actualité. Il faut donc manipuler différement les données, avec le langage de script proposé par MongoDB, très proche de **JavaScript**. Il y a deux possibilités pour accéder aux données sous MongoDB. a première consiste à taper du code dans la console (ou *shell*). La seconde est de créer un script (fichier texte) qu'on va exécuter avec la commande `load('script1.js')`.

### Quelques commandes simples

Je présente ici quelques commandes basiques permettant d'accèder aux données et de commencer à les manipuler. 

#### Sélection de la BD `cpt2000` 

```mongo
use cpt2000 // uniquement dans le shell
db = db.getSiblingDB('cpt2000');
```

#### Liste des collections de la db

```mongo
db.getCollectionNames();
```

#### Nombre d'éléments dans la collection `Commandes`

```mongo
db.Commandes.count();
```

#### Nombre d'éléments dans la collection `Produits`

```mongo
db.Produits.count();
```

#### Liste des produits

```mongo
cursor = db.Produits.find();
while ( cursor.hasNext() ) {
   printjson( cursor.next() );
}
```

Notez que j'ai obtenu les premiers documents de chaque collection avec les commandes suivantes :

```mongo
db.Commandes.find()[0];
db.Produits.find()[0];
```

### Requêtages classiques

Restriction, projection, projection avec suppression des doublons

#### Liste des produits (Nomprod, Prixunit)
```mongo
cursor = db.Produits.find({}, { Nomprod: 1, PrixUnit: 1, _id: 0 });
while ( cursor.hasNext() ) {
    c = cursor.next();
    print(c.Nomprod + ":\t" + c.PrixUnit + "€");
}
```

#### Liste des produits (Nomprod, Prixunit), dont le prix est inférieur à 50€
```mongo
cursor = db.Produits.find({ PrixUnit: { $lt: 50 } }, { Nomprod: 1, PrixUnit: 1, _id: 0 });
while ( cursor.hasNext() ) {
    c = cursor.next();
    print(c.Nomprod + ":\t" + c.PrixUnit + "€");
}
```

#### Liste des produits (Nomprod, Prixunit), dont le prix est inférieur à 100€ et du fournisseur numéro 17
```mongo
cursor = db.Produits.find({ PrixUnit: { $lt: 100 }, "Fournisseur.NoFour": 17 }, { Nomprod: 1, PrixUnit: 1, "Fournisseur.NoFour": 1, _id: 0 });
while ( cursor.hasNext() ) {
    c = cursor.next();
    print(c.Nomprod + ":\t" + c.PrixUnit + "€ (NoFour = " + c.Fournisseur.NoFour + ")");
}
```

#### Liste des produits (Nomprod, Prixunit), dont le prix est inférieur à 100€ et des fournisseurs 17, 18 et 20
```mongo
cursor = db.Produits.find({ PrixUnit: { $lt: 100 }, "Fournisseur.NoFour": { $in: [ 17, 18, 20] } }, { Nomprod: 1, PrixUnit: 1, "Fournisseur.NoFour": 1, _id: 0 });
while ( cursor.hasNext() ) {
    c = cursor.next();
    print(c.Nomprod + ":\t" + c.PrixUnit + "€ (NoFour = " + c.Fournisseur.NoFour + ")");
}
```

#### Liste des catégories
```mongo
printjson(db.Produits.distinct( "Categorie.NomCateg" ));
```

### Calcul d'agrégat

#### Nombre de produits achetés pour chaque commande

```mongo
cursor = db.Commandes.group({ 
    key: { NoCom: 1 }, 
    reduce:  function (c, r) { 
        r.total = (c.Produits.length ? c.Produits.length : 1);
    }, 
    initial: { total: 0}
});
printjson(cursor);
```

#### Montant des commandes et nombre de produits achetés

```mongo
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
```

#### Montant des achats et nombre de produits achetés, pour chaque client

```mongo
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
```

### Map-Reduce

#### Chiffre d'affaire de chaque employé

```mongo
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
        if (cle === 77)
            printjson({cle: cle, values: values });
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
```











