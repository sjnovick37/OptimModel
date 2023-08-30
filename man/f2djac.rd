\name{f2djac}
\alias{f2djac}
\title{Compute derivative with respect to parameters}
\description{ Compute derivative with respect to parameters. }
\usage{f2djac(Func, theta, ...)}
\arguments{
    \item{Func}{ Returns an n x 1 vector, where n represents the number of. }
    \item{theta}{ A p x 1 vector of parameters. }
    \item{...}{ Other arguments needed for function.    }
}
\details{
}
\value{
  Returns an n x p matrix of derivatives with respect to theta.
  Computes d{ Func(theta, ...)  }/d{theta}
}
\examples{
    f = function(theta, x){ theta[1] + (theta[2]-theta[1])/(1 + (x/theta[3])^theta[4]) }
    theta0 = c(0, 100, .5, 2)
    x = 0:10
    f2djac(f, theta0, x=x)
}
\author{Steven Novick}
\keyword{Derivative}