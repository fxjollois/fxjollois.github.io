trafic2015 = read.table("trafic-annuel-entrant-par-station-du-reseau-ferre-2015-test.csv", 
                        header=T, sep=";", quote="\"")

table(trafic2015$Arrondissement.pour.Paris)

trafic2015.paris = subset(trafic2015, Ville == "Paris")
trafic2015.paris.metro = subset(trafic2015.paris, Réseau == "Métro")
trafic2015.paris.rer = subset(trafic2015.paris, Réseau == "RER")

resume = merge(
    merge(
        merge(
            setNames(aggregate(Trafic ~ Arrondissement.pour.Paris, trafic2015.paris, length), c("arr", "stations")),
            setNames(aggregate(Trafic ~ Arrondissement.pour.Paris, trafic2015.paris, sum), c("arr", "entrées"))
        ),
        merge(
            setNames(aggregate(Trafic ~ Arrondissement.pour.Paris, trafic2015.paris.metro, length), c("arr", "stationsMétro")),
            setNames(aggregate(Trafic ~ Arrondissement.pour.Paris, trafic2015.paris.metro, sum), c("arr", "entréesMétro"))
        ),
        all = TRUE
    ),
    merge(
        setNames(aggregate(Trafic ~ Arrondissement.pour.Paris, trafic2015.paris.rer, length), c("arr", "stationsRER")),
        setNames(aggregate(Trafic ~ Arrondissement.pour.Paris, trafic2015.paris.rer, sum), c("arr", "entréesRER"))
    ),
    all = TRUE
)

write.table(resume,
            "trafic-annuel-entrant-par-station-du-reseau-ferre-2015-resume.csv", 
            row.names = FALSE, sep = ";")

