library("xml2")
library(rvest)
library(jpeg)
library(httr)
library(base64enc)
library(tidyr)

#############        enter studyID                ###########################################
#
studyID <- "abd1234"
#
#############################################################################################



#############################################################################################
#
# get html documents from miniview and import
#
#############################################################################################

# define the working folder
base_path <- "Z:/Polysomnography/Data/"
full_path <- paste0(base_path, studyID)
setwd(full_path)

# import html file of MSV report
html_file <- paste0(full_path, "/", "psg_", studyID, "_report.htm")
html_content <- read_html(html_file)

# Extract all tables 
tables <- html_content %>% html_table(fill = TRUE)

# Check the content 
print(tables[[4]])  # Print the first table


#############################################################################################
#
# OSA and PLM data
#
#############################################################################################

# data from table 2 and 3 
table2 <- tables[[2]]
lights_on_off <- tables[[2]][table2$X5 == "Light off - Light on", "X6"] #extracts the value from column X2, which corresponds to the surname.
colnames(table2) <- c("description", "text_output")

#get <- table2$description== "Surname" # checks for the row where description equals "Surname".
#studyID <- tables[[2]][table2$description== "Surname", "X2"] #extracts the value from column X2, which should match studyID

# all data from table 4, respiratory parameters
OSA_data <- rbind(tables[[4]], tables[[5]])
OSA_data$OSA_variables <- as.numeric(gsub(",", ".", OSA_data$X2))
colnames(OSA_data) <- c("description", "text_output", "resp_var")
OSA_data <- OSA_data[!(OSA_data$description == "" | OSA_data$description == ""), ]

OSA_data$description[OSA_data$description == "AHI [Per hour]"] <- "AHI_h"
OSA_data$description[OSA_data$description == "RDI [Per hour]"] <- "RDI_h"
OSA_data$description[OSA_data$description == "Apnea Index AI [Per hour]"] <- "Apnea_Index_h"
OSA_data$description[OSA_data$description == "Hypopnea Index HI [Per hour]"] <- "Hypopnea_Index_h"
OSA_data$description[OSA_data$description == "Total CSB time [Sec]"] <- "CSB_sec"
OSA_data$description[OSA_data$description == "No. of CSB phases [n]"] <- "CSB_Phases_n"
OSA_data$description[OSA_data$description == "AHI in REM [Per hour]"] <- "AHI_REM_h"
OSA_data$description[OSA_data$description == "No. of Apnea [n]"] <- "apnea_n"
OSA_data$description[OSA_data$description == "Number Central Apnea [n]"] <- "apnea_central_n"

# Remove rows with 'evaluation' - they are col headings in the report
OSA_data <- OSA_data[!grepl("evaluation", OSA_data$description, ignore.case = TRUE) , ]



# all data from table 6, HR parameters
HR_leg_data <- tables[[6]][c(1:2)]
HR_leg_data$hr_leg_var <- as.numeric(gsub(",", ".", HR_leg_data$X2))
colnames(HR_leg_data) <- c("description", "text_output", "hr_leg_var")
HR_leg_data <- HR_leg_data[!(HR_leg_data$description == "" | HR_leg_data$description == ""), ]

# Remove rows with 'evaluation' - they are col headings in the report
HR_leg_data <- HR_leg_data[!grepl("evaluation", HR_leg_data$description, ignore.case = TRUE) , ]

HR_leg_data$description[HR_leg_data$description== "Maximum HF [1/min]"] <- "HR_max"
HR_leg_data$description[HR_leg_data$description== "Mean heart frequency [1/min]"] <- "HR_mean"
HR_leg_data$description[HR_leg_data$description== "Minimum HF [1/min]"] <- "HR_min"
HR_leg_data$description[HR_leg_data$description== "No. of Bradycardias [n]"] <- "bradycardia_n"
HR_leg_data$description[HR_leg_data$description== "No. of Tachycardias [n]"] <- "tachycardia_n"
HR_leg_data$description[HR_leg_data$description== "No. of Extrasyst. [n]"] <- "extra_syst_n"
HR_leg_data$description[HR_leg_data$description== "LM [n]"] <- "LM_n"
HR_leg_data$description[HR_leg_data$description== "LMI [Per hour]"] <- "LM_h"
HR_leg_data$description[HR_leg_data$description== "Non-PLM [n]"] <- "non_PLM_n"
HR_leg_data$description[HR_leg_data$description== "Non-PLMI [Per hour]"] <- "non_PLM_h"
HR_leg_data$description[HR_leg_data$description== "PLM [n]"] <- "PLM"


#############################################################################################
#
# get sleep data
#
#############################################################################################

# all data from table 12, sleep parameters
PSG_sleep_vars <- tables[[12]][c(1:2)]
colnames(PSG_sleep_vars) <- c("description", "text_output")
PSG_sleep_vars <- PSG_sleep_vars[!(PSG_sleep_vars$description == "" | PSG_sleep_vars$description == ""), ]

# Replace all single-number values (1 to 1000) with "REM" followed by the number to get REM minutes
PSG_sleep_vars$description <- ifelse(grepl("^[1-9][0-9]{0,2}$", PSG_sleep_vars$description), 
                            paste0("REM", PSG_sleep_vars$description), 
                            PSG_sleep_vars$description)

# Remove rows with 'PSG_sleep_vars' - they are col headings in the report
PSG_sleep_vars <- PSG_sleep_vars[!grepl("NREM/REM-cycles", PSG_sleep_vars$description, ignore.case = TRUE) , ]

# Remove non-numeric characters ("Min" and "%") from output text
PSG_sleep_vars$text_output <- gsub("[^0-9,.]", "", PSG_sleep_vars$text_output)
PSG_sleep_vars$PSG_sleep_vars <- as.numeric(gsub(",", ".", PSG_sleep_vars$text_output))

#rename
PSG_sleep_vars[PSG_sleep_vars == "Sleep Onset SO - latency"] <- "SO_latency"
PSG_sleep_vars[PSG_sleep_vars == "NREM/REM-cycles"] <- "NREM_REM_cycles"
PSG_sleep_vars[PSG_sleep_vars == "REM cycle"] <- "REM_cycle"
PSG_sleep_vars[PSG_sleep_vars == "REM1"] <- "REM_1"
PSG_sleep_vars[PSG_sleep_vars == "REM2"] <- "REM_2"
PSG_sleep_vars[PSG_sleep_vars == "REM3"] <- "REM_3"
PSG_sleep_vars[PSG_sleep_vars == "REM4"] <- "REM_4"
PSG_sleep_vars[PSG_sleep_vars == "REM5"] <- "REM_5"
PSG_sleep_vars[PSG_sleep_vars == "N1-latency (LO)"] <- "N1_latency"
PSG_sleep_vars[PSG_sleep_vars == "N2-latency (LO)"] <- "N2_latency"
PSG_sleep_vars[PSG_sleep_vars == "N3-latency (LO)"] <- "N3_latency"
PSG_sleep_vars[PSG_sleep_vars == "REM-latency (SO)"] <- "REM_latency"
PSG_sleep_vars[PSG_sleep_vars == "Latency to onset of Persistent Sleep LPS"] <- "LPS_latency"
PSG_sleep_vars[PSG_sleep_vars == "TIB"] <- "TIB"
PSG_sleep_vars[PSG_sleep_vars == "SPT"] <- "SPT"
PSG_sleep_vars[PSG_sleep_vars == "TST"] <- "TST"
PSG_sleep_vars[PSG_sleep_vars == "Sleep efficiency (TST/TIB)" ] <- "sleep_eff_TST_TIB"
PSG_sleep_vars[PSG_sleep_vars == "Sleep efficiency (TST/SPT)" ] <- "sleep_eff_TST_SPT"



#############################################################################################
#
# sleep stage dist - table 15
#
#############################################################################################

# all data from table 15, sleep stage dist TIB
PSG_sleep_stage_dist <- tables[[15]][c(1:7)]
colnames(PSG_sleep_stage_dist) <- c("description", "text_output_TIB_min", "text_output_TIB_pc", "text_output_SPT_min", "text_output_SPT_pc", "text_output_TST_min", "text_output_TST_pc")
PSG_sleep_stage_dist <- PSG_sleep_stage_dist[!(PSG_sleep_stage_dist$description == "" | PSG_sleep_stage_dist$description == ""), ]

# Remove rows with 'Stage distribution' and n.i.- they are col headings in the report
PSG_sleep_stage_dist <- PSG_sleep_stage_dist[!grepl("Stage distribution", PSG_sleep_stage_dist$description, ignore.case = TRUE) , ]
PSG_sleep_stage_dist <- PSG_sleep_stage_dist[!grepl("n.i.", PSG_sleep_stage_dist$description, ignore.case = TRUE) , ]

#
PSG_sleep_stage_dist$text_output_TIB_min <- gsub("[^0-9,.]", "", PSG_sleep_stage_dist$text_output_TIB_min) #remove non numeric
PSG_sleep_stage_dist$PSG_TIB_min <- as.numeric(gsub(",", ".", PSG_sleep_stage_dist$text_output_TIB_min))

PSG_sleep_stage_dist$text_output_TIB_pc <- gsub("[^0-9,.]", "", PSG_sleep_stage_dist$text_output_TIB_pc)
PSG_sleep_stage_dist$PSG_TIB_pc <- as.numeric(gsub(",", ".", PSG_sleep_stage_dist$text_output_TIB_pc))

# make table of TIB stage pc
stages <- PSG_sleep_stage_dist[, 1]  
percentages <- PSG_sleep_stage_dist[, 9] 
stage_dist_pc <- data.frame(t(percentages),row.names = NULL)

# Rename the columns by adding "pc_" prefix and using the values from the 'stages' column
colnames(stage_dist_pc) <- c("N1_pc", "N2_pc", "N3_pc", "REM_pc", "Wake_pc")

#############################################################################################
#
# arousals
#
#############################################################################################

# all data from table 16, arousals
PSG_arousals <- tables[[16]]
colnames(PSG_arousals) <- c("description", "text_output_TIB", "text_output_TST")
PSG_arousals <- PSG_arousals[!(PSG_arousals$description == "" | PSG_arousals$description == ""), ]

PSG_arousals$description[PSG_arousals$description == "Number (TIB) [n]"] <- "arousals_TIB_n"
PSG_arousals$description[PSG_arousals$description == "Number Arousal (respiratory) (TIB) [n]"] <- "arousal_res_TIB_n"
PSG_arousals$description[PSG_arousals$description == "Number Arousal (movement) (TIB) [n]"] <- "arousal_move_TIB_n"
PSG_arousals$description[PSG_arousals$description == "Number Arousal (PLM) (TIB) [n]"] <- "arousal_PLM_TIB_n"
PSG_arousals$description[PSG_arousals$description == "Number Arousal (spontaneous) (TIB) [n]"] <- "arousal_spon_TIB_n"
PSG_arousals$description[PSG_arousals$description == "Arousal Index (TIB) [Per hour]"] <- "arousal_index_TIB_h"
PSG_arousals$description[PSG_arousals$description == "Index Arousal (respiratory) (TIB) Per hour"] <- "arousal_res_TIB_h"
PSG_arousals$description[PSG_arousals$description == "Index Arousal (movement) (TIB) Per hour"] <- "arousal_move_TIB_h"
PSG_arousals$description[PSG_arousals$description == "Index Arousal (PLM) (TIB) Per hour"] <- "arousal_PLM_TIB_h"
PSG_arousals$description[PSG_arousals$description == "Index Arousal (spontaneous) (TIB) Per hour"] <- "arousal_spon_TIB_h"


#############################################################################################
#
# images - this is the hypogram - don't include in report
#
#############################################################################################
# 
# 
# # Find all <img> nodes and extract their src attributes
# img_nodes <- html_content %>% html_nodes("img")
# img_urls <- img_nodes %>% html_attr("src")
# 
# 
# # Check if there are at least 5 images
# if (length(img_urls) >= 5) {
#   # Get the 5th base64 image
#   base64_image_5 <- img_urls[5]
#   
#   # Clean the base64 string for JPEG
#   clean_base64_string <- gsub("data:image/jpeg;base64,", "", base64_image_5)
#   
#   # Decode the base64 string into raw binary data
#   image_data <- base64decode(clean_base64_string)
#   
#   # Construct the filename using "hyponogram_" and the studyID
#   output_jpeg_path <- paste0("C:/Users/Admin/Desktop/", studyID, ".png")
#   
#   # Write the binary data to the JPEG file
#   writeBin(image_data, output_jpeg_path)
#   
#   cat("The fifth base64 image has been exported as a high-quality JPEG file:", output_jpeg_path, "\n")
# } else {
#   cat("There are less than 5 base64 images in the HTML file.\n")
# }
# 
# 
# 

#############################################################################################
#
# make data table
#
#############################################################################################


# Create a new data frame to export sleep vars to database
PSG_sleep_data <- PSG_sleep_vars[,c(1,3)]

# Fill 'studyID' for all rows
PSG_sleep_data$studyID <- studyID

# Reshape the data from long to wide format
PSG_sleep_data_wide <- pivot_wider(PSG_sleep_data, names_from = description, values_from = PSG_sleep_vars)

# get the OSA variables
OSA_data <- OSA_data[,c(1,3)]

# Fill 'studyID' for all rows
OSA_data$studyID <- studyID

# Reshape the data from long to wide format
OSA_data_wide <- pivot_wider(OSA_data, names_from = description, values_from = resp_var)

# Extract specific columns from OSA_data_wide
subset_OSA_data <- OSA_data_wide[, c("AHI_h", "RDI_h", "Apnea_Index_h", "Hypopnea_Index_h")]

# get sleep stage dist = stage_dist_pc 
stage_dist_pc

#add to main datatable
PSG_parameters <- cbind(PSG_sleep_data_wide, subset_OSA_data, stage_dist_pc )

# Append the single row to the existing CSV
write.table(PSG_parameters, file = "Z:/Polysomnography/Data/Sleep metrics/psg_parameters.csv", 
            append = TRUE, sep = ",", col.names = FALSE, row.names = FALSE)


