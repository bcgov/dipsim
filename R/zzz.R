.onLoad <-
  function(libname = find.package("dipsim"),
           pkgname = "dipsim") {
    
    
    # CRAN Note avoidance
    if (getRversion() >= "2.15.1") {
        utils::globalVariables(
        # Vars used in Non-Standard Evaluations, declare here to avoid CRAN warnings
        ## This is getting ridiculous
        c(
          "count",
          ":="
          #"." # piping requires '.' at times
        )
      )
    }
}
  