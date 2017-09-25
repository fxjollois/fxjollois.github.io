airbnb = read.table("airbnb-paris-2015-09-02.csv", header = T, sep = ",")

airbnb$zipcode = sub(" PARIS", "", airbnb$zipcode)
airbnb$zipcode = sub("Paris ", "", airbnb$zipcode)
airbnb$zipcode = sub(" ", "", airbnb$zipcode)
airbnb$zipcode[which(airbnb$zipcode %in% c(17001, 7009, 75, 75000, 750109, 
                                           75106, 75522, 76015, 78005, 78008, 79019,
                                           "adf", "Paris"))] = ""
table(airbnb$zipcode)



library(openxlsx)
write.xlsx(airbnb, file = "airbnb-paris-2015-09-02.xlsx", colNames = TRUE)
