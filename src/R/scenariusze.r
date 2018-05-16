
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

all_cases <- rmvt(10000, sigma, degreesOfFreedom, mu)
#all_cases <- rmvt(10000, mu,sigma, tol, empirical, eispack)
all_cases <- all_cases[all_cases[,1]>=80,]
all_cases <- all_cases[all_cases[,2]>=80,]
all_cases <- all_cases[all_cases[,3]>=80,]
all_cases <- all_cases[all_cases[,4]>=80,]
all_cases <- all_cases[all_cases[,5]>=80,]
all_cases <- all_cases[all_cases[,6]>=80,]
all_cases <- all_cases[all_cases[,1]<=120,]
all_cases <- all_cases[all_cases[,2]<=120,]
all_cases <- all_cases[all_cases[,3]<=120,]
all_cases <- all_cases[all_cases[,4]<=120,]
all_cases <- all_cases[all_cases[,5]<=120,]
all_cases <- all_cases[all_cases[,6]<=120,]
all_cases <- all_cases[1:1000,]

write.table(all_cases, "scenariusze.data", sep=" ", eol="]\n[", row.names = FALSE, col.names=FALSE)


