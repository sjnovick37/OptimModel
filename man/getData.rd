\name{getData}
\alias{getData}
\alias{getData.optim.fit}
\title{Extract data object from an optim fit}
\description{ Extract data object from an optim fit. }
\usage{getData(object)}
\arguments{
    \item{object}{ object of class "optim.fit". }
}
\details{
}
\value{
  Returns a data frame with elements x and y.
}
\examples{
    fit = optim.fit(c(0, 100, .5, 1), f.model=f, x=x, y=y)
    d=getData(fit)
}
\author{Steven Novick}
