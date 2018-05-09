function accel = calcAcceleration(frustration,curSpeed,desiredSpeed,followingDistance)
decelerationConstant = -5;
minFollowingDistance = 10;

if curSpeed > desiredSpeed
    accel = decelerationConstant;
elseif followingDistance <= minFollowingDistance
    accel = decelerationConstant;
elseif curSpeed == desiredSpeed
    accel = 0;
else
    accel = frustration*100;
end

end
