# Manip de base sur Python
import matplotlib.pyplot
import pandas
from ggplot import *

# Lecture d'un fichier texte
iris = pandas.read_csv("Sites/fxjollois.github.io/donnees/Iris.txt", 
                       header = 0, sep = ";", quotechar = "'")

# informations diverses
iris.shape
iris.count()
iris.info()
list(iris.columns)
list(iris)

# résumé basique
iris.describe()

#------------------------------------------------------
# Stat univarié 

# quanti
iris["Sepal.Length"].describe()
iris["Sepal.Length"].mean()
iris["Sepal.Length"].std()
iris["Sepal.Length"].var()
iris["Sepal.Length"].min()
iris["Sepal.Length"].max()
iris["Sepal.Length"].median()
iris["Sepal.Length"].quantile([.01, .1, .9, .99])

# histogramme
iris.plot.hist()
iris["Sepal.Length"].hist()
iris["Sepal.Length"].hist(bins = 20)
iris["Sepal.Length"].plot(kind = "hist")
iris["Sepal.Length"].plot(kind = "hist", normed = True)
iris["Sepal.Length"].plot(kind = "kde")
iris["Sepal.Length"].plot(kind = "hist", normed = True, color = "lightgrey")
iris["Sepal.Length"].plot(kind = "kde")
# boxplot
iris.boxplot()
iris.boxplot(column = "Sepal.Length")
iris.boxplot(column = "Sepal.Length", grid = False)

# quali
iris.Species.describe()
iris.Species.unique()
iris.Species.value_counts()
iris.Species.value_counts() / iris.Species.count()
tab1 = iris.Species.value_counts()
tab1
tab1p = tab1 / tab1.sum()
tab1p
tab2 = pandas.crosstab(iris.Species, columns="freq")
tab2
tab2p = tab2 / tab2.sum()
tab2p

tab1.plot(kind = "bar")
tab2.plot(kind = "bar")
tab1p.plot(kind = "bar")
tab2p.plot(kind = "bar")
(tabp * 100).plot(kind = "bar")
tab1.plot(kind = "pie", figsize = (6, 6))


#------------------------------------------------------
# Stat bivarié 

# quanti-quanti
iris.corr()
iris["Sepal.Length"].corr(iris["Sepal.Width"])
iris["Sepal.Length"].cov(iris["Sepal.Width"])

iris.plot()

# quali-quanti
iris.groupby("Species").mean()

iris.boxplot(by = "Species")
iris.boxplot(column = "Sepal.Length", by = "Species")

# 