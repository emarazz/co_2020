function [w_val, b_val] = quantile_regression(x, y, tau, rho)
m = size(x,1);
n = size(x,2);
w = sdpvar(n,1);
b = sdpvar(1,1);
t = sdpvar(m,1);
objective   = sum(1/2*t+(tau-1/2)*(x*w+b-y))+rho/2*norm(w,2)^2;
constraints = [x*w+b-y<=t,
            -x*w-b+y<=t,
            0<=t]
ops = sdpsettings('solver', 'mosek', 'verbose', 0);
diagnosis = optimize(constraints, objective , ops);
value(objective)
w_val = value(w);
b_val = value(b);
end 


