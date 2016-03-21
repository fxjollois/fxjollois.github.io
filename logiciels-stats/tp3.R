adult = read.table("adult.data", sep = ",")
names(adult) = c(
    # read.table("adult.names", sep = ":", 
    #            skip = 96, stringsAsFactors = F)[,1]
    unlist(
        lapply(
            tail(readLines("adult.names"), 14), 
            function(n) return (strsplit(n, ":")[[1]][1]))
        ),
    "class"
)

head(adult)

