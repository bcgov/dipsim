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

#' Select parquet data file or partition
#' 
#' @description
#' Opens a file explorer window and searches the file system for data.  Root of 
#' search path is set to the core-snapshot folder in the SAE.  To override this behavior, 
#' set `sae=FALSE`.
#'
#'@param sae a flag to indicate if working in the SAE
#'
#' @return 
#' A character string.  A folder location of a
#' parquet data file or partition.
#'
#' @examples
#' \dontrun{
#' ## returns a filepath
#' fp <- search_parquet_data()
#' 
#' ## open a file explorer window
#' fp <- search_parquet_data(sae=FALSE)
#' }
#' 
#' @importFrom dplyr %>%
#' @export
#' 

search_parquet_data <- function(sae=TRUE){
 
  # check if sae flag is set to TRUE
  if (.Platform$OS.type == "windows"){
    
    fldr = "C:\\"
    if(sae == TRUE){
      fldr = "R:\\working\\parquet_data\\core-snapshot"
    }
    
    # create a temp file with .vbs extension to hold VB code.
    tf <- tempfile(fileext = ".vbs")
    
    #VB code to temp file to prompt user to select a folder with their Parquet data.
    cat('Set folder = CreateObject("Shell.Application") _
        .BrowseForFolder (0, "Please choose a folder with your parquet data. 
        The folder may contain multiple partitions, or a single .parquet file.", _
        &H0200,',fldr,'
        Wscript.Echo folder.Self.Path', file = tf)
    
    # execute the .vbs script and capture the path of the selected folder.
    fp <- utils::tail(shell(paste('Cscript', tf), intern = T), 1)
    
  } else if (.Platform$OS.type == "unix") {
    fp = file.choose()
  } else {
    stop("unrecognized operating system")
  }
  
}

#' Create folder structure for sample data
#
#'@description
#' Creates a folder structure at `location` specified, with same name as parquet data.  
#' if no folder exists at the specified location, it is created.
#' 
#' @param name name of parquet data or partition
#' @param folder_location file path to working folder, defaults to `dipsim/data`
#'
#' @examples
#' \dontrun{
#' ## creates ./data/ido_mcfd and subfolders
#' create_folder_structure(name = "ido_mcdf") 
#' ## or
#' create_folder_structure("/20210201/ido_mcdf") 
#' 
#' ## returns a file path, fp
#' fp <- search_parquet_data() 
#' create_folder_structure(fp)
#' }
#' 
#' @export
#' 
create_folder_structure <- function(name, folder_location = './data'){
  
  # set up folder structure, checking if the folders exist.
  # the desired folder structure looks like:
  # --  folder_location
  #   --  name
  #     --  distributions  
  #       --  empirical
  #       --  theoretical
  
  if (!dir.exists(glue::glue("{folder_location}"))) {
    dir.create(glue::glue("{folder_location}"))
  }
  
  if (!dir.exists(glue::glue("{folder_location}/{name}"))) {
    dir.create(glue::glue("{folder_location}/{name}"))
  }
   
  if (!dir.exists(glue::glue("{folder_location}/{name}/distributions"))) {
    dir.create(glue::glue("{folder_location}/{name}/distributions"))
  }
    
  if (!dir.exists(glue::glue("{folder_location}/{name}/distributions/empirical"))) {
      dir.create(glue::glue("{folder_location}/{name}/distributions/empirical"))
  }
    
  if (!dir.exists(glue::glue("{folder_location}/{name}/distributions/theoretical"))) {
      dir.create(glue::glue("{folder_location}/{name}/distributions/theoretical"))
  }
}

#' Apply common data cleaning methods
#'
#' @description 
#' Cleans a vector of data by applying common data cleaning operations.  
#' 
#' @param .x a vector of data of any basic data type
#' 
#' @details 
#' Any data type can be passed to the function, but some type checking is done
#' before an operation is performed. Character vectors are stripped of the following 
#' characters: `-`
#'
#' @return a vector of clean data 
#'
#' @examples
#' \donttest{
#' ## Clean a column of character data
#' v <- c("cat","dog-cat","c-a-t","-catdo-g")
#' clean_data_col(v)
#' ## [1] "cat"    "dogcat" "cat"    "catdog"
#' }
#' 
#' @export 
#' 
clean_data_col <- function(.x){
  
  # If .x is a character vector, replace all occurrences of "-" with ""
  if(is.character(.x)) 
    x <- stringr::str_replace_all(.x, pattern = "-", replacement = "")
  return(x)
}


#' Get names of matching columns
#'
#' @description 
#' Return a vector of columns names found in two given data frames. 
#' Currently only names must match for the column to be chosen.
#' 
#' @param data theoretical dataset
#' @param test_data empirical dataset
#' 
#' @details 
#'  Both names and class should match for the column to be identified as a match.
#'  Currently only names are checked and matching names is case-sensitive.
#'
#' @return a vector of column names
#'
#' @examples
#' \donttest{
#' a <- data.frame(col_one = c(1,2,3), col_two = c("a","b","c"))
#' b <- data.frame(col_one = c(1,2,3), col_two = c("d","e","f"))
#' compare_data(a,b)
#' c <- data.frame(col_One = c(1,2,3), col_two = c("a","b","c"))
#' compare_data(a,b)
#' d <- data.frame(col_one = c(TRUE, FALSE, FALSE), col_two = c("a","b","c"))
#' compare_data(a,b)
#' }
#' 
#' @export 
#'
compare_data <- function(data, test_data) {
#issue - check we've captured all the cols, output some message if there are issues
  # Find column names in data that are not in test_data
  setdiff(names(data), names(test_data))
  
  # Find column names in test_data that are not in data
  setdiff(names(test_data), names(data))
  
  # Find the common column names between data and test_data and sort them
  cols <- sort(intersect(names(data), names(test_data)))
  
#issue - check coltypes are the same - handle if there are issues
  # Get the classes of each column in the common set of columns between data and test_data
  classes <- sapply(data[,cols], class)
  
  # Get the classes of each column in the common set of columns between test_data and data
  test_classes <- sapply(test_data[,cols], class)
  
  # Find the index of the columns where the classes in data and test_data are different
  which(classes != test_classes)
  
  #return valid cols to use
  return(cols)
}