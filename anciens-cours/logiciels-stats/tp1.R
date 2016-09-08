##################################################
# Importation de fichiers

# Iris.txt
ir = read.table("Iris.txt", header = T, sep = ";")
head(ir)

# heart.txt
heart = read.table("heart.txt", header = T) # sep = "\t" est inutile ici
head(heart)

# Detroit_homicide.txt
# readLines("Detroit_homicide.txt")
dh = read.table("Detroit_homicide.txt", 
                skip = 35, header = T)
head(dh)

# hepatitis.TXT
hep = read.table("hepatitis.TXT", 
                 header = T, na.strings = "?")
head(hep)

##################################################
# Complément de langage

# heart.txt
heart = read.table("heart.txt", header = T) 
heart$coeurB = (heart$coeur == "presence")
heart$nbA = apply(heart[,c("type_douleur", "sucre", "electro", "vaisseau")] == "A", 1, sum)
heart$coeurF = factor(heart$coeurB, labels = c("Absence", "Présence"))

heart60 = heart[heart$age < 60,]    

heart60M = heart60[heart$sexe == "masculin",]
heart60F = heart60[heart$sexe == "feminin",]

# detroit_homicide.txt 
dh = read.table("Detroit_homicide.txt", skip = 35, header = T)
attr(dh, "info") = paste(readLines("Detroit_homicide.txt", n = 19), collapse = "\n")

labels = tail(readLines("Detroit_homicide.txt", n = 34), n = 15)
labels = labels[labels != ""]
attr(dh, "labels") = 
    as.data.frame(
        t(
            sapply(
                labels, 
                function(lab) {
                    split = strsplit(lab, " - ")[[1]]
                    return (c(nom = trimws(split[1]), label = split[2]))
                },
                USE.NAMES = FALSE
            )
        )
    )

attributes(dh)

