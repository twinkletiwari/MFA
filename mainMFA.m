function [idx] = mainMFA(meanColor,numColors,A,Gt,pixelIdxList)

flag=0; % 1: minimization, 0: maximization

d = numColors*size(meanColor,2);
Lb=min(meanColor,[],1);
Ub=max(meanColor,[],1);

Xmax = repmat(Ub,1,numColors);
Xmin = repmat(Lb,1,numColors);

Population_size=30;
max_it=500;

objectiveFunction='ClusteringCost';
[Fbest,Lbest]=mfa(objectiveFunction,Population_size,d,Xmin,Xmax,max_it,meanColor,numColors,A,Gt,pixelIdxList);
gBest=Lbest;

mn1=reshape(gBest,size(meanColor,2),[]);
cmap=mn1';

    % Calculate Distance Matrix
    d = pdist2(meanColor,cmap);
    
    % Assign Clusters and Find Closest Distances
    [dmin, idx] = min(d, [], 2);
    
end
