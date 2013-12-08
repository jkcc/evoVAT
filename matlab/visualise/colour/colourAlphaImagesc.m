function colourAlphaImagesc(mDis, mTime, mColourMap, minAlphaVal, maxAlphaVal, vBackgrdColour)
%
% Produces a scaled colourmap image that combines both a distance component
% (scaled into colourmap) and also a time component (used to decrease
% alpha/intensity values).  
%
% INPUT:
%
% OUTPUT:
%
% @author: Jeffrey Chan, 2013
%

    disClim = [min(min(mDis)), max(max(mDis))];
    timeCLim = [min(min(mTime)), max(max(mTime))];
    
    colourNum = size(mColourMap,1);
    
%     % linear mapping into colourmap
%     mNormDis = (mDis - disClim(1)) / (disClim(2) - disClim(1));
    mIndicedDis = min(round((colourNum-1) * (mDis - disClim(1)) / (disClim(2) - disClim(1)) + 1),colourNum);

    mRgb = ind2rgb(mIndicedDis, mColourMap);
    
%     figure;
%     hold on;
%     subplot(1,2,1);
%     image(mRgb);
%     colormap(mColourMap);
    
    % linear mapping into alpha
    mNormTime = (mTime - timeCLim(1)) / (timeCLim(2) - timeCLim(1));
    mAlpha = min((mNormTime * (maxAlphaVal - minAlphaVal)) + minAlphaVal, maxAlphaVal);
    
    % background colour of white
%     vBackgrdColour = [0.95,0.95,0.95];
    mNewRgb = rgba2rgb(mRgb, 1 - mAlpha, vBackgrdColour);
    
%     subplot(1,2,2);
    image(mNewRgb);
%     hold off;
%     
%     set(h, 'AlphaData', mAlphaMap);
    
end % end of function


