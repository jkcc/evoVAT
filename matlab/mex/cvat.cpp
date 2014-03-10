/**
 * C/C++ implementation of the VAT algorithm.
 *
 * @author: Jeffrey Chan, 2014
 *
 */

#include <cmath>
#include <cassert>
#include <vector>
#include <list>
#include "mex.h"

/*
 * Declarations.
 */

void usageMessage();

void primsAlgor(const double* pMDis, int rowNum, int colNum, double* pVPermVerts, double* pMMst);


// IMPLEMENATION
/* ******************************************************************* */

/**
 * Mex function entry point.
 *
 * [mRearrangedDis, vPermVerts, vMstChain, vMinWeights, mMst, vVertPos] = cvat(mDis)
 */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
    /* Check for proper number of arguments. */
    // input
    if ( nrhs != 1 ) {
        usageMessage();
    } 
    
    // output
    if (nlhs != 2) {
        usageMessage();
    }    
    
    /* check type of arguments */
    // INPUT
    // first argument should be mDis (2D double matrix)
    if (mxGetNumberOfDimensions(prhs[0]) != 2 || !mxIsDouble(prhs[0])) {
        mexErrMsgIdAndTxt("cvat", "Incorrect input argument.");
    }
    
    
    /* get pointers */
    // INPUT
    const double* pMDis = mxGetPr(prhs[0]);
    int rowNum = mxGetM(prhs[0]);
    int colNum = mxGetN(prhs[0]);
    if (rowNum != colNum) {
        mexErrMsgIdAndTxt("cvat", "Input distance matrix must be square.");
    }
    
    
    // OUTPUT
    plhs[0] = mxCreateDoubleMatrix(1, rowNum, mxREAL);
    double* pVPermVerts = mxGetPr(plhs[0]);
    plhs[1] = mxCreateSparse(rowNum, rowNum, 2*(rowNum-1), mxREAL);
    double* pMMst = mxGetPr(plhs[1]);

    primsAlgor(pMDis, rowNum, colNum, pVPermVerts, pMMst);

} // end of mexFunction()



/* ************************************************************************* */


void primsAlgor(const double* pMDis, int rowNum, int colNum, double* pVPermVerts, double* pMMst)
{
    
    // find root vert and populate lIndices
    double maxDis = -1;
    int maxRow = -1;
    int maxCol = -1;
    for (int i = 0; i < rowNum * colNum; ++i) {
        if (pMDis[i] > maxDis) {
            // rowNum is the lenght of a column
            maxRow = i % rowNum; 
            maxCol = std::floor(i / rowNum);
        }
        
    }
    
    // choose maxRow as the starting vertex and remove it from lIndices
    int rootVert = maxRow;
    
    // intialise data structures
    typedef std::vector<double> C_Dis;
    typedef std::vector<int> C_VertIndices;
    typedef std::list<int> C_Indices;
    // vector of smallest distance to vertices not in mst
    C_Dis vDisRemaining = C_Dis(rowNum);
    // vector of the src vertics
    C_VertIndices vSrcIndices = C_VertIndices(rowNum);
    // list of indices to add to MST
    C_Indices lIndices = C_Indices();    
    
    for (int i = 0; i < rowNum; ++i) {
        lIndices.push_back(i);
    }
    typename C_Indices::iterator it = lIndices.begin();
    std::advance(it,rootVert);  
    lIndices.erase(it);
    
    // vertices just added to MST
    int justAddedVert = rootVert;
    int permVertsCurrIndex = 0;
    pVPermVerts[permVertsCurrIndex] = rootVert + 1;
    ++permVertsCurrIndex;
    
    //
    // perform prim's algorithm
    //
    
    // for intial vert
    int srcIndex = justAddedVert;
        
    assert(lIndices.size() > 0);
    it = lIndices.begin();
    double currMin = vDisRemaining[*it];
    typename C_Indices::iterator itMin = it;
    ++it;
    for ( ; it != lIndices.end(); ++it) {
        vDisRemaining[*it] = pMDis[*it * rowNum + srcIndex];
        if (vDisRemaining[*it] < currMin) {
            itMin = it;
            currMin = vDisRemaining[*it];
            vSrcIndices[*it] = srcIndex;
        }
    }  
    justAddedVert = *itMin;
    pVPermVerts[permVertsCurrIndex] = justAddedVert + 1;
    ++permVertsCurrIndex;
    lIndices.erase(itMin);
    
    // rest of vertices
    while (lIndices.size() > 0) {
        srcIndex = justAddedVert;
        
        // first index
        itMin = it = lIndices.begin();
        double currDis = pMDis[*it * rowNum + srcIndex];
        if (currDis < vDisRemaining[*it]) {
            vDisRemaining[*it] = currDis;
            vSrcIndices[*it] = srcIndex;
        }

    	currMin = currDis; 

        for ( ; it != lIndices.end(); ++it) {
            currDis = pMDis[*it * rowNum + srcIndex];
            if (currDis < vDisRemaining[*it]) {
                vDisRemaining[*it] = currDis;
                vSrcIndices[*it] = srcIndex;
            }
            if (currDis < currMin) {
                itMin = it;
                currMin = currDis;
            }
        }
        
        justAddedVert = *itMin;
        pVPermVerts[permVertsCurrIndex] = justAddedVert + 1;
        ++permVertsCurrIndex;
        lIndices.erase(itMin);        
        
    } // end of while 


} // end of primsAlgor()



void usageMessage() 
{
    mexErrMsgIdAndTxt("cvat","Usage: [mRearrangedDis, vPermVerts, vMstChain, vMinWeights, mMst, vVertPos] = cvat(mDis).");   
} // end of errorMessage()
