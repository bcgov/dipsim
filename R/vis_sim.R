#' Title
#'
#' @param data simulated data
#' @param test_data original data
#' @param cols columns to plot, must be in both data and test_data
#'
#' @export
#'
#' @examples 
#' \dontrun{
#' vis_sim(df1, df2, c(col1, col2))
#' }
#' 
#' @importFrom dplyr %>%
vis_sim <- function(data, test_data, cols){
  for(i in cols){
    x <- data %>% 
         dplyr::pull(i)
    
    x_test <- test_data %>% 
              dplyr::pull(i)
    
    #we will want to expand this across all values
    cat(paste0("processing column: ", i, "\n"))
    
    g.th  <- plot_distribution(x, limits = scale_limits(x), 
                               ttl = paste0(i, ": Theoretical Distribution"))
    g.emp <- plot_distribution(x_test, limits = scale_limits(x), 
                               ttl = paste0(i, ": Empirical Distribution"))
    
    gridExtra::grid.arrange(rbind(g.th, g.emp))
    
    Sys.sleep(5)
  }
}
  