\name{print.optim.fit}
\alias{print.optim.fit}
\title{Prints optim.fit objects}
\description{ Provides a nice printed summary of optim.fit objects.  }
\usage{ print.optim.fit(object, digits=4)
}
\arguments{
    \item{object}{ An object resulting from optim.fit(). }
    \item{digits}{ Number of digits to print for output. }
}
\details{
}
\value{

}
\examples{
set.seed(123)

x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2)
y1 = hill.model(theta, x) + rnorm( length(x), sd=2 )

fit1=optim.fit(theta, hill.model, x=x, y=y1)
print(fit1)
fit1

}
\author{Steven Novick}
\keyword{Nonlinear}