% Single Link Arm Parameter File

clear all

% Physical parameters of arm known to the controller
P.m1 = 0.35;  % kg
P.m2 = 2.0;  % kg
P.length = 0.5; % m
P.g = 9.81; % m/s^2

P.radius = 0.05;



% initial conditions
P.theta0 = 0;     % initial angle of the arm in rad
P.thetadot0 = 0;  % initial angular rate in rad/sec


P.z0 = P.length/2;         % initial position of cart in m
P.zdot0 = 0;      % initial velocity of cart in m/s
P.theta0 = 0.0*pi/180;     % initial angle of rod in rad
P.thetadot0 = 0;  % initial angular velocity of rod in rad/sec

% Simulation Parameters
P.t_start = 0.0;  % Start time of simulation
P.t_end = 500.0;   % End time of simulation
P.Ts = 0.01;      % sample time for simulation
P.t_plot = 0.1;   % the plotting and animation is updated at this rate

% dirty derivative parameters
P.sigma = 0.05; % cutoff freq for dirty derivative
P.beta = (2*P.sigma-P.Ts)/(2*P.sigma+P.Ts); % dirty derivative gain

%equilibrium force
P.Fe = P.m1*P.g*P.z0/P.length + P.m2*P.g/2;

% control saturation limits
P.F_max = 15;

