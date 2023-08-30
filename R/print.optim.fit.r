print.optim.fit = function(object, digits=4)
{
  cat("\n")    
  cat( "Fit method = '", object$fit.method, "'\n", sep="" )
  cat( "Variance computation method = '", object$var.method, "'\n", sep="" )
  cat( "Weights =", attr(attr(object, "w.func"), "label"), "\n" )
  cat( "Convergence :", ifelse(object$converge==0, "Achieved", "Failed"), "\n" )
  cat("\n")   
  cat( 100*attr(object$beta, "conf.level"), "% Wald CI for parameters\n", sep="" )
  print.noquote( round(object$beta, digits) )
  cat( "sigma =", round(object$sigma, digits), "on", object$df, "degrees of freedom", "\n" )
  cat( "r-squared =", round(object$r.squared, digits), "\n" )
  cat( "BIC = ", round(object$bic, digits), "  (smaller is better)\n" )
  if ( object$fit.method != "ols" )
  {
    if ( !is.null( attr(object, "var.param") ) )
    {
      cat("var/weight param(s):\n")
      phi = round(attr(object, "var.param"), digits)
      print.noquote( ifelse(is.na(phi), "none", phi) )
    }
  }

  if ( !is.null(object$message) )
    print.noquote( object$message )

  invisible()
}

