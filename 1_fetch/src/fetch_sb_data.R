library(sbtools)

fetch_sb_data <- function(project_output_dir, out_filepath){
  dir.create(project_output_dir, showWarnings = FALSE)
  
  # Get the data from ScienceBase
  mendota_file <- file.path(project_output_dir, 'model_RMSEs.csv')
  item_file_download('5d925066e4b0c4f70d0d0599', names = out_filepath, 
                     destinations = mendota_file, overwrite_file = TRUE)
  return(mendota_file)
}