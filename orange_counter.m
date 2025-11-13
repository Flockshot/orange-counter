
% Main function, which returns the number of big Oranges and small Oranges.
function [bigOranges, smallOranges] = Assignment3(img)
    
    % Calling the segmentImage function with the input image.
    imgSegmented = segmentImage(img);
    % Calling the counting algorithm to count the number of oranges in the
    % segmented image.
    [bigOranges, smallOranges] = countOranges(imgSegmented);    

end


% Image segmentation function.
function imgSegmented = segmentImage(img)
    
    % Converting the rgb image to a gray image.
    imgGray = rgb2gray(img);
    % Finding the threshold value from 0-1 using Otsu's method.
    % Using Otsu's method since we can have imgages with different colors
    % which will give different threshold value, so to get that threshold
    % value we use otsu.
    threshold = graythresh(imgGray);
    % Multiplying by 255 since 255 is our Intensity.
    threshold = threshold * 255;
    
    % Segmenting image based on the threshold.
    imgSegmented = zeros(size(imgGray));
    imgSegmented(imgGray<=threshold) = 0;
    imgSegmented(imgGray>threshold) = 1;
    
    % Inverting the image, so that morphological operations apply correctly
    % on it.
    imgSegmented = not(imgSegmented);

    % Creating the figure showing all the steps performed in segmentation.
    figure();
    subplot(2,2,1), imshow(img), title("1: Original Image");
    subplot(2,2,2), imshow(imgGray), title("2: Conversion to Gray Image");
    subplot(2,2,3), imshow(not(imgSegmented)), title("3: Segmentation of Image");
    subplot(2,2,4), imshow(imgSegmented), title("4: Inversion of Segmentation");

end

% Couting algorithm function.
function [bigOrangesCount, smallOrangesCount] = countOranges(segmentedImg)
    
    % A disk structuring element to remove noise from the image, if any.
    S = strel('disk', 1);
    % Eroding the image to remove the noise, (Eroding since the image is inverted)
    E = imerode(segmentedImg, S);
    % Diliting the image to bring it back into its original form with
    % noise.
    D = imdilate(E, S);    
    % Filling the half peeled oranges completly, to help with counting.
    F = imfill(E, 'holes');

    % Finding out the connected components in the image.
    % Using connected components so that we can count how many circles there 
    % are in the picture, and then depending on the size of the circles
    % we can determine if its a big orange or a small orange.
    C = bwconncomp(F);
    
    % Finding the size of each connected component (No of pixels)
    orangeSize = cellfun(@numel,C.PixelIdxList);

    % Finding the max and min size of half peeled oranges and then taking
    % average to use a threshold measure to decide if an orange is big or
    % small.
    % Using this technique since the oranges differ by some pixels even if
    % they look the same size in image.
    biggestSize = max(orangeSize);
    smallestSize = min(orangeSize);
    midSize = (biggestSize+smallestSize)/2;
    
    % Count variable for oranges.
    bigOrangesCount = 0;
    smallOrangesCount = 0;
      
    % Looping through all the connected components
    for i=1 : C.NumObjects
        
        % Checking the size of the orange against the threshold value
        % decided (midSize), if greater then the orange is a big ornage, if
        % it is less then it is counted as a small orange.
        if(orangeSize(i)>=midSize)
            bigOrangesCount = bigOrangesCount+1;
        else
            smallOrangesCount = smallOrangesCount+1;
        end        
    end
    
    % Defining an empty image to show the number on figure.
    emptyImg = zeros([128 128]);

    % Creating the figure to show the final image after morphological
    % operations, and then showing the number of big and small oranges as
    % number in an image.
    figure();
    subplot(2,3,1), imshow(D), title("5: Dilating the Image");
    subplot(2,3,2), imshow(E), title("6: Eroding the Image");
    subplot(2,3,3), imshow(F), title("Final: Filling the Image");    
    subplot(2,3,4), imshow(emptyImg), title("Number of Big Oranges:"),
    % sprintf is used to convert the double value of oranges count to
    % string
    caption = sprintf('%d', bigOrangesCount);
    % text is used to display the text on the empty image, the text will be
    % of the count of oranges, either big or small.
    text(128/2-5, 128/2, caption, 'FontSize', 50, 'Color', [1,1,1]);
    subplot(2,3,5), imshow(emptyImg), title("Number of Small Oranges:"),
    caption = sprintf('%d', smallOrangesCount);
    text(128/2-5, 128/2, caption, 'FontSize', 50, 'Color', [1,1,1]);

end
