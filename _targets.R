library(targets)

source("1_fetch/src/fetch_sb_data.R")
source("2_process/src/process_sb_data.R")
source("3_visualize/src/plot_results.R")

tar_option_set(packages = c("tidyverse",
                            "stringr", 
                            "sbtools",
                            "whisker"))

project_output_dir <- 'my_dir'

list(
  # Get the data from ScienceBase
  tar_target(
    file_out,
    fetch_sb_data(out_filepath = "model_RMSEs.csv"),
    format = "file"
  ), 
  # Prepare the data for plotting
  tar_target(
    eval_data,
    process_sb_data(in_filepath = file_out, 
                    project_output_dir = project_output_dir),
  ),
  # Create a plot
  tar_target(
    figure_1_png,
    plot_results(file_name = "figure_1.png", 
                 project_output_dir = project_output_dir,
                 data = eval_data), 
    format = "file"
  ),
  # Save the processed data
  tar_target(
    model_summary_results_csv,
    write_processed(eval_data, 
                    project_output_dir = project_output_dir,
                    file_out = "model_summary_results.csv"), 
    format = "file"
  ),
  # Save the model diagnostics
  tar_target(
    model_diagnostic_text_txt,
    model_diagnostic(file_out = "model_diagnostic_text.txt", 
                     project_output_dir = project_output_dir,
                     data = eval_data), 
    format = "file"
  )
)
