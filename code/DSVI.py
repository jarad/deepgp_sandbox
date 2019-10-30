#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 24 22:57:13 2019

@author: faezehyazdi
"""

import numpy as np
import tensorflow as tf
from gpflow.likelihoods import Gaussian as Gaussian_lik
from gpflow.kernels import RBF
from gpflow.models.gpr import GPR
from gpflow.models.svgp import SVGP
from doubly_stochastic_dgp.dgp import DGP
from gpflow.training import AdamOptimizer, ScipyOptimizer
import time
import matplotlib.pyplot as plt
import math
from matplotlib.pyplot import colorbar


# Making predictions with standard GP, Sparse GP and one single layer Deep GP

np.random.seed(0)

    
n, Np= 30, 900    # number of points in each direction for making n by n grid, numer of prediction points (Np = n.n)
N, M = 500, 100   # number of observation points , number of inducing points in each layer

x1 = np.random.uniform(0, 1, N)[:, None]   #  generating X by Randomly sample from uniform distribution(0,1)
x2 = np.random.uniform(0, 1, N)[:, None]
X=np.concatenate((x1,x2), axis=1)          #  X is Matrix N by 2, observed input locations       
d=X.shape[1]                               #  Inputs dimention

plt.scatter(x1, x2)
plt.xlabel('X1')
plt.ylabel('X2')

z1 = np.random.uniform(0, 1, M)[:, None]  # generating inducing point locations by Randomly sample from uniform distribution(0,1)
z2 = np.random.uniform(0, 1, M)[:, None]
Z=np.concatenate((z1,z2), axis=1)         #  Z is Matrix M by 2, inducing point locations (initializing for first layer)


def fun(a):
    l_a=a.shape[0]
    f=np.zeros((l_a,1))
    for i in range(l_a):
        f[i] = np.sin(2*math.pi*a[i,0])+np.cos(2*math.pi*a[i,1]) 
    return f

Y=fun(X)        # generating observed data Y from deterministic function f given X, Y is a N by 1 vector

xp1 = np.linspace(0.0001,0.9997, n)[:, None] # n prediction points in each direction
xp2=xp1

l2 =len(xp1)               # making a n by n grid on [0,1]
cc2=np.zeros((l2,2))
cout2=np.zeros((0,2))
for i in range(l2):
 for j in range(l2):
     cc2[j,0]=xp1[i]
     cc2[j,1]=xp1[j]
 cout2=np.concatenate((cout2,cc2), axis=0)
 
Xp=cout2                 # Xp is Matrix Np by 2, unobserved input locations    
Y_truth=fun(Xp)          # Truth function values at unobserved locations Xp, Y_truth is a Np by 1 vector
Y_var=np.var(Y_truth,ddof=1)  

#################################################################
# prdiction using Standard GP model  

kernel=RBF(d,lengthscales=0.2, variance=1.) # Initialize lengthscales and variance
m_gp = GPR(X, Y, kernel)                     # Making a GP model using GPR in GPflow
m_gp.likelihood.variance = 1e-2             # initialize likelihood variance

iterations=2000
start_time = time.time()
ScipyOptimizer().minimize(m_gp,maxiter=iterations)  # minimizing the negative log-likelihood, "minimize"(local optimization)is method of that optimizer with model as optimization target
t_op=time.time() - start_time
print("--- %s seconds ---" % (t_op))               # optimization time: 1.788 seconds ---

m_gp.as_pandas_table()    # This model has Three trainable parameters
#GPR/likelihood/variance  Parameter  None  ...        True               1e-06
#GPR/kern/variance        Parameter  None  ...        True   20.89545882608174
#GPR/kern/lengthscales    Parameter  None  ...        True  0.5349702709611209

m_gp.read_trainables()
#{'GPR/kern/lengthscales': array(0.53497027),
# 'GPR/kern/variance': array(20.89545883),
# 'GPR/likelihood/variance': array(1.e-06)}


kernel.as_pandas_table() # class	  prior	transform	trainable	shape	fixed_shape	value
#GPR/kern/variance      Parameter  None  ...        True   20.89545882608174
#GPR/kern/lengthscales  Parameter  None  ...        True  0.5349702709611209

m_gp.likelihood.as_pandas_table() # to see all the parameters that are part of the likelihood
#GPR/likelihood/variance  Parameter  None       +ve  ...     ()        True  1e-06
#likelihood/variance is a parameter controlling the variance of the noise, as part of the likelihood


pred_time = time.time() 
m_gp, v_gp = m_gp.predict_y(Xp)   # returns the mean and variance of new data points
t_pred=time.time() - pred_time
print("--- %s seconds ---" % (t_pred))  # Prediction time: 0.256 seconds ---

#np.save('plots/gp',m_gp)

Xp1, Xp2 = np.meshgrid(xp1, xp2)
Yt_mat=np.reshape(Y_truth, (n,n))     # doing this for heat map of Truth values
Yt_mat_tr=np.transpose(np.fliplr(Yt_mat))


Yp_mat=np.reshape(m_gp, (n,n))        # doing this for heat map 
Yp_mat_tr=np.transpose(np.fliplr(Yp_mat))


diff_gp=m_gp-Y_truth                 # difference between truth and predicted values
diff_mat=Yt_mat_tr-Yp_mat_tr         # doing this for heat map 


#################################################################

# Prediction using sparse GP

kernel=RBF(d, lengthscales=0.2, variance=1.)
m_svgp = SVGP(X, Y, kernel , Gaussian_lik(), Z, minibatch_size=None) # Making a Sparse GP model using SVGP in GPflow
m_svgp.likelihood.variance = 1e-2
m_svgp.q_sqrt = m_svgp.q_sqrt.value * 1e-5   # initializing covariance matrix of variational distribution q(u)~N(m,S) in the paper

iterations=2000
# The bound on the marginal likelihood (ELBO) is used as an objective function in optimizing the covariance function parameters as well as the inducing input points Z.
start_time = time.time()
ScipyOptimizer().minimize(m_svgp, maxiter=iterations)
#AdamOptimizer(0.001).minimize(m_svgp, maxiter=iterations) ScipyOptimizer vs AdamOptimizer : Scipy is much better than Adam here
t_op=time.time() - start_time
print("--- %s seconds ---" % (t_op))   # 17.00 seconds

m_svgp.read_trainables()

# 'SVGP/feature/Z': array([[ 7.67472295e-01,  2.81515030e-01],...

# 'SVGP/kern/lengthscales': array(0.39247158),

# 'SVGP/kern/variance': array(2.40283),

# 'SVGP/likelihood/variance': array(1.29052772e-05)

# 'SVGP/q_mu': array([[-7.66615891e-01], ...

# 'SVGP/q_sqrt': array([[[ 4.90077789e-04,  0.00000000e+00,...

pred_time = time.time() 
m_sgp, v_sgp = m_svgp.predict_y(Xp)        # returns the mean and variance of new data points
t_pred=time.time() - pred_time
print("--- %s seconds ---" % (t_pred))     # 0.238 seconds ---

#np.save('plots/svgp',m_sgp)


Yp_mat=np.reshape(m_sgp, (n,n))        # doing this for heat map 
Yp_mat_tr=np.transpose(np.fliplr(Yp_mat))

diff_sgp=m_sgp-Y_truth               # difference between truth and predicted values
diff_mat=Yt_mat_tr-Yp_mat_tr



############################################################################

# Prediction using one single layer DGP (equivalent with last model: SVGP )

kernels=[RBF(d, lengthscales=0.2, variance=1.)]

m_dgp = DGP(X, Y, Z, kernels, Gaussian_lik(), minibatch_size=None)  # Making a one single layer DGP model using DGP in doubly_stochastic_dgp package 
m_dgp.likelihood.likelihood.variance = 1e-2
     
for layer in m_dgp.layers[:-1]:
        layer.q_sqrt = layer.q_sqrt.value * 1e-5  # initializing covariance matrix of variational distribution q(u) (in each layer)

iterations=2000        
start_time = time.time()
ScipyOptimizer().minimize(m_dgp, maxiter=iterations)
#AdamOptimizer(0.001).minimize(m_dgp, maxiter=iterations)  #Scipy is much better than Adam here for one single layer
t_op=time.time() - start_time
print("--- %s seconds ---" % (t_op))   # 21.741 seconds ---

m_dgp.read_trainables()

# 'DGP/layers/0/feature/Z': array([[ 1.07059431,  0.60848968],...

# DGP/layers/0/kern/lengthscales': array(0.43516127),

# DGP/layers/0/kern/variance': array(1.18654215),

#'DGP/layers/0/q_mu : array([[-3.36836837e-01], ...

# DGP/layers/0/q_sqrt': array([[[-5.27008346e-03,  0.00000000e+00, ...

# DGP/likelihood/likelihood/variance': array(5.59128476e-06)

pred_time = time.time() 
m_dgp, v_dgp = m_dgp.predict_y(Xp,1)       #  returns the mean and variance of new data points
t_pred=time.time() - pred_time
print("--- %s seconds ---" % (t_pred))     # 0.246 seconds ---

#np.save('plots/dgp', m_dgp )

m_dgp=m_dgp[:, :, 0].T
Yp_mat=np.reshape(m_dgp, (n,n))                  # doing this for heat map  
Yp_mat_tr=np.transpose(np.fliplr(Yp_mat))     

diff_dgp=m_dgp-Y_truth                          # difference between truth and predicted values
diff_mat=Yt_mat_tr-Yp_mat_tr



#####################################################################
# GP, SGP and DGP plots

a1=max(m_gp)  # m_sgp, m_dgp
b1=min(m_gp)  # m_sgp, m_dgp
a2=max(Y_truth) 
b2=min(Y_truth)

a=max(a1,a2)
b=min(b1,b2)

fig = plt.figure(figsize=(8.2, 2.4),dpi=100)    
sub1 = plt.subplot(1,3,1)
im_t = plt.imshow(Yt_mat_tr, vmax=a, vmin=b)  
plt.axis('off')
plt.title("Truth")
cbar = colorbar(im_t)
cbar.solids.set_edgecolor("face")

sub2 = plt.subplot(1,3,2)
im_p = plt.imshow(Yp_mat_tr,vmax=a, vmin=b)
plt.axis('off')
plt.title("Prediction")
cbar = colorbar(im_p)
cbar.solids.set_edgecolor("face")

sub3 = plt.subplot(1,3,3)
im_d = plt.imshow(diff_mat)
plt.axis('off')
plt.title("Diff")
cbar = colorbar(im_d)
cbar.solids.set_edgecolor("face")

fig.tight_layout()

