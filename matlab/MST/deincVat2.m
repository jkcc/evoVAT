function [mNewDis,vRearrangedVert,mNewMst,mNewExist,vNewRoot] = deincVat2(mDis,mMst,mExist,vPointsToDel)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    mNewMst = mMst;
    mNewExist = mExist;
    mNewDis = mDis;
    
    mNewExist(vPointsToDel,:)=[];
    mNewExist(:,vPointsToDel)=[];
    mNewDis(vPointsToDel,:)=[];
    mNewDis(:,vPointsToDel)=[];
    
    [~, vRearrangedVert, ~, ~, mNewMst] = Vat(mNewDis);
    vNewRoot=vRearrangedVert(1);

end