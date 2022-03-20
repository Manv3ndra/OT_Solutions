format short
clear all
clc
%input params
variables={'x1','x2','s2','s3','A1','A2','sol'}; 
M=1000; 
cost=[-2 -1 0 0 -M -M 0];
A=[3 1 0 0 1 0 3; 
   4 3 -1 0 0 1 6; 
   1 2 0 1 0 0 3;]; 
s = eye(size(A,1));

%finding starting bfs
BV=[]; 
for j=1:size(s,2)
    for i=1:size(A,2)
        if A(:,i)==s(:,j)
            BV = [BV i];
        end
    end
end

%find Zj-Cj
B = A(:,BV); 
A = inv(B)*A; 
ZjCj = cost(BV)*A-cost; 

%print table
Zcj = [ZjCj;A];
Simptable = array2table(Zcj);
Simptable.Properties.VariableNames(1:size(Zcj,2))=variables

run = true; 
while run   
    ZC = ZjCj(:,1:end-1); 
    if any(ZC<0)
        %find entering variable
        fprintf("Current BFS is not optimal\n"); 
        [entval, pvtcol]=min(ZC); 
        fprintf("Entering column: %d\n",pvtcol);
    
    
        %finding the leaving variable
        sol=A(:,end);
        column = A(:,pvtcol);
        if all(column<=0)
            fprintf('solution is unbounded'); 
        else
            for i=1:size(column,1)
                if column(i)>0
                    ratio(i)=sol(i)./column(i); 
                else
                    ratio(i)=inf; 
                end 
            end
            [minR, pvtrow]= min(ratio); 
            fprintf('Leaving row: %d',pvtrow);
        end
        
        %update the table and bv
        BV(pvtrow)= pvtcol;
        B = A(:,BV); 
        A = inv(B)*A; 
        ZjCj = cost(BV)*A-cost;
    
        %print table
        Zcj = [ZjCj;A];
        Simptable = array2table(Zcj);
        Simptable.Properties.VariableNames(1:size(Zcj,2))=variables

    else
    run = false; 
    fprintf('Current bfs is optimal');
    end
end
%final optimal solution print
final_bfs= zeros(1,size(A,2)); 
final_bfs(BV)= A(:,end); 
final_bfs(end) = sum(final_bfs.*cost); 
optimalbfs = array2table(final_bfs);
optimalbfs.Properties.VariableNames(1:size(optimalbfs,2))=variables



