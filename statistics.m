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


xlswrite(filenameStats,Statistics);
xlswrite(filenamePersonalStats,PersonalStats);