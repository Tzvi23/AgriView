%Parameters
Approved = imread('approved.jpg');
Rejected = imread('rejected.jpg');
Fail = imread('Fail-Stamp.png');
answer = 80;
flag = 0;

%%Test ApRe Function
answer = ApRe(answer,Approved,Rejected,Fail);
close all;
assert(answer == 1,'Answer Return Function Returned bad Answer');

%Function
function [flag]=ApRe(answer,Approved,Rejected,Fail)
    if answer >= 75
        subplot(3,3,9);
        imshow(Approved);
        fontSize = 12;
        title('Analyze Answer:', 'FontSize', fontSize);
        flag = 1;
    elseif answer == -1 %If didnt choose fruit in fruit menu
        subplot(3,3,9);
        fontSize = 12;
        title('Analyze Answer:', 'FontSize', fontSize);
        imshow(Fail);
        flag = 2;
        else
        subplot(3,3,9);
        fontSize = 12;
        title('Analyze Answer:', 'FontSize', fontSize);
        imshow(Rejected);
        flag = 3;
    end
end



