function accel = calcAcceleration(frustration,curSpeed,desiredSpeed,followingDistance)
decelerationConstant = -.5;
minFollowingDistance = 2;

if curSpeed >= desiredSpeed
    accel = 0;
elseif followingDistance <= minFollowingDistance
    accel = decelerationConstant;
else
    accel = frustration;
end

end
