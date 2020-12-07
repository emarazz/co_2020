%% Distributionally Robust Portfolio Optimization
% Loop over 1,000 independent training datasets
% Fill in the sections marked by '...'

%% Clear Matlab
clc
clear
close all

%% Set random number generator seed for reproducibility
rng(0);

%% Specify training and testing samples
% testing set
load test
% training set
N = 1000;           % number of independent training datasets
N_train = 30;       % number of training samples in each set

%% Declare results and set Wasserstein radius
saa = zeros(N,1);
dro = zeros(N,1);
rho = 0.9;          % Wasserstein radius
%% Compute optimal utility when knowing all testing samples
pi = p6q3(test, test);
%% Loop over all training datasets
for n = 1:N
    train = sample_data(N_train);       % draw a new training dataset
    saa(n) = p6q3(train, test);
    dro(n) = p6q4(train, test, rho);
    fprintf('Progress %0.2f\n',n/N)
end
%% Save results
save results

%% Plot normalized cumulative distribution function
figure;
fig = gcf;
set(0,'DefaultAxesFontSize',12)

plot(sort(saa)/pi,1/N:1/N:1,'LineWidth',1.5,'DisplayName','SAA','Color',[1 0.5 0]);
hold on
plot(sort(dro)/pi,1/N:1/N:1,'LineWidth',1.5,'DisplayName','DRO','Color',[0.25 0.5 1]);
line([mean(saa)/pi,mean(saa)/pi] ,[0 1],'LineWidth',1.5,'Color',[1 0.5 0],'LineStyle','--','DisplayName','Mean SAA')
line([mean(dro)/pi, mean(dro)/pi],[0 1],'LineWidth',1.5,'Color',[0.25 0.5 1],'LineStyle','--','DisplayName','Mean DRO')
legend('boxoff')

axis([0.65 1 0 1])

ax = gca();
ax.LineWidth = 1;

grid on

xlabel('Normalized mean utility on the test samples')
ylabel('Probability')
legend('Location','northwest')

% Save the figure under the name 'fname'
fig_pos = fig.PaperPosition;
fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(fig,'SAA_vs_DRO_cdf','-dpdf')
