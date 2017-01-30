# Importation
pen.tra = read.table("../../donnees/pendigits.tra", sep = ",")
pen.tes = read.table("../../donnees/pendigits.tes", sep = ",")

pen = rbind(pen.tra, pen.tes)
names(pen) = c(paste0(c("X", "Y"), rep(1:8, each = 2)), "digit")
pen$digit = factor(pen$digit)

# remove useless variables
rm(pen.tra, pen.tes)

# Melt data
pen.melt = melt(pen, id.vars = 17)

# Drawn function
drawn <- function(v, n = NULL, point = FALSE, add = FALSE, color = "black") {
    # Transformation of the data.frame if needed
    if (is.data.frame(v))
        v = unlist(v)
    # extract x and y coordinates
    x = v[seq(1, 15, by = 2)]
    y = v[seq(2, 16, by = 2)]
    # optimize space into graphics in reducing margin (sse ?par for more information)
    opar = par(mar = c(0, 0, 2, 0) + .1)
    if (!add) { # Create a graphic
        plot(x, y, 
             # Specify limits is a way to have always the same frame for plotting lines
             xlim = c(-5, 105), ylim = c(-5, 105),
             # Do not show axes
             axes = FALSE,
             # If point is TRUE, we add a space (with pch = " ") at each point
             # If not, draw a line
             type = ifelse(point, "b", "l"), 
             pch = " ", 
             # Specify color (black by default)
             col = color,
             # Add a title (NULL by default)
             main = n)
        if (point) text(x, y, 1:8)
    } else { # Add line to the plot
        # lines() add lines to an existing plot (the last produce)
        lines(x, y, 
              # same comment than before
              xlim = c(-5, 105), ylim = c(-5, 105),
              type = ifelse(point, "b", "l"), 
              pch = " ", 
              col = color)
    }
    par(opar)
}

# PCA
res = PCA(pen, quali.sup = 17, graph = FALSE)
res2 = data.frame(res$ind$coord, digit = pen$digit)

# Compute HAC
## Ward criterion
hac.ward = lapply(0:9, function(dig) {
    sub = subset(pen, digit == dig, -digit)
    h = hclust(dist(sub), "ward.D2")
    return(h)
})

# Compute k-means
km = lapply(0:9, function(dig) {
    sub = subset(pen, digit == dig, -digit)
    res = lapply(1:10, kmeans, x = sub, nstart = 30, iter.max = 20)
    return(res)
})

# Compute Mclust
mclust = lapply(0:9, function(dig) {
    sub = subset(pen, digit == dig, -digit)
    res = lapply(1:10, function(G) {
        m = Mclust(data = sub, G = G)
        p = nMclustParams(m$modelName, m$d, G)
        m$ICL = icl(m)
        m$AIC = -2 * m$loglik + 2 * p
        m$AIC3 = -2 * m$loglik + 3 * p
        return(m)
    })
    return(res)
})

# save results
save.image(file = "pendigits.RData")
