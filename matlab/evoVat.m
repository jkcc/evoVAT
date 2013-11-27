function evoVat(mEvolvingData, sStreamingModel, varargin)
%
% VAT for evolving data.  The data can either be a set of points that move with
% time, or a set of new points that continually stream in.
%
% INPUT:
% mEvolvingData             - Each row is a data instance, (feature1, feature2,
%                               ..., time)
% sSteamingModel            - The data input model to use.
%
% OUTPUT:
% None
%
% @author Jeffrey Chan, 2013
%


    switch sStreamingModel
        case 'stream'
            streamDataVatSubplot(varargin{:});
        case 'tracking'
            trackDataVat(mEvolvingData);
        otherwise
            warning('evoVat: %s is an unknown sSteamingModel.\n', sStreamingModel);
            return;
    end % end of switch


end % end of function