function [methodataMFA]=callMFA(meanColor,numColors,A,Gt,pixelIdxList,N,currentFilename,pathName)
   
    % Calling the MFA to return the indexes of the generated clusters
    [idx]=mainMFA(meanColor,numColors,A,Gt,pixelIdxList) ;
    
    Lout = zeros(size(A,1),size(A,2));
    for i = 1:N
        Lout(pixelIdxList{i}) = idx(i);
    end
        
  
    segmented_images = cell(1,numColors);
    rgb_label = repmat(Lout,[1 1 3]);
    FinalDc=0;
    FinalImg = uint8(zeros(size(A,1),size(A,2),size(A,3)));
    for k = 1:numColors
        
        color = A;
        color(rgb_label == k) = 255;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
        
     RevImg=segmented_images{k};
    RevImg=rgb2gray(RevImg);
    
    % Convert the image into logical format
    RevImg1 = imbinarize(RevImg);
    
    
    % To calculate Dice coefff.
    [dice,mchCo,gtcou] = dicecoef(RevImg1,Gt);
         
    % % To find connected components for generated image
    [L1,num1] = bwlabel(RevImg1);
   
    % % To find connected components for ground truth image
    [L2,num2] = bwlabel(Gt);
    
    % % To find connected components in intersection of generated and ground truth image 
    %To compute the intersection of img and ground truth
    imgInt= Gt & RevImg1;
    [L3,num3] = bwlabel(imgInt);
    if FinalDc <= dice
        FinalDc = dice;
        FinalImg = RevImg;
    end
    end
    
% Wrtie the results to excel
filenam = [pathName '/MFA' '/' currentFilename(1:end-4) '.png'];
imwrite(FinalImg,filenam);
methodataMFA=[FinalDc];    


end