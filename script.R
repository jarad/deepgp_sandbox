library("tidyverse")
library("MASS")

# Function to compute covariance matrix based on squared exponential
# assuming scalar locations
create_covariance_matrix <- function(x, sigma2, lengthscale) {
  d <- length(x) # assumes scalar locations
  m <- matrix(sigma2, nrow = d, ncol = d) 
  for (i in 1:(d-1)) {
    for (j in 2:d) {
      m[i,j] <- m[j,i] <- sigma2*exp(-(x[i]-x[j])^2/lengthscale)
    }
  }
  return(m)
}

n <- 100
x <- runif(n)
K <- create_covariance_matrix(x, 2, 0.1)

h <- mvrnorm(1, rep(0,n), K)

rgp <- function(x) {
  n <- length(x)
  K <- create_covariance_matrix(x, 1, 0.01)
  mvrnorm(1, rep(0,n), K)
}

rdeepgp <- function(x, n_layers = 0) {
  f = rgp(x)
  while (n_layers > 0) {
    n_layers <- n_layers - 1
    f <- rgp(f)
  }
  return(f)
}

rdeepgp <- function(n_reps=5, n_layers=0, n_points=101) {
  d <- tibble(x = seq(0,1,length.out = n_points),
              rep = 1:n_reps) %>%
    
  
}
