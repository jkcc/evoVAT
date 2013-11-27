function [pho, pval] = testCorr(vFullOrdering, vTestOrdering)
%
% Test the correlation between the ordering when the full data is available to
% VAT (vFullOrdering) against the ordering for different streaming options
% (vTestOrdering).  The lengths of the two might not be the same.
%

    assert(length(vTestOrdering) <= length(vFullOrdering));
    
    vFullOverlapOrdering = zeros(1, length(vTestOrdering));
    for i = 1 : length(vTestOrdering)
        idx = find(vFullOrdering == vTestOrdering(i));
        vFullOverlapOrdering(v) = idx;
    end
    
    % sort the indices of vFullOrdering that overlaps with testOrdering
    vFullOverlapOrdering = sort(vFullOverlapOrdering, 'ascend');
    
    % compute correlation
    [pho, pval] = corr(vFullOverlapOrdering, vFullOrdering, 'test', 'spearman', 'tail', 'right');

end % end of function