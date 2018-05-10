function [followingDistance,leadingCarSpeed] = calcDistance(index,currentPositions)

roadLength = 100;

position = currentPositions(currentPositions(:,1)==index,2);
lane = currentPositions(currentPositions(:,1)==index,4);
carsInLane = currentPositions(currentPositions(:,4)==lane,:);
otherCars = carsInLane(carsInLane(:,1)~=index,2:3);

if isempty(otherCars)==1
    followingDistance = roadLength;
    leadingCarSpeed = roadLength;
else
    distances = otherCars(:,1) - position;
    if sum(distances>0)<1
        followingDistance = roadLength;
        leadingCarSpeed = roadLength;
    else
        leadingCarPosn = min(otherCars(otherCars(:,1)-position>0,1));
        followingDistance = leadingCarPosn - position;
        leadingCarSpeed = currentPositions(currentPositions(:,2)==leadingCarPosn, 3);
    end
end
            
end