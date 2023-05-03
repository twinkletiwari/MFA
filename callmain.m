function callmain(pathName,maxClusters)

filename2 = [pathName '/' 'MFA.mat'];

methodMFA1=[];

% Path of the Image Dataset
filePath = 'images_auto/';
filePath1 = 'images_groundTruth/';

directoryFiles = dir(filePath);
for fileIndex=1:length(directoryFiles)
    currentFilename = directoryFiles(fileIndex).name;
    disp(currentFilename);
    if (length(currentFilename)>4) && strcmp(currentFilename(end-3:end),'.jpg')
        imageFullPath = [filePath currentFilename];
        % Reading the image
        image = imread(imageFullPath);
        % Resizing the image
        image = imresize(image, [64 64]);
         
        maskFullPath = [filePath1 currentFilename(1:end-4) '.jpg'];
        % Reading the image ground truth
        mask = imread(maskFullPath);
        % Resizing the image ground truth
        mask = imresize(mask, [64 64]);
        
% Calling the clustering function
[methodMFAresult]=callClustering(image,mask,currentFilename,maxClusters,pathName) ;

% Storing the results
methodMFA1=[methodMFA1;methodMFAresult];

 end
end
save(filename2,'methodMFA1');
end