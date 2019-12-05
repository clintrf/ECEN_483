addpath ./..
massParam

P.makeMovie = true;
%  tuning parameters
%tr = 2; % part (a)
tr = 2.2;  % tuned to get fastest possible rise time before saturation.
zeta = 0.7;

P.sigma = 0.05;
P.F_max = 2;

Delta_ol = [1, P.b/P.m, P.k/P.m];
p_ol = roots(Delta_ol);

wn = 2.2/tr;
Delta_cl_d = [1, 2*zeta*wn, wn^2];
P.kp = P.m*(Delta_cl_d(3) - Delta_ol(3));
P.kd = P.m*(Delta_cl_d(2) - Delta_ol(2));




%P.kp = (Delta_cl_d(3)-.6)/.2;
%P.kd = (Delta_cl_d(2)-.1)/.2;

%wn = sqrt(P.kp);
%Delta_cl_d = [1, 2*zeta*wn, wn^2];

%P.kd = (Delta_cl_d(2)-.1)/.2;


fprintf('\t kp: %f\n', P.kp)
fprintf('\t kd: %f\n', P.kd)