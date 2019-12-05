drnParamHWA
P
drn = drnDynamics(P);
z_reference = signalGenerator(1.5, 0.1);
h_reference = signalGenerator(1, 0.1);
zRef = signalGenerator(1, .1);
hRef = signalGenerator(.5, .1);
thetaRef = signalGenerator(4*pi, 0.2);   


fRef = signalGenerator(5, 0.5);
tauRef = signalGenerator(5, 0.5);

% instantiate the data plots and animation
dataPlot = plotData(P);
animation = drnAnimation(P);

% main simulation loop
t = P.t_start;  % time starts at t_start
while t < P.t_end  
    % set variables
    
    z_r = z_reference.square(t);
    z = zRef.sin(t);
    h_r = h_reference.square(t);
    h = hRef.sin(t);
    
    theta = thetaRef.sin(t);
    f = fRef.sawtooth(t);
    
    tau = tauRef.sawtooth(t);
    
    
    
    
    % update animation and data plot
    droneState = [z; h; theta; 0.0; 0.0; 0.0];
    
    animation.drawVTOL(droneState,z_r);
    
    dataPlot.updatePlots(t, theta, droneState, tau);
    t = t + P.t_plot;  % advance time by t_plot
    pause(0.1)
end