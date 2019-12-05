classdef massController
    % 
    %    This class inherits other controllers in order to organize multiple controllers.
    %
    %----------------------------
    properties
        zCtrl
        F_max
    end
    %----------------------------
    methods
        %----------------------------
        function self = massController(P)
            % Instantiates the SS_ctrl object
            % self.zCtrl = PDControl(P.kp, P.kd, P.F_max, P.beta, P.Ts);
            self.zCtrl = PIDControl(P.kp, P.ki, P.kd, P.F_max, P.beta, P.Ts);
            % plant parameters known to controller

            self.F_max = P.F_max;
        end
        %----------------------------
        function F = u(self, y_r, y)
            % y_r is the referenced input
            % y is the current state
            z_r = y_r;
            z = y(1);
            
            % linearized Force using PID 
            %F_tilde = self.zCtrl.PD(z_r, z,false);
            F_tilde = self.zCtrl.PID(z_r, z,false);
            
            
            % Total Force
            F = self.saturate(F_tilde);
        end
        
        function out = saturate(self, u)
            if abs(u) > self.F_max
                u = self.F_max * sign(u);
            end
            out = u;
        end
    end
end