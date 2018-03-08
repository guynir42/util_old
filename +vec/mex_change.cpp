#include "mex.h"
#define INDEX_VECTOR 0
#define INDEX_INDEX 1
#define INDEX_VALUE 2

void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[] ){

	if(nrhs<1){ // usage is detailed when function is called without arguments!
		mexPrintf("Usage: mex_change(mex_vector, index, value)\n");
		mexPrintf("Change a value inside the vector 'mex_vector' without invoking copy-on-write...\n");
		mexPrintf("INPUTS: -mex_vector is a vector or a uint64/double numeric value that can be de-referenced to a valid pointer.\n");
		mexPrintf("        -index is the (1-based) index in the vector (if you give an illegal value matlab will crash...).\n");
		mexPrintf("        -value is the new value to put in the vector (must be a scalar double).\n");
		return;
	}
	
	double *mex_vector=0;
	if(mxIsNumeric(prhs[INDEX_VECTOR])==0) 
		mexErrMsgIdAndTxt( "MATLAB:util:vec:mex_change:inputNotNumeric", "Input %d must be numeric!", INDEX_VECTOR+1);

	if(mxIsScalar(prhs[INDEX_VECTOR])) mex_vector= (double*)(long long int) mxGetScalar(prhs[INDEX_VECTOR]); // this needs to be carefully tested...
	else mex_vector=mxGetPr(prhs[INDEX_VECTOR]);
	
	if(mxIsNumeric(prhs[INDEX_INDEX])==0 || mxIsScalar(prhs[INDEX_INDEX])==0) 
		mexErrMsgIdAndTxt( "MATLAB:util:vec:mex_change:inputNotNumeric", "Input %d must be a numeric scalar!", INDEX_INDEX+1);
	
	int index=(int) mxGetScalar(prhs[INDEX_INDEX]);
	index--; // convert to C++ indices
	
	if(mxIsEmpty(prhs[INDEX_VALUE]) || mxIsNumeric(prhs[INDEX_VALUE])==0 || mxIsScalar(prhs[INDEX_VALUE])==0)
		mexErrMsgIdAndTxt( "MATLAB:util:vec:mex_change:inputNotNumeric", "Input %d must be a numeric scalar!", INDEX_VALUE+1);
	
	double value=mxGetScalar(prhs[INDEX_VALUE]);
	
	mex_vector[index]=value;
	
}