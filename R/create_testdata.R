#' Generate a simulated dataset
#'
#' @details Generate a dataset of any given size based on a pdf or pmf stored
#' at a given folder location.  The pmf or pdf are generated in the
#' function `generate_empirical() ` in this package.
#'
#' @param dataset_size desired size of the dataset to return, defaults to 1000 rows
#' @param folder_location path to data, relative to the package folder, defaults to ./data
#' @param name name of dataset to simulate
#'
#'
#' @examples
#' \dontrun{
#' wd <- 'R:/working/users/brobert/mydata'
#' fp <- search_parquet_data()
#' generate_testdata(folder_location = wd, name = fp, dataset_size = 100)
#' }
#' 
#' @importFrom dplyr %>%
#' 
#' @export
generate_testdata <- function(folder_location = './data', name, dataset_size = 1000){

  cols <- list.files(glue::glue("{folder_location}/{name}/distributions/empirical/"))
  cols <- stringr::str_replace(cols, ".csv", "")

  test.df <- data.frame(dummy = 1:dataset_size)
  cols.df <- data.frame(name = "dummy", coltype = "n")

  for(i in cols){
    print(glue::glue("processing column {i}"))
    empirical.df <- readr::read_csv(glue::glue("{folder_location}/{name}/distributions/empirical/{i}.csv"), 
                                    show_col_types = FALSE,  n_max = 10e6)

    #handle case where empirical.df$x has one level
    #as we can't draw a sample from a population of 1
    if(length(empirical.df$distribution.x) == 0){
      x_emp <- sample(1:dataset_size, dataset_size, replace = FALSE)
    } else if(length(empirical.df$distribution.x) == 1) {
      x_emp <- factor(rep(empirical.df$distribution.x, dataset_size), exclude = NULL)
    } else {
      x_emp <- sample(empirical.df$distribution.x, dataset_size, replace = TRUE, prob = empirical.df$distribution.p) #empirical x_vals. 
    }
  
    test.df <- test.df %>% dplyr::mutate({{i}} := x_emp)
    cols.df <- cols.df %>% rbind(cbind(name = i, coltype = min(empirical.df$value)))
  
  }
  
  readr::write_csv(test.df, glue::glue("{folder_location}/{name}/test_df_{dataset_size}.csv"))
  readr::write_csv(cols.df, glue::glue("{folder_location}/{name}/cols_df_{dataset_size}.csv"))

}


#create factor levels - may not be needed for creating the data - does this belong in the plotting?
#if(empirical.df$type == "discrete"){
#  empirical.df$distribution.x <- factor(empirical.df$distribution.x, exclude = NULL)
#}
