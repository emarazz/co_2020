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
tau_vals = ...;
rho = 0.01;
pred = zeros(length(tau_vals), m);
figure;
fig = gcf;
for k = 1 : length(tau_vals)
   ...
   plot(SKIP_LEN : 50 + SKIP_LEN-1, pred(k, 1:50), 'Displayname', string(tau_vals(k)), 'LineWidth', 2)
end

%% VISUALIZE
plot(SKIP_LEN : 50 + SKIP_LEN-1, y(1:50), 'Displayname', 'actual', 'LineWidth', 2, 'color', 'k')
xlabel('t')
ylabel('Electricity prices')
hold off
legend show
