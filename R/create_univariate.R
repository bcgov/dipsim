#' A title for create_univariate
#' 
#' Details of create_univariate
#' 
#' @param v vector of values to simulate
#' @param samp_size integer representing size of empirical distribution
#' 
#' @examples 
#' \dontrun{
#' create_univariate(rnorm(10))
#' }
#' 
#' @export
#' 
#' @importFrom dplyr %>%
create_univariate <- function(v, samp_size = 20) {
  UseMethod("create_univariate", v)
}

#' @export
create_univariate.default <- function(v, samp_size = 20) {
  stop("No current method for ", class(v))
}

#' @export
create_univariate.POSIXct <- function(v, samp_size = 20) {
  stop("Package doesn't know what to do with dates!  Please try again later...")
}

#' @export
create_univariate.factor <- function(v, samp_size = 20) {
  
  #if v is NULL
  if(length(v) == 0){
    return(list("x" = character(0), "p" =  logical(0), 
                "type" = character(0), "value" = "c"))
  }
  
  #if v is all NA
  if(all(is.na(v))) {
    return(list("distribution.x" = unique(v), "distribution.p" = 1), 
                "type" = "discrete", "value" = "c")
  }
  
  if(is.numeric(v)){
    ret <- create_univariate(as.numeric(v))
  }
  else if(is.character(typeof(v))){
    ret <- create_univariate(as.character(v))
  }
  return(ret)
}

#' @export
create_univariate.character <- function(v, samp_size = 20) {
  
  if (length(unique(v)) < samp_size) {
    ret <- create_discrete(v)
  } else {
    ret <- create_discrete(sample(v, samp_size))
  }
  return(ret)
}

#' @export
create_univariate.logical <- function(v, samp_size = 20) {
  v <- as.character(v)
  ret <- create_discrete(v)
  return(ret)
}

#' @export
create_univariate.numeric <- function(v, samp_size = 20) {
  
  if (isTRUE(all.equal(v,round(v))) && length(unique(v)) < samp_size) {
    ret <- create_discrete(v)
  } else {
    ret <- create_continuous(v)
  }
  return(ret)
}

#' @describeIn create_univariate A Title for create_continuous
create_continuous <- function(v) {
  UseMethod("create_continuous", v)
}

#' @export
create_continuous.default <- function(v) {
  stop("class(v) unknown")
}

#' @export
create_continuous.numeric <- function(v) {
  
  Fn  <- stats::ecdf(v)
  x   <- stats::knots(Fn)
  p   <- c(Fn(x[1]), diff(Fn(x)))
  pna <- sum(is.na(v))/length(v)
  
  if(pna != 0) {
    p <- c(p*(1-pna), pna)
    x <- c(x, NA)
  }
  
  d <- dplyr::tibble(x, p) %>%
       dplyr::mutate(p = ifelse(is.na(p), 0, p)) %>% # Is this needed?
       dplyr::arrange(x)
  
  ret <- c("distribution" = d, "type" = "continuous", "value" = "n")
  return(ret)
}


#' @describeIn create_univariate A Title for create_discrete
create_discrete <- function(v) {
  UseMethod("create_discrete", v)
}

#' @export
create_discrete.default <- function(v) {
  stop("class(v) unknown")
}

#' @export
create_discrete.numeric <- function(v) {
  
  v  <- factor(sort(v, na.last = TRUE), exclude = NULL)
  Fn <- stats::ecdf(v)
  x  <- stats::knots(Fn)
  p  <- c(Fn(x[1]), diff(Fn(x)))
  
  d <- dplyr::tibble(x,p) %>%
       dplyr::mutate(p = ifelse(is.na(p),0,p)) %>%
       dplyr::arrange(x)
  
  ret <- c("distribution" = d,  "type" = "discrete", "value" = "n")
  
  return(ret)
}

#' @export
create_discrete.character <- function(v) {
  
  v  <- factor(sort(v, na.last = TRUE), exclude = NULL)
  Fn <- stats::ecdf(v)
  x  <- stats::knots(Fn)
  p  <- c(Fn(x[1]), diff(Fn(x)))
  
  d <- dplyr::tibble(x=levels(v),p) %>%
       dplyr::mutate(p = ifelse(is.na(p),0,p)) %>%
       dplyr::arrange(x)
  
  ret <- c("distribution" = d, "type" = "discrete", "value" = "c")
  
  return(ret)
}

