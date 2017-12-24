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