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
w_s = sdpvar(1,1);
b_s = sdpvar(1,1);

% Objective function
%Type your code here...
% Specify solver settings and run solver
ops = sdpsettings('solver', 'mosek', 'verbose', 0);
diagnosis_squaredloss = optimize([], objective_s , ops);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Visualization %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lower_bound = w_low*x + b_low
upper_bound = w_high*x + b_high
figure
fig = gcf;
scatter(x, y, 100, 'MarkerEdgeColor',[0 0 0],...
              'MarkerFaceColor',[0.5 0.5 0.5],...
              'LineWidth',1.5);
grid on; hold on;
plot(x, lower_bound, 'color', 'g', 'LineWidth', 3);
hold on
plot(x, w_mid*x + b_mid, 'color', [1, 0.7, 0.7]	,...
    'LineWidth', 3);
hold on
plot(x, upper_bound,'color', 'c', 'LineWidth', 3);
hold on;
plot(x,value(w_s)'*x + value(b_s),'r','LineWidth', 3);
hold on
xlabel('x')
ylabel('y')
legend('Data points','Quantile Regression - \tau=0.1','Quantile Regression - \tau=0.5','Quantile Regression - \tau=0.9','Squared loss','Location','Best');
fig.PaperPositionMode = 'auto'
fig_pos = fig.PaperPosition;
ylim([-5, 15])
fig.PaperSize = [fig_pos(3) fig_pos(4)];
% Requires R2020a or later
print(fig,'q3a','-dpdf')

%% Cumulative distribution mass function of residuals
tau_vals = [0.1, 0.5, 0.9]

% yvals = ...; % this will construct the y axis of cumulative distribution
% plot so it should be between 0 and 1
figure
fig = gcf;

% For tau = 0.1
prediction = w_low * x + b_low;
% residuals = ... ;
% residuals_low = sort(...);
% plot(residuals_low, yvals, 'DisplayName', ['\tau = 0.1'], 'LineWidth', 3)
% hold on

% For tau = 0.5


% For tau = 0.9



leg = legend()
set(leg, 'Interpreter', 'latex')
legend show

plot(linspace(-2.5, 2.5, length(y)), ones(length(y), 1) * tau_vals, '--', 'LineWidth', 2, 'Color', 'k')
plot(zeros(length(y), 1), yvals, '--', 'Color', [.75 .75 .75], 'LineWidth', 2)
ylabel('Cumulative mass function')
xlabel('Prediction errors')
xlim([-1.5, 1.5])