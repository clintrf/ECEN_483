classdef massController < handle
    % 
    %    This class inherits other controllers in order to organize multiple controllers.
    %
    %----------------------------
    properties
        z_dot
        z_d1
        K
        kr
        
        beta
        Ts
        limit
    end
    %----------------------------
    methods
        %----------------------------
        function self = massController(P)
            % initialized object properties
            self.z_dot = 0.0;
            self.z_d1 = 0.0;
            self.K = P.K;
            self.kr = P.kr;
            
            self.beta = P.beta;
            self.Ts = P.Ts;

            self.limit = P.F_max;
        end
        %----------------------------
        function F = u(self, y_r, y)
            % y_r is the referenced input
            % y is the current state
            z_r = y_r;
            z = y(1);
            
            % linearized Force using PID 
            %F_tilde = self.zCtrl.PD(z_r, z,false);
            F_e = 0;
            
            self.differentiateZ(z);
            
            x = [z; self.z_dot];
            
            F_tilde = -self.K*x + self.kr*z_r;
            
            
            % Total Force
            F = self.saturate(F_e + F_tilde);
        end
        %----------------------------
        function self = differentiateZ(self, z)
            self.z_dot = ...
                self.beta*self.z_dot...
                + (1-self.beta)*((z-self.z_d1) / self.Ts);
            self.z_d1 = z;
        end
        %----------------------------
        function out = saturate(self, u)
            if abs(u) > self.limit
                u = self.limit * sign(u);
            end
            out = u;
        end
    end
end