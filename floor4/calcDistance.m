function [followingDistance,leadingCarSpeed,leadingCarAccel] = calcDistance(index,currentPositions)

roadLength = 100;

position = currentPositions(currentPositions(:,1)==index,2);
lane = currentPositions(currentPositions(:,1)==index,5);
carsInLane = currentPositions(currentPositions(:,5)==lane,:);
otherCars = carsInLane(carsInLane(:,1)~=index,2:5);

if isempty(otherCars)==1
    followingDistance = roadLength;
    leadingCarSpeed = roadLength;
    leadingCarAccel = roadLength;
else
    distances = otherCars(:,1) - position;
    if sum(distances>0)<1
        followingDistance = roadLength;
        leadingCarSpeed = roadLength;
        leadingCarAccel = roadLength;
    else
        leadingCarPosn = min(otherCars(otherCars(:,1)-position>0,1));
        followingDistance = leadingCarPosn - position;
        leadingCarSpeed = currentPositions(currentPositions(:,2)==leadingCarPosn, 3);
        leadingCarAccel = currentPositions(currentPositions(:,2)==leadingCarPosn, 4);
    end
end
            
end