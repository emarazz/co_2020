clc;
clearvars;
load('p2q6data.mat');
tau = 0.5;
sigma = .5;
rho = 0.0001; %regularization parameter

%% Solve the dual problem (6) with the Gaussian kernel 
%Denote the dual decision variables by lambda_p and lambda_m
n = size(x,2);
m = size(x,1);
lambda_p = sdpvar(m,1);
lambda_m = sdpvar(m,1);

%K = ones(m,m,n).*reshape(x,m,1,n);
K = ones(m,m).*x-x';
K = -1/(2*sigma)*arrayfun(@(x) norm(x,2)^2,K);
K = arrayfun(@(x) exp(x),K);

objective = (lambda_p-lambda_m+tau-1/2)'*(y+1/(2*rho)*K*(lambda_p-lambda_m+tau-1/2));

constraints = [m*(1/2-tau)==sum(lambda_p-lambda_m),
               lambda_p+lambda_m<=1/2
               0<=lambda_p
               0<=lambda_m]

ops = sdpsettings('solver', 'mosek', 'verbose', 0,'debug',1);
diagnosis_squaredloss = optimize(constraints, objective , ops);

lambda_p = value(lambda_p);
lambda_m = value(lambda_m);

%%
%Compute b*(denote by b_opt) using the optimal dual solution
k = find(lambda_p-lambda_m<=0.4999,1);
b_opt = (1/rho*K(k,:)*(lambda_p-lambda_m+tau-1/2)+y(k));
%%
%Discretize the input region, i.e., [min(x), max(x)] to 100 discretization points
%Create a vector (input) where ith component is the ith discrete point
%Compute the corresponding output y = (w*)'phi(x) + b* 
%for each component x of the input vector
%Hint: Use w* that you computed in terms of the optimal dual solution
%Create a vector (output) that contains the y values computed 
%for all components of the input vector

output = -1/rho*K*(lambda_p-lambda_m+tau-1/2)+b_opt;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
fig = gcf;

scatter(x, y, 'k', 'filled'); grid on; hold on;

hold on

% Visualize the kernelized quantile regression prediction
[sorted_array sorted_order] = sort(x);
plot(sort(x), output(sorted_order), 'r', 'LineWidth', 3); hold on;
%% %Solve the original quantile regression problem (3)
%You can use your code for question 3
% Denote the decision variables by w_q and b_q
[w_q, b_q] = quantile_regression(x, y, 0.1, rho);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(x, w_q'*x + b_q,'b','LineWidth', 3);
legend('Data points','Kernelized Quantile','Original Quantile','Location','Best');