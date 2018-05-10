currentPositions = [1 2 5 1; 2 10 4 1; 3 26 7 2; 4 25 8 1]

% should output [8, 4]
[a1, a2] = calcDistance(1,currentPositions)

% should output [15, 8]
[a3, a4] = calcDistance(2,currentPositions)

% should output [100, 100]
[a5, a6] = calcDistance(3,currentPositions)

% should output [100, 100]
[a7, a8] = calcDistance(4,currentPositions)