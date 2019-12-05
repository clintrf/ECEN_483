massParamHWA


Z_Ref = signalGenerator(.8, 0.5);   


% instantiate the data plots and animation
dataPlot = plotData(P);
animation = massAnimation(P);

% main simulation loop
t = P.t_start;  % time starts at t_start
while t < P.t_end  
    % set variables
    
    z = Z_Ref.sin(t);
    r = Z_Ref.square(t);
    tau = Z_Ref.sawtooth(t);
    % update animation and data plot
    state = [z; 0.0];
    animation.drawMass(state);
    dataPlot.updatePlots(t, r, state, tau);
    t = t + P.t_plot;  % advance time by t_plot
    pause(0.1)
end