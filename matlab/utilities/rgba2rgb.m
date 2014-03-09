function [mRgb] = rgba2rgb(mSrcRgb, mAlpha, vBackgrdRgb)
%
% Converts a rgba colour to rgb.
%
% @author: Jeffrey Chan, 2013
%

    assert(size(mSrcRgb,1) == size(mAlpha,1));
    assert(size(mSrcRgb,2) == size(mAlpha,2));
    
    mRgb = zeros(size(mSrcRgb,1), size(mSrcRgb,2), 3);
    
    
    mRgb(:,:,1) = min((1 - mAlpha) .* mSrcRgb(:,:,1) + mAlpha .* repmat(vBackgrdRgb(1),size(mSrcRgb,1), size(mSrcRgb,2)), 1);
    mRgb(:,:,2) = min((1 - mAlpha) .* mSrcRgb(:,:,2) + mAlpha .* repmat(vBackgrdRgb(2), size(mSrcRgb,1), size(mSrcRgb,2)), 1);
    mRgb(:,:,3) = min((1 - mAlpha) .* mSrcRgb(:,:,3) + mAlpha .* repmat(vBackgrdRgb(3), size(mSrcRgb,1), size(mSrcRgb,2)), 1);

    
%     for c = 1 : size(mSrcRgb,2)
%         for r = 1 : size(mSrcRgb,1)
%             % alpha of source rbga
%             alpha = mAlpha(r,c);
%     
%             % red, green, blue
%             mRgb(r,c,:) = min(((1 - alpha) * squeeze(mSrcRgb(r,c,:)) + alpha * vBackgrdRgb'), 1);
%         end 
%     end

end % end of function