

function [z] = ClusteringCost(X,meanColor,numColors,A,Gt,pixelIdxList)

mn1=reshape(X,size(meanColor,2),[]);
cmap=mn1';


    % Calculate Distance Matrix
    d = pdist2(meanColor,cmap);
    
    % Assign Clusters and Find Closest Distances
    [dmin, idx] = min(d, [], 2);

    Lout = zeros(size(A,1),size(A,2));
    for i = 1:size(meanColor,1)
        Lout(pixelIdxList{i}) = idx(i);
    end    

    %%% Compute and display the segmented images %%%
    segmented_images = cell(1,numColors);
    rgb_label = repmat(Lout,[1 1 3]);
    
    FinalDc=0;
    for k = 1:numColors
        
        color = A;
        color(rgb_label == k) = 255;
        color(rgb_label ~= k) = 0;
        segmented_images{k} = color;
    
    RevNucleiImg=segmented_images{k};
    RevNucleiImg=rgb2gray(RevNucleiImg);
        
    % Convert the image into logical format
    RevNucleiImg1 = imbinarize(RevNucleiImg);
    
    % To calculate Dice coefff.
    [dice,mchCo,gtcou] = dicecoef(RevNucleiImg1,Gt);
         
    if FinalDc <= dice
        FinalDc = dice;
    end
    end
    z=FinalDc; 
end