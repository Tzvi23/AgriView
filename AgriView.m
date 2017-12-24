function AgriView()
%Authors: Tzvi Puchinsky,Elad Ben Avraham,Michael Afonin,Alla Kitaeva
choice = 99;
fullImageFileName = 0;
%Loads aprroved+rejected+fail+logo pictures
Approved = imread('approved.jpg');
Rejected = imread('rejected.jpg');
Fail = imread('Fail-Stamp.png');
welcome = imread('AgriViewLogo.png');
%Load Password
Password = 'agriview';

%%Welcome Window
h = figure;
subplot(1,1,1);
imshow(welcome);
uiwait(h,3);%Sets time delay of 3
close;

figure('units','normalized','outerposition',[0 0 1 1]);%maximize figure window
%%loads Personal Parameters to matrix PersonalStats
%         RedMax RedMin GreenMax GreenMin BlueMax BlueMin
% Banana    0      0       0        0        0       0
% Orange    0      0       0        0        0       0
% Apple     0      0       0        0        0       0
% Tomato    0      0       0        0        0       0

filenamePersonalStats = 'PersonalParameters.xlsx';
PersonalStats = xlsread(filenamePersonalStats);

%%Statistics Values Matrix
%            Tests  Pass   Fail
%     Apple    0      0      0     
%     Banana   0      0      0     
%     Orange   0      0      0     
%     Tomato   0      0      0  
filenameStats = 'statistics.xlsx';
Statistics = xlsread(filenameStats);
%Statistics = [0 0 0 ;0 0 0 ; 0 0 0 ; 0 0 0 ];
while choice ~= 6
    %%Main Menu
    choice = menu('Choose Function','Take photo & Save File','Choose File','analyze','Change Parameters','Statistics','Exit');
    switch choice
        case 2 %Choose File
        %% Pick Image
        [baseFileName, folder] = uigetfile('*.*', 'Specify an image file'); 
        fullImageFileName = fullfile(folder, baseFileName); 
        if fullImageFileName ~= 0
        %% Display Image
            fontSize = 12;
            subplot(3,3,1);
            imshow(fullImageFileName);
            title('Original Image','FontSize',fontSize);
        end
        case 1 %Take Photo
        %% Video Aqcuisition
        vid = videoinput('winvideo', 1, 'YUY2_1024x576');
        src = getselectedsource(vid);
        vid.FramesPerTrigger = 1;

        vid.ReturnedColorspace = 'rgb';

        vid.FramesPerTrigger = 50;

        preview(vid);
        
        %MsgBox to adjust camera
        uiwait(msgbox('Press Ok when Ready to Continue'));
        
        start(vid);
        
        %Takes 50 frames pictures and takes the 49 frame as picture
        ImageTest = getdata(vid);
        data = ImageTest(:,:,:,49);
        subplot(3,3,7);
        imshow(data);
        fontSize = 12;
        title('Last Captured Image', 'FontSize', fontSize);
        stoppreview(vid);
        closepreview;
        
        %Prompts User FileName Input
        filename = inputdlg('Enter File Name:','Enter FileName:',1,{'*********.jpg'});
        if ~(isequal(filename,{}))
            filename = strcat(filename{1});
            imwrite(data,filename);
        else
            warndlg('Pressed Cancel -  File didnt save');
        end

        case 3 %Analyze
            if (fullImageFileName ~= 0)
            %default font size  
            fontSize = 12;
            %% Read Image
            [rgbImage] = imread(fullImageFileName);

            %% Display Image
            subplot(3,3,1); 
            imshow(rgbImage);
            title('Original Image','FontSize',fontSize);

            %% convert RGB Image to HSV
            %H - Hue S - Saturation V - Value
            hsvImage = rgb2hsv(rgbImage);
            % Extract out the H, S, and V images individually
            hImage = hsvImage(:,:,1);
            sImage = hsvImage(:,:,2);
            vImage = hsvImage(:,:,3);

            % Display the hue image.
            subplot(3,3,2);
            imshow(sImage);
            title('Saturation', 'FontSize', fontSize);
            subplot(3,3,5);
            imshow(hImage);
            title('Hue', 'FontSize', fontSize);
            subplot(3,3,8);
            imshow(vImage);
            title('Value', 'FontSize', fontSize);

            [hueThresholdLow, hueThresholdHigh, saturationThresholdLow, saturationThresholdHigh, valueThresholdLow, valueThresholdHigh,button] = SetThresholds();
            % Now apply each color band's particular thresholds to the color band
                hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
                saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
                valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);

            % Combine the masks to find where all 3 are "true."
                % Then we will have the mask of only the red parts of the image.
                coloredObjectsMask = uint8(hueMask & saturationMask & valueMask);

                coloredObjectsMask = cast(coloredObjectsMask, 'like', rgbImage); 

                % Use the colored object mask to mask out the colored-only portions of the rgb image.
                maskedImageR = coloredObjectsMask .* rgbImage(:,:,1);
                maskedImageG = coloredObjectsMask .* rgbImage(:,:,2);
                maskedImageB = coloredObjectsMask .* rgbImage(:,:,3);   
                % Concatenate the masked color bands to form the rgb image.
                maskedRGBImage = cat(3, maskedImageR, maskedImageG, maskedImageB);
                subplot(3,3,4);
                imshow(maskedRGBImage);
                fontSize = 12;
                title('After Thresholds', 'FontSize', fontSize);
            %% Precentage
                choice = menu('Choose Paramaters:','Default','Personal');
                switch choice
                    case 1
                        [answer,fruitType] = calculate(maskedRGBImage,button);
                        
                        switch fruitType
                            case 1
                                    Statistics(2,1) = Statistics(2,1) + 1;
                                    if answer >= 75
                                    Statistics(2,2) = Statistics(2,2) + 1;
                                    else
                                        Statistics(2,3) = Statistics(2,3) + 1;
                                    end
                            case 2
                                    Statistics(3,1) = Statistics(3,1) + 1;
                                    if answer >= 75
                                    Statistics(3,2) = Statistics(3,2) + 1;
                                    else
                                        Statistics(3,3) = Statistics(3,3) + 1;
                                    end
                            case 3
                                    Statistics(1,1) = Statistics(1,1) + 1;
                                    if answer >= 75
                                    Statistics(1,2) = Statistics(1,2) + 1;
                                    else
                                        Statistics(1,3) = Statistics(1,3) + 1;
                                    end
                            case 4
                                    Statistics(4,1) = Statistics(4,1) + 1;
                                    if answer >= 75
                                    Statistics(4,2) = Statistics(4,2) + 1;
                                    else
                                        Statistics(4,3) = Statistics(4,3) + 1;
                                    end
                        end
                        
                    case 2
                        ChoiceFruit = menu('Choose Fruit','Yellow Banana','Ornage','Red Apple','Red Tomato','cancel');
                        switch ChoiceFruit
                            %Yellow Banana
                            case 1
                                [answer] = calculateUserValues (maskedRGBImage,PersonalStats(1,2),PersonalStats(1,1),PersonalStats(1,4),PersonalStats(1,3),PersonalStats(1,6),PersonalStats(1,5));
                                if answer ~= -1
                                    Statistics(2,1) = Statistics(2,1) + 1;
                                    if answer >= 75
                                        Statistics(2,2) = Statistics(2,2) + 1;
                                    else
                                        Statistics(2,3) = Statistics(2,3) + 1;
                                    end
                                end
                            %Orange
                            case 2
                                [answer] = calculateUserValues (maskedRGBImage,PersonalStats(2,2),PersonalStats(2,1),PersonalStats(2,4),PersonalStats(2,3),PersonalStats(2,6),PersonalStats(2,5));
                                    Counter_Test_Orange = Counter_Test_Orange + 1;
                                if answer ~= -1
                                        Statistics(3,1) = Statistics(3,1) + 1;
                                    if answer >= 75
                                        Statistics(3,2) = Statistics(3,2) + 1;
                                    else
                                        Statistics(3,3) = Statistics(3,3) + 1;
                                    end
                                end
                            %Red Apple
                            case 3
                                [answer] = calculateUserValues (maskedRGBImage,PersonalStats(3,2),PersonalStats(3,1),PersonalStats(3,4),PersonalStats(3,3),PersonalStats(3,6),PersonalStats(3,5));
                                if answer ~= -1
                                    Statistics(1,1) = Statistics(1,1) + 1;
                                    if answer >= 75
                                        Statistics(1,2) = Statistics(1,2) + 1;
                                    else
                                        Statistics(1,3) = Statistics(1,3) + 1;
                                    end
                                end
                            %Red Tomato
                            case 4
                                [answer] = calculateUserValues (maskedRGBImage,PersonalStats(4,2),PersonalStats(4,1),PersonalStats(4,4),PersonalStats(4,3),PersonalStats(4,6),PersonalStats(4,5));
                                if answer ~= -1
                                        Statistics(4,1) = Statistics(4,1) + 1;
                                    if answer >= 75
                                        Statistics(4,2) = Statistics(4,2) + 1;
                                    else
                                        Statistics(4,3) = Statistics(4,3) + 1;
                                    end
                                end
                        end
                end
                if answer ~= -1 %If pressed cancel in choose fruit menu will put Fail Stamp
                str = sprintf('Precntege: %.2f',answer);
                        msgbox(str);
                end
                        ApRe(answer,Approved,Rejected,Fail);
            else
                warndlg('Choose Picture Please');
            end
        case 4 %Change Parameters
            Pass = inputdlg('Enter Password:','Enter Password:');
            if ~isempty(Pass)
            Pass = strcat(Pass{1});
            if strcmp(Pass,Password)
                FruitChoice = menu('Choose Fruit','Yellow Banana','Ornage','Red Apple','Red Tomato','Reset Custom Parameters','cancel');
                switch FruitChoice
                    %YellowBanana
                    case 1
                       prompt = {'Enter Red Max:','Enter Red Min:','Enter Green Max:','Enter Green Min:','Enter Blue Max:','Enter Blue Min:'};
                       dlg_title = 'New Paramaters:';
                       defaultants = {'0<x<255','0<x<255','0<x<255','0<x<255','0<x<255','0<x<255'};
                       answer = inputdlg(prompt,dlg_title,1,defaultants);
                       answer = str2double(answer); % converts answer to "double" numbers
                       %The if - checks if entered values and not pressed Cancel
                       if ~(isequal(answer,[]))
                       %Extracts the numbers as requested to variables
                            PersonalStats(1,1) = answer(1,1);
                            PersonalStats(1,2) = answer(2,1);
                            PersonalStats(1,3) = answer(3,1);
                            PersonalStats(1,4) = answer(4,1);
                            PersonalStats(1,5) = answer(5,1);
                            PersonalStats(1,6) = answer(6,1);
                       end
                    %Orange
                    case 2
                       prompt = {'Enter Red Max:','Enter Red Min:','Enter Green Max:','Enter Green Min:','Enter Blue Max:','Enter Blue Min:'};
                       dlg_title = 'New Paramaters:';
                       defaultants = {'0<x<255','0<x<255','0<x<255','0<x<255','0<x<255','0<x<255'};
                       answer = inputdlg(prompt,dlg_title,1,defaultants);
                       answer = str2double(answer); % converts answer to "double" numbers
                       %The if - checks if entered values and not pressed Cancel
                       if ~(isequal(answer,[]))
                       %Extracts the numbers as requested to variables
                            PersonalStats(2,1) = answer(1,1);
                            PersonalStats(2,2) = answer(2,1);
                            PersonalStats(2,3) = answer(3,1);
                            PersonalStats(2,4) = answer(4,1);
                            PersonalStats(2,5) = answer(5,1);
                            PersonalStats(2,6) = answer(6,1);
                       
                       end 
                      %Red Apple
                    case 3
                       prompt = {'Enter Red Max:','Enter Red Min:','Enter Green Max:','Enter Green Min:','Enter Blue Max:','Enter Blue Min:'};
                       dlg_title = 'New Paramaters:';
                       defaultants = {'0<x<255','0<x<255','0<x<255','0<x<255','0<x<255','0<x<255'};
                       answer = inputdlg(prompt,dlg_title,1,defaultants);
                       answer = str2double(answer); % converts answer to "double" numbers
                       %The if - checks if entered values and not pressed Cancel
                       if ~(isequal(answer,[]))
                       %Extracts the numbers as requested to variables
                            PersonalStats(3,1) = answer(1,1);
                            PersonalStats(3,2) = answer(2,1);
                            PersonalStats(3,3) = answer(3,1);
                            PersonalStats(3,4) = answer(4,1);
                            PersonalStats(3,5) = answer(5,1);
                            PersonalStats(3,6) = answer(6,1);
                       end 
                       %Red Tomato
                    case 4
                       prompt = {'Enter Red Max:','Enter Red Min:','Enter Green Max:','Enter Green Min:','Enter Blue Max:','Enter Blue Min:'};
                       dlg_title = 'New Paramaters:';
                       defaultants = {'0<x<255','0<x<255','0<x<255','0<x<255','0<x<255','0<x<255'};
                       answer = inputdlg(prompt,dlg_title,1,defaultants);
                       answer = str2double(answer); % converts answer to "double" numbers
                       %The if - checks if entered values and not pressed Cancel
                       if ~(isequal(answer,[]))
                       %Extracts the numbers as requested to variables
                            PersonalStats(4,1) = answer(1,1);
                            PersonalStats(4,2) = answer(2,1);
                            PersonalStats(4,3) = answer(3,1);
                            PersonalStats(4,4) = answer(4,1);
                            PersonalStats(4,5) = answer(5,1);
                            PersonalStats(4,6) = answer(6,1);
                       end 
                    case 5
                        sure = menu('Are you Sure to Reset Custom Parameters??','Yes','No');
                        if sure == 1
                            PersonalStats = [-2 -2 -2 -2 -2 -2;-2 -2 -2 -2 -2 -2;-2 -2 -2 -2 -2 -2;-2 -2 -2 -2 -2 -2];
                            xlswrite(filenamePersonalStats,PersonalStats);
                            uiwait(warndlg('Custom Parameters Reset!'));
                        else
                            uiwait(warndlg('Pressed NO - Stopped Reset'));
                        end
                end
            else
                msgbox('Incorrect Password');
            end
            else
                msgbox('Incorrect Password');
            end
        case 5 %Statistics
             Pass = inputdlg('Enter Password:','Enter Password:');
             if ~isempty(Pass)
             
             Pass = strcat(Pass{1});
             if strcmp(Pass,Password)
                   %X axis labels
                    c = categorical({'Apple','Banana','Orange','Tomato'});%Alphabetic Order
                    MaxValue = max(Statistics);
                    MaxValue = max(MaxValue) + 0.5;
                    figure;
                    bar(c,Statistics);
                    ylim([0 MaxValue]);
                    %%Graph Labels
                    %Apple 
                    text(0.6,Statistics(1,1) + 0.15,'Tests');
                    text(0.88,Statistics(1,2) + 0.15,'Pass');
                    text(1.1,Statistics(1,3) + 0.15,'Fail');
                    %Banana
                    text(1.6,Statistics(2,1) + 0.15,'Tests');
                    text(1.88,Statistics(2,2) + 0.15,'Pass');
                    text(2.1,Statistics(2,3) + 0.15,'Fail');
                    %Orange
                    text(2.6,Statistics(3,1) + 0.15,'Tests');
                    text(2.88,Statistics(3,2) + 0.15,'Pass');
                    text(3.1,Statistics(3,3) + 0.15,'Fail');
                    %Tomato
                    text(3.6,Statistics(4,1) + 0.15,'Tests');
                    text(3.88,Statistics(4,2) + 0.15,'Pass');
                    text(4.1,Statistics(4,3) + 0.15,'Fail'); 
                    
                    CloseWin = menu('Close Graph Window?','Reset Statistics','Continue');
                    if CloseWin == 1
                        sure = menu('Are you Sure to Reset?','yes','no');
                        if sure == 1
                        Statistics = [0 0 0 ; 0 0 0 ; 0 0 0 ; 0 0 0 ];
                        uiwait(msgbox('Statistics Set to 0!'));
                        xlswrite(filenameStats,Statistics);
                        close;
                        else
                            uiwait(warndlg('Aborted Reset'));
                            close;
                        end
                    elseif CloseWin == 2
                            close;
                    end
             else
                msgbox('Incorrect Password');    
             end
             else
                msgbox('Incorrect Password'); 
             end
        case 6
            %%Writes Statistics & PersonalStats to files & closes all
            %%figures
            xlswrite(filenameStats,Statistics);
            xlswrite(filenamePersonalStats,PersonalStats);
            close all;

    end
end
end


%% ~~~~~ Functions ~~~~~ %
%Calculate
%Input : masked RGB Image after filtering by color
%Ouptu : precntage of the colors
function [answer,fruitType] = calculate (maskedRGBImage,button)
    if (button == 3)%Red Apple
        binaryR = maskedRGBImage(:,:,1) >= 150;
        binaryG = (maskedRGBImage(:,:,2) <= 150 & maskedRGBImage(:,:,2) >= 10);
        binaryB = (maskedRGBImage(:,:,3) <= 180 & maskedRGBImage(:,:,3) >= 12) ;

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
        
        fruitType = 3;
    elseif (button == 1)%Yellow banana
        binaryR = maskedRGBImage(:,:,1) > 178.000;
        binaryG = (maskedRGBImage(:,:,2) > 160 & maskedRGBImage(:,:,2) <= 250);
        binaryB = (maskedRGBImage(:,:,3) < 156 & maskedRGBImage(:,:,3) >= 0) ;

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
        
        fruitType = 1;
    elseif (button == 2)%Orange
        binaryR = maskedRGBImage(:,:,1) > 165.000;
        binaryG = (maskedRGBImage(:,:,2) >= 94 & maskedRGBImage(:,:,2) <= 250);
        binaryB = (maskedRGBImage(:,:,3) <= 188 & maskedRGBImage(:,:,3) >= 0) ;

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
        
        subplot(3,3,3)
        imshow(bw);
      
        answer = CountPixel/numberOfPixels*100;
        
        fruitType = 2;
        elseif (button == 4)%Red Tomato
            binaryR = maskedRGBImage(:,:,1) > 95;
            binaryG = (maskedRGBImage(:,:,2) >= 25 & maskedRGBImage(:,:,2) <= 150);
            binaryB = (maskedRGBImage(:,:,3) <= 75 & maskedRGBImage(:,:,3) >= 0) ;

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
            subplot(3,3,3)
            imshow(bw);

            answer = CountPixel/numberOfPixels*100;
            
            fruitType = 4;
            elseif (button == 5)
                warndlg('Didnt Choose Fruit - Failed Check');
                answer = -1 ;
    end
end


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
% Ask user what color they want for the onions and peppers images and set up pre-defined threshold values.
function [hueThresholdLow, hueThresholdHigh, saturationThresholdLow, saturationThresholdHigh, valueThresholdLow, valueThresholdHigh,button] = SetThresholds()
try
% 	button = menu('What color do you want to find?', 'yellow', 'green', 'red', 'white');
	% Menu with purple commented out because it's all around and the regionfill just ends up selecting the whole image.
	button = menu('What Fruit Are You Checking?', 'Yellow Banana', 'Orange', 'Red Apple', 'Red Tomato', 'Cancel');
	% Use values that I know work for the onions and peppers demo images.
	switch button
		case 1
			% Yellow Banana
			hueThresholdLow = 0.114;
			hueThresholdHigh = 1;
			saturationThresholdLow = 0.172;
			saturationThresholdHigh = 1;
			valueThresholdLow = 0.1;
			valueThresholdHigh = 1.0;
		case 2
			% Orange
			hueThresholdLow = 0;
			hueThresholdHigh = 1;
			saturationThresholdLow = 0.081;
			saturationThresholdHigh = 1;
			valueThresholdLow = 0;
			valueThresholdHigh = 1;
		case 3
			% Red Apple
			% IMPORTANT NOTE FOR RED.  Red spans hues both less than 0.1 and more than 0.8.
			% We're only getting one range here so we will miss some of the red pixels - those with hue less than around 0.1.
			% To properly get all reds, you'd have to get a hue mask that is the result of TWO threshold operations.
			hueThresholdLow = 0.0001;
			hueThresholdHigh = 1;
			saturationThresholdLow = 0.45;
			saturationThresholdHigh = 1;
			valueThresholdLow = 0.3;
			valueThresholdHigh = 1.0;

		case 4
			% Red Tomato
			hueThresholdLow = 0.0001;
			hueThresholdHigh = 1;
			saturationThresholdLow = 0.45;
			saturationThresholdHigh = 1;
			valueThresholdLow = 0.3;
			valueThresholdHigh = 1.0;
        case 5
            hueThresholdLow = 0;
			hueThresholdHigh = 1;
			saturationThresholdLow = 0;
			saturationThresholdHigh = 1;
			valueThresholdLow = 0;
			valueThresholdHigh = 1;
	end
catch ME
	errorMessage = sprintf('Error in function %s() at line %d.\n\nError Message:\n%s', ...
		ME.stack(1).name, ME.stack(1).line, ME.message);
	fprintf(1, '%s\n', errorMessage);
	uiwait(warndlg(errorMessage));
end
end

% return; % From SetThresholds()

%%Approved/Rejceted
function []=ApRe(answer,Approved,Rejected,Fail)
    if answer >= 75
        subplot(3,3,9);
        imshow(Approved);
        fontSize = 12;
        title('Analyze Answer:', 'FontSize', fontSize);
    elseif answer == -1 %If didnt choose fruit in fruit menu
        subplot(3,3,9);
        fontSize = 12;
        title('Analyze Answer:', 'FontSize', fontSize);
        imshow(Fail);
        else
        subplot(3,3,9);
        fontSize = 12;
        title('Analyze Answer:', 'FontSize', fontSize);
        imshow(Rejected);
    end
end
%%Picture Acquisition
% vid = videoinput('winvideo', 1, 'YUY2_1024x576');
% src = getselectedsource(vid);
% 
% vid.FramesPerTrigger = 1;
% 
% vid.ReturnedColorspace = 'rgb';
% 
% vid.FramesPerTrigger = 22;
% 
% preview(vid);
% 
% start(vid);
% 
% stoppreview(vid);
% ImageTest = getdata(vid);