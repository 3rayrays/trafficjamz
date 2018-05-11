function [followingDistance,leadingCarSpeed,leadingCarAccel] = ...
    calcDistance(index,currentPositions)

% model parameters
roadLength = 100;

% get the position of the car
position = currentPositions(currentPositions(:,1)==index,2);
% get the lane of the car
lane = currentPositions(currentPositions(:,1)==index,5);
% get a matrix of all the cars that are in the same lane
carsInLane = currentPositions(currentPositions(:,5)==lane,:);
% get a matrix that does not include the car itself
otherCars = carsInLane(carsInLane(:,1)~=index,2:5);

% if there are no other cars in the lane
if isempty(otherCars)==1
    % set values for followingDistance, leadingCarSpeed, and
    % leadingCarAccel to values that are arbitrarily large so that they
    % will not affect the calculation of acceleration
    followingDistance = roadLength;
    leadingCarSpeed = roadLength;
    leadingCarAccel = roadLength;
% if there are other cars in the lane
else
    % calculate the distance between the other cars and this car
    distances = otherCars(:,1) - position;
    % if none of the distances are positive, then
    if sum(distances>0)<1
        % set values for followingDistance, leadingCarSpeed, and
        % leadingCarAccel to values that are arbitrarily large so that 
        % they will not affect the calculation of acceleration
        followingDistance = roadLength;
        leadingCarSpeed = roadLength;
        leadingCarAccel = roadLength;
    % if some distances between the car and other cars in the lane >0
    else
        % get the position of the leading car
        leadingCarPosn = min(otherCars(otherCars(:,1)-position>0,1));
        % get the followingDistance
        followingDistance = leadingCarPosn - position;
        % get the speed of the leading car
        leadingCarSpeed = currentPositions(currentPositions(:,2)==leadingCarPosn, 3);
        % get the acceleration of the leading car
        leadingCarAccel = currentPositions(currentPositions(:,2)==leadingCarPosn, 4);
    end
end
            
end