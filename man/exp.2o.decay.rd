\name{exp.2o.decay}
\alias{exp.2o.decay}
\title{Five-parameter second-order exponential decay, gradient, starting values, and back-calculation functions}
\description{ Five-parameter second-order exponential decay, gradient, starting values, and back-calculation functions.  }
\usage{ 
        exp.2o.decay(theta, x)

        attr(exp.2o.decay, "gradient")(theta, x)
        
        attr(exp.2o.decay, "start")(x, y)
        
        attr(exp.2o.decay, "backsolve")(theta, y)
}
\arguments{
    \item{theta}{ Vector of five parameters: (A, B, k1, k2, p).  See details.}
    \item{x}{ Vector of concentrations. }
    \item{y}{ Response variable. }
}
\details{
  The five-parameter exponential decay model is given by:
  
y = A + B * P * exp(-K1 * x) + B * (1-P) * exp(-K2 * x ). 

The parameter vector is (A, B, k1, k2, p) where A = minimum y value, A+B = maximum y value, 
K1=exp(k1) = shape parameter for first term, K2=exp(k2) = shape parameter for second term, and 
P=1/(1+exp(p)) = proportion of signal from first term. 

  
}
\value{
Let N = length(x).  Then

exp.2o.decay(theta, x) returns a numeric vector of length N.

attr(exp.2o.decay, "gradient")(theta, x) returns an N x 5 matrix.

attr(exp.2o.decay, "start")(x, y) returns a numeric vector of length 5 with starting values for (A, B, k1, k2, p). 

attr(exp.2o.decay, "backsolve")(theta, y) returns a numeric vector of length=length(y).

}
\examples{
x = 2^(-4:4)
theta = c(25, 75, log(3), log(1.2), 1/(1+exp(.7)))
exp.2o.decay(theta, x)
attr(exp.2o.decay, "gradient")(theta, x)
attr(exp.2o.decay, "start")(x, y)
attr(exp.2o.decay, "backsolve")(theta, 38)
}
\author{Steven Novick}
\keyword{Nonlinear}
