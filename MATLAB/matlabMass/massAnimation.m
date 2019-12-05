classdef massAnimation < handle
    %MASSANIMATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mass_handle
        length
        width
    end
    
    methods
        function self = massAnimation(P)
            self.length = P.length;
            self.width = P.width;
            
            figure(1), clf
            hold on
            %plot([0,2*self.length],[0,0],'k-');
            %plot([0,0],[0,2*self.width],'k-');
            %plot([0,-self.width],[0, -self.width],'k-');
            
                        
            plot([0,0],[-P.length, -2*self.length],'k-');
            plot([-P.length,3*self.length],[0,0],'k-');
            plot([-P.length, -P.length], [0,2*P.width],'k');
            
            self.drawMass(P.z0)
            axis([-P.length-P.length/5, 2*P.length, -1*P.length, 2*P.length]);
            
        end
        
        function self = drawMass(self,x)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            z = x(1);
            
            X = [z-self.width/2, z+self.width/2, z+self.width/2,z-self.width/2];
            Y = [0,0,self.width, self.width];
            
            
%            pts = [...
%                0, 0;...
%                self.length, 0;...
%                self.length, self.height;...
%                0, self.height;...
%                ]';
%            pts = pts + [...
%                1.5,0;...
%                1.5,0;
%                1.5,0;
%                1.5,0].';
%            %R = [cos(z), -sin(z); sin(z), cos(z)];
%            %pts = R*pts;
%            pts = pts+ [...
%                z,0;...
%                z,0;
%                z,0;
%                z,0].';
%            
%            if isempty(self.mass_handle)
%                self.mass_handle = fill(pts(1,:), pts(2,:), 'b');
%            else
%                set(self.mass_handle, 'XData', pts(1,:), 'YData', pts(2,:));
%                drawnow
%            end
            
            if isempty(self.mass_handle)
                self.mass_handle = fill(X, Y, 'b');
            else
                set(self.mass_handle, 'XData', X, 'YData', Y);
                drawnow
            end
            
        end
    end
end



