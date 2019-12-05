classdef dMassController < handle
    % 
    %    This class inherits other controllers in order to organize multiple controllers.
    %
    %----------------------------
    properties
        z1_dot
        z1_d1
        z2_dot
        z2_d1
        
        K
        kr
        
        beta
        Ts
        %limit
    end
    %----------------------------
    methods
        %----------------------------
        function self = dMassController(P)
            % initialized object properties
            self.z1_dot = 0.0;
            self.z1_d1 = 0.0;
            
            self.z2_dot = 0.0;
            self.z2_d1 = 0.0;
            
            self.K = P.K;
            self.kr = P.kr;
            
            self.beta = P.beta;
            self.Ts = P.Ts;

            %self.limit = P.F_max;
        end
        %----------------------------
        function F = u(self, y_r, y)
            % y_r is the referenced input
            % y is the current state
            z_r = y_r;
            x1 = y(1);
            
            x2 = y(2);
            
            
            
            % linearized Force using PID 
            %F_tilde = self.zCtrl.PD(z_r, z,false);
            F_e = 0;
            
            self.differentiateZ1(x1);
            self.differentiateZ2(x2);
            
            x = [x1;...
                self.z1_dot;...
                x2-x1;...
                self.z2_dot-self.z1_dot];
            
            F_tilde = -self.K*x + self.kr*z_r;
            
            
            % Total Force
            F = F_e + F_tilde;
        end
        %----------------------------
        function self = differentiateZ1(self, z)
            self.z1_dot = ...
                self.beta*self.z1_dot...
                + (1-self.beta)*((z-self.z1_d1) / self.Ts);
            self.z1_d1 = z;
        end
        %----------------------------
        function self = differentiateZ2(self, z)
            self.z2_dot = ...
                self.beta*self.z2_dot...
                + (1-self.beta)*((z-self.z2_d1) / self.Ts);
            self.z2_d1 = z;
        end
        %----------------------------
        function out = saturate(self, u)
            out = u;
        end
    end
end