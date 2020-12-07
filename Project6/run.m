%% 3 Perfect Distributional Information
clear; clc;

load train
load test

y_3 = p6q3(test,test);

%% 4 DRO Implementation
load train
load test

rho = 0.9;
y_4= p6q4(train,test,rho);

%% 5 SAA vs. DRO




fprintf('\nThe utility is for Ex. 3 is: %0.5f \n',y_3);
fprintf('The utility for Ex. 4 is: %0.5f \n',y_4);