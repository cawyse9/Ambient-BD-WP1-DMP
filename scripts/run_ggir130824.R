library (GGIR)
library(dplyr)
library(stringr)

#  Notes:
#      - this is designed for processing single files because of the long duration of the datafiles (3 months)
#      - paste only one cwa file into the datadir

#======================================================================================
#
# Stage 1 - Set up temporary local folders for input of cwa file and export of results
#
#======================================================================================

# set the working directory to the FG sharepoint
setwd("./Maynooth University/Family Genomics - Documents/General/Research/Ambient BD/Axivity")

# processing cwa files

# 1  Download cwa file from axivity into local datadir folder eg ""
# 2  Run GGIR 
# 3. Check for errors and missing days
# 4  Transfer cwa file and GGIR output to Z:
# 5  Extract time series data (for circadian rhythms analysis) and GGIR parameters that we will use

# Define directories
datadir <- "./Axivity_Processing/paste_1_cwa_file"   # paste the cwa for analysis here
outputdir <- "./Axivity_Processing/results"   # Location of GGIR output on local PC - also the source folder for items to move to Z:
metadatadir <- "./Axivity_Processing/meta"
datadir <- "Z:/Axivity/cwa_files"
outputdir <- "C:/practiseAXIVITY"

#======================================================================================
#
# Stage 2 - Run GGIR with Ambient-BD standard arguments
#
#======================================================================================

mode = c(1,2,3,4,5)
studyname = "AmbientBD" 
f0 = 1  # file number to start
f1 = 2  # file number to end


GGIR(
  mode = mode, # ggir modes to run
  datadir = datadir,  # location of cwa file
  outputdir = outputdir,  # output to temporary local drive
  metadatadir = outputdir, # output metadata to local drive
  studyname = studyname, 
  f0 = f0, 
  f1 = f1, 
  overwrite = TRUE, # reuse early phases of ggir if available
  do.imp = TRUE, # input missing data
  idloc = 1, # location of ID - not needed
  print.filename = FALSE, # not needed
  storefolderstructure = FALSE, #store structure of folder with cwa
  
  
  
  #------------------------------# Part 1 parameters: #------------------------------
  
  windowsizes = c(5,900,3600), #this will give 5s epoch files and 60 min non-wear evaluation window [epoch lengths for acc, angle and non-wear epochs]
  do.cal = TRUE, # apply autocalibration
  do.enmo = TRUE, # calculates the metric: = _x^2 + acc_y^2 + acc_z^2 - 1 
  do.anglez = TRUE, #calculate arm angle
  chunksize = 1, # autocalibration procedure
  printsummary = TRUE, # print autocalibation results to screen
  
  
  
  #------------------------------# Part 2 parameters: #------------------------------
  data_masking_strategy = 1, # how to deal with knowledge about study protocol - might be applied in later stages of ABD
  ndayswindow = 7,  # used as part of data_masking_strategy 
  hrs.del.start = 1, # disregard first hour
  hrs.del.end = 1, # disregard last hour
  maxdur = 0, # days after start of experiment did experiment definitely stop, zero if unknown
  includedaycrit = 16, # minimum required number of valid hours in calendar day 
  M5L5res = 10, # Resolution of L5 and M5 analysis in minutes
  winhr = c(5,10), # Vector of window size(s) (unit: hours) of LX and MX analysis
  qlevels = NULL,  # vector of percentiles eg c(c(1380/1440),c(1410/1440)),
  qwindow = c(0,24), 
  ilevels = NULL, # Levels for acceleration value frequency distribution in m eg c(seq(0,400,by=50),8000)
  mvpathreshold = c(100,120), # acceleration threshold for MVPA if c(), then MVPA is not estimated.  We might as well calculate this but not used in ABD
  
  
  #------------------------------# Part 3 parameters: #------------------------------
  timethreshold = c(5), # Time threshold (minutes) for sustained inactivity periods detection
  anglethreshold = 5, # Angle threshold (degrees) for sustained inactivity periods detection.
  ignorenonwear = TRUE, # ignore detected monitor non-wear periods to avoid confusion between monitor non-wear time and sustained inactivity
  
  
  #------------------------------# Part 4 parameters: #------------------------------
  excludefirstlast = FALSE, # first and last night of the measurement are ignored for the sleep assessment in g.part4
  includenightcrit = 16, # Minimum number of valid hours per night (24 hour window between noon and noon), used for sleep assessment in g.part4
  def.noc.sleep = 1, # The time window during which sustained inactivity will be assumed to represent sleep, 1 uses van hees algorithm
  #loglocation = "D:/sleeplog.csv", 
  outliers.only = FALSE, # all available nights are included in the visual representation of the data and sleeplog
  criterror = 4,  # sleep log
  relyonguider = FALSE,  # sleep log
  colid = 1, # sleep log
  coln1 = 2,  # sleep log
  do.visual = TRUE, #generate a pdf with a visual representation of the overlap between the sleeplog entries and the accelerometer detections
  
  
  
  #------------------------------# Part 5 parameters: #------------------------------
  
  # Key functions: Merging physical activity with sleep analyses 
  threshold.lig = c(30,40,50), # Threshold for light physical activity 
  threshold.mod = c(100,120),  # Threshold for mod physical activity
  threshold.vig = c(400,500),  # Threshold for vig physical activity
  boutcriter = 0.8, # bout definitions
  boutcriter.in = 0.9, 
  boutcriter.lig = 0.8, 
  boutcriter.mvpa = 0.8, 
  boutdur.in = c(10,20,30), 
  boutdur.lig = c(1,5,10), 
  boutdur.mvpa = c(1,5,10),
  timewindow = c("WW"), # timewindow over which summary statistics are derived. Value can be “MM” (midnight to midnight), “WW” (waking time to waking time), “OO” (sleep onset to sleep onset)

  epochvalues2csv = TRUE, # epoch values are exported to a csv file
  
  
  
  #------------------------------# Part 6 parameters: #------------------------------
  
  #cosinor = TRUE, # we will do that separately ourselves
  #part6CR = TRUE,
  
  
  #----------------------------------# Report generation #------------------------------
  do.report = c(2,4,5))


rm(list=ls(all=TRUE)) # clear environment


#======================================================================================
#
# Stage 3 - Check the data quality before moving data to the server
#
#======================================================================================

# view the QC files before moving the results to the server

pdffile <- list.files(outputdir, pattern = "plots_to_check_data_quality_1.pdf", recursive = TRUE, full.names = TRUE)
shell.exec(pdffile)

# look at the visual output to make sure all is okay before moving to next stage.  If not, then look at more data quality parameters in outputdir 
# If all okay, move to z:, next stage
# no need to save pdf


#=============================================================================================
#
# Stage 4 Extract the csv time series and GGIR variables into results folders in Z:

#=============================================================================================

# Extract studyID from the single cwa file
cwa_name <- list.files(datadir)[1]  # Get the single file name
name <- substr(cwa_name, start = 1, stop = 7)  # Extract the study ID (first 7 characters)

# copy the csv file for each participant to csv_files results folder on Z:
new_filename <- paste0("acc_timeseries_", name, ".RData")
csv_folder <- file.path(outputdir, "output_cwa/meta/csv_files")

rdata_file <- list.files(csv_folder,  full.names = TRUE) #assuming only one file - need to put check here
new_file_path <- file.path("Z:/Axivity/results/csv_files", new_filename)
file.copy(rdata_file, new_file_path)

# move the ggir data for each participant to ggir_variables folder on Z:
new_filename_ggir <- paste0("acc_ggir_", name, ".csv")
ggir_folder <- file.path(outputdir, "results")
data_file_ggir <- list.files(ggir_folder, pattern = "part4_summary_sleep_cleaned.csv", full.names = TRUE)
new_file_path_ggir <- file.path("Z:/Axivity/results/ggir_variables", new_filename_ggir)
file.copy(data_file_ggir, new_file_path_ggir)


#================================================================================================
#
# Stage 5 Transfer cwa file and all generated GGIR data to Z: and delete temporary local files
#
#================================================================================================

#"Z:\Axivity\Participant_GGIR_output" - this folder has separate sub-folders for each participant

# Define directories (same as stage 1)
# datadir    Location of local download of cwa file
# outputdir  Location of GGIR output on local PC - also the source folder for items to move to Z:
# studyID already defined as variable "name" from Stage 4 

move_GGIR_results <- "Z:/Axivity/Participants_GGIR_output"  # Path to create GGIR results folder for each participant and move results there
move_cwa_file <- "Z:/Axivity/cwa_files"    # Path to cwa store in Z:
  
# Create the new folder using the study ID
results_folder_Z <- file.path(move_GGIR_results, name)  #this is the participant folder in z:
dir.create(results_folder_Z, recursive = TRUE)  # Create the directory without checking if it exists - note this will overwrite existing data - need to put check step here

# Get the list of files in the Axivity output local folder
files <- list.files(outputdir, full.names = TRUE)

# Move the results files to the new folder - note this is move, not copy
file.rename(files, file.path(results_folder_Z, basename(files)))

# move the cwa file
cwa_folder_Z <- file.path(move_cwa_file)  #this is the participant folder in z:
cwa_file <- list.files(datadir, pattern = "*.cwa", full.names = TRUE) #assuming there is only one cwa file in the folder
file.rename(cwa_file, file.path(cwa_folder_Z, basename(cwa_file)))

#  Final outputs of this script

#   Z:/Axivity/cwa_files                all cwa files
#   Z:/Axivity/Results/csv_files        time series data for all participants in separate files
#   Z:/Axivity/Results/ggir_variables   GGIR variables needed for Ambient-BD in separate files
#   Z:/Axivity/Participant_GGIR_output  All GGIR output for all participants in separate folders



