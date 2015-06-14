# Hadoop
type: slides

## Présentation

Framework orienté Big Data ([site web](http://hadoop.apache.org))

Objectifs :
- Faciliter la création d'applications à large échelle
- Être open source
- Ne pas demander des ressources matériels hors norme (i.e. des ordinateurs de bureau peuvent convenir)

---
## Historique

- Créé en 2004 à partir des articles de Google sur MapReduce et GoogleFS, par D. Cutting
- Top-level project Apache en 2006
- Hadoop 1.0 sorti en 2012
- Hadoop 2.0 sorti en 2013

## Quelques liens 

- http://fr.slideshare.net/hugfrance/hugfr-sl2013-hadoop?related=3
- http://fr.hortonworks.com/hadoop-tutorial/hello-world-an-introduction-to-hadoop-hcatalog-hive-and-pig/
- http://mbaron.developpez.com/tutoriels/bigdata/hadoop/introduction-hdfs-map-reduce/
- http://cours.tokidev.fr/bigdata/
- http://soat.developpez.com/tutoriels/bigdata/bigdata-hadoop-log/
- http://pagesperso-systeme.lip6.fr/Jonathan.Lejeune/documents/cours_hadoop.pdf

---
## Quelques utilisateurs connus

- [eBay](http://www.ebaytechblog.com/2010/10/29/hadoop-the-power-of-the-elephant/#.VLb3TIqG9rU)
- [Facebook](https://www.facebook.com/notes/facebook-engineering/looking-at-the-code-behind-our-three-uses-of-apache-hadoop/468211193919)
- [Google](http://googlepress.blogspot.fr/2007/10/google-and-ibm-announce-university_08.html)
- [IBM](http://www-01.ibm.com/software/data/infosphere/hadoop/)
- [ImageShack](http://www.techcrunch.com/2008/05/20/update-imageshack-ceo-hints-at-his-grander-ambitions/)
- [LinkedIn](https://engineering.linkedin.com/hadoop)
- [The New York Times](http://open.blogs.nytimes.com/2007/11/01/self-service-prorated-super-computing-fun/)
- [Spotify](http://files.meetup.com/5139282/SHUG%201%20-%20Hadoop%20at%20Spotify.pdf)
- [Twitter](http://www.slideshare.net/kevinweil/hadoop-pig-and-twitter-nosql-east-2009)
- [Yahoo!](http://developer.yahoo.com/blogs/hadoop)
- [D'autres encore](http://wiki.apache.org/hadoop/PoweredBy)

---
## Composants

- Interne
	- Hadoop Common : outil utile pour la gestion des autres composants
	- HDFS : système de fichiers distribué
	- YARN : framework de 
	- MapReduce : système de calcul parallèle à l'aide de l'algorithme MapReduce
- Autres projets Apache
	- [HBase](http://hbase.apache.org) : BD de type *Column Store*
	- [ZooKeeper](http://zookeeper.apache.org) : gestion de configuration
	- [Hive](http://hive.apache.org) : langage de requête, proche de SQL
	- [Pig](http://pig.apache.org) : langage de requête 
	- [Mahout](http://mahout.apache.org) : libraire de Machine Learning
	- ...

