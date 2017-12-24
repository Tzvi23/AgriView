%Calculate Using User values
%Input : masked RGB Image after filtering by color
%Ouptu : precntage of the colors
function [answer] = calculateUserValues (maskedRGBImage,RedMin,RedMax,GreenMin,GreenMax,BlueMin,BlueMax)
        
        if RedMin == -2 && RedMax == -2 && GreenMin == -2 && GreenMax == -2 && BlueMin == -2 && BlueMax == -2
            warndlg('Error! User Values Not entered || ANALYZE FAIL');
            answer = -1;
            return
        end
        
        binaryR = (maskedRGBImage(:,:,1) >= RedMin & maskedRGBImage(:,:,1) <= RedMax);
        binaryG = (maskedRGBImage(:,:,2) <= GreenMax & maskedRGBImage(:,:,2) >= GreenMin);
        binaryB = (maskedRGBImage(:,:,3) <= BlueMax & maskedRGBImage(:,:,3) >= BlueMin) ;

        binaryImage = binaryR & binaryG & binaryB;
        CountPixel = sum(binaryImage(:));
        
        subplot(3,3,9)
        imshow(binaryImage)
        fontSize = 8;
        title('Binary Picture', 'FontSize', fontSize);
        
        grayscale = rgb2gray(maskedRGBImage);
        bw = imbinarize(grayscale);
        subplot(3,3,6)
        imshow(bw)
        fontSize = 8;
        title('BW', 'FontSize', fontSize);
        numberOfPixels = sum(bw(:));   

        answer = CountPixel/numberOfPixels*100;
end