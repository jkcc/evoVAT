/**
 * C/C++ implementation of the VAT algorithm.
 *
 * @author: Jeffrey Chan, 2014
 *
 */

#include <cmath>
#include <cassert>
#include <algorithm>
#include <iostream>
#include <vector>
#include <list>
#include "mex.h"

/*
 * Declarations.
 */

void usageMessage();

void primsAlgor(const double* pMDis, int rowNum, int colNum, double* pVPermVerts,
        mxArray* mMst);


typedef std::pair<int,int> C_IntPair;
bool pairComparator ( const C_IntPair& l, const C_IntPair& r)
   { return l.first < r.first; }


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
    plhs[1] = mxCreateSparse(rowNum, rowNum, rowNum-1, mxREAL);

    primsAlgor(pMDis, rowNum, colNum, pVPermVerts, plhs[1]);

} // end of mexFunction()



/* ************************************************************************* */


void primsAlgor(const double* pMDis, int rowNum, int colNum, double* pVPermVerts,
        mxArray* mMst)
{
    using std::cout;
    using std::endl;
    
    double* pMMst = mxGetPr(mMst);
    mwIndex* pMMstIr = mxGetIr(mMst);
    mwIndex* pMMstJc = mxGetJc(mMst);    
    
    // find root vert and populate lIndices
    double maxDis = -1;
    int maxRow = -1;
    int maxCol = -1;
    for (int i = 0; i < rowNum * colNum; ++i) {
//         cout << i << ": ";
        if (pMDis[i] > maxDis) {
            maxDis = pMDis[i];
            // rowNum is the lenght of a column
            maxRow = i % rowNum; 
            maxCol = std::floor(i / rowNum);
//             cout << "maxRow = " << maxRow << ", maxCol = " << maxCol;
        }
//         cout << endl;
    }
    
    // choose maxRow as the starting vertex and remove it from lIndices
    int rootVert = maxRow;
    
    // intialise data structures
    typedef std::vector<double> C_Dis;
    typedef std::vector<int> C_VertIndices;
    typedef std::vector<C_IntPair> C_PairIndices;
    typedef std::list<int> C_Indices;
    // vector of smallest distance to vertices not in mst
    C_Dis vDisRemaining = C_Dis(rowNum);
    // vector of the src vertics
    C_VertIndices vSrcIndices = C_VertIndices(rowNum);
    // list of indices to add to MST
    C_Indices lIndices = C_Indices();    
    // edges in MST
    C_VertIndices vMstSrcIndices = C_VertIndices(rowNum-1);
    C_PairIndices vMstDestIndices = C_PairIndices(rowNum-1);
    
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
    int edgeIndex = 0;
    vMstSrcIndices[edgeIndex] = srcIndex;
    vMstDestIndices[edgeIndex] = std::make_pair(justAddedVert, edgeIndex);    
    ++edgeIndex;
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
        vMstSrcIndices[edgeIndex] = srcIndex;
        vMstDestIndices[edgeIndex] = std::make_pair(justAddedVert, edgeIndex);;        
        ++edgeIndex;
        lIndices.erase(itMin);        
        
    } // end of while 


    // update of MST
    // sort the columns (destIndices)
    std::sort(vMstDestIndices.begin(), vMstDestIndices.end(), pairComparator);
    int lastColSum = 0;
    // this is always 0
    pMMstJc[0] = lastColSum; 
    
    int currIndex = 0;
    int nextColIndexToFill = 1;
    
    
//     std::cout << vMstDestIndices.size() << std::endl;
    typename C_PairIndices::iterator itPairs  = vMstDestIndices.begin();
    if ( itPairs != vMstDestIndices.end()) {
//         std::cout << "(" << vMstSrcIndices[itPairs->second] << ", " << itPairs->first << "), index = " << itPairs->second <<  std::endl;
        
        while (nextColIndexToFill <= itPairs->first) {
            pMMstJc[nextColIndexToFill] = lastColSum;
            ++nextColIndexToFill;
        }
        
        ++lastColSum;
        pMMstIr[currIndex] = vMstSrcIndices[itPairs->second];
        pMMst[currIndex] = 1;
        ++currIndex;
        
        ++itPairs;
        
        // do rest of pairs
        for ( ; itPairs != vMstDestIndices.end(); ++itPairs) {
//             std::cout << "(" << vMstSrcIndices[itPairs->second] << ", " << itPairs->first << "), index = " << itPairs->second <<  std::endl;
            while (nextColIndexToFill <= itPairs->first) {
                pMMstJc[nextColIndexToFill] = lastColSum;
                ++nextColIndexToFill;
            }
            
            ++lastColSum;
            pMMstIr[currIndex] = vMstSrcIndices[itPairs->second];
            pMMst[currIndex] = 1;
            ++currIndex;
        }
    }
    
    while (nextColIndexToFill <= rowNum+1) {
        pMMstJc[nextColIndexToFill] = lastColSum;
        ++nextColIndexToFill;
    }
    
//     cout << "pMMstJc" << endl;
//     for (int j = 0; j < rowNum+1 ; ++j) {
//         cout << pMMstJc[j] << ", ";
//     }
//     cout << endl;
//     
//     cout << "pMMstIr" << endl;
//     for (int j = 0; j < rowNum-1 ; ++j) {
//         cout << pMMstJc[j] << ", ";
//     }
//     cout << endl;
//     
//     cout << "pMMst" << endl;
//     for (int j = 0; j < rowNum-1 ; ++j) {
//         cout << pMMst[j] << ", ";
//     }    
//     cout << endl;
//     
} // end of primsAlgor()



void usageMessage() 
{
    mexErrMsgIdAndTxt("cvat","Usage: [mRearrangedDis, vPermVerts, vMstChain, vMinWeights, mMst, vVertPos] = cvat(mDis).");   
} // end of errorMessage()
