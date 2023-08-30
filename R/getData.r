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

