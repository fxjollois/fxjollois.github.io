barplot(res$eig[,2], names.arg = 1:nrow(res$eig))
r.drawn <-
c("unemployment", "future", "comfort", "economic", "to_live", 
"work", "fear", "world", "circumstances", "employment")
c.drawn <-
c("university", "high_school_diploma", "unqualified", "cep")
plot.CA(res, selectRow = r.drawn, selectCol = c.drawn, axes = 1:2, choix = 'CA', invisible = c('var', 'quali'), title = '', cex = cex)
res.hcpc = HCPC(res, nb.clust = -1, graph = FALSE)
drawn <-
c("unemployment", "future", "comfort", "economic", "to_live", 
"work", "fear", "world", "circumstances", "employment")
plot.HCPC(res.hcpc, choice = 'map', draw.tree = FALSE, select = drawn, title = '')
dimdesc(res, axes = 1:1)
res.hcpc$desc.var
