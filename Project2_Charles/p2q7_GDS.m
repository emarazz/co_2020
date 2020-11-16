clear; close all; clc
%% Prepare Electricity price dataset dataset
data = importdata('data.txt');
data = split(data(:));
data = data(:, 3);
data = str2double(data);

m = 400;
SKIP_LEN = 50;

n = 50;
x = zeros(m, n);
y = zeros(m, 1);

for i = SKIP_LEN : m + SKIP_LEN-1
    x(i-SKIP_LEN+1, :) = data(i-n+1:i);
    y(i-SKIP_LEN+1) = data(i+1);
end

%%
tau_vals = [0.1 0.5 0.9];
rho = 0.01;
pred = zeros(length(tau_vals), m);
figure;
fig = gcf;
n = 10; m = 100;
w_val = zeros(n,length(tau_vals));
b_val = zeros(1,length(tau_vals));
for k = 1 : length(tau_vals)
   [w_val(:,k), b_val(:,k)] = quantile_regression(x(1:m,1:n), y(1:m), tau_vals(k), rho)
   plot(SKIP_LEN : 50 + SKIP_LEN-1, pred(k, 1:50), 'Displayname', string(tau_vals(k)), 'LineWidth', 2)
end

%% VISUALIZE
plot(SKIP_LEN : 50 + SKIP_LEN-1, y(1:50), 'Displayname', 'actual', 'LineWidth', 2, 'color', 'k')
hold on
plot(SKIP_LEN : 50 + SKIP_LEN-1, w_val(:,1)'*x(49:98,1:n)'+b_val(1), 'Displayname', 'prediction \tau = 0.1', 'LineWidth', 2)
plot(SKIP_LEN : 50 + SKIP_LEN-1, w_val(:,2)'*x(49:98,1:n)'+b_val(2), 'Displayname', 'prediction \tau = 0.5', 'LineWidth', 2)
plot(SKIP_LEN : 50 + SKIP_LEN-1, w_val(:,3)'*x(49:98,1:n)'+b_val(3), 'Displayname', 'prediction \tau = 0.9', 'LineWidth', 2)
xlabel('t')
ylabel('Electricity prices')
hold off
legend show
