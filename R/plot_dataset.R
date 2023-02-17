#' Title
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

#' @export
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