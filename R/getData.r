# Program:  getData.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  If possible, obtain the data from the optim.fit() object

getData = function(object)
    UseMethod("getData")
getData.optim.fit = function(object)
{
    mCall = object$call
    x = eval(mCall$x)
    y = eval(mCall$y)
    data = data.frame(x=x, y=y)

    return(as.list(data))
}

