%% simplex method
clc 
close all
clear all
format short
%% input parameters 
a = [3,4 ; 2,5];
b = [5;7];
C = [2,-3];
numberOfVariables = 2; % do not include s1,s2...
s = eye(size(a,1)); % identity matrix of size of number of equations
A = [a s b] % table of simplex table
cost = zeros(1,size(A,2));
cost(1:numberOfVariables) = C
%% do the above procedure or directly write the simplex table in a,b,c (shown below)
% A = [3,4,1,0 ; 2,5,0,1];
% B = [5;7]; 
% C = [2,-3,0,0]; % cost
%% calculations
bv = numberOfVariables+1 : 1 : size(A,2)-1 % basic variable
zjcj = cost(bv)*A - cost % calculates zj - cj
zcj = [zjcj ; A]; % makes a table with zjcj on top of A
simptable = array2table(zcj);
simptable.Properties.VariableNames(1:size(zcj,2)) = {'x1','x2','s1','s2','sol'}
% main loop
RUN = true;
while RUN
    zc = zjcj(1:end-1); % to check if all zj-cj are >=0
    if any(zc<0)
        disp('Not optimal solution')
        % finding the entering variable and pivot column
        [enter_var , pvt_col] = min(zc);
        enter_var
        pvt_col % wrt to A
        if all(A(:,pvt_col)<=0)
            error('LPP has unbounded solution')
        else
            sol = A(:,end); % last column of A 
            column = A(: , pvt_col); % pivot column of A
            ratio = [];
            for i = 1 : size(A,1)
                if column(i)<0
                    ratio(i) = inf;
                else
                    ratio(i) = sol(i)/column(i);
                end
            end
            ratio
        end
        % finding the leaving variable and pivot row
        [leav_var,pvt_row] = min(ratio);
        leav_var
        pvt_row % wrt to A
        % updating the basic variable
        bv(pvt_row) = pvt_col;
        % applying row operations
        for i = 1 : size(A,1)
            if i~=pvt_row
                A(i,:) = A(i,:) - (A(i,pvt_col).*A(pvt_row,:))/A(pvt_row,pvt_col);
            end
        end
        k = zjcj(pvt_col);
        for i = 1 : size(A,2)
            zjcj(i) = zjcj(i) - (A(pvt_row,i)*k)/A(pvt_row,pvt_col);
        end
        A(pvt_row,:) = A(pvt_row,:)/A(pvt_row,pvt_col);
        A
        zjcj
    else
        RUN = false;
    end
end
fprintf('Optimal Solution = %.4f\n',zjcj(end))
fprintf('Optimal values = %.4f\n ',A(:,end))
bv