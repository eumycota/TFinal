# ----------- LIBRERIA --------------------

library(plyr) 
library(data.table) 
library(knitr)

# --------- DATABASE ---------------------------------

setwd("/Users/Xongo/Documents/MichyFus/Cursos/Data Science/3 Getting and Cleaning Data/Final Work")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "./data.zip", method = "curl")
unzip(zipfile = "./data.zip")
prueba <- read.table("./test")

ruta<-file.path("./UCI HAR Dataset")

DatosActPrueba <- read.table(file.path(ruta, "test" , "Y_test.txt" ),header = FALSE)
DatosActEntre  <- read.table(file.path(ruta, "train", "Y_train.txt"),header = FALSE)

DatosSubPrueba <- read.table(file.path(ruta,"test","subject_test.txt"),header = FALSE)
DatosSubEntre  <- read.table(file.path(ruta,"train","subject_train.txt"),header = FALSE)

DatosCaracPrueba <-read.table(file.path(ruta,"test","X_test.txt"),header = FALSE)
DatosCaraEntre   <-read.table(file.path(ruta,"train", "X_train.txt"),header = FALSE)

DBSubj  <-rbind(DatosSubEntre, DatosSubPrueba)
DBActiv <-rbind(DatosActEntre, DatosActPrueba)
DBCarac <-rbind(DatosCaraEntre,DatosCaracPrueba)
NombreCara <-read.table("./UCI HAR Dataset/features.txt",header = FALSE)

names(DBActiv) <-c("actividad")
names(DBSubj)  <-c("sub")
names(DBCarac) <-NombreCara$V2

BASE <- cbind(DBSubj,DBActiv)
DATOS <-cbind(DBCarac,BASE)

# ----------------- SUBSET --------------------

Subnombres  <- NombreCara$V2[grep("mean\\(\\)|std\\(\\)",NombreCara$V2)]
Seleccionar <- c(as.character(Subnombres),"actividad","sub")
Muestra     <- subset(DATOS,select = Seleccionar)

# ------------------ Etiquetas ---------------

EtiquetasActividad <-read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE)

# ---------------- Descriptores ---------------

names(Muestra) <-gsub("^t", "time",names(Muestra))
names(Muestra) <-gsub("^f", "frequency",names(Muestra))
names(Muestra) <-gsub("Acc", "Accelerometer",names(Muestra))
names(Muestra) <-gsub("Gyro", "Gyroscope",names(Muestra))
names(Muestra) <-gsub("Mag", "Magnitude",names(Muestra))
names(Muestra) <-gsub("BodyBody", "Body",names(Muestra))

# ---------------- Seg Muetra ----------------------

Muestra2 <-aggregate(.~sub + actividad, Muestra, mean)
Muestra2 <-Muestra2[order(Muestra2$sub,Muestra2$actividad),]
write.table(Muestra2, file = "./tidydata.txt", row.names = FALSE)

knit2html("codebook.Rmd")
