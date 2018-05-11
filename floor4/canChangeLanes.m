function output = canChangeLanes(index, currentPositions, numLanes)

output = 0;
minFollowingDistance = 10;
carsInOtherLanes = [];

position = currentPositions(currentPositions(:,1)==index,2);
lane = currentPositions(currentPositions(:,1)==index,5);
if lane+1 <= numLanes
    carsInOtherLanes = [carsInOtherLanes; currentPositions(currentPositions(:,5)==lane+1,:)];
end
if lane-1 > 0
    carsInOtherLanes = [carsInOtherLanes, currentPositions(currentPositions(:,5)==lane-1,:)];
end
%if cars in other lane are out of the way
% if distance between them and me > minFollowingDistance
if isempty(carsInOtherLanes)==1
    if sum(size(carsInOtherLanes))>0
        output = (lane+1 < numLanes)*(lane+1) + (lane-1>0)*(lane-1);
        if output == 2*lane
            output = (rand>0.5) * (lane+1);
            if output == 0
                output = lane-1;
            end
        end
    end
    % if you can't switch lanes to either lane, output 0
elseif sum(abs(carsInOtherLanes(:,2) - position)<= minFollowingDistance)==length(carsInOtherLanes(:,2))
    output = 0;
    % else if you can switch lanes to the left lane, do it
elseif sum(abs(carsInOtherLanes(carsInOtherLanes(:,5)==lane+1,2) - position > minFollowingDistance))==length(carsInOtherLanes(carsInOtherLanes(:,5)==lane+1,2)) && length(carsInOtherLanes(carsInOtherLanes(:,5)==lane+1,2))~=0
    output = lane+1;
    % else if you can switch lanes to the right lane, do it
elseif sum(abs(carsInOtherLanes(carsInOtherLanes(:,5)==lane-1,2) - position > minFollowingDistance))==length(carsInOtherLanes(carsInOtherLanes(:,5)==lane-1,2)) && length(carsInOtherLanes(carsInOtherLanes(:,5)==lane-1,2))~=0
    output = lane-1;
else
    output = 0;
end

end
