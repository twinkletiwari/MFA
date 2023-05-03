function [methodMFAresult] = callClustering(image,mask,currentFilename,maxClusters,pathName)
% dice: Dice coeff. value
% mchCo: No. of pixels that are same in generated image and Gorund truth image
% gtcou: No. of pixels in Gorund truth image
% L1: Matrix of connected components in generated image
% num1: No. of connected components in generated image
% L2: Matrix of connected components in Ground truth image
% num2: No. of connected components in Ground truth image
% L3: Matrix of connected components in the intersection of generated and Ground truth image
% num3: No. of connected components in the intersection of generated and Ground truth image

methodMFAresult=[];

    A = image; % Considered Image
    
    Gt=mask; % Considered Ground Truth

    % Converting to Lab
    Alab = rgb2lab(A);
    
    % Applying superpixel
    [L,N] = superpixels(Alab,2000,'isInputLab',true);
    
    
    pixelIdxList = label2idx(L);
    meanColor = zeros(N,3);
    [m,n] = size(L);
    for  i = 1:N
        meanColor(i,1) = mean(Alab(pixelIdxList{i}));
        meanColor(i,2) = mean(Alab(pixelIdxList{i}+m*n));
        meanColor(i,3) = mean(Alab(pixelIdxList{i}+2*m*n));
    end
    

    
      for numColors = 2:maxClusters % number of clusters
        % Applying MFA
        [MFAresult]=callMFA(meanColor,numColors,A,Gt,pixelIdxList,N,currentFilename,pathName);
        [methodMFAresult]=[methodMFAresult;{currentFilename(1:end-4)}, MFAresult, numColors];
      end
end




