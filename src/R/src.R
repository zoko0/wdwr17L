library(mvtnorm)

#input params
dataRange = data.frame(bottom = 80, top = 120)
mu = c(116, 102, 113, 100, 107, 110)
degreesOfFreedom = 5
data = c(1, 1, 0, 1, 1, 1,
         1,36,-1,-1,-3,-5,
         0,-1, 4, 2, 2, 0,
         1,-1, 2,49,-5,-2,
         1,-3, 2,-5,16,-2,
         1,-5, 0,-2,-2, 9)
sigma = matrix(data = data, nrow = 6, ncol = 6)


main = function () {
  randomVectorComponents = c()
  randomVectorComponents = countRandomVectorComponents()
  
  for (j in 1:6){
    print(randomVectorComponents[j])
  }
  
  #ddd = data.frame(A = c(R1, R4), B = c(R2, R5), C = c(R3, R6))
  
  # R5
  #ddd[2, 2]; ddd$B[2]; ddd[[2]][2]; ddd[names(ddd) == "B", 2]
  
  # R6
  #ddd[2, 3]; ddd$C[2]; ddd[[3]][2]
  
}

countExpectedValue = function (mu, sig, df = degreesOfFreedom, dr = dataRange) {
  if (df > 1) {
    a = (dr$bottom - mu)/sig
    b = (dr$top    - mu)/sig
    
    nominator = gamma( ((df-1)/2))*((df + a^2)^(-1*(df-1)/2) -
                       (df + b^2)^(-1*(df-1)/2))  * df^(df/2)
    
    denominator = 2*(pt(b, df) - pt(a, df)) * gamma(df/2) * gamma(1/2)
    
    return (mu + sig * nominator / denominator)
    
  } else { stop("countExpected: Degrees of freedom should be > 1") }
}

countRandomVectorComponents = function () {
  randomVectorElements = c()
  for (i in 1:6) {
    randomVectorElements[i] = countExpectedValue(mu[i], sigma[i, i])
  }
  
  return (randomVectorElements)
}

main()

