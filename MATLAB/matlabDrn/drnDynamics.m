classdef drnDynamics < handle
    %  Model the physical system
    %----------------------------
    properties
        state
        mc
        mr
        Jc
        d
        mu
        g
        Ts
        F_wind
        
    
        
        
        
        
    end
    %----------------------------
    methods
        %---constructor-------------------------
        function self = drnDynamics(P)
            % Initial state conditions
            
            self.state = [...                
                        P.z0;...          % z initial position
                        P.theta0;...      % Theta initial orientation
                        P.h0;...
                        P.zdot0;...       % zdot initial velocity
                        P.thetadot0;...   % Thetadot initial velocity
                        P.hdot0
                        ];    
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % The parameters for any physical system are never known exactly.  Feedback
            % systems need to be designed to be robust to this uncertainty.  In the simulation
            % we model uncertainty by changing the physical parameters by a uniform random variable
            % that represents alpha*100 % of the parameter, i.e., alpha = 0.2, means that the parameter
            % may change by up to 20%.  A different parameter value is chosen every time the simulation
            % is run.
            alpha = P.alpha;
            self.mc = P.mc * (1+2*alpha*rand-alpha);
            self.mr = P.mr * (1+2*alpha*rand-alpha);
            self.Jc = P.Jc * (1+2*alpha*rand-alpha);
            self.d = P.d * (1+2*alpha*rand-alpha);
            self.mu = P.mu * (1+2*alpha*rand-alpha);
            self.g = P.g;  % the gravity constant is well known and so we don't change it.
            self.Ts = P.Ts; % sample rate at which dynamics is propagated
            self.F_wind = P.F_wind * (1+2*alpha*rand-alpha);
            
          
        end
        %----------------------------
        function self = propagateDynamics(self, u)
            %
            % Integrate the differential equations defining dynamics
            % P.Ts is the time step between function calls.
            % u contains the system input(s).
            % 
            % Integrate ODE using Runge-Kutta RK4 algorithm
            k1 = self.derivatives(self.state, u);
            k2 = self.derivatives(self.state + self.Ts/2*k1, u);
            k3 = self.derivatives(self.state + self.Ts/2*k2, u);
            k4 = self.derivatives(self.state + self.Ts*k3, u);
            self.state = self.state + self.Ts/6 * (k1 + 2*k2 + 2*k3 + k4);
        end
        %----------------------------
        function xdot = derivatives(self, state, u)
            %
            % Return xdot = f(x,u), the derivatives of the continuous states, as a matrix
            % 
            % re-label states and inputs for readability
            %theta = state(1);
            %thetadot = state(2);
            %tau = u;
            z = state(1);
            h = state(2);
            theta = state(3);
            
            zdot = state(4);
            hdot = state(5);
            thetadot = state(6);
            
            fr = u(1);
            fl = u(2);
            
            % The equations of motion.
            %thetaddot = (3/self.m/self.ell^2)*(tau - self.b*thetadot - self.m*self.g*self.ell/2*cos(theta)); 
            %zeddot = (F-self.b*zedot-self.k*ze)/self.m;

            
            
            zddot = (-(fr+fl)*sin(theta)-self.F_wind*zdot)/(self.mc+2*self.mr);
            hddot = (-(self.mc+2*self.mr)*self.g+(fr+fl)*cos(theta))/(self.mc+2*self.mr);
            thetaddot = (self.d*(fr-fl))/(self.Jc+2*self.mr*self.d^2);
            
            
            
            
            
            % build xdot and return
            xdot = [zdot; hdot; thetadot; zddot; hddot; thetaddot];
        end
        %----------------------------
        function y = outputs(self)
            %
            % Returns the measured outputs as a list
            % [z, theta] with added Gaussian noise
            % 
            % re-label states for readability
            z = self.state(1);
            h = self.state(2);
            theta = self.state(3);
            
            % add Gaussian noise to outputs
            z_m = z;% + 0.01*randn;
            h_m = h;% + 0.01*randn;
            theta_m = theta;% + 0.001*randn;
            
            
            % return measured outputs
            y = [z_m; h_m; theta_m];
        end
        %----------------------------
        function x = states(self)
            %
            % Returns all current states as a list
            %
            x = self.state;
        end
    end
end