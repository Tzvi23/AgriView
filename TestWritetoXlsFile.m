%Parameters
% Note: CheckWriteFile.xlsx has to be EMPTY!!!
input = [1 2 3 4 5 6;1 2 3 4 5 6;1 2 3 4 5 6;1 2 3 4 5 6];
%%Test
xlswrite('CheckWriteFile.xlsx',input);
file = xlsread('CheckWriteFile.xlsx');
assert(isequal(input,file),'Failed to write to file');