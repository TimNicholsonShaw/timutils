library(tidyverse)


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

get_qPCR_results_summary <- function(
    csv_loc,
    ) {

}