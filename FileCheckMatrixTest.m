%Test Parameters
MatrixCheck = [-2 -2 -2 -2 -2 -2;-2 -2 -2 -2 -2 -2;-2 -2 -2 -2 -2 -2;-2 -2 -2 -2 -2 -2];

%%Test1
inputMatrix = xlsread('ParametersTestFile.xlsx');
assert(isequal(inputMatrix,MatrixCheck),'Failed to Import Matrix');