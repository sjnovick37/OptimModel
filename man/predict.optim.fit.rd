\name{predict.optim.fit}
\alias{predict.optim.fit}
\title{Predicted values for optim.fit objects}
\description{ Provides predicted values, standard errors, confidence intervals and prediction intervals for optim.fit objects.  }
\usage{ predict.optim.fit(object, x, se.fit=FALSE, interval=c("none", "confidence", "prediction"), K=1, level=.95)
}
\arguments{
    \item{object}{ An object resulting from optim.fit(). }
    \item{x}{ If supplied, a vector, data.frame, or matrix of Explanatory variables. }
    \item{se.fit}{ Logical.  Should standard errors be returned?  Requires that 'x' is supplied. }
    \item{interval}{ If equal to 'confidence', returns a 100*level\% confidence interval for the
    mean response.  If equal to 'prediction', returns a 100*level\% prediction interval for the mean of the next
    K observations.  Requires that 'x' is supplied. }    
    \item{K}{ Only used for prediction interval.  Number of observations in the mean for the prediction interval. }
    \item{level}{ Confidence/prediction interval level.}
}
\details{
}
\value{
Returns a vector (if interval='none').
Otherwise returns a data.frame with possible columns 'x', 'y.hat', 'se.fit', 'lower', and 'upper'.
}
\examples{
set.seed(123)

x = rep( c(0, 2^(-4:4)), each=4 )
theta = c(0, 100, log(.5), 2)
y1 = hill.model(theta, x) + rnorm( length(x), sd=2 )

fit1=optim.fit(theta, hill.model, x=x, y=y1)
fitted(fit1)
predict(fit1)
predict(fit1, x=x)
predict(fit1, x=seq(0, 1, by=.1), se.fit=TRUE)
predict(fit1, x=seq(0, 1, by=.1), interval="conf")
predict(fit1, x=seq(0, 1, by=.1), interval="conf")
predict(fit1, x=seq(0, 1, by=.1), interval="pred")

}
\author{Steven Novick}
\keyword{Nonlinear}
