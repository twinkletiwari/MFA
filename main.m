% Main File. Code starts from here

clear all;
clc;
close all;


runs=50;         % Number of times the code should execute
maxClusters=2;  % Number of clusters to be formed

for j=1:runs
            filename=strcat(num2str(j),'run');
        mkdir(filename); 
        cd(filename);
        mkdir('MFA');                            
        
        cd ..
          
       callmain(filename,maxClusters);
end
