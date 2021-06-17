library(targets)

source("1_fetch/src/fetch_sb_data.R")
source("2_process/src/process_sb_data.R")
source("3_visualize/src/plot_results.R")

tar_option_set(packages = c("tidyverse",
                            "stringr", 
                            "sbtools",
                            "whisker"))

dir.create("1_fetch/out", showWarnings = FALSE)
dir.create("2_process/out", showWarnings = FALSE)
dir.create("3_visualize/out", showWarnings = FALSE)

list(
  # Get the data from ScienceBase
  tar_target(
    file_out,
    fetch_sb_data(out_filepath = "model_RMSEs.csv",
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
                 data = eval_data), 
    format = "file"
  ),
  # Save the processed data
  tar_target(
    model_summary_results_csv,
    write_processed(eval_data, 
                    project_output_dir = "2_process/out",
                    file_out = "model_summary_results.csv"), 
    format = "file"
  ),
  # Save the model diagnostics
  tar_target(
    model_diagnostic_text_txt,
    model_diagnostic(file_out = "model_diagnostic_text.txt", 
                     project_output_dir = "2_process/out",
                     data = eval_data), 
    format = "file"
  )
)
