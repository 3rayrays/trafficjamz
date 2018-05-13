function output = canChangeLanes(index, currentPositions, numLanes)

output = 0;
minFollowingDistance = 15;
carsInOtherLanesLeft = [];
carsInOtherLanesRight = [];
left = false;
right = false;

position = currentPositions(currentPositions(:,1)==index,2);
lane = currentPositions(currentPositions(:,1)==index,5);
if lane+1 <= numLanes
    carsInOtherLanesLeft = [carsInOtherLanesLeft; currentPositions(currentPositions(:,5)==lane+1,:)];
end
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
elseif left   
    output = lane+1;
elseif right
    output = lane-1;
% if you can't switch lanes to either lane, output 0
else
    output = 0;
end


end
