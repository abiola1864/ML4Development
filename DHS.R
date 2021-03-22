#get required functions 
library(jsonlite)
library(geojson)
library(data.table)
library(dplyr)

require(RJSONIO)


#this code uses API key, "DUMMY-123456". Replace it with your own valid key 

#FE_FRTR_W_TFR  
url<-("http://api.dhsprogram.com/rest/dhs/data?f=json&indicatorIds=FE_FRTR_W_TFR&surveyid=all&breakdown=all&perpage=10000&APIkey=DUMMY-125456")

jsondata<-fromJSON(url) 
dta<-data.table(jsondata$Data)
dta<-select(dta, CountryName, SurveyId, Value, 
            CharacteristicCategory, CharacteristicLabel)   
FE_FRTR_W_TFR<- dta %>% rename(FE_FRTR_W_TFR=Value)



#
url2<-("http://api.dhsprogram.com/rest/dhs/data?f=json&indicatorIds=FE_FRTR_W_TFR&countryids=MW,TZ&surveyid=all&breakdown=all&perpage=10000&APIkey=DUMMY-123456")

<-fromJSON(url2) 
dta2<-data.table(jsondata2$Data)
dta2<-select(dta2, CountryName, SurveyId, Value, 
            CharacteristicCategory, CharacteristicLabel)  
FE_FRTR_W_TFR2<- dta2 %>% rename(FE_FRTR_W_TFR=Value)


#
url3<-("http://api.dhsprogram.com/rest/dhs/v7/datasets?countryIds=EG")
jsondata3<-fromJSON(url3) 
dta3<-data.table(jsondata3$Data)




require(RJSONIO)

# Import DHS Indicator data for TFR for each survey

json_file <- fromJSON("http://api.dhsprogram.com/rest/dhs/data?f=json&countryIds=TZ&surveyId=TZDHS1999")

# Unlist the JSON file entries
json_data <- lapply(json_file$Data, function(x) { unlist(x) })

# Convert JSON input to a data frame
APIdata <- as.data.frame(do.call("rbind", json_data),stringsAsFactors=FALSE)



# Tabulate the TFR values by the survey IDs
xtabs(as.numeric(Value) ~ SurveyId, data=APIdata)


