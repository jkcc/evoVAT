function [mNewDis, mNewMst, mNewExist] = incVatRebuit(mDis, mExist, mNewPtsDis,visualise)
    mNewDis = mDis;
    oldSize = size(mDis,1);
    
    for i = 1:size(mNewPtsDis,2)
        vNewPtsDis = mNewPtsDis(1:(oldSize+i-1),i);
        
        [mNewDis, ~, ~, ~, mNewMst] = VatNoIncre(mNewDis, vNewPtsDis, visualise);
    end
    
    mNewExist = ones(size(mNewPtsDis,1),size(mNewPtsDis,1));

    %[mRearrangedDis, vPermVerts, vMstChain, vMinWeights, mMst] = Vat(mDis, bVisualise)
end