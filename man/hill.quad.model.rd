\name{hill.quad.model}
\alias{hill.quad.model}
\title{Five-parameter Hill model with quadratic component, gradient, starting values, and back-calculation functions}
\description{ Five-parameter Hill model with quadratic component, gradient, starting values, and back-calculation functions.  }
\usage{ 

        hill.quad.model(theta, x)

        attr(hill.quad.model, "gradient")(theta, x)
        
        attr(hill.quad.model, "start")(x, y)
        
        attr(hill.quad.model, "backsolve")(theta, y)
}
\arguments{
    \item{theta}{ Vector of five parameters:  (A, B, a, b, c).  See details. }
    \item{x}{ Vector of concentrations for the five-parameter Hill model with quadratic component. }
    \item{y}{ Response variable. }
}
\details{
  The five parameter Hill model with quadratic component is given by:
  
  y = A + (B-A)/( 1 + exp( -(a + b*x + c*x^2) )  ) .
  
  A = minimum y value, B = maximum y value, (a, b, c) = quadratic parameters for x.

  Notes:

  1.  If c = 0, this model is equivalent to the four-parameter Hill model (hill.model).

  2.  The ic50 is defined such that a + b*x + c*x^2 = 0.  If the roots of the quadratic equation are real, then the ic50
  is given by ( -b +/- sqrt( b^2 - 4*a*c ) )/(2*c).

  3.  For many dose-response applications, model convergence may be more easily achieved for log-transformed x values.
  As shown in the example (below), log-transformed x-values may be mean-centered.


}
\value{
Let N = length(x).  Then

hill.quad.model(theta, x) returns a numeric vector of length N.

attr(hill.quad.model, "gradient")(theta, x) returns an N x 5 matrix.

attr(hill.quad.model, "start")(x, y) returns a numeric vector of length 5 with starting values for
(A, B, a, b, c).

If the quadratic roots are real-valued, attr(hill.quad.model, "backsolve")(theta, y) returns a numeric vector of length=2.

}
\examples{
x = rep( c(0, 2^(-4:4)), each=3 )      ## Dose
xlog = log(x)
M = mean(xlog[ xlog > -Inf ])
z = xlog - M                           ## mean-centered log(Dose)

theta = c(0, 100, 2, 1, -0.5)          ## Model parameters
y = hill.quad.model(theta, z) + rnorm( length(z), mean=0, sd=5 )

  ## Generate data
hill.quad.model(theta, z)
attr(hill.quad.model, "gradient")(theta, z)
attr(hill.quad.model, "start")(z, y)
attr(hill.quad.model, "backsolve")(theta, 50)
}
\author{Steven Novick}
\keyword{Nonlinear}
