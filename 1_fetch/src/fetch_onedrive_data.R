library(sbtools)

fetch_onedrive_data <- function(ds_pipeline, project_output_dir, out_filepath){
  
  dir.create(project_output_dir, showWarnings = FALSE)
  
  # Get the data from a shared OneDrive folder
  mendota_file <- file.path(project_output_dir, out_filepath)
  file.copy(from = file.path(ds_pipeline, "me_RMSE.csv"),
            to = mendota_file, 
            overwrite = TRUE)
  return(mendota_file)
}