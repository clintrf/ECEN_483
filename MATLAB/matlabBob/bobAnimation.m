classdef bobAnimation < handle
    %MASSANIMATION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        ball_handle
        beam_handle
        
        length
        radius
    end
    
    methods
        function self = bobAnimation(P)
            self.length = P.length;
            self.radius = P.radius;
            
            figure(1), clf
            plot([0,P.length],[0,0],'k-');
            
            hold on
           
            %plot([0,0],[0,2*self.length],'k-');
                        
            self = self.drawBall(P.z0, P.theta0);
            self = self.drawBeam(P.theta0);
            
            axis([-1*P.length/5, P.length + P.length/5,...
                -P.length, P.length]);
            
        end
        
        function self = drawBob(self, u)
            z= u(1);        % Horizontal position of cart, m
            theta = u(2);   % Angle of pendulum, rads
            self = self.drawBall(z,theta);
            self = self.drawBeam(theta);
                        
            drawnow
        end
        
        function self = drawBall(self, z, theta)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            N = 20;
            
            xi = 0:(2*pi/N):2*pi;
            X = z*cos(theta) - self.radius*sin(theta) + self.radius*cos(xi);
            Y = z*sin(theta) + self.radius*cos(theta) + self.radius*sin(xi);
            
            
%            center = [...
%                z + (self.ballRadius)*sin(theta),...
%                self.beamHeight+(self.ballRadius)*cos(theta)...
%                ];
%            ballPts = [self.ballRadius*cos(th)', self.ballRadius*sin(th)'];
%            
%            xp = zeros(divider0,2);
%            xp(:,1) = self.ballRadius/(4*pi) + self.beamLength/2;
%            
%            yp = zeros(divider0,2);
%            yp(:,2) = self.ballRadius*1.1;
%            
%            
%            
%            zp = zeros(divider0,2);
%            zp(:,1) =  z;
%            
%            ballPts = ballPts + xp + yp +zp ;
%            
%            R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
%            
%            ballPts = R*ballPts.';
%            ballPts = ballPts.';
            
            
            if isempty(self.ball_handle)
                self.ball_handle = fill(X,Y,'g');
            else
                set(self.ball_handle,'XData', X, 'YData', Y);
            end 
        end
        function self = drawBeam(self,theta)
            %METHOD1 Summary of this method goes here
            
            X = [0, self.length*cos(theta)];
            Y = [0, self.length*sin(theta)];
            

            
 %           beamPts = [...
 %               0, 0;...
 %               self.beamLength, 0;...
%                self.beamLength, -self.beamHeight;...
%                0, -self.beamHeight;...
%                ]';
%            R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
%            beamPts = R*beamPts;

            if isempty(self.beam_handle)
                self.beam_handle = fill(X, Y, 'g', 'Linewidth' , 2);
            else
                set(self.beam_handle, 'XData', X, 'YData', Y);
            end
        end
    end
end



