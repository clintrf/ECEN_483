massParamHW8

mass = massDynamics(P);
ctrl = massController(P);
amplitude = .5;%30*pi/180;
frequency = .004;
reference = signalGenerator(amplitude, frequency);

if (P.makeMovie)
    mov = makeMovie(P);
end

% instantiate the data plots and animation
dataPlot = plotData(P);
animation = massAnimation(P);

disturbance = (.25);

% main simulation loop
t = P.t_start;  % time starts at t_start
while t < P.t_end  
    % Get referenced inputs from signal generators
    ref_input = reference.square(t);
    % Propagate dynamics in between plot samples
    t_next_plot = t + P.t_plot;
    
    while t < t_next_plot % updates control and dynamics at faster simulation rate
        u = ctrl.u(ref_input, mass.outputs());  % Calculate the control value
        system_input = u+disturbance;
        mass.propagateDynamics(system_input);  % Propagate the dynamics
        t = t + P.Ts; % advance time by Ts
    end
    % update animation and data plots
    animation.drawMass(mass.states);
    
    if (P.makeMovie)
       mov.addFrame(gcf); 
    end
    
    dataPlot.updatePlots(t, ref_input, mass.states, u);
    
    %pause(0.1)
end
if (P.makeMovie)
    mov.finalizeMovie();
end
    