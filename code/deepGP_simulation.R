## Understanding deep GPs
Rcpp::sourceCpp("covariance_functionsC.cpp")
library(mvtnorm)
library(ggplot2)
library(Matrix)
library(glmnet)

## interesting seeds
# set.seed(1115)
# set.seed(2111)
# set.seed(3112)
set.seed(5112)


## inputs/covariates
z <- seq(from = 0, to = 1, by = 1/200)

## sample from a latent GP layer
cov_par_z <- list("sigma" = 1, "l" = 1/4, "tau" = 0)
Sigz <- make_cov_matC(x = matrix(z, ncol = 1), x_pred = matrix(), cov_par = cov_par_z, cov_fun = "sqexp", delta = 0)
x <- mvtnorm::rmvnorm(n = 1, sigma = Sigz)

plot(x = z, y = x)

## sample |z| output observations from the output GP
cov_par_x <- list("sigma" = 1, "l" = 1/4, "tau" = 0)
Sigx <- make_cov_matC(x = matrix(x, ncol = 1), x_pred = matrix(), cov_par = cov_par_x, cov_fun = "sqexp", delta = 0)
y <- mvtnorm::rmvnorm(n = 1, sigma = Sigx)

plot(x = z, y = y)
