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

#' Read a dataset into memory
#'
#' @details read a dataset from a given folder location. Metadata are stored along 
#' with the dataset and used in `read_csv()` to specify column types and 
#' which columns to read in.
#'
#' @param folder_location path to data, relative to the package folder, defaults to ./data
#' @param name name of dataset to simulate
#'
#' @return a simulated dataset
#'
#' @examples 
#' \dontrun{
#' wd <- 'R:/working/users/brobert/mydata'
#' fp <- search_parquet_data()
#' read_testdata(folder_location = wd, name = fp)
#' }
#' 
#' @export
read_testdata <- function(folder_location = './data', name){

  cols <-  readr::read_csv(glue::glue("{folder_location}/{name}/cols_df_{dataset_size}.csv"), 
                                show_col_types = FALSE,  n_max = 10e6)
  
  data <-  readr::read_csv(glue::glue("{folder_location}/{name}/test_df_{dataset_size}.csv"), 
                                col_names = cols$name, 
                                col_types = paste(cols$coltype, collapse = ""), 
                                show_col_types = FALSE,  
                                n_max = 10e6, 
                                skip = 1)
  return(data)
}