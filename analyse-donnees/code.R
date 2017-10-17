barplot(res$eig[,2], names.arg = 1:nrow(res$eig))
drawn <-
c("Casarsa", "Karpov", "Drews", "Sebrle", "BOURGUIGNON", "Clay", 
"NOOL", "YURKOV", "Parkhomenko", "Korkizoglou", "Warners", "Lorenzo", 
"Uldal", "Macey", "WARNERS", "Averyanov", "Nool", "MARTINEAU", 
"Karlivans")
plot.PCA(res, select = drawn, axes = 1:2, choix = 'ind', invisible = 'quali', title = '', cex = cex)
drawn <-
c("400m", "Shot.put", "Discus", "Long.jump", "100m", "110m.hurdle"
)
plot.PCA(res, select = drawn, axes = 1:2, choix = 'var', title = '', cex = cex)
drawn <-
c("Korkizoglou", "Nool", "BERNARD", "KARPOV", "Sebrle", "Terek", 
"CLAY", "ZSIVOCZKY", "Macey", "Parkhomenko", "Smith", "McMULLEN", 
"Clay", "Bernard", "Barras", "Zsivoczky", "Karpov", "Lorenzo", 
"Karlivans")
plot.PCA(res, select = drawn, axes = 3:4, choix = 'ind', invisible = 'quali', title = '', cex = cex)
drawn <-
c("Pole.vault", "Javeline", "1500m", "110m.hurdle")
plot.PCA(res, select = drawn, axes = 3:4, choix = 'var', title = '', cex = cex)
res.hcpc = HCPC(res, nb.clust = -1, graph = FALSE)
drawn <-
c("Casarsa", "Karpov", "Drews", "Sebrle", "BOURGUIGNON", "Clay", 
"NOOL", "YURKOV", "Parkhomenko", "Korkizoglou", "Warners", "Lorenzo", 
"Uldal", "Macey", "WARNERS", "Averyanov", "Nool", "MARTINEAU", 
"Karlivans")
plot.HCPC(res.hcpc, choice = 'map', draw.tree = FALSE, select = drawn, title = '')
dimdesc(res, axes = 1:3)
res.hcpc$desc.var
