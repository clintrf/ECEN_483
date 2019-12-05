classdef bobController < handle
    properties
        m1
        m2
        g
        length
        
        theta_dot
        z_dot
        theta_d1
        z_d1
        K
        kr
        limit
        beta
        Ts
        
    end
    %----------------------------
    methods
        %----------------------------
        function self = bobController(P)            
            self.m1 = P.m1;
            self.m2 = P.m2;
            self.g = P.g;
            self.length = P.length;
            
            self.theta_dot = 0.0;
            self.z_dot = 0.0;
            self.theta_d1 = 0.0;
            self.z_d1 = 0.0;
            self.K = P.K;
            self.kr = P.kr;
            self.limit = P.F_max;
            self.beta = P.beta;
            self.Ts = P.Ts;


        end
        %----------------------------
        function F = u(self, y_r, y)
            % y_r is the referenced input
            % y is the current state
            z_r = y_r;
            z = y(1);
            theta = y(2);
            
            self.differentiateTheta(theta);
            self.differentiateZ(z);
            
            z_e = self.length/2;
            % Construct the state
            %x = [theta; z; self.theta_dot; self.z_dot;];
            %x = [theta; z-z_e; self.theta_dot; self.z_dot; ];
            
            z_tilde = [theta; z-z_e; self.theta_dot; self.z_dot; ];
            
            %Fe = self.m1*self.g*(z/self.length) +self.m2*self.g/2;
            F_e = self.m1*self.g*(z_e/self.length) +self.m2*self.g/2;
            % Compute the state feedback controller
            zr_tilde = z_r - z_e;
            F_tilde = -self.K*z_tilde + self.kr*zr_tilde;
            
            %F_unsat = -self.K*x + self.kr*z_r;
            F_unsat = F_tilde + F_e;
            %F_sat = self.saturate(F_unsat +Fe);
            F_sat = self.saturate(F_unsat);
            F = F_sat;
            
            
        end
                %----------------------------
        function self = differentiateZ(self, z)
            self.z_dot = ...
                self.beta*self.z_dot...
                + (1-self.beta)*((z - self.z_d1) / self.Ts);
            self.z_d1 = z;            
        end
        %----------------------------
        function self = differentiateTheta(self, theta)
            self.theta_dot = ...
                self.beta*self.theta_dot...
                + (1-self.beta)*((theta-self.theta_d1) / self.Ts);
            self.theta_d1 = theta;
        end
        %----------------------------
        function out = saturate(self,u)
            if abs(u) > self.limit
                u = self.limit*sign(u);
            end
            out = u;
        end
    end
end