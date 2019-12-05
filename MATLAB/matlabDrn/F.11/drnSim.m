%restoredefaultpath
drnParamHW11

drn = drnDynamics(P);
ctrl = drnController(P);
z_reference = signalGenerator(4, 0.02);
h_reference = signalGenerator(3, 0.03);

%if (P.makeMovie)
%    mov = makeMovie(P);
%end

% instantiate the data plots and animation
dataPlot = plotData(P);
animation = drnAnimation(P);

disturbance = 0;%(.25);

% main simulation loop
t = P.t_start;  % time starts at t_start
while t < P.t_end  
    % Get referenced inputs from signal generators
    z_ref = 5+ z_reference.square(t);
    h_ref = 5+ h_reference.square(t);
    % Propagate dynamics in between plot samples
    t_next_plot = t + P.t_plot;
    
    while t < t_next_plot % updates control and dynamics at faster simulation rate
        u = ctrl.u([z_ref;h_ref], drn.outputs());  % Calculate the control value
        drn.propagateDynamics(P.mixing*u);  % Propagate the dynamics
        t = t + P.Ts; % advance time by Ts
    end
    % update animation and data plots
    animation.drawDrn(drn.states,z_ref);
    
    %if (P.makeMovie)
    %    mov.addFrame(gcf);
    %end
    
    dataPlot.updatePlots(t, h_ref , drn.states, u(2));
end
%if (P.makeMovie)
%    mov.finalizeMovie();
%end
    
  