library(mvtnorm)

#parametry wejsciowe
przedzial = data.frame(bottom = 80, top = 120)
mu = c(116, 102, 113, 100, 107, 110)
degresOfFreedom = 5
data = c(1, 1, 0, 1, 1, 1,
         1,36,-1,-1,-3,-5,
         0,-1, 4, 2, 2, 0,
         1,-1, 2,49,-5,-2,
         1,-3, 2,-5,16,-2,
         1,-5, 0,-2,-2, 9)
sigma = matrix(data = data, nrow = 6, ncol = 6)

countExpected = function(mu, sig, df, prze = przedzial) {
  if (df > 1) {
    a = (prze$bottom - mu)/sig
    b = (prze$top    - mu)/sig
    
    licznik = gamma( ((df-1)/2))*((df + a^2)^(-1*(df-1)/2) -
                       (df + b^2)^(-1*(df-1)/2))  * df^(df/2)
    
    mianownik = 2*(pt(b, df) - pt(a, df)) * gamma(df/2) * gamma(1/2)
    
    return(mu + sig*licznik/mianownik)
  } else {
    stop("countExpected: Degrees of freedom should be > 1")
  }
}