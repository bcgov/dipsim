# Copyright 2023 Province of British Columbia
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

#' Generate an input an data set
#'
#' @description 
#' obtains a sample of a parquet dataset for easier memory handling.  
#' Rows are randomly selected using sample(). Setup files and folder structure
#' to house simulated data is also created.
#'
#' @param support_fp file path to support data
#' @param resize an integer number of rows to sample, defaults to 100000
#' @param folder_location a path to a folder to write data.  defaults to `.`
#'
#' @return a sample of the support data or the full dataset.
#' @export
#'
#' @examples
#' \dontrun{
#' ## Generate a sample of parquet data
#' wd <- 'R:/working/users/brobert/mydata'
#' fp <- search_parquet_data()
#' df <- make_input_data(support_fp = fp, resize = 100, folder_location = wd)
#' }
#' 
make_input_data <- function(support_fp, resize = 100000, folder_location = '.'){
  
  create_folder_structure(folder_location = folder_location, 
                          name = tools::file_path_sans_ext(basename(support_fp)))
  
  generate_theoretical(support = support_fp, resize = resize, folder_location = folder_location)
  
}


#' @export 
#' 
generate_theoretical <- function(support, resize, folder_location){
  #issue: arrow now supports slice_sample()
  # check user has passed a valid dataset
  
  # Open an Arrow dataset and convert it to a tibble
  ds <- arrow::open_dataset(support) %>% 
    dplyr::collect() 
  
  # Sample a subset of the dataset. The sample size is the smaller of either the value of "resize" 
  # or the number of rows in the dataset.
  ds <- ds %>%
    dplyr::slice(sample(x = nrow(ds), size =  min(nrow(ds), resize), replace = FALSE))
  
  #issue: stop if no folder  
  # Save the sampled dataset as a CSV file
  file = glue::glue("{folder_location}/{tools::file_path_sans_ext(basename(support))}/distributions/theoretical/theoretical.csv")
  readr::write_csv(ds, file)
  
  return(ds)
}