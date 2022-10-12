/*=========================================================
 * matrixDivide.c - Example for illustrating how to use 
 * LAPACK within a C MEX-file.
 *
 * X = matrixDivide(A,B) computes the solution to a 
 * system of linear equations A * X = B
 * using LAPACK routine DGESV, where 
 * A is a real N-by-N matrix.
 * X and B are real N-by-1 matrices.
 *
 * This is a MEX-file for MATLAB.
 * Copyright 2009-2017 The MathWorks, Inc.
 *=======================================================*/

#include "mex.h"
#include "lapack.h"
#include <math.h>
#include <matrix.h>
#include <stdio.h>
#include <stdlib.h>


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int N;
    double  *D , *C , *Y ;    /* pointers to input matrices */
    double *x                ;  /* out arguments to DGESV*/
   
    size_t n_row,n_column,D_row,D_column,C_row,C_column,Y_row,Y_column;     /* matrix dimensions */
    
    N = mxGetScalar(prhs[0]); /* pointer to first input matrix */
    D = mxGetPr(prhs[1]); /* pointer to second input matrix */
    C = mxGetPr(prhs[2]); /* pointer to third input matrix */
    Y = mxGetPr(prhs[3]); /* pointer to fourth input matrix */
    
   
    
    Y_row    = mxGetM(prhs[3]);  
    Y_column = mxGetN(prhs[3]);
    
    
   


       plhs[0] = mxCreateDoubleMatrix(Y_row,Y_column, mxREAL);
       x=mxGetPr(plhs[0]);
    
      int n;
      double w ,v[N];
      
      w       = D[0]   ;
      x[0]    = Y[0]/w ;

  for(n = 1 ; n<=N-1 ; n++)
     {
      v[n-1]  = C[n-1]/w;
      w       = D[n] - C[n-1]*v[n-1];
      x[n]    = ( Y[n] - C[n-1]*x[n-1] )/w;
     }

  for(n = N-2 ; n>=0 ; n--) 
     {
      x[n]   = x[n] - v[n]*x[n+1];
     }
    
}