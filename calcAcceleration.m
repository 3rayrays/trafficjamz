function accel = calcAcceleration(frustration,curSpeed,desiredSpeed,followingDistance)
decelerationConstant = -5;
minFollowingDistance = 2;

if curSpeed > desiredSpeed
    accel = decelerationConstant;
elseif followingDistance <= minFollowingDistance
    accel = decelerationConstant;
elseif curSpeed == desiredSpeed
    accel = 0;
else
    accel = frustration*10;
end

end
