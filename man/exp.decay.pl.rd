\name{exp.decay.pl}
\alias{exp.decay.pl}
\title{Three-parameter exponential decay with initial plateau, gradient, starting values, and back-calculation functions}
\description{ Three-parameter exponential decay with initial plateau, gradient, starting values, and back-calculation functions.  }
\usage{ 
        exp.decay.pl(theta, x)

        attr(exp.decay.pl, "gradient")(theta, x)
        
        attr(exp.decay.pl, "start")(x, y)
        
        attr(exp.decay.pl, "backsolve")(theta, y)
}
\arguments{
    \item{theta}{ Vector of four parameters:  (x0, yMax, yMin, k).  See details.}
    \item{x}{ Vector of concentrations. }
    \item{y}{ Response variable. }
}
\details{
  The three-parameter exponential decay with initial plateau model is given by:
  
  y = yMax  if  x <= X0
  y = yMin + (yMax-yMin)*exp(-K*(x-X0)) if  x > X0,
  
  where X0=exp(x0) = inflection point between plateau and exponential decay curve,
  yMin = minimum response, yMax = maximum response, and K=exp(k) is the shape parameter.
  
  
}
\value{
Let N = length(x).  Then

exp.decay.pl(theta, x) returns a numeric vector of length N.

attr(exp.decay.pl, "gradient")(theta, x) returns an N x 4 matrix.

attr(exp.decay.pl, "start")(x, y) returns a numeric vector of length 4 with starting values for
(x0, yMax, yMin, k).

attr(exp.decay.pl, "backsolve")(theta, y) returns a numeric vector of length=length(y).

}
\examples{
x = 2^(-4:4)
theta = c(0.4, 75, 10, log(3))
exp.decay.pl(theta, x)
attr(exp.decay.pl, "gradient")(theta, x)
attr(exp.decay.pl, "start")(x, y)
attr(exp.decay.pl, "backsolve")(theta, 38)
}
\author{Steven Novick}
\keyword{Nonlinear}
