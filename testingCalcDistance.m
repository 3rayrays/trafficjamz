currentPositions = [1 2 5 2 1; 2 10 4 3 1; 3 26 7 4 2; 4 25 8 5 1]

numLanes=2;

% should output [8, 4, 3]
[a1, a2, b1] = calcDistance(1,currentPositions)
%should output 2
canChangeLanes(1, currentPositions, numLanes)

% should output [15, 8, 5]
[a3, a4, b2] = calcDistance(2,currentPositions)
% should output 2
canChangeLanes(2, currentPositions, numLanes)

% should output [100, 100, 100]
[a5, a6, b3] = calcDistance(3,currentPositions)
% should output 0
canChangeLanes(3, currentPositions,numLanes)

% should output [100, 100, 100]
[a7, a8, b4] = calcDistance(4,currentPositions)
% should output 0
canChangeLanes(4,currentPositions,numLanes)