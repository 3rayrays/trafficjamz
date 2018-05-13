function output = canChangeLanes(index, currentPositions, numLanes, ...
    minFollowingDistance)
% this function takes in the current state of the world and outputs
% 0 if the car cannot currently change lanes, or if it can, the function
% outputs the index of the lane to which it should change.

output = 0;
carsInOtherLanesLeft = [];
carsInOtherLanesRight = [];
% left and right are binary variables that will tell us whether we can 
% change into the lane to our left/right
left = false;
right = false;

% get the current position and lane of the car of interest
position = currentPositions(currentPositions(:,1)==index,2);
lane = currentPositions(currentPositions(:,1)==index,5);

% if there is a lane to their left, then subset currentPositions to cars
% in the left lane
if lane+1 <= numLanes
    carsInOtherLanesLeft = [carsInOtherLanesLeft; currentPositions(currentPositions(:,5)==lane+1,:)];
end
% if there is a lane to their right, then subset currentPositions to cars
% in the right lane
if lane-1 > 0
    carsInOtherLanesRight = [carsInOtherLanesRight; currentPositions(currentPositions(:,5)==(lane-1),:)];
end
% if there is nothing in the matrix of cars to the left
if isempty(carsInOtherLanesLeft)==1
    % if it is empty because there are no cars, but lane exists
    if sum(size(carsInOtherLanesLeft))>0
        % then you can switch to that lane
        left = true;
    end
% if left lane has cars but you can switch to that lane, do it
elseif sum(abs(carsInOtherLanesLeft(:,2) - position)>minFollowingDistance)==length(carsInOtherLanesLeft(:,2))
    left = true;
end
% if there is nothing in the matrix of cars to the right
if isempty(carsInOtherLanesRight)==1
    % if it is empty because there are no cars, but lane exists
    if sum(size(carsInOtherLanesRight))>0
        % then you can switch to that lane
        right = true;
    end
% if right lane has cars but you can switch to that lane, do it 
elseif sum(abs(carsInOtherLanesRight(:,2) - position)>minFollowingDistance)==length(carsInOtherLanesRight(:,2))
    right = true;
end 

% if both lanes are good to switch to, then randomly choose a lane
if left && right
    output = (rand>0.5) * (lane+1);
    if output == 0
        output = lane-1;
    end
% if the left lane is good to switch to, then choose left    
elseif left
    output = lane+1;
% if the right lane is good to switch to, then choose right    
elseif right
    output = lane-1;
% if you can't switch lanes to either lane, output 0
else
    output = 0;
end


end
