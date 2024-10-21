%黑卡视频抓帧
% Specify the video file and frame rate
framerate = 120; 
%videoFile = strcat(num2str(framerate),'fps测试视频.avi');
videoFile = ('C0034.MP4');
extractrate = 50;

% Create a VideoReader object
v = VideoReader(videoFile);

% Calculate the interval between frames to match the desired frame rate
videoFrameRate = v.FrameRate;
frameInterval = round(videoFrameRate / extractrate);

% Create a directory to save the extracted frames
outputDir = 'extracted_frames_2';
if ~exist(outputDir, 'dir')
    mkdir(outputDir);
end

last_progress = 0;

% Initialize frame index
%frameIndex = 0;
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

%%
%抓帧图片合成（逐格处理）
frameHeight = 1088;
frameWidth = 1920;
rows = 16;
cols = 30;
cellWidth = frameWidth / cols;
cellHeight = frameHeight / rows;
outimg = zeros(frameHeight, frameWidth, 3, 'uint8');
outimg(1:frameHeight, 1:cellWidth:frameWidth, :) = 255; % Vertical lines
outimg(1:cellHeight:frameHeight, 1:frameWidth, :) = 255; % Horizontal lines



% 指定读取照片的文件夹
readfromDir = 'extracted_frames';

% 获取文件夹中的所有PNG文件
imageFiles = dir(fullfile(readfromDir, '*.png'));

last_progress = 0;

% 遍历每一个文件
for k = 1:length(imageFiles)
    % 获取当前文件的完整路径
    baseFileName = imageFiles(k).name;
    fullFileName = fullfile(readfromDir, baseFileName);

    % 读取图像文件
    current_image = rgb2gray(imread(fullFileName));

    row = 1;
    for m = round(cellHeight/2):round(cellHeight):frameHeight
        col = 1;
        for n = round(cellWidth/2):round(cellWidth):frameWidth
            xStart = (col - 1) * round(cellWidth) + 1;
            yStart = (row - 1) * round(cellHeight) + 1;
            xEnd = col * round(cellWidth);
            yEnd = row * round(cellHeight);
            if current_image(m, n) >= 210
                outimg(yStart:yEnd, xStart:xEnd, :) = 255;
            end
            col = col + 1;
        end
        row = row + 1;
    end

    progress = round(k/length(imageFiles)*100);
    if progress ~= last_progress
        disp(strcat('Generating: ', num2str(progress), '%'));
        last_progress = progress;
    end
end
%画格子线
linewidth = 3;
for gridH = 1:4*cellHeight:frameHeight
    outimg(gridH:(gridH+linewidth), 1:frameWidth, 1) = 255;
    outimg(gridH:(gridH+linewidth), 1:frameWidth, 2) = 0;
    outimg(gridH:(gridH+linewidth), 1:frameWidth, 3) = 0;
end
outimg((frameHeight-linewidth):frameHeight, 1:frameWidth, 1) = 255;
outimg((frameHeight-linewidth):frameHeight, 1:frameWidth, 2) = 0;
outimg((frameHeight-linewidth):frameHeight, 1:frameWidth, 3) = 0;

outimg(1:frameHeight, 1:linewidth, 1) = 255;
outimg(1:frameHeight, 1:linewidth, 2) = 0;
outimg(1:frameHeight, 1:linewidth, 3) = 0;
outimg(1:frameHeight, (frameWidth-linewidth):frameWidth, 1) = 255;
outimg(1:frameHeight, (frameWidth-linewidth):frameWidth, 2) = 0;
outimg(1:frameHeight, (frameWidth-linewidth):frameWidth, 3) = 0;

imwrite(outimg, 'outimg.png');
disp('Frame process completed!');