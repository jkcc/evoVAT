function [mRgb] = rgba2rgb(mSrcRgb, mAlpha, vBackgrdRgb)
%
% Converts a rgba colour to rgb.
%
% @author: Jeffrey Chan, 2013
%

    assert(size(mSrcRgb,1) == size(mAlpha,1));
    assert(size(mSrcRgb,2) == size(mAlpha,2));
    
    mRgb = zeros(size(mSrcRgb,1), size(mSrcRgb,2), 3);
    
    
    for c = 1 : size(mSrcRgb,2)
        for r = 1 : size(mSrcRgb,1)
            % alpha of source rbga
            alpha = mAlpha(r,c);
    
            % red, green, blue
            mRgb(r,c,:) = min(((1 - alpha) * squeeze(mSrcRgb(r,c,:)) + alpha * vBackgrdRgb'), 1);
        end 
    end

end % end of function