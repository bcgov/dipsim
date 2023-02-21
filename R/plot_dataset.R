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

#' Dynamically plot a dataset
#'
#' @param x column to plot
#' @param ttl plot title
#' @param ... others parameters passed to function
#'
#' @return a ggplot grob with plot
#' @export
#'
#' @examples 
#' \dontrun{
#' plot_distribution(rnorm(100))
#' }
#' 
#' @importFrom ggplot2 aes labs element_text theme after_stat
plot_distribution <- function(x, ttl = NULL, ...){
  
  p <-  as.data.frame(x) %>%
        ggplot2::ggplot(aes(x = x)) +
        geom_hist_or_bar(class(x)) +
        labs(y="frequency", x = NULL, title = ttl) +
        scale_x_adapt(x, ...) +
        theme(axis.text.x = element_text(angle = 90, size = 6))
  
  ggplot2::ggplotGrob(p)
  
}


scale_limits <- function(x) UseMethod("scale_limits", x)


scale_limits.default <- function(x) NULL


scale_limits.numeric <- function(x) range(x, na.rm = TRUE)


scale_limits.character <- function(x) NULL


scale_x_adapt <-  function(x, ...) UseMethod("scale_x_adapt", x)


scale_x_adapt.default <- NULL


scale_x_adapt.character <- function(x, ...)  ggplot2::scale_x_discrete(drop = FALSE, ...)


scale_x_adapt.factor <- function(x, ...)  ggplot2::scale_x_discrete(drop = FALSE, ...)


scale_x_adapt.numeric <- function(x, ...)  ggplot2::scale_x_continuous(...)


geom_hist_or_bar <- function(x) UseMethod("geom_hist_or_bar", x)


geom_hist_or_bar.default <- NULL


geom_hist_or_bar.character <- function(x)  ggplot2::geom_bar(aes(y = after_stat((count/sum(count)))))


geom_hist_or_bar.factor <- function(x)  ggplot2::geom_bar(aes(y = after_stat((count/sum(count)))))


geom_hist_or_bar.numeric <- function(x) ggplot2::geom_density()