bobParamHWA

bob = bobDynamics(P);
%reference = signalGenerator(0.5, 0.1);
reference = signalGenerator(0.01, 0.02);  
torque = signalGenerator(1.5, 0.5);

thetaRef = signalGenerator(pi/4, 0.4);   
tauRef = signalGenerator(5, 0.5);
zRef = signalGenerator(1.0, 4);

% instantiate the data plots and animation
dataPlot = plotData(P);
animation = bobAnimation(P);

% main simulation loop
t = P.t_start;  % time starts at t_start
while t < P.t_end  
    % set variables
    
    ref_input = reference.square(t);
    t_next_plot = t + P.t_plot;
    
    while t < t_next_plot % updates control and dynamics at faster simulation rate
        tau = torque.square(t);  % Calculate the input force
        bob.propagateDynamics(tau);  % Propagate the dynamics
        t = t + P.Ts; % advance time by Ts
    end
    
    r = reference.square(t);
    theta = thetaRef.sin(t);
    tau = tauRef.sawtooth(t);
    
    z = zRef.sin(t);
    
    % update animation and data plot
    %beamState = [theta; 0.0];
    %ballState = [z; theta];
    %animation.drawBeam(beamState);
    %animation.drawBall(ballState);
    
    animation.drawBob(bob.states);
    dataPlot.updatePlots(t, r, bob.states, tau);
    %t = t + P.t_plot;  % advance time by t_plot
    pause(0.1)
end