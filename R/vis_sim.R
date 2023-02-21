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

#' plot simulated data against original data
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
    
    # Extract theoretical data in variable `i`
    x <- data %>% 
         dplyr::pull(i)
    
    # Extract empirial data in variable`i`
    x_test <- test_data %>% 
              dplyr::pull(i)
    
    #we will want to expand this across all values
    cat(paste0("processing column: ", i, "\n"))
    
    # Generate a theoretical distribution plot for the theoretical data
    g.th  <- plot_distribution(x, limits = scale_limits(x), 
                               ttl = paste0(i, ": Theoretical Distribution"))
    
    # Generate an empirical distribution plot for the empirical data
    g.emp <- plot_distribution(x_test, limits = scale_limits(x), 
                               ttl = paste0(i, ": Empirical Distribution"))
    
    # Arrange the two plots in a grid
    gridExtra::grid.arrange(rbind(g.th, g.emp))
    
    # Display and pause 5 seconds before plotting next variable
    Sys.sleep(5)
  }
}
  