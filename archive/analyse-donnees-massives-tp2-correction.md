---
title: TP2 - MapReduce sur MongoDB - *correction*
subtitle: Analyse de Données Massives - Master 1ère année
---

## Exercices

Répondez en utilisant le paradigme **Map-Reduce**

##### 1. Calculer le nombre de gymnases pour chaque ville

```js
db.Gymnases.mapReduce(
    function() {
        emit(this.Ville, 1);
    },
    function(cle, valeurs) {
        return Array.sum(valeurs);
    },
    { out: { inline: 1 }}
)
```

##### 2. Calculer le nombre de séances pour chaque jour de la semaine

```js
db.Gymnases.mapReduce(
    function() {
        if (this.Seances) {
            for (s of this.Seances) {
                emit(s.Jour.toLowerCase(), 1);
            }
        }
    },
    function(cle, valeurs) {
        return Array.sum(valeurs);
    },
    { out: { inline: 1 }}
)
```

##### 3. De même pour chaque sport

```js
db.Gymnases.mapReduce(
    function() {
        if (this.Seances) {
            for (s of this.Seances) {
                emit(s.Libelle, 1);
            }
        }
    },
    function(cle, valeurs) {
        return Array.sum(valeurs);
    },
    { out: { inline: 1 }}
)
```

##### 4. Calculer la superficie moyenne des gymnases, pour chaque ville

Pour cela, vous devez calculer la somme des superficie ET la nombre de gymnase (à émettre dans un même objet et à réduire en tenant compte que ce double aspect)

```js
db.Gymnases.mapReduce(
    function() {
        emit(this.Ville, { "nb": 1, "surface": this.Surface, "surfMoy": this.Surface })
    },
    function(cle, valeurs) {
        var nb = 0, surface = 0;
        for (val of valeurs) {
            nb += val.nb;
            surface += val.surface;
        }
        return { "nb": nb, "surface": surface, "surfMoy": Math.round(100 * surface / nb) / 100 }
    },
    { out: { inline: 1 }}
)
```

##### 5. Calculer pour chaque sport, le nombre de séance pour chaque jour de la semaine

- il faudra émettre, pour chaque sport, une valeur complexe (littéral `JSON` pour le jour)
- il faudra réfléchir à l'étape de réduction


```js
db.Gymnases.mapReduce(
    function() {
        if (this.Seances) {
            for (s of this.Seances) {
                emit(s.Libelle, { [s.Jour.toLowerCase()]: 1 });
            }
        }
    },
    function(cle, valeurs) {
        var res = valeurs.reduce(function(A, B) {
            var r = A;
            for (j of Object.keys(A)) {
                if (j in B) {
                    r[j] = A[j] + B[j];
                }
            }
            for (j of Object.keys(B)) {
                if (!(j in A)) {
                    r[j] = B[j];
                }
            }
            return r;
        });
        return res;
    },
    { out: { inline: 1 }}
)
```





