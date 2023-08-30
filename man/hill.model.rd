\name{hill.model}
\alias{hill.model}
\title{Four-parameter Hill model, gradient, starting values, and back-calculation functions}
\description{ Four-parameter Hill model, gradient, starting values, and back-calculation functions.  }
\usage{ 
        hill.model(theta, x)

        attr(hill.model, "gradient")(theta, x)
        
        attr(hill.model, "start")(x, y)
        
        attr(hill.model, "backsolve")(theta, y)
}
\arguments{
    \item{theta}{ Vector of four parameters:  (emin, emax, lec50, and m).  See details.}
    \item{x}{ Vector of concentrations for the Hill model. }
    \item{y}{ Response variable. }
}
\details{
  The four parameter Hill model is given by:
  
  y = emin + (emax-emin)/( 1 + exp( m*log(x) - m*lec50 ) ), where
    emin = minimum y value, emax = maximum y value, lec50 = log( ec50 ), and m = shape parameter.
    Note:  ec50 is defined such that hill.model(theta, ec50) = .5*( emin+ emax ).  
  
}
\value{
Let N = length(x).  Then

hill.model(theta, x) returns a numeric vector of length N.

attr(hill.model, "gradient")(theta, x) returns an N x 4 matrix.

attr(hill.model, "start")(x, y) returns a numeric vector of length 4 with starting values for
(emin, emax, lec50, m).

attr(hill.model, "backsolve")(theta, y) returns a numeric vector of length=length(y).

}
\examples{
x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2)
hill.model(theta, x)
attr(hill.model, "gradient")(theta, x)
attr(hill.model, "start")(x, y)
attr(hill.model, "backsolve")(theta, 50)
}
\author{Steven Novick}
\keyword{Nonlinear}
