addpath ./..
bobParam

P.alpha = 0.0;
P.sigma = .05;
P.beta = (2*P.sigma-P.Ts)/(2*P.sigma+P.Ts);


P.makeMovie = true;
P.title = 'ballbeam.mp4';

%  tuning parameters
%tr = 2; % part (a)
tr_z = 1.2;%2.3;  % tuned to get fastest possible rise time before saturation.
zeta_z = .707;1;%0.707;

M = 10;
zeta_th = .707;

P.ki_z = -.1;
P.theta_max = 90;%30.0*pi/180.0;

P.ze = P.length/2;
b0 = P.length/(P.m2*P.length^2/3+P.m1*P.ze^2);
tr_theta = tr_z/M;
wn_th = 2.2/tr_theta;

P.ki_th = 0;%-.005;
P.kp_th = wn_th^2/b0;
P.kd_th = 2*zeta_th*wn_th/b0;

k_DC_th = 1;

wn_z = 2.2/tr_z;
P.kp_z = -wn_z^2/P.g;
P.kd_z = -2*zeta_z*wn_z/P.g;


%wn = 2.2/tr_z;
%Delta_cl_d = [1, 2*zeta*wn, wn^2];

%P.kp = (Delta_cl_d(3)-.6)/.2;
%P.kd = (Delta_cl_d(2)-.1)/.2;

%P.kp = P.tau_max;

%wn = sqrt(P.kp);
%Delta_cl_d = [1, 2*zeta*wn, wn^2];

%P.kd = (Delta_cl_d(2)-.1)/.2;

fprintf('\t k_DC_th: %f\n', k_DC_th)
fprintf('\t kp_th: %f\n', P.kp_th)
fprintf('\t kd_th: %f\n', P.kd_th)
fprintf('\t ki_th: %f\n', P.ki_th)
fprintf('\t kp_z: %f\n', P.kp_z)
fprintf('\t kd_z: %f\n', P.kd_z)
fprintf('\t ki_z: %f\n', P.ki_z)

