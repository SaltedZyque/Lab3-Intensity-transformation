%% Task 1 - imadjust
clear all
close alla
f_info = imfinfo('assets/breastXray.tif');
f = imread('assets/breastXray.tif');
imshow(f)

% Reading Intensity Information
f(3,10) % intensity of specific point
[fmin,fmax] = bounds(f(:));

% Slicing image in half
figure
imshow(f(1:285,:))
title('Slice Image horizontally f(1:285, :)')

figure 
imshow(f(:, 241:482))
title('Slice Image vertically f(:, 241:482)')

% Negative Image
g1 = imadjust(f, [0 1], [1 0]);
figure                         
imshowpair(f, g1, 'montage')
title('Intensity Inversion')

% Gamma Correct
g2 = imadjust(f, [0.5 0.75], [0 1]);
g3 = imadjust(f, [ ], [ ], 2);
figure
montage({g2,g3})
title('Gamma Correction')

%% Task 2 - Contrast Stretching Transformation

clear all       % clear all variables
close all       % close all figure windows
f = imread('assets/bonescan-front.tif');
r = double(f);  % uint8 to double conversion
k = mean2(r);   % find mean intensity of image
E = 0.9;
s = 1 ./ (1.0 + (k ./ (r + eps)) .^ E);
g = uint8(255*s);
imshowpair(f, g, "montage")
title('Constrast Stretching')

%% Task 3 - Histogram contrast enhancement

clear all       % clear all variable in workspace
close all       % close all figure windows
f=imread('assets/pollen.tif');
imshow(f)
figure          % open a new figure window
imhist(f);      % calculate and plot the histogram

g=imadjust(f,[0.3 0.55]);
figure
montage({f, g})     % display list of images side-by-side
figure
imhist(g);
title('Stretching with imadjust')

g_pdf = imhist(g) ./ numel(g);  % compute PDF
g_cdf = cumsum(g_pdf);          % compute CDF
figure
subplot(1,2,1)                  % plot 1 in a 1x2 subplot
plot(g_pdf)
title('PDF')
subplot(1,2,2)                  % plot 2 in a 1x2 subplot
plot(g_cdf)
title('CDF')

x = linspace(0, 1, 256);    % x has 256 values equally spaced between 0 and 1
figure
plot(x, g_cdf)
axis([0 1 0 1])             % graph x and y range is 0 to 1
set(gca, 'xtick', 0:0.2:1)  % x tick marks are in steps of 0.2
set(gca, 'ytick', 0:0.2:1)
xlabel('Input intensity values', 'fontsize', 9)
ylabel('Output intensity values', 'fontsize', 9)
title('Transformation function', 'fontsize', 12)

h = histeq(g,256);              % histogram equalize g
figure
montage({f, g, h})
title('Comparing Two Intensity Stretching Methods')
figure;
subplot(1,3,1); imhist(f);
title('Original')
subplot(1,3,2); imhist(g);
title('imadjust')
subplot(1,3,3); imhist(h);
title('CDF')

%% 4 - Lowpass Noise Reduction

clear all
close all
f = imread('assets/noisyPCB.jpg');
imshow(f)

w_box = fspecial('average', [9 9]);
w_gauss = fspecial('Gaussian', [7 7], 1.0);

g_box = imfilter(f, w_box, 0);
g_gauss = imfilter(f, w_gauss, 0);
figure
montage({f, g_box, g_gauss})
title('Comparing box and gaussian filter')

%% 5 - Median Filtering

g_median = medfilt2(f, [7 7], 'zero');
figure; 
montage({f, g_median})
title('Median Filtering')

%% 6 - Other filters

clear all
close all
f = imread('assets/moon.tif');
imshow(f)
title('Original Moon Image')

w_lapla = fspecial('laplacian', 0.5); % 0.5 is the default alpha
w_sobel = fspecial('sobel'); 
w_unsharp = fspecial('unsharp', 0.2); % 0.2 is the default alpha

g_lapla = imfilter(f, w_lapla, 0);
g_sobel = imfilter(f, w_sobel, 0);
g_unsharp = imfilter(f, w_unsharp, 0);

figure;
montage({f,g_lapla,g_sobel,g_unsharp})
title('Original vs Laplacian vs Sobel vs Unsharp')