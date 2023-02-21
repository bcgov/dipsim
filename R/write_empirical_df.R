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

#' A title for write_empirical_df
#' 
#' Details of write_empirical_df
#' 
#' @param name name of dataset to simulate
#' @param samp_size integer, desired row count of empirical data, defaults to 100
#' @param folder_location path to data, relative to the package folder, defaults to ./data
#' 
#' @examples 
#' \dontrun{
#' wd <- '.'
#' fp <- search_parquet_data()
#' generate_testdata(samp_size = 50, folder_location = wd, name = fp)
#' }
#' @export
#' 
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
