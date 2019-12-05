classdef drnAnimation < handle
    %MASSANIMATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        drone_handle
        target_handle
        
    end
    
    methods
        function self = drnAnimation(P)

            figure(1), clf
            plot([0,P.length],[0,0],'k');
            hold on
            
            self = self.drawDrone(P.z0, P.h0,P.theta0);
            self = self.drawTarget(P.target0);
            
            axis([-P.length/5, P.length+P.length/5, ...
                -P.length, P.length]);
            
        end
        
        function self=drawDrn(self, x,target)
            z = x(1);
            h = x(2);
            theta = x(3);
            self = self.drawDrone(z, h, theta);
            self = self.drawTarget(target);
            drawnow
            
        end
        
        function self = drawDrone(self, z, h, theta)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            x1 = 0.1;
            x2 = 0.3;
            x3 = 0.4;
            y1 = 0.05;
            y2 = 0.01;
            pts = [...
                x1,y1;...
                x1,0;...
                x2,0;...
                x2,y2;...
                x3,y2;...
                x3,-y2;...
                x2,-y2;...
                x2,0;...
                x1,0;...
                x1,-y1;...
                -x1,-y1;...
                -x1,0;...
                
                -x2,0;...
                -x2,-y2;...
                -x3,-y2;...
                -x3,y2;...
                -x2,y2;...
                -x2,0;...
                -x1,0;...
                -x1,y1;...
                x1,y1;...
                ];
            R = [cos(theta), sin(theta); -sin(theta), cos(theta)];
            pts = pts*R;
            pts = pts + repmat([z,h],size(pts,1),1);
            
            if isempty(self.drone_handle)
                self.drone_handle = fill(pts(:,1),pts(:,2),'b');
            else
                set(self.drone_handle,'XData',pts(:,1),'YData',pts(:,2));
            end 
        end
        
        function self = drawTarget(self, target)
            w = .5;
            h = 0.4;
            pts = [...
                w/2, h;...
                w/2, 0;...
                -w/2, 0;...
                -w/2, h;...
                w/2,h;...
                ];
            pts = pts +repmat([target,0], size(pts,1),1);

            if isempty(self.target_handle)
                self.target_handle = fill(pts(:,1),pts(:,2),'r');
            else
                set(self.target_handle,'XData',pts(:,1),'YData',pts(:,2));
            end
        end
    end
end



