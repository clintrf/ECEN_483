classdef plotData < handle
    %    This class plots the time histories for the pendulum data.
    %----------------------------
    properties
        % data histories
        time_history
        z_ref_history
        z_history
        z2_ref_history
        z2_history
        F_history
        index
        % figure handles
        z_ref_handle
        z_handle
        z2_ref_handle
        z2_handle
        F_handle
    end
    methods
        %--constructor--------------------------
        function self = plotData(P)
            % Instantiate lists to hold the time and data histories
            self.time_history = NaN*ones(1,(P.t_end-P.t_start)/P.t_plot);
            self.z_ref_history = NaN*ones(1,(P.t_end-P.t_start)/P.t_plot);
            self.z_history = NaN*ones(1,(P.t_end-P.t_start)/P.t_plot);
            
            self.z2_ref_history = NaN*ones(1,(P.t_end-P.t_start)/P.t_plot);
            self.z2_history = NaN*ones(1,(P.t_end-P.t_start)/P.t_plot);
            
            self.F_history = NaN*ones(1,(P.t_end-P.t_start)/P.t_plot);
            self.index = 1;

            % Create figure and axes handles
            figure(1), clf
            subplot(3, 1, 1)
                hold on
                self.z_ref_handle = plot(self.time_history, self.z_ref_history, 'g');
                self.z_handle    = plot(self.time_history, self.z_history, 'b');
                ylabel('z1(m)')
                title('Mass1 Data')
            subplot(3, 1, 2)
                hold on
                self.z2_ref_handle = plot(self.time_history, self.z_ref_history, 'g');
                self.z2_handle    = plot(self.time_history, self.z_history, 'b');
                ylabel('z2(m)')
                title('Mass2 Data')
            subplot(3, 1, 3)
                hold on
                self.F_handle    = plot(self.time_history, self.F_history, 'b');
                ylabel('Force(N-m)')
                title('Force Data')
        end
        %----------------------------
        function self = updatePlots(self, t, reference, states, ctrl)
            % update the time history of all plot variables
            self.time_history(self.index) = t;
            self.z_ref_history(self.index) = reference;%180/pi*reference;
            self.z_history(self.index) = states(1);%180/pi*states(1);
            
            self.z2_ref_history(self.index) = reference;%180/pi*reference;
            self.z2_history(self.index) = states(3);%180/pi*states(1);
            
            self.F_history(self.index) = ctrl;
            self.index = self.index + 1;
            
            % update the time history of all plot variables



            % update the plots with associated histories
            
            set(self.z2_ref_handle, 'Xdata', self.time_history, 'Ydata', self.z2_ref_history)
            set(self.z2_handle, 'Xdata', self.time_history, 'Ydata', self.z2_history)
            set(self.z2_handle, 'Xdata', self.time_history, 'Ydata', self.z2_history)
            
            
            set(self.z_ref_handle, 'Xdata', self.time_history, 'Ydata', self.z_ref_history)
            set(self.z_handle, 'Xdata', self.time_history, 'Ydata', self.z_history)
            set(self.z_handle, 'Xdata', self.time_history, 'Ydata', self.z_history)
            set(self.F_handle, 'Xdata', self.time_history, 'Ydata', self.F_history)
        end
    end
end
