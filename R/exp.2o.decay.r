# Program:  exp.2o.decay.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Exponential second-order decay Model, gradiant, and backsolve algorithms

exp.2o.decay = function (theta, x)
{
    A = theta[1]
    B = theta[2]
    k1 = exp(theta[3])
    k2 = exp(theta[4])
    p = 1/(1 + exp(theta[5]))
    pred = A + B * p * exp(-k1 * x) + B * (1 - p) * exp(-k2 *  x)
    return(pred)
}
attr(exp.2o.decay,"backsolve") = function (theta, y, log=FALSE)
{
    f.ssq = function(x, theta, y) {
        (y - exp.2o.decay(theta, x))^2
    }
    x0 = attr(exp.decay, "backsolve")(theta[c(1, 2, 3)], y)
    x1 = attr(exp.decay, "backsolve")(theta[c(1, 2, 4)], y)
    out = optimize(f.ssq, interval = sort(c(x0, x1)), theta = theta, y = y)$minimum

    if ( log )
      out = log(out)

    return(out)
}
attr(exp.2o.decay,"gradient") = function (theta, x)
{
    A = theta[1]
    B = theta[2]
    k1 = exp(theta[3])
    k2 = exp(theta[4])
    p = 1/(1 + exp(theta[5]))
    grad = matrix(NA, length(x), 5)
    grad[, 1] = 1
    grad[, 2] = p * exp(-k1 * x) + (1 - p) * exp(-k2 * x)
    grad[, 3] = -B * p * exp(-k1 * x) * k1 * x
    grad[, 4] = -B * (1 - p) * exp(-k2 * x) * k2 * x
    grad[, 5] = B * p * (1 - p) * (exp(-k2 * x) - exp(-k1 * x))
    return(grad)
}
attr(exp.2o.decay,"start") = function (x, y)
{
    theta0 = attr(exp.decay, "start")(x, y)
    theta0 = c(theta0[c(1, 2, 3, 3)], 0)
    names(theta0) = c("A", "B", "log.k1", "log.k2", "logit.p")
    return(theta0)
}
