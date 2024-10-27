%Generate test video

%set number of row and col
rows = 16;
cols = 30;

%set resolution
frameHeight = 1080;
frameWidth = 1920;

%set fps
framerate = 120;

%set video length (sec)
videolength = 5;
loop = videolength/(rows*cols*1/framerate);

% Create a video writer object
name = strcat(num2str(framerate),'fps_test_video.avi');
v = VideoWriter(name);
v.FrameRate = framerate;
open(v);

% Define the size of each grid
cellWidth = frameWidth / cols;
cellHeight = frameHeight / rows;

%colordisk
colordisk = [255 255 255; 255 255 255; 255 255 255; 255 255 255];

%generate a videohead 
headframe = zeros(frameHeight, frameWidth, 3, 'uint8');
headframe(1:frameHeight, 1:frameWidth, :) = 0;

for m = 1:framerate*3
    writeVideo(v, headframe);
end

%Generate frames
for k = 1:loop
    disky = 0;
    for m = 1:((rows*cols)/framerate)
        disky = disky + 1;
        for i = 1:framerate
            % Create a black frame
            frame = zeros(frameHeight, frameWidth, 3, 'uint8');

            % Determine the row and column for the current cell
            row = 4*(disky-1)+ceil(i / cols); %向上取整得出当前格子在第几行
            col = mod(i - 1, cols) + 1; % i - 1以确保每行最后一格不被归为第零列

            % Calculate the position of the rectangle
            xStart = (col - 1) * cellWidth + 1;
            yStart = (row - 1) * cellHeight + 1;
            xEnd = col * cellWidth;
            yEnd = row * cellHeight;

            % Set the rectangle area to white
            frame(yStart:yEnd, xStart:xEnd, 1) = colordisk(disky, 1);
            frame(yStart:yEnd, xStart:xEnd, 2) = colordisk(disky, 2);
            frame(yStart:yEnd, xStart:xEnd, 3) = colordisk(disky, 3);

            % Draw grid lines
            frame(1:frameHeight, 1:cellWidth:frameWidth, :) = 255; % Vertical lines
            frame(1:cellHeight:frameHeight, 1:frameWidth, :) = 255; % Horizontal lines

            % Write the frame to the video
            writeVideo(v, frame);
        end
    end
    disp(strcat('Generating: ', num2str(k*100/loop), '%'));
end
disp('Complete!')
close(v);