% Two Phase method
clc
clear

A = [1 1 1 0 0; 1 3 0 1 0; 1 -1 0 0 1];
b = [2; 3; 1];
c = [3 2 0 0];
C = [0 0 0 0 1]; % phase-I optimization function
n_art = 1;

[m, n] = size(A);

A = [A b];

% Phase-I
fprintf("Phase-I:\n")
cost = zeros(1, n + 1);
cost(1:n) = C;

bv = (n - m + 1):(n);   % basic variables
zjcj = cost(bv)*A - cost;
zcj = [zjcj; A];


simplexTable = array2table(zcj);
simplexTable.Properties.VariableNames(1: n + 1) = ["x1", "x2", "s1", "s2", "a3", "sol"];
disp(simplexTable)

while(1)
    if any(zjcj(1:n) > 0)
        disp("The current BFS is not optimal")
        ZC = zjcj(1:n);
        [val, pvt_col] = max(ZC);

        if all(A(:, pvt_col) < 0)
            disp("LPP is unbounded")
        else
            sol = A(:, n + 1);
            column = A(:, pvt_col);

            for i = 1:m
                if(column(i) > 0)
                    ratio(i) = sol(i)/column(i);
                else
                    ratio(i) = inf;
                end
            end
            [leaving_val, pvt_row] = min(ratio);
        end
        pvt_key = A(pvt_row, pvt_col);
        bv(pvt_row) = pvt_col;
        A(pvt_row, :) = A(pvt_row, :)./pvt_key;

        for i = 1:size(A,1)
            if (i ~= pvt_row)
                A(i,:) = A(i,:) - A(i, pvt_col).*A(pvt_row, :);
            end
        end
        zjcj = zjcj - zjcj(pvt_col).*A(pvt_row, :);
        zcj = [zjcj; A];
        
        table = array2table(zcj);
        table.Properties.VariableNames(1: n + 1) = ["x1", "x2", "s1", "s2", "a3", "sol"];
        disp(table)
        
    else
        disp("Current BFS is optimal.")
        break;
    end
end


% Phase-II
fprintf("\nPhase II:\n")
cost = zeros(1, n - n_art + 1);
cost(1: n - n_art) = c;

A(:, n - n_art + 1: n) = [];
zjcj = cost(bv)*A - cost;
zcj = [zjcj; A];

n = n - n_art;

simplexTable = array2table(zcj);
simplexTable.Properties.VariableNames(1: n + 1) = ["x1", "x2", "s1", "s2", "sol"];
disp(simplexTable)

while(1)
    if any(zjcj(1:n) < 0)
        disp("The current BFS is not optimal")
        ZC = zjcj(1:n);
        [val, pvt_col] = min(ZC);

        if all(A(:, pvt_col) < 0)
            disp("LPP is unbounded")
        else
            sol = A(:, n + 1);
            column = A(:, pvt_col);

            for i = 1:m
                if(column(i) > 0)
                    ratio(i) = sol(i)/column(i);
                else
                    ratio(i) = inf;
                end
            end
            [leaving_val, pvt_row] = min(ratio);
        end
        pvt_key = A(pvt_row, pvt_col);
        bv(pvt_row) = pvt_col;
        A(pvt_row, :) = A(pvt_row, :)./pvt_key;

        for i = 1:size(A,1)
            if (i ~= pvt_row)
                A(i,:) = A(i,:) - A(i, pvt_col).*A(pvt_row, :);
            end
        end
        zjcj = zjcj - zjcj(pvt_col).*A(pvt_row, :);
        zcj = [zjcj; A];
        
        table = array2table(zcj);
        table.Properties.VariableNames(1: n + 1) = ["x1", "x2", "s1", "s2", "sol"];
        disp(table)
        
    else
        disp("Current BFS is optimal.")
        break;
    end
end

Z = zcj(1, end);
fprintf("\nMaximised Z = \n")
disp(Z)