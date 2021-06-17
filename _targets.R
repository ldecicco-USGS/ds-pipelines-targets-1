library(targets)

# Sync target_test folder
# Set the path here:
path_to_data <- function() {
  "C:/Users/ldecicco/OneDrive - DOI/Documents/target_test"
}


source("1_fetch/src/fetch_onedrive_data.R")
source("2_process/src/process_sb_data.R")
source("3_visualize/src/plot_results.R")

tar_option_set(packages = c("tidyverse",
                            "stringr", 
                            "sbtools",
                            "whisker"))

dir.create("1_fetch/out", showWarnings = FALSE)
dir.create("2_process/out", showWarnings = FALSE)
dir.create("3_visualize/out", showWarnings = FALSE)

tar_workflow <- list(
  tar_target(
    raw_data_file,
    path_to_data(),
    format = "file"
  ),
  # Get the data from OneDrive
  tar_target(
    file_out,
    fetch_onedrive_data(out_filepath = "model_RMSEs.csv",
                        ds_pipeline = raw_data_file,
                        project_output_dir = "1_fetch/out"),
    format = "file"
  ), 
  # Prepare the data for plotting
  tar_target(
    eval_data,
    process_sb_data(in_filepath = file_out),
  ),
  # Create a plot
  tar_target(
    figure_1_png,
    plot_results(file_name = "figure_1.png", 
                 project_output_dir = "3_visualize/out",
                 df = eval_data), 
    format = "file"
  ),
  # Save the processed data
  tar_target(
    model_summary_results_csv,
    write_processed(df = eval_data, 
                    project_output_dir = "2_process/out",
                    file_out = "model_summary_results.csv"), 
    format = "file"
  ),
  # Save the model diagnostics
  tar_target(
    model_diagnostic_text_txt,
    model_diagnostic(file_out = "model_diagnostic_text.txt", 
                     project_output_dir = "2_process/out",
                     df = eval_data), 
    format = "file"
  )
)

