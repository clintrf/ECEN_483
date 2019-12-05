clear all

% Physical parameters of mass
P.m1 = 2500; % kg
P.m2 = 320;  % kg
P.k1 = 80000;  % N/m
P.k2 = 500000; % N/m
P.b1 = 350;    % N-s/m
P.b2 = 15020;  % N-s/m
P.g  = 9.81; % m/s^2

% initial conditions
P.z1_eq = 2;     % initial position
P.z1dot_eq = 0;  % initial velosity
P.z2_eq = 0;     % initial position
P.z2dot_eq = 0;  % initial velosity

% Simulation Parameters
P.t_start = 0.0;  % Start time of simulation
P.t_end = 60.0;   % End time of simulation
P.Ts = 0.01;      % sample time for simulation
P.t_plot = 0.1;   % the plotting and animation is updated at this rate

% dirty derivative parameters
P.sigma = 0.05; % cutoff freq for dirty derivative
P.beta = (2*P.sigma-P.Ts)/(2*P.sigma+P.Ts); % dirty derivative gain

% control saturation limits
%P.F_max = 2; % max Force, N-m

tr = 0.402;
zeta = 0.707;

P.z_e = 0;
P.F_e = 0;

A=[0                 1   0                                              0;
  -(P.b1*P.b2)/(P.m1*P.m2)   0   ((P.b1/P.m1)*((P.b1/P.m1)+(P.b1/P.m2)+(P.b2/P.m2)))-(P.k1/P.m1)   -(P.b1/P.m1);
   P.b2/P.m2             0  -((P.b1/P.m1)+(P.b1/P.m2)+(P.b2/P.m2))                      1;
   P.k2/P.m2             0  -((P.k1/P.m1)+(P.k1/P.m2)+(P.k2/P.m2))                      0];
B=[0;
   1/P.m1;
   0 ;
   (1/P.m1)+(1/P.m2)];

C = [...
    1, 0,0,0;...
    ];

%Delta_ol = [1, P.b/P.m, P.k/P.m];
%p_ol = roots(Delta_ol);

wn_z1 = 2.2/tr;
wn_z2 = 2.2/(tr/10);


des_char_poly = conv(...
    [1,2*zeta*wn_z1,wn_z1^2],...
    [1,2*zeta*wn_z2,wn_z2^2]);
des_poles = roots(des_char_poly);

% is the system controllable?
if rank(ctrb(A,B))~=4 
    disp('System Not Controllable'); 
else
    P.K = place(A,B,des_poles); 
    P.kr = -1/(C*inv(A-B*P.K)*B);
end

fprintf('\t K: [%f, %f]\n', P.K(1), P.K(2))
fprintf('\t kr: %f\n', P.kr)



mass = dMassDynamics(P);
ctrl = dMassController(P);

amplitude = 5;%meters
frequency = .05;%frequency
reference = signalGenerator(amplitude, frequency);

% instantiate the data plots and animation
dataPlot = plotData(P);


% main simulation loop
t = P.t_start;  % time starts at t_start
while t < P.t_end  
    % Get referenced inputs from signal generators
    ref_input = reference.square(t);
    % Propagate dynamics in between plot samples
    t_next_plot = t + P.t_plot;
    while t < t_next_plot % updates control and dynamics at faster simulation rate
        u = ctrl.u(ref_input, mass.outputs());  % Calculate the control value
        mass.propagateDynamics(u);  % Propagate the dynamics
        t = t + P.Ts; % advance time by Ts
    end
    
    % plot data
    dataPlot.updatePlots(t, ref_input, mass.states, u);

end

    