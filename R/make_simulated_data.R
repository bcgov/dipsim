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

#' Generate a simulated dataset
#'
#' @details Generate a dataset of any given size based on a pdf or pmf stored
#' at a given folder location.  The pmf or pdf are generated in the
#' function `generate_empirical() ` in this package.
#'
#' @param name name of dataset to simulate
#' @param folder_location path to data, relative to the package folder, defaults to ./
#' @param dataset_size desired size of the dataset to return, defaults to 1000 rows
#' @param samp_size integer, desired row count of base data, defaults to 100
#'
#'@return a simulated dataset
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples 
#' \dontrun{
#' wd <- '.'
#' fp <- search_parquet_data()
#' generate_empirical(samp_size = 50, folder_location = wd, name = fp, dataset_size = 100)
#' }
make_simulated_data <- function(samp_size = 50, folder_location, name, dataset_size = 100){
  
  generate_empirical(samp_size = 50, folder_location = folder_location, name = name)
  generate_testdata(dataset_size = 1000, folder_location = folder_location, name = name)
  read_testdata(folder_location = wd, name = name)
}

#' 
#' @export
#' @importFrom dplyr %>%
#' 
generate_empirical <- function(samp_size = 50, folder_location, name){
  #issue - rewrite with apply
  file = glue::glue("{folder_location}/{name}/distributions/theoretical/theoretical.csv")
  data <- readr::read_csv(file)
  
  for(i in names(data)){
    
    x <- data %>% 
      dplyr::pull(i)
    
    #recode commas for compatibility with .csv
    if(is.character(x))
      x <- gsub(",", " ", x) #could also use #comma# and replace
    
    emp <- create_univariate(x, samp_size)
    
    #issue stop if no folder exists
    
    file = glue::glue("{folder_location}/{name}/distributions/empirical/{i}.csv")
    readr::write_csv(data.frame(emp), file)
    
    gc
  }
}


#check for crash-likely distributions - these could be abstracted out
#if(!is.numeric(x) & sum(!duplicated(x)) > nrow(data)/5) {
#  message(paste0(i, " has too many levels. No distribution created."))
#  x <- as.factor(NULL)
#}

#if(!is.numeric(x) & sum(!duplicated(x)) <= nrow(data)/5 & sum(!duplicated(x)) > n) {
#  message(paste0(i, " has too many levels. Distribution sampled."))
#  x <- x[which(x %in% sample(unique(x), size = n))]
#}





#' 
#' @export
#' @importFrom dplyr %>%
#' 
generate_testdata <- function(folder_location = '.', name, dataset_size = 1000){
  
  # List files containing the empirical data on each column.  Strip the ".csv" extension in each filename
  cols <- list.files(glue::glue("{folder_location}/{name}/distributions/empirical/"))
  cols <- stringr::str_replace(cols, ".csv", "")
  
  # Initialize a data frame `test.df` with a single id column
  test.df <- data.frame(dummy = 1:dataset_size)
  
  # Initialize a data frame`cols.df` 
  cols.df <- data.frame(name = "dummy", coltype = "n")
  
  # Loop over each file name
  for(i in cols){
    
    # Read the empirical distribution data from the current file
    print(glue::glue("processing column {i}"))
    empirical.df <- readr::read_csv(glue::glue("{folder_location}/{name}/distributions/empirical/{i}.csv"), 
                                    show_col_types = FALSE,  n_max = 10e6)
    
    
    # If the empirical data is empty, generate some data
    if(length(empirical.df$distribution.x) == 0){
      x_emp <- sample(1:dataset_size, dataset_size, replace = FALSE)
      # If the empirical data has one level, generating a factor vector of that level only
    } else if(length(empirical.df$distribution.x) == 1) {
      x_emp <- factor(rep(empirical.df$distribution.x, dataset_size), exclude = NULL)
      # Generate a random sample from the empirical data using associated probabilities
    } else {
      x_emp <- sample(empirical.df$distribution.x, dataset_size, replace = TRUE, prob = empirical.df$distribution.p) #empirical x_vals. 
    }
    
    # Add a new column to `test.df`
    test.df <- test.df %>% dplyr::mutate({{i}} := x_emp)
    
    # Add a new row to`cols.df`
    cols.df <- cols.df %>% rbind(cbind(name = i, coltype = min(empirical.df$value)))
    
  }
  
  # write test.df and cols.df for later reference
  readr::write_csv(test.df, glue::glue("{folder_location}/{name}/test_df_{dataset_size}.csv"))
  readr::write_csv(cols.df, glue::glue("{folder_location}/{name}/cols_df_{dataset_size}.csv"))
}

#' @export
read_testdata <- function(folder_location = '.', name){
  
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

#create factor levels - may not be needed for creating the data - does this belong in the plotting?
#if(empirical.df$type == "discrete"){
#  empirical.df$distribution.x <- factor(empirical.df$distribution.x, exclude = NULL)
#}
