# Script to read in Portal Project survey data, check plot ids and output a summary figure
# Code authors: Sarah R. Supp 2016

#---------- FUNCTIONS

## This function checks that all the plot IDs (listed in the plots.csv file)
## occur in the survey file (surveys.csv). If all the plots are found, the function
## shows a message and returns TRUE, otherwise the function emits a warning, and 
## returns FALSE.
check_plots <- function(survey_file = "data/surveys.csv", plot_file = "data/plots.csv"){
  
  #load files
  surv <- read.csv(file=survey_file, stringsAsFactors=FALSE)
  plts <- read.csv(file=plot_file, stringsAsFactors=FALSE)
  
  # get unique plot_id
  uniq_surv_plots <- unique(surv$plot_id)
  
  if (all(uniq_surv_plots %in% plots$plot_id)){
    message("Everything looks good.")
    return(TRUE)
  } else {
    warning("Something is wrong.")
    return(FALSE)
  }
}

#---------- EXECUTE

check_plots()

surveys <- read.csv(file="/data/surveys.csv", stringsAsFactors=FALSE)
plots <- read.csv(file=plot_file, stringsAsFactors=FALSE)

nrow(surveys)
ncol(surveys)

dim(plots)

unique(surveys$species_id)

#---------- PLOT DATA

plot(surveys$species_id, surveys$weight)

