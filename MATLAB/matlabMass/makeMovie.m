classdef makeMovie < handle
    properties
        image_array = struct('cdata',[600 600 3] , 'colormap',[])
        count
        title
    end
    
    methods
        function self = makeMovie(P)
            self.count = 0;
            self.title = P.title;
        end
        
        function self = finalizeMovie(self)
            video = VideoWriter(self.title, 'MPEG-4');
            
            video.FrameRate = 8;
            video.Quality = 100;
            open(video)
            writeVideo(video, self.image_array)
            close(video)
        end
        
        function self = addFrame(self, current_fig)
            self.count = self.count + 1;
            rect = get(current_fig, 'Position');
            rect(1:2) =  [0 0];
            self.image_array(:,self.count)= getframe(current_fig, rect);
        end
    end
end
