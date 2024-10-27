% remix the extracted frame into one picture

% put resolution of *TEST_VIDEO*
frameHeight = 1088;
frameWidth = 1920;

% put number of row and col of *TEST VIDEO*
rows = 16;
cols = 30;

cellWidth = frameWidth / cols;
cellHeight = frameHeight / rows;
outimg = zeros(frameHeight, frameWidth, 3, 'uint8');
outimg(1:frameHeight, 1:cellWidth:frameWidth, :) = 255; % Vertical lines
outimg(1:cellHeight:frameHeight, 1:frameWidth, :) = 255; % Horizontal lines

% specify the folder
readfromDir = 'extracted_frames';

% read img files from folder
imageFiles = dir(fullfile(readfromDir, '*.png'));

last_progress = 0;

% Traverse every img file
for k = 1:length(imageFiles)
    % generate the full file path of each img file
    baseFileName = imageFiles(k).name;
    fullFileName = fullfile(readfromDir, baseFileName);

    % convert from rgb to gray file
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

%draw grid lines
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