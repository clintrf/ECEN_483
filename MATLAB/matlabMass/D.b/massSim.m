massParamHWA


Z_Ref = signalGenerator(.8, 0.02);   
%reference = signalGenerator(0.01, 0.001);

% instantiate the data plots and animation
dataPlot = plotData(P);
animation = massAnimation(P);
mass = massDynamics(P);

% main simulation loop
t = P.t_start;  % time starts at t_start
while t < P.t_end  
    % set variables
    %ref_input = reference.square(t);
    t_next_plot = t + P.t_plot;
    while t< t_next_plot
        force = Z_Ref.square(t);
        mass.propagateDynamics(force);
        t = t + P.Ts;
        
    end
    z = Z_Ref.sin(t);
    r = Z_Ref.square(t);
    
    % update animation and data plot
    
    animation.drawMass(mass.state);
    dataPlot.updatePlots(t, r, mass.state, force);
    %t = t + P.t_plot;  % advance time by t_plot
    pause(0.1)
end