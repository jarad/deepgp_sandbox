#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
double cov_fun_sqrd_expC(NumericVector x1, NumericVector x2, List cov_par){

double sigma = as<double>(cov_par["sigma"]);
double l = as<double>(cov_par["l"]);

return pow(sigma,2) * exp(-1/(2 * pow(l,2)) * sum(pow((x1 - x2),2)));

}

// [[Rcpp::export]]
double cov_fun_expC(NumericVector x1, NumericVector x2, List cov_par){
  
  double sigma = as<double>(cov_par["sigma"]);
  double l = as<double>(cov_par["l"]);
  
  return pow(sigma,2) * exp(-1/l * sum(abs(x1 - x2)));
  
}

// [[Rcpp::export]]
NumericMatrix make_cov_matC(NumericMatrix x, NumericMatrix x_pred, List cov_par, String cov_fun, double delta){
  // select the squared exponential covariance function
  if(cov_fun == "sqexp"){
    
    // if the length of x_pred is zero, make variance covariance matrix for x
    if(NumericMatrix::is_na(x_pred(0,0)) == 1){
      int nrow = x.nrow();
      int ncol = x.nrow();
      
      NumericMatrix mat(nrow, ncol);
      
      for(int i = 0; i < nrow; i++){
        
        for(int j = 0; j < ncol; j++){
          if(i == j){
            mat(i , j) = cov_fun_sqrd_expC(x(i, _), x(j, _), cov_par) + pow(as<double>(cov_par["tau"]),2) + delta;
          }
          else{
            mat(i , j) = cov_fun_sqrd_expC(x(i, _), x(j, _), cov_par);
          }
        }
        
      }
      return mat; 
    }
    // if the length of x_pred is nonzero, make the covariance matrix where x is rows, x_pred is columns
    if(NumericMatrix::is_na(x_pred(0,0)) != 1){
      int nrow = x.nrow();
      int ncol = x_pred.nrow();
      
      NumericMatrix mat(nrow, ncol);
      
      for(int i = 0; i < nrow; i++){
        
        for(int j = 0; j < ncol; j++){
          mat(i , j) = cov_fun_sqrd_expC(x(i, _),x_pred(j,_), cov_par);
        }
        
      }
      return mat; 
    }
  }
  
  // select the exponential covariance function
  if(cov_fun == "exp"){
    
    // if the length of x_pred is zero, make variance covariance matrix for x
    if(NumericMatrix::is_na(x_pred(0,0)) == 1){
      int nrow = x.nrow();
      int ncol = x.nrow();
      
      NumericMatrix mat(nrow, ncol);
      
      for(int i = 0; i < nrow; i++){
        
        for(int j = 0; j < ncol; j++){
          if(i == j){
            mat(i , j) = cov_fun_expC(x(i, _), x(j, _), cov_par) + pow(as<double>(cov_par["tau"]),2) + delta;
          }
          else{
            mat(i , j) = cov_fun_expC(x(i, _), x(j, _), cov_par);
          }
        }
        
      }
      return mat; 
    }
    // if the length of x_pred is nonzero, make the covariance matrix where x is rows, x_pred is columns
    if(NumericMatrix::is_na(x_pred(0,0)) != 1){
      int nrow = x.nrow();
      int ncol = x_pred.nrow();
      
      NumericMatrix mat(nrow, ncol);
      
      for(int i = 0; i < nrow; i++){
        
        for(int j = 0; j < ncol; j++){
          mat(i , j) = cov_fun_expC(x(i, _),x_pred(j,_), cov_par);
        }
        
      }
      return mat; 
    }
  }
  
  else{
    NumericMatrix mat(0,0);
    Rcerr << "Error: invalid covariance function";
    return mat;
    }
  NumericMatrix mat(0,0);
  Rcerr << "Error: invalid covariance function";
  return mat;
}


/*** R
# x1 <- matrix(nrow = 2000, ncol = 2, rnorm(n = 12000))
# x2 <- matrix(nrow = 100, ncol = 2, rnorm(n = 200))
# print(x1)
# print(x2)
# cov_par <- list("sigma" = 1, "l" = 1, "tau" = 0)

# make_cov_matC(x = x1, x_pred = x2, cov_par = cov_par, cov_fun = "sqexp")

# system.time(test_cov_matC <- make_cov_matC(x = x1, x_pred = matrix(), cov_par = cov_par, cov_fun = "sqexp"))
# 
# make_cov_matC(x = x1[1:10,], x_pred = matrix(), cov_par = cov_par, cov_fun = "exp")
*/
