if (!require("rdhs")) stop("Reading RDHS data into R requires the ipumsr package. It can be installed using the following command: install.packages('rdhs')")

# Make an api request
library(rdhs)


## what are the countryIds
ids <- dhs_countries(returnFields=c("CountryName", "DHS_CountryCode"))
ids [grepl("Uganda", ids$CountryName), ]

str(ids)


# lets find all the surveys that fit our search criteria
survs <- dhs_surveys(
  #surveyCharacteristicIds = 15,
  countryIds = c("RW","TZ", "UG"),
  surveyType = "DHS",
  surveyYearStart = 2010,
  surveyYearEnd = 2019)


# and lastly use this to find the datasets we will want to download 
# and let's download the flat files (.dat) datasets 
datasets <- dhs_datasets(surveyIds = survs$SurveyId, 
                         fileFormat = "flat", 
                         fileType = "PR")



## set up your credentials
set_rdhs_config(email = "abiola.oyebanjo@fu-berlin.de",
                project = "Education Migrants")


## set up your credentials
set_rdhs_config(email = "abiola.oyebanjo@fu-berlin.de",
                project = "Education Migrants",
                config_path = "rdhs.json",
                cache_path = "project_one",
                global = FALSE)


# download datasets
downloads <- get_datasets(datasets$FileName)


# read in our dataset
rwan <- readRDS(downloads$RWPR61FL)
rwan1 <- readRDS(downloads$RWPR70FL)

#check for specific variables
spec<-get_variable_labels(downloads$RWPR61FL)
spec<-c[grepl("Anemia", c$description), ]
spec1<-spec %>% select(variable, description)
spec1


# and grab the questions from this now utilising the survey variables
vars <- search_variables(datasets$FileName, variables = c("ha57 ","hv220",
                                                          'hv105'))  




extract <- extract_dhs(vars, add_geo = TRUE)
finaldata <- extract$RWPR61FL




