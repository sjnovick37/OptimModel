\name{exp.decay}
\alias{exp.decay}
\title{Three-parameter exponential decay, gradient, starting values, and back-calculation functions}
\description{ Three-parameter exponential decay, gradient, starting values, and back-calculation functions.  }
\usage{ 
        exp.decay(theta, x)

        attr(exp.decay, "gradient")(theta, x)
        
        attr(exp.decay, "start")(x, y)
        
        attr(exp.decay, "backsolve")(theta, y)
}
\arguments{
    \item{theta}{ Vector of three parameters:  (A, B, k).  See details.}
    \item{x}{ Vector of concentrations. }
    \item{y}{ Response variable. }
}
\details{
  The three-parameter exponential decay model is given by:
  
  y = A + B * exp(-K * x).
  
  The parameter vector is (A, B, k) where
    A = minimum y value, A+B = maximum y value, and K=exp(k) = shape parameter.
  
}
\value{
Let N = length(x).  Then

exp.decay(theta, x) returns a numeric vector of length N.

attr(exp.decay, "gradient")(theta, x) returns an N x 3 matrix.

attr(exp.decay, "start")(x, y) returns a numeric vector of length 3 with starting values for
(A, B, k).

attr(exp.decay, "backsolve")(theta, y) returns a numeric vector of length=length(y).

}
\examples{
x = 2^(-4:4)
theta = c(25, 75, log(3))
exp.decay(theta, x)
attr(exp.decay, "gradient")(theta, x)
attr(exp.decay, "start")(x, y)
attr(exp.decay, "backsolve")(theta, 38)
}
\author{Steven Novick}
\keyword{Nonlinear}
