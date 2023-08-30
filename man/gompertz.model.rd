\name{gompertz.model}
\alias{gompertz.model}
\title{Four-parameter Gompertz model, gradient, starting values, and back-calculation functions}
\description{ Four-parameter Gompertz model, gradient, starting values, and back-calculation functions.  }
\usage{ 
        gompertz.model(theta, x)

        attr(gompertz.model, "gradient")(theta, x)
        
        attr(gompertz.model, "start")(x, y)
        
        attr(gompertz.model, "backsolve")(theta, y)
}
\arguments{
    \item{theta}{ Vector of four parameters:  (A, B, m, offset).  See details.}
    \item{x}{ Vector of concentrations for the Gompertz model. }
    \item{y}{ Response variable. }
}
\details{
  The four parameter Gompertz model is given by:
                                    
  y = A + (B-A)*exp( -exp( m*(x-offset) ) ), where
    A = minimum y value, A+(B-A)*exp(-exp( -m*offset )) = maximum y value, m = shape parameter, and offset shifts the curve, 
    relative to the concentration x.
  
}
\value{
Let N = length(x).  Then

gompertz.model(theta, x) returns a numeric vector of length N.

gompertz(hill.model, "gradient")(theta, x) returns an N x 4 matrix.

attr(gompertz.model, "start")(x, y) returns a numeric vector of length 4 with starting values for
(A, B, m, offset).

attr(gompertz.model, "backsolve")(theta, y) returns a numeric vector of length=length(y).

}
\examples{
}
\author{Steven Novick}
\keyword{Nonlinear}
