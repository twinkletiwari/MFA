function [Fbest,Lbest]=mfa(fname,N,dim,low,up,max_it,meanColor,numColors,A,Gt,pixelIdxList)
%% Problem Definition

X = meanColor; 
k1 = numColors; 


VarSize=[k1 size(X,2)];  % Decision Variables Matrix Size

nVar=prod(VarSize);     % Number of Decision Variables

VarMin= repmat([min(X)],k1,1);      % Lower Bound of Variables
VarMax= repmat([max(X)],k1,1);      % Upper Bound of Variables


%% MFA Settings

MaxIt=max_it;              % Maximum Number of Iterations

nPop=N;               % Population Size (Colony Size)

gamma = 1;            % Light Absorption Coefficient

beta0 = 2;            % Attraction Coefficient Base Value

alpha = 0.2;          % Mutation Coefficient

alpha_damp = 0.98;    % Mutation Coefficient Damping Ratio

delta = 0.05*(VarMax-VarMin);     % Uniform Mutation Range

m = 2;

if isscalar(VarMin) && isscalar(VarMax)
    dmax = (VarMax-VarMin)*sqrt(nVar);
else
    dmax = norm(VarMax-VarMin);
end

%% Initialization

% Empty Firefly Structure
firefly.Position = [];
firefly.Cost = [];

% Initialize Population Array
pop = repmat(firefly, nPop, 1);

% Initialize Best Solution Ever Found
BestSol.Cost = inf;

% Create Initial Fireflies
for i = 1:nPop
    
    % Population Initialization
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    x1=reshape(pop(i).Position',1,[]);
    % Fitness Function
    fitness=-feval(fname,x1,meanColor,numColors,A,Gt,pixelIdxList);
    pop(i).Cost = fitness;
    
    
    if pop(i).Cost <= BestSol.Cost
        BestSol = pop(i);
    end
end

% Array to Hold Best Cost Values
BestCost = zeros(MaxIt, 1);

%% Modified Firefly Algorithm Main Loop

for it = 1:MaxIt
    
    newpop = repmat(firefly, nPop, 1);
    for i = 1:nPop
        newpop(i).Cost = inf;
        for j = 1:nPop
            if pop(j).Cost < pop(i).Cost
                rij = norm(pop(i).Position-pop(j).Position)/dmax;
                beta = beta0*exp(-gamma*rij^m);
                e = delta.*unifrnd(-1, +1, VarSize);
                %e = delta*randn(VarSize);

                % Converting to vector
                x1=reshape(pop(i).Position',1,[]);
                x2=reshape(pop(j).Position',1,[]);
                x21=reshape(BestSol.Position',1,[]);
                e1=reshape(e',1,[]);
                
                % Modified Position Updation Equation
                for d = 1:nVar
                        x3(1,d) = x1(d)+ beta*rand*(x2(d)-x1(d))+ 2*rand*(x21(d)-x1(d));                    
                end

                % Reshaping
                newsol.Position=reshape(x3,[],k1)';
                
                newsol.Position = max(newsol.Position, VarMin);
                newsol.Position = min(newsol.Position, VarMax);
                x4=reshape(newsol.Position',1,[]);
                
                % Fitness Function
                fitness=-feval(fname,x4,meanColor,numColors,A,Gt,pixelIdxList);
                newsol.Cost = fitness;
                
                if newsol.Cost <= newpop(i).Cost
                    newpop(i) = newsol;
                    if newpop(i).Cost <= BestSol.Cost
                        BestSol = newpop(i);
                    end
                end
                
            end
        end
    end
    
    % Merge
    pop = [pop
        newpop];  %#ok
    
    % Sort
    [~, SortOrder] = sort([pop.Cost]);
    pop = pop(SortOrder);
    
    % Truncate
    pop = pop(1:nPop);
    
    % Store Best Cost Ever Found
    BestCost(it) = BestSol.Cost;
    
    
    % Damp Mutation Coefficient
    alpha = alpha*alpha_damp;
    
end

Fbest = BestSol.Cost;
Lbest = BestSol.Position';
end


