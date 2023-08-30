# Program:  print.rout.fit.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Print results from an rout.fit() object

print.rout.fit = function(object, digits=4)
{
  cat("\n")
  cat("\nROUT Fitted Model Statistics", "\n")
  cat("\n")
  cat( "Convergence :", ifelse(object$Converge, "Achieved", "Failed"), "\n" )
  cat("\n")
  cat( "Parameter estimates\n", sep="" )
  print.noquote( round(object$par, digits) )
  cat("\n")
  cat( "RSDR =", round(object$rsdr, digits), "from", length(object$residuals), "obsevations and", length(object$par)-1, "parameter(s)", "\n" )
  cat("\n")
  cat( "r-sq (without FDR correction) =", round(object$r.squared, digits), "\n" )
  cat( "r-sq (with FDR correction) =", round(object$r.squared.adj, digits), "\n" )
  cat("\n")

  cat("Q =", attr(object, "Q"), "\n")
  cat( "# of outliers detected (without FDR correction) =", sum(object$outlier), "\n" )
  cat( "# of outliers detected (with FDR correction) =", sum(object$outlier.adj), "\n" )

  if ( !is.null(object$message) )
    print.noquote( object$message )

  invisible()
}

