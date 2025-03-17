# Clean merge of occupation in PNAD 1990's to CBO-Dom

# OBS: Save the content that mattered on the second sheet.
library(readxl)
library(data.table)
library(dplyr)
library(foreign)

# Set user
user = "Alysson"

if (user == "Alysson") {
  working_folder <- "C:/Users/alyssonlp1/Documents/@github/occ_crosswalk_br"
  
}

merge_occ <- read_excel(
  path = file.path(working_folder, "data/CBO-DomxCenso91.xls"),
  sheet = 2) %>% as.data.table()

colnames(merge_occ) <- c("cbo_dom", "occ_90s", "names")

# Drop names
merge_occ$names <- NULL

# Drop dupliates:
merge_occ <- unique.data.frame(merge_occ)

# Randomize the observation to delete to make it compatible:
length(unique(merge_occ$occ_90s))

merge_occ$random <- runif(n = nrow(merge_occ))
setorder(merge_occ, cbo_dom, occ_90s, random)

merge_occ <- merge_occ[!duplicated(occ_90s), ]
merge_occ$random <- NULL

merge_occ[, cbo_dom := as.numeric(cbo_dom)]
merge_occ[, occ_90s := as.numeric(occ_90s)]

# Export as csv
fwrite(merge_occ, 
          file = file.path(working_folder, 
                           "data/crosswalks/crosswalk_occ_91_cbo_dom.csv"))

write.dta(merge_occ, 
          file = file.path(working_folder, 
                           "data/crosswalks/crosswalk_occ_91_cbo_dom.dta"))

