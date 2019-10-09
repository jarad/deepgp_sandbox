library("MASS")

# Function to compute covariance matrix based on squared exponential
# assuming scalar locations
create_covariance_matrix <- function(x, sigma, lengthscale) {
  d <- length(x) # assumes scalar locations
  sigma2 <- sigma^2
  m <- matrix(sigma2, nrow = d, ncol = d) 
  for (i in 1:(d-1)) {
    for (j in 2:d) {
      m[i,j] <- m[j,i] <- sigma2*exp(-(x[i]-x[j])^2/lengthscale)
    }
  }
  return(m)
}

rgp <- function(x, sigma, lengthscale) {
  n <- length(x)
  K <- create_covariance_matrix(x, sigma, lengthscale)
  mvrnorm(1, rep(0,n), K)
}

rdeepgp <- function(x, sigma, lengthscale, n_layers = 0) {
  f = rgp(x, sigma, lengthscale)
  while (n_layers > 0) {
    n_layers <- n_layers - 1
    f <- rgp(f, sigma, lengthscale)
  }
  return(f)
}
