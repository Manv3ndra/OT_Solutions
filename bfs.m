format short
clear all
clc

%phase 1 input parameters
C=[2 3 4 7]; 
A=[2 3 -1 4; 1 -2 6 -7]; 
b=[8; -3]; 


%phase 2 no of constraints and variables
m = size(A,1); 
n = size(A,2);

%phase 3 define no of basic soln 
nv = nchoosek(n,m);
t = nchoosek(1:n, m); 

%phase 4 construct the basic solution
sol = []; 
if n>=m
    for i=1:nv
        y = zeros(n,1); 
        x = A(:,t(i,:))\b; 
        %check the feasibility solution
        if all(x>=0 & x~=inf & x~=-inf) 
            y(t(i,:))=x;
            sol = [sol y];
        end
    end
else
    error('Equations are greater than variables')
end

%objective function
Z = C*sol; 

%finding the optimal solution
[Zmax, Zind] = max(Z); 
BFS = sol(:,Zind);

%printing the solution
optval = [BFS' Zmax]; 
OPTIMAL_BFS = array2table(optval); 
OPTIMAL_BFS.Properties.VariableNames(1:size(OPTIMAL_BFS,2))={'x1','x2','x3','x4','Z'}

