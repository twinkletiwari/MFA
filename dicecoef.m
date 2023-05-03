function [diceVal,matchCount,grdCount]=dicecoef(segIm,grndTruth)
% Function to calculate the dice coefficient value.
% Condition the images must be of same size size and are logical. Otherwise
% it will convert them to logical datatype. You can change the code for
% make it work on numeric data type images also.

% To check whether the generated image is logical of not
if islogical(segIm)
else
    segIm = imbinarize(segIm);
end

% To check whether the Ground Truth image is logical of not
if islogical(grndTruth)
else
    grndTruth = imbinarize(grndTruth);
end

diceVal = 2*nnz(segIm&grndTruth)/(nnz(segIm) + nnz(grndTruth));
matchCount=nnz(segIm&grndTruth);
grdCount=nnz(grndTruth);