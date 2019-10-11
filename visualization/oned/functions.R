library("MASS")

# Function to compute covariance matrix based on squared exponential
# assuming scalar locations
create_covariance_matrix <- function(x, sigma, lengthscale, nugget) {
  d <- length(x) # assumes scalar locations
  sigma2 <- sigma^2
  m <- matrix(sigma2 + nugget, nrow = d, ncol = d) 
  for (i in 1:(d-1)) {
    for (j in 2:d) {
      m[i,j] <- m[j,i] <- sigma2*exp(-(x[i]-x[j])^2/lengthscale)
    }
  }
  return(m)
}

rgp <- function(x, sigma, lengthscale, nugget) {
  n <- length(x)
  K <- create_covariance_matrix(x, sigma, lengthscale, nugget)
  mvrnorm(1, rep(0,n), K)
}

rdeepgp <- function(x, sigma, lengthscale, nugget, n_layers) {
  f = matrix(NA, nrow = length(x), ncol = n_layers + 2)
  f[,n_layers + 2] = x
  
  for (i in (n_layers+1):1) 
    f[,i] = rgp(f[,i+1], sigma[i], lengthscale[i], nugget[i])

  return(f)
}
