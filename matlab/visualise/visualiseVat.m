function visualiseVat(mDis, vRearrangedVert, sHeading, varargin)
%
% Visualise the VAT image.
%
% @author: Jeffrey Chan, 2013
%

    inParser = inputParser;
    % default values
    defaultCMap = hsv;
    
    addOptional(inParser, 'cmap', defaultCMap);
    addOptional(inParser, 'visualiseLabels', false);
    addOptional(inParser, 'genFigure', true);
    addOptional(inParser, 'ageData', []);
    
    parse(inParser, varargin{:});
    
%     % check optional arguments
%     switch length(varargin)
%         case 1
%             cmap = varargin{1};
%         case 2
%             cmap = varargin{1};
%             bVisualiseLabels = varargin{2};
%         case 3
%             cmap = varargin{1};
%             bVisualiseLabels = varargin{2};            
%             bSubplot = varargin{3};
%         otherwise
%     end % end of switch
        

    cmap = inParser.Results.cmap;
    bGenFigure = inParser.Results.genFigure;
    bVisualiseLabels = inParser.Results.visualiseLabels;
    mAge = inParser.Results.ageData;

    if bGenFigure
        figure;
        hold on;
    end
    
    % have age data so use it for alpha values
    if ~isempty(mAge)
        minAlpha = 0.1;
        maxAlpha = 1.0;
        % white background colour
        vBackColour = [1,1,1];
        colourAlphaImagesc(mDis(vRearrangedVert, vRearrangedVert), mAge(vRearrangedVert, vRearrangedVert), cmap, minAlpha, maxAlpha, vBackColour);
    else   
        imagesc(mDis(vRearrangedVert, vRearrangedVert));
        colormap(cmap);

    end
    
    xlim([0,length(vRearrangedVert)]);
    ylim([0,length(vRearrangedVert)]);
    title(sHeading);
    
    % see if we want to visualise the labels 
    if bVisualiseLabels
        set(gca,'XTickLabel', vRearrangedVert);
        set(gca,'YTickLabel', vRearrangedVert);
        set(gca,'XTick', 1:length(vRearrangedVert));
        set(gca,'YTick', 1:length(vRearrangedVert));
    end
    
    if bGenFigure
        hold off;
    end
       
end % end of function