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
k = find(lambda_p+lambda_m<0.5,1);
b_opt = (1/rho*K(k,:)*(lambda_p-lambda_m+tau-1/2)+y(k));
%%
%Discretize the input region, i.e., [min(x), max(x)] to 100 discretization points
%Create a vector (input) where ith component is the ith discrete point
%Compute the corresponding output y = (w*)'phi(x) + b* 
%for each component x of the input vector
%Hint: Use w* that you computed in terms of the optimal dual solution
%Create a vector (output) that contains the y values computed 
%for all components of the input vector
input = linspace(min(x),max(x),100);
output = zeros(100,1);
w_phi = 0;
for i = 1 : 100
    for j = 1 : 50
        w_phi = w_phi +((lambda_m(j)-lambda_p(j)+1/2-tau)*gaussianKernel(x(j),input(i),sigma));
    end
    output(i) = w_phi/rho+b_opt;
    w_phi = 0;
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
fig = gcf;

scatter(x, y, 'k', 'filled'); grid on; hold on;

hold on

% Visualize the kernelized quantile regression prediction

plot(input, output, 'r', 'LineWidth', 3); hold on;
%% %Solve the original quantile regression problem (3)
%You can use your code for question 3
% Denote the decision variables by w_q and b_q
[w_q, b_q] = quantile_regression(x, y, tau, rho);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
plot(x, w_q'*x + b_q,'b','LineWidth', 3);
legend('Data points','Kernelize1d Quantile','Original Quantile','Location','Best');4