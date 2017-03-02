# intro à Python

# quelques types de base

1
"chaîne"
(1, 2)
[1, 2]
(1, (2, 3), [4, 5])
[1, [2, 3], (4, 5)]


type(1)
type("chaine")
type((1, 2))
type((1, "deux"))
type([1, 2])
type([1, "deux"])

# typage dynamique
a = 1
print(a)
type(a)
a = "deux"
print(a)
type(a)

# suppression d'une variable
del(a)

# opérateurs arithmétiques
5 + 2
5 - 2
5 * 2
5 / 2
5 // 2
5 % 2
5 ** 2

float(5) / float(2)

# opérateurs de comparaisons
5 > 2
5 >= 2
5 < 2
5 <= 2
5 == 2
5 != 2

# Opérateurs booléens
True | False
True & True
not(True)

# sur les chaînes
a = "bonjour"
len(a)
a[1:5]
a[0:3]
a[:3]
a[3:len(a)]
a[3:]
a.upper()
a.capitalize()
a.find('j')
a.replace('jour', 'soir')
a.count('o')

# Création de listes
a = [3, 1, 9, 7]
print(a)
len(a)
a[0]
a[1]
a.sort()
print(a)
a.reverse()
print(a)
a.pop()
print(a)
a.append(5)
print(a)
a.insert(0, 6)
print(a)
a.remove(7)
print(a)
a[:3]
a[2:]
a[1:3]

a = range(1, 5)
print(a)
list(a)
list(range(5))
list(range(5, 0, -1))

[x for x in range(10)]
[x for x in range(10) if x%2 == 0]
[x**2 for x in a if x >= 4]


# Attention aux passages de référence
a = [1, 2, 3, 4]
print(a)
b = a
print(b)
a[0] = 5
print(a)
print(b)
b[1] = 9
print(b)
print(a)
b = a.copy()
a[0] = -1
print(a)
print(b)

# Listes nommées
a = { "nom": "Jollois", "prenom": "FX", "langues": ["R", "Python", "SQL", "SAS"], "labo": { "nom": "LIPADE", "lieu": "CUSP"}}
print(a)
a["nom"]
a["langues"]
a["labo"]
a["labo"]["lieu"]
a.keys()
a.values()



