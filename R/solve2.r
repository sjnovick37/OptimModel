# Program:  solve2.R
# Version:  1
# Author:   Steven Novick
# Date:     July 3, 2003
# Purpose:  Calculate inverse of a positive-definite matrix H

solve2 = function(H)
{
  H.inv = try( solve(H), silent=TRUE )
  if ( class(H.inv)[1] == "try-error" )
    H.inv = try( Matrix::solve(Matrix::Matrix(H)), silent=TRUE )
  if ( class(H.inv)[1] == "try-error" )
    H.inv = try( chol2inv( chol(H) ), silent=TRUE )
  if ( class(H.inv)[1] == "try-error" )
    H.inv = matrix(NA, nrow(H), ncol(H))

  return(H.inv)
}
