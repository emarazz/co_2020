%% Distributionally Robust Portfolio Optimization
% Sample Average Approximation
% function y = p6q3(train,test)
% Input: 
% - train: training samples
% - test: testing samples
% Output:
% - y: mean utility achieved by the optimal decision

% For Question 3, the input arguments train and test are the same.
% Run this function with the matlab variable 'test' obtained by loading
% the file test.mat 
% Fill in the sections marked by '...'
function y = p33(train,test)
%% Utility function
a = [4; 1];
b = [0; 0];

%% Number of assets, training periods, and utility function coefficients
K = length(train(1,:));
N = length(train(:,1));
L = length(a);

%% Decision Variables
x=sdpvar(K,1);
t=sdpvar(N,1);

%% Objective
obj = -sum(t)/N;

%% Constraints
con = [ones(K,1)'*x==1,
       x>=0,
       train*x*a'+ones(N,1)*b'>=t*ones(1,L)];

%% Optimization Settings
ops = sdpsettings('solver','Gurobi','verbose',1);
diag = optimize(con,obj,ops);

%% Retrieve portfolio weights 
x = value(x);
    
%% Evaluate portfolio utility
y = mean(min(test*x*a'+ones(size(test,1),1)*b',[],2));

end