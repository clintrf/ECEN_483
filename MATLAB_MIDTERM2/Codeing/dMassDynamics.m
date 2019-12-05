classdef dMassDynamics < handle
    %  Model the physical system
    %----------------------------
    properties
        state
 
        m1 
        m2 
        k1 
        k2 
        b1 
        b2 
        g  
        Ts
    end
    %----------------------------
    methods
        %---constructor-------------------------
        function self = dMassDynamics(P)
            % Initial state conditions
            self.state = [...
                        P.z1_eq;...      % initial p
                        P.z1dot_eq;...   % initial v
                        P.z2_eq;...
                        P.z2dot_eq;
                        ];   
            
            
            self.m1 = P.m1;
            self.m2 = P.m2;
            self.k1 = P.k1;
            self.k2 = P.k2;
            self.b1 = P.b1;
            self.b2 = P.b2;
            self.g  = P.g;
            self.Ts = P.Ts;
            
        end
        %----------------------------
        function self = propagateDynamics(self, u)
            %
            % Integrate the differential equations defining dynamics
            % P.Ts is the time step between function calls.
            % u contains the system input(s).
            % 
            % Integrate ODE using Runge-Kutta RK4 algorithm
            k11 = self.derivatives(self.state, u);
            k22 = self.derivatives(self.state + self.Ts/2*k11, u);
            k33 = self.derivatives(self.state + self.Ts/2*k22, u);
            k44 = self.derivatives(self.state + self.Ts*k33, u);
            self.state = self.state + self.Ts/6 * (k11 + 2*k22 + 2*k33 + k44);
        end
        %----------------------------
        function xdot = derivatives(self, state, u)
            z1 = state(1);
            z1dot = state(2);
            z2 = state(3);
            z2dot = state(4);
            
            F = u;
            % The equations of motion.
       %Tryed to implement te force of gravity 
            %z1ddot = ((F-self.b1*z1dot-self.k1*z1)/self.m1)-((self.m1)*self.g);
            %z2ddot = ((F-self.b2*z2dot-self.k2*z2)/self.m2)-((self.m2)*self.g);
            z1ddot = ((F-self.b1*z1dot-self.k1*z1)/self.m1);
            z2ddot = ((F-self.b2*z2dot-self.k2*z2)/self.m2);
            % build xdot and return
            xdot = [z1dot; z1ddot; z2dot; z2ddot];
        end
        %----------------------------
        function y = outputs(self)
            %
            % Returns the measured outputs as a list
            % [z, theta] with added Gaussian noise
            % 
            % re-label states for readability
            z1 = self.state(1);
            z2 = self.state(3);
            % add Gaussian noise to outputs
            z_m1 = z1;
            z_m2 = z2;
            
            % return measured outputs
            y = [z_m1,z_m2];
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