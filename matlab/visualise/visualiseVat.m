function visualiseVat(mDis, vRearrangedVert, varargin)
%
% Visualise the VAT image.
%
% @author: Jeffrey Chan, 2013
%
    % default cmap
    cmap = hsv;
    bVisualiseLabels = false;
    
    % check optional arguments
    switch length(varargin)
        case 1
            cmap = varargin{1};
        case 2
            cmap = varargin{1};
            bVisualiseLabels = varargin{2};
        otherwise
    end % end of switch
        
    figure;
    colormap(cmap);
    imagesc(mDis(vRearrangedVert, vRearrangedVert));
    
    if bVisualiseLabels
        set(gca,'XTickLabel', vRearrangedVert);
        set(gca,'YTickLabel', vRearrangedVert);
        set(gca,'XTick', 1:length(vRearrangedVert));
        set(gca,'YTick', 1:length(vRearrangedVert));
    end
    hold off;
       
end % end of function