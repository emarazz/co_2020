clc;
clearvars;
load('p2q6data.mat');
tau = 0.5
sigma = .5
rho = 0.0001; %regularization parameter

%% Solve the dual problem (6) with the Gaussian kernel 
%Denote the dual decision variables by lambda_p and lambda_m

%Type your code here...

lambda_p = value(lambda_p);
lambda_m = value(lambda_m);

%%
%Compute b*(denote by b_opt) using the optimal dual solution

%Type your code here...
%%
%Discretize the input region, i.e., [min(x), max(x)] to 100 discretization points
%Create a vector (input) where ith component is the ith discrete point
%Compute the corresponding output y = (w*)'phi(x) + b* 
%for each component x of the input vector
%Hint: Use w* that you computed in terms of the optimal dual solution
%Create a vector (output) that contains the y values computed 
%for all components of the input vector

%Type your code here...

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
fig = gcf

scatter(x, y, 'k', 'filled'); grid on; hold on;

hold on

% Visualize the kernelized quantile regression prediction
% plot(input, output, 'r', 'LineWidth', 3); hold on;
%% %Solve the original quantile regression problem (3)
%You can use your code for question 3
% Denote the decision variables by w_q and b_q

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(x, w_q'*x + b_q,'b','LineWidth', 3);
legend('Data points','Kernelized Quantile','Original Quantile','Location','Best');)