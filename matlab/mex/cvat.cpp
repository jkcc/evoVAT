/**
 * C/C++ implementation of the VAT algorithm.
 *
 * @author: Jeffrey Chan, 2014
 *
 */

#include "mex.h"


void usageMessage();


/**
 * Mex function entry point.
 *
 * [mRearrangedDis, vPermVerts, vMstChain, vMinWeights, mMst, vVertPos] = cvat(mDis)
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
    /* Check for proper number of arguments. */
    if ( nrhs != 1 ) {
        usageMessage();
    } 
    
    
    // check arguments
    // first argument should be mDis (2D double matrix)
    if (mxGetNumberOfDimensions(prhs[0]) != 2 || !mxIsDouble(prhs[0])) {
        mexErrMsgIdAndTxt("cvat", "Incorrect input argument.");
    }
    
    
    /* Check output */
    if (nlhs != 6) {
        usageMessage();
    }
    
    
    
    
    double* pMDis = mxGetPr(prhs[0]);
    int rowNum = mxGetM(prhs[0]);
    int colNum = mxGetN(prhs[0]);
    
    
    
    
    
} // end of mexFunction()



/* ************************************************************************* */


void usageMessage() 
{
    mexErrMsgIdAndTxt("cvat","Usage: [mRearrangedDis, vPermVerts, vMstChain, vMinWeights, mMst, vVertPos] = cvat(mDis).");   
} // end of errorMessage()