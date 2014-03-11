function [vPermVerts, mMst] = Vat2(mDis)
%
% Wrapper for c implementation of VAT.
%
% @author: Jeffrey Chan, 2014
%
    [vPermVerts, mMst] = cvat(mDis);
    mMst = mMst + mMst';

end % end of function