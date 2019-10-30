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
# set.seed(5112)


## inputs/covariates
z <- seq(from = 0, to = 1, by = 1/200)

## sample from two latent GP layer
cov_par_z <- list("sigma" = 1, "l" = 1/5, "tau" = 0)
Sigz <- make_cov_matC(x = matrix(z, ncol = 1), x_pred = matrix(), cov_par = cov_par_z, cov_fun = "sqexp", delta = 0)
x1 <- as.numeric(mvtnorm::rmvnorm(n = 1, sigma = Sigz))
# x2 <- as.numeric(mvtnorm::rmvnorm(n = 1, sigma = Sigz))
# x3 <- as.numeric(mvtnorm::rmvnorm(n = 1, sigma = Sigz))

plot(x = z, y = x1)
# plot(x = z, y = x2)
# plot(x = z, y = x3)

# x <- cbind(x1, x2, x3)
x <- as.matrix(x1, ncol = 1)

## sample |z| output observations from the output GP
cov_par_x <- list("sigma" = 1, "l" = 1/5, "tau" = 0)
Sigx <- make_cov_matC(x = x, x_pred = matrix(), cov_par = cov_par_x, cov_fun = "sqexp", delta = 0)
y <- mvtnorm::rmvnorm(n = 1, sigma = Sigx)

plot(x = z, y = y, type = "l")


## simulation from a Bayesian 
## neural network type architecture with only one hidden unit per layer
x1nn <- tanh(rnorm(n = 1, mean = 0, sd = 2) * z)
x2nn <- tanh(rnorm(n = 1, mean = 0, sd = 2) * x1nn)
x3nn <- tanh(rnorm(n = 1, mean = 0, sd = 2) * x2nn)
x4nn <- tanh(rnorm(n = 1, mean = 0, sd = 2) * x3nn)
x5nn <- tanh(rnorm(n = 1, mean = 0, sd = 2) * x4nn)
ynn <- rnorm(n = 1, mean = 0, sd = 3) * x5nn

plot(x = z, y = ynn)
