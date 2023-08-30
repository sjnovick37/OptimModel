\name{rout.outlier.test}
\alias{rout.outlier.test}
\title{ROUT Outlier Testing}
\description{ Perform ROUT outlier testing on rout.fitter() object.  }
\usage{rout.outlier.test(fit, Q=0.01)
}
\arguments{
    \item{fit}{ A 'rout.fitter' object from the rout.fitter() function. }
    \item{Q}{ Test size for ROUT outlier detection.  }
}
\details{
  rout.outlier.test() is typically called from rout.fitter(), but may also be called directly by the user.
}
\value{

outlier = logical vector.  TRUE indicates observation is an outlier via hypothesis testing with unadjust p-values.

outlier.adj = logical vector.  TRUE indicates observation is an outlier via hypothesis testing with FDR-adjust p-values.

attr(object, "Q") = test size for outlier detection

}
\examples{
set.seed(123)

x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2)
sigma = 2
y = hill.model(theta, x) + rnorm( length(x), sd=sigma )

ii = sample( 1:length(y), 2 )
y[ii] = hill.model(theta, x[ii]) + 5.5*sigma + rnorm( length(ii), sd=sigma )

fit = rout.fitter(c( theta, log(sigma) ), hill.model, x=x, y=y, Q=0.01)
rout.outlier.test(fit, Q=0.001)

}
\author{Steven Novick}
\keyword{Nonlinear}