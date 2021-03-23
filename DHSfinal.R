############
#note
#################


#These codes are used to download DHS data for Tanzania, Rwanda, and Uganda
#from the DHS R package called RDHS, then merged with geocovariates data
#sourced online via URL links of each. Final data saved as csv as finaldata
#and added to Github

#From the RDHS package, I am able download specific variables rather than the whole
#DHS data. For now, variables on maternal mortality are not available using
#variable names that starts with mm e.g mm1, mm2. I will keep checking.

#For an easy check of other variable names and labels, use WorldBank library at
#https://microdata.worldbank.org/index.php/catalog/2597/data-dictionary/F1?file_name=RECH0

#Variables downloaded are age of HH member, anemia level for child, father and mother
# and their body mass.

#for geocovariates, there are GPS coordinates, cluster ID, nightlight composite





#install libraries

if (!require("rdhs")) stop("Reading RDHS data into R requires the ipumsr package. It can be installed using the following command: install.packages('rdhs')")
library(rdhs)# Make an api request
library(dplyr) # data manipulation
library(data.table) #for unlisting data

# find all the surveys that fit our search criteria
survs <- dhs_datasets(
  #surveyCharacteristicIds = 15,
  countryIds = c("RW","TZ", "UG"),
  #surveyType = "DHS",
  #indicatorIds = "MM_MMRT_W_PDT",
  surveyYearStart = 2010,
  surveyYearEnd = 2019,
 fileFormat = "Flat",
  fileType = c('PR') #Household Member Recode
  )
  

## set up your credentials
set_rdhs_config(email = "oyebanjoabiola@gmail.com",
                project = "Education Migrants")


## set up your credentials
set_rdhs_config(email = "oyebanjoabiola@gmail.com",
                project = "Education Migrants",
                config_path = "~/.rdhs.json",
                cache_path = "project_th",
                global = TRUE)



# download datasets
downloads <- get_datasets(survs$FileName,
                          clear_cache = TRUE)


# and grab the questions from this now utilising the survey variables
vars <- search_variables(dataset_filenames = names(downloads),
                               variables = c( "ha40", #body mass for father
                                                  "hb40", #body mass  for mother
                                                   "ha57",#anemia for father
                                                   "hb57", #anemia for mother
                                                  'hv105',  #age
                                              "hhid",  #hh ID
                                              # 'sb217', #current pregnant
                                                   'mm1',
                                                          'mm2',
                                                          'mm9',
                                                          'mm10'),
                         reformat=TRUE
                                                          )  
#extract data
extract <- extract_dhs(vars, add_geo = TRUE)


#unlist data and rename variables to be used for merging
dat<-rbindlist(extract, use.names=TRUE, fill=TRUE) %>% as.data.frame()
dat1 <- rbind_labelled(dat) %>% 
  rename (DHSCLUST = 'CLUSTER') %>% 
  rename (SurveyID = 'SurveyId')



########################
#GPS COVARIATES
########################


#since RDHS does not give GPS covariates, at least from my efforts at the moment
#we get them from their URL in spatialdata.dhsprogram.con


#################
#Rwanda GPS covariates (2010, 2015)
#################
temp <- tempfile()
download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/RW/RWGC62FL.ZIP",temp, mode="wb")
unzip(temp, "RWGC62FL.csv")
rwand2010 <- read.table("RWGC62FL.csv", sep=",", header=T)

download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/RW/RWGC72FL.ZIP",temp, mode="wb")
unzip(temp, "RWGC72FL.csv")
rwand2015 <- read.table("RWGC72FL.csv", sep=",", header=T)

#row merge all Rwanda
rwanda_all<- rbind(rwand2014,rwand2010)

#################
#Tanzania GPS covariates (2010, 2012, 2015, 2017)
#################
download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/TZ/TZGC62FL.ZIP",temp, mode="wb")
unzip(temp, "TZGC62FL.csv")
tan2010 <- read.table("RWGC62FL.csv", sep=",", header=T)

download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/TZ/TZGC6BFL.ZIP",temp, mode="wb")
unzip(temp, "TZGC6BFL.csv")
tan2012 <- read.table("TZGC6BFL.csv", sep=",", header=T)

download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/TZ/TZGC7BFL.ZIP",temp, mode="wb")
unzip(temp, "TZGC7BFL.csv")
tan2015 <- read.table("RWGC72FL.csv", sep=",", header=T)


download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/TZ/TZGC7JFL.ZIP",temp, mode="wb")
unzip(temp, "TZGC7JFL.csv")
tan2017 <- read.table("RWGC72FL.csv", sep=",", header=T)


#row merge all Tanzania
tan_all<- rbind(tan2010,tan2012,tan2015,tan2017)


#################
#Uganda GPS covariates (2011, 2014, 2016, 2018)
#################

download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/UG/UGGC62FL.ZIP",temp, mode="wb")
unzip(temp, "UGGC62FL.csv")
uga2011 <- read.table("RWGC62FL.csv", sep=",", header=T)

download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/UG/UGGC72FL.ZIP",temp, mode="wb")
unzip(temp, "UGGC72FL.csv")
uga2014 <- read.table("TZGC6BFL.csv", sep=",", header=T)

download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/UG/UGGC7BFL.ZIP",temp, mode="wb")
unzip(temp, "UGGC7BFL.csv")
uga2016 <- read.table("RWGC72FL.csv", sep=",", header=T)


download.file("https://spatialdata.dhsprogram.com/utility-api/SDR/covariates/production/internal/UG/UGGC7JFL.ZIP",temp, mode="wb")
unzip(temp, "UGGC7JFL.csv")
uga2018 <- read.table("RWGC72FL.csv", sep=",", header=T)

#row merge all uganda

uga_all<- rbind(uga2011,uga2014,uga2016,uga2018)


#################
#merge all countries
geocov<- rbind(uga_all, tan_all, rwanda_all) %>% 

  
  
#################
## Merge DHS data + GEO COVARIATES
#################
# select important covariates, including nightlife composite 
geocov1<- geocov[c(1:6,77)]


# merge by SurveyID and DHSCLUST
finaldata<-inner_join(dat1,geocov1,
             by =  c('SurveyID', "DHSCLUST"))

# write CSV file
write.csv(finaldata, "finaldata/finaldata_abiola.csv")

