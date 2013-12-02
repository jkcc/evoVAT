function [mRgb] = rgba2rgb(mSrcRgba, vBackgrdRgb)
%
% Converts a rgba colour to rgb.
%
% @author: Jeffrey Chan, 2013
%

    mRgb = zeros(size(mSrcRgba,1), size(mSrcRgba,2)-1);
    
    for r = 1 : size(mSrcRgba,1)
        vCurrSrc = mSrcRgba(r,:);
        % alpha of source rbga
        alpha = vCurrSrc(1);
        % normalise both source and background by 255
        vNormSrcRgba = vCurrSrc / 255;
        vNormBgrdRgb = vBackgrdRgb / 255;
    
        % red
        mRgb(r,1) = min(((1 - alpha) * vNormSrcRgba(2) + alpha * vNormBgrdRgb(1)), 1);
        % green
        mRgb(r,2) = min(((1 - alpha) * vNormSrcRgba(3) + alpha * vNormBgrdRgb(2)), 1);
        % blue
        mRgb(r,3) = min(((1 - alpha) * vNormSrcRgba(4) + alpha * vNormBgrdRgb(3)), 1);
    end

end % end of function