%Parameters
load('ApprovedTest.mat');%loads the expected matrices as variable

%%Test 1 : A
check = imread('approved.jpg');
assert(isequal(check,Approved),'Fail to Import Image');