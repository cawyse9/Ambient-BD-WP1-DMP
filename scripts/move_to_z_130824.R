# view the QC files before moving the results to the server
main <- "C:/practiseAXIVITY/output_cwa/output_cwa"
pdffile <- list.files(main, pattern = "plots_to_check_data_quality_1.pdf", recursive = TRUE, full.names = TRUE)
shell.exec(pdffile)

# if all is okay, move to z:


# copy the csv file for each participant to csv_files results folder on Z:
####  change this #####             studyID <- "studyID"
new_filename <- paste0("acc_timeseries_", studyID, ".RData")
csv_folder <- file.path(main, "meta/csv")

rdata_file <- list.files(csv_folder,  full.names = TRUE)
new_file_path <- file.path("Z:/Axivity/results/csv_files", new_filename)
file.copy(rdata_file, new_file_path)

# move the ggir data for each participant to ggir_variables folder on Z:

new_filename_ggir <- paste0("acc_ggir_", studyID, ".csv")
ggir_folder <- file.path(main, "results")
data_file_ggir <- list.files(ggir_folder, pattern = "part4_summary_sleep_cleaned.csv.txt", full.names = TRUE)
new_file_path_ggir <- file.path("Z:/Axivity/results/ggir_variables", new_filename_ggir)
file.copy(data_file_ggir, new_file_path_ggir)

