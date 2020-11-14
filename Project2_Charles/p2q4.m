%%%%%%%%%%%%%%%%%%%%%% MGT-418 Convex Optimization %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Project 2 / Answer 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compare the squared loss minimization and the Huber loss minimization %%
clear;
close all
clc
load('p2q4data.mat');
rho = 0; %regularization parameter

%%
%%%%%%%%%%%%%%%%%%%%% Quantile Regression - Linear Reformulation %%%%%%%%%%%%%%%%%%%%
[w_low, b_low] = quantile_regression(x, y, 0.1, rho);
[w_mid, b_mid] = quantile_regression(x, y, 0.5, rho);
[w_high, b_high] = quantile_regression(x, y, 0.9, rho);


%%
%%%%%%%%%%%%%%%%%%%% Squared loss minimization problem %%%%%%%%%%%%%%%%%%%%
% Decision variables
n = size(x,2);
m = size(x,1);
w_s = sdpvar(n,1);
b_s = sdpvar(1,1);

% Objective function
objective_s = (x*w_s+b_s-y)'*(x*w_s+b_s-y) %sum of (r_i)^2

% Specify solver settings and run solver
ops = sdpsettings('solver', 'mosek', 'verbose', 0);
diagnosis_squaredloss = optimize([], objective_s , ops);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lower_bound = x*w_low + b_low;
upper_bound = x*w_high + b_high;
figure
fig = gcf;
scatter(x, y, 100, 'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.5 0.5 0.5],...
              'LineWidth',1.5);
grid on; hold on;
plot(x, lower_bound, 'color', 'g', 'LineWidth', 3);
hold on
plot(x, x*w_mid + b_mid, 'color', [1, 0.7, 0.7]	,...
    'LineWidth', 3);
hold on
plot(x, upper_bound,'color', 'c', 'LineWidth', 3);
hold on;
plot(x,x*value(w_s) + value(b_s),'r','LineWidth', 3);
hold on
xlabel('x')
ylabel('y')
legend('Data points','Quantile Regression - \tau=0.1','Quantile Regression - \tau=0.5','Quantile Regression - \tau=0.9','Squared loss','Location','Best');
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
ylim([-5, 15])
fig.PaperSize = [fig_pos(3) fig_pos(4)];
% Requires R2020a or later
%print(fig,'q3a','-dpdf')

%% Cumulative distribution mass function of residuals
tau_vals = [0.1, 0.5, 0.9];

% yvals = ...; % this will construct the y axis of cumulative distribution
% plot so it should be between 0 and 1
figure
fig = gcf;

% For tau = 0.1
%prediction = x*w_low + b_low;
%residuals = prediction - y;
% residuals_low = sort(...);
% plot(residuals_low, yvals, 'DisplayName', ['\tau = 0.1'], 'LineWidth', 3)
cdfplot(x*w_low + b_low-y)
hold on

% For tau = 0.5
cdfplot(x*w_mid + b_mid-y)
hold on
% For tau = 0.9
cdfplot(x*w_high + b_high-y)
hold on

xlim([-2.5,2.5])
ylabel('Cumulative mass function')
xlabel('Prediction errors')
legend('\tau = 0.1','\tau = 0.5','\tau = 0.9')

%plot(linspace(-2.5, 2.5, length(y)), ones(length(y), 1) * tau_vals, '--', 'LineWidth', 2, 'Color', 'k')
%plot(zeros(length(y), 1), yvals, '--', 'Color', [.75 .75 .75], 'LineWidth', 2)
