% Single Link Arm Parameter File

clear all

% Physical parameters of arm known to the controller
P.mc = 1.0;  % kg
P.mr = .25;
P.g = 9.81; % m/s^2
P.d = .3;
P.Jc = .0042;
P.mu = .1;
P.F_wind = .1;
% parameters for animation
P.length = 10;

P.alpha = 0.2;

% initial conditions
P.z0 = 6.0;
P.h0 = 0.0;
P.theta0 = 0;     % initial angle of the arm in rad


P.zdot0 = 0;       % zdot initial velocity
P.hdot0 = 0;
P.thetadot0 = 0;   % Thetadot initial velocity
P.target0 = 0;


% Simulation Parameters
P.t_start = 0.0;  % Start time of simulation
P.t_end = 150.0;   % End time of simulation
P.Ts = 0.01;      % sample time for simulation
P.t_plot = 0.1;   % the plotting and animation is updated at this rate

% dirty derivative parameters
P.sigma = 0.05; % cutoff freq for dirty derivative
P.beta = (2*P.sigma-P.Ts)/(2*P.sigma+P.Ts); % dirty derivative gain

P.Fe = ((P.mc+2*P.mr)*P.g);

P.mixing = inv([1,1;P.d,-P.d]);


% control saturation limits
P.F_max = 110; % mN
