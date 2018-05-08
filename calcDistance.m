function followingDistance = calcDistance(index,currentPositions)

roadLength = 100;

followingDistance= roadLength;

position = currentPositions(currentPositions(:,1)==index,2);
lane = currentPositions(currentPositions(:,1)==index,3);
carsInLane = currentPositions(currentPositions(:,3)==lane,:);
otherCars = carsInLane(carsInLane(:,1)~=index,2);
followingDistance = min(otherCars - position);
            
end