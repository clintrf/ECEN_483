bobParamHWA


reference = signalGenerator(0.5, 0.1);
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
    
    r = reference.square(t);
    theta = thetaRef.sin(t);
    tau = tauRef.sawtooth(t);
    
    z = zRef.sin(t);
    
    % update animation and data plot
    beamState = [theta; 0.0];
    ballState = [z; theta];
    animation.drawBeam(beamState);
    animation.drawBall(ballState);
    
    dataPlot.updatePlots(t, r, beamState, tau);
    t = t + P.t_plot;  % advance time by t_plot
    pause(0.1)
end