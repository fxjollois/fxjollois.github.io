library(Hmisc)

con = mdb.get("ca.mdb")
contents(con)

# Transformation en CSV
for (t in names(con)) {
    cat("Table :", t, "\n")
    n = paste("csv/", t, ".csv", sep = "")
    cat("\tFichier :", n, "\n")
    colnames(con[[t]]) = sub("\\.", "_", colnames(con[[t]]))
    write.table(con[[t]], file = n, row.names = F, quote = FALSE, sep = ";")
    file.show(n)
}

# Transformation en JSON
library(rjson)
library(jsonlite)
caall = 
    merge(
        merge(
            merge(
                con$ca, 
                con$groupe, 
                by.x = "groupe_no", by.y = "no"
            ), 
            con$provenance, 
            by.x = "prov_no", by.y = "no"
        ),
        con$mois,
        by.x = "mois_no", by.y = "no"
    )
ca = subset(caall, select = -c(mois_no, prov_no, groupe_no, code_dep, code_groupe, code_sgroupe, code_prov))
names(ca)

writeLines(toJSON(ca, pretty = TRUE), "ca.json")
file.show("ca.json")

ca = con$ca
groupe = con$groupe
mois = con$mois
provenance = con$provenance
save(ca, groupe, mois, provenance, file = "ca.RData")

