classdef drnController < handle
    properties
        mixing
        Fe
        
        K_lon
        K_lat
        kr_lon
        kr_lat
        
        limit
        beta
        Ts
        
        z_dot
        h_dot
        th_dot
        
        z_d1
        h_d1
        th_d1
        
    end
    methods
        function self = drnController(P)
            self.Fe = P.Fe;
            self.mixing = P.mixing;
            
            self.K_lon = P.K_lon;
            self.K_lat = P.K_lat;
            self.kr_lon = P.kr_lon;
            self.kr_lat = P.kr_lat;
            
            self.h_dot = 0.0;
            self.z_dot = 0.0;
            self.th_dot = 0.0;
            
            self.z_d1 = 0.0;
            self.h_d1 = 0.0;
            self.th_d1 = 0.0;
            
            self.limit = P.F_max;
            self.beta = P.beta;
            self.Ts = P.Ts;


        end
        function out = u(self,r,y)
            z_r = r(1);
            h_r = r(2);
            z = y(1);
            h = y(2);
            theta = y(3);
            
            self.differentiateZ(z);
            self.differentiateH(h);
            self.differentiateTheta(theta);
            
            z_lon = [h; self.h_dot];
            F_e = self.Fe/cos(theta);
            
            F_tilde = -self.K_lon*z_lon + self.kr_lon*h_r;
            F = F_e + F_tilde;
            
            z_lat = [z; theta; self.z_dot; self.th_dot];
            
            tau = -self.K_lat*z_lat + self.kr_lat*z_r;
            
            out = [F; tau];
            
            
            %F_tilde = self.hCtrl.PID(h_r,h,false);
            %theta_ref = self.zCtrl.PID(z_r,z, false);
            %tau = self.thetaCtrl.PID(theta_ref, theta, false);
            %F = F_tilde + self.Fe;
            
            %out = [F;tau];
            
            %u = self.mixing*out;
            %u(1) = self.thetaCtrl.saturate(u(1));
            %u(2) = self.thetaCtrl.saturate(u(2));
            %out = inv(self.mixing)*u;
        end
        %----------------------------
        function self = differentiateZ(self, z)
            self.z_dot = ...
                self.beta*self.z_dot...
                + (1-self.beta)*((z - self.z_d1) / self.Ts);
            self.z_d1 = z;            
        end
        %----------------------------
        function self = differentiateH(self, h)
            self.h_dot = ...
                self.beta*self.h_dot...
                + (1-self.beta)*((h - self.h_d1) / self.Ts);
            self.h_d1 = h;            
        end
        %----------------------------
        function self = differentiateTheta(self, theta)
            self.th_dot = ...
                self.beta*self.th_dot...
                + (1-self.beta)*((theta - self.th_d1) / self.Ts);
            self.th_d1 = theta;            
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
