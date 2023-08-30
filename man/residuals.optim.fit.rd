\name{residuals.optim.fit}
\alias{residuals.optim.fit}
\title{Residuals for optim.fit objects}
\description{ Provides raw and studentized residuals for optim.fit objects.  }
\usage{ residuals.optim.fit(object, type=c("raw", "studentized"))
}
\arguments{
    \item{object}{ An object resulting from optim.fit(). }
    \item{type}{ 'raw' or 'studentized' residuals. }
}
\details{
}
\value{
Returns a numeric vector.
}
\examples{
set.seed(123)

x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2)
y1 = hill.model(theta, x) + rnorm( length(x), sd=2 )

fit1=optim.fit(theta, hill.model, x=x, y=y1)
residuals(fit1)
residuals(fit1, type="s")
}
\author{Steven Novick}
\keyword{Nonlinear}