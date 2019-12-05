%restoredefaultpath
bobParamHW10

bob = bobDynamics(P);
ctrl = bobController(P);
amplitude = .125;%.15;
frequency = .02;
reference = signalGenerator(amplitude, frequency);

if(P.makeMovie)
    mov = makeMovie(P);
end


% instantiate the data plots and animation
dataPlot = plotData(P);
animation = bobAnimation(P);

disturbance = 1;

% main simulation loop
t = P.t_start;  % time starts at t_start
while t < P.t_end  
    % Get referenced inputs from signal generators
    ref_input = .25+ reference.square(t);
    % Propagate dynamics in between plot samples
    t_next_plot = t + P.t_plot;
    
    while t < t_next_plot % updates control and dynamics at faster simulation rate
        u = ctrl.u(ref_input, bob.outputs());  % Calculate the control value
        system_input = u+disturbance;
        bob.propagateDynamics(system_input);  % Propagate the dynamics
        t = t + P.Ts; % advance time by Ts
    end
    % update animation and data plots
    animation.drawBob(bob.states);
    
    if (P.makeMovie)
        mov.addFrame(gcf);
    end
    
    dataPlot.updatePlots(t, ref_input, bob.states, u);
end
if (P.makeMovie)
    mov.finalizeMovie();
end