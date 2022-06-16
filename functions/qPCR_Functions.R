library(tidyverse)
library(readxl)

# internal utility functions
get_sample <- function(SampleTarget) { # Separates strings of type 'Sample;Target' to get Sample
  return(str_split(SampleTarget, ";")[[1]][1])
}
get_target <- function(SampleTarget) { # Separates strings of type 'Sample;Target' to get Target
  return(str_split(SampleTarget, ";")[[1]][2])
}

calculate_master_mix <- function( # Uses qPCR map template to calculate master mixes for each target
    well_map,
    MM_vol = 5,
    PP_vol = 1,
    water_vol = 2,
    extra_samples = 5) { 

    df <- read.csv(well_map, header=TRUE) %>%
        pivot_longer(cols=starts_with("C"), names_to="Column", values_to="WellTarget") %>%
        mutate(Column=as.integer(sapply(Column, sub, pattern="C", replacement=""))) %>% #Turn column into an integer
        mutate(Sample=sapply(WellTarget, get_sample), Target=sapply(WellTarget, get_target)) %>% # extract sample and target into their own column
        select(-WellTarget) %>% 
        drop_na() # get rid of wells with nothing in it
    
    MasterMixCalculations <-  # calculate out master mix with 5 sample overfill
        df %>% count(Target) %>%
        mutate(overfill = n + extra_samples) %>%
        mutate(MasterMix = overfill*4, PP=overfill, Water=2*overfill)
        MasterMixCalculations

    return(MasterMixCalculations)
}

# returns a dataframe of summarised qPCR CTs
# made for use with JLA qPCR machine (Applied Biosystems something something)
get_qPCR_results_summary <- function( 
    csv_loc,
    skip_rows=21,
    sheet_name = "Results"
    ) {
    
    # read in excel file and skip metadata lines, only get results sheet
    df <- read_excel(csv_loc, sheet=sheet_name, skip=skip_rows)
    names(df) <- sapply(names(df), sub, pattern=" ", replacement="") # remove spaces

    return(
        df %>% select("SampleName", "TargetName", "CT") %>% # get relevant columns
        mutate(CT=as.numeric(CT)) %>% # convert to numeric column instead of char
        group_by(SampleName, TargetName) %>% # sample/target groups
        summarise(
            CTmean=mean(CT),
            CTstdev=sd(CT)
        )
    )



}