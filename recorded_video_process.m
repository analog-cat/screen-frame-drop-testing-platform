%extract frames from recored video

%put the file name of the video that is proceesed
videoFile = ('C0034.MP4');

%put the exctractrate (number of pics extracted per second)
extractrate = 50;

% Create a VideoReader object
v = VideoReader(videoFile);

% Calculate the interval between frames to match the desired frame rate
videoFrameRate = v.FrameRate;
frameInterval = round(videoFrameRate / extractrate);

% Create a directory to save the extracted frames
outputDir = 'extracted_frames';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

last_progress = 0;

% Initialize frame index
videoLengthInSeconds = v.Duration;

for frameIndex = 1:videoFrameRate*videoLengthInSeconds
    % Read the next frame
    frame = readFrame(v);
    
    % Save the frame if it matches the interval
    if mod(frameIndex, frameInterval) == 0
        % Construct the output filename
        outputFileName = sprintf('%s/frame_%05d.png', outputDir, frameIndex);
        % Save the frame as an image
        imwrite(frame, outputFileName);
    end
    
    % Increment the frame index
    %frameIndex = frameIndex + 1;
    progress = round(frameIndex/(videoFrameRate*videoLengthInSeconds)*100);
    if progress ~= last_progress
        disp(strcat('Generating: ', num2str(progress), '%'));
        last_progress = progress;
    end
end

disp('Frame extraction completed!');

