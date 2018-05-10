gitfunction accel = calcAcceleration(frustration,curSpeed,desiredSpeed,followingDistance)
maxFollowingDistance = 30;
minFollowingDistance = 10;

if followingDistance > maxFollowingDistance
    %free driving
    if curSpeed > desiredSpeed
        %a_n^-
        if curSpeed < 6.1
            accel = -8.7;
        elseif curSpeed >= 6.1 && curSpeed < 12.2
            accel = -5.2;
        elseif curSpeed >= 12.2 && curSpeed < 18.3
            accel = -4.4;
        elseif curSpeed >=18.3 && curSpeed < 24.4
            accel = -2.9;
        else
            accel = -2;
        end
    elseif curSpeed == desiredSpeed
        accel = 0;
    else
        %a_n^+
        if curSpeed < 6.096
            accel = 7.8;
        elseif curSpeed >= 6.096 && curSpeed < 12.192
            accel = 6.7;
        else
            accel = 4.8;
        end
    end
elseif followingDistance < minFollowingDistance
    %emergency deceleration
    if curSpeed < 6.1
        accel = -8.7;
    elseif curSpeed >= 6.1 && curSpeed < 12.2
        accel = -5.2;
    elseif curSpeed >= 12.2 && curSpeed < 18.3
        accel = -4.4;
    elseif curSpeed >=18.3 && curSpeed < 24.4
        accel = -2.9;
    else
        accel = -2;
    end
else
    %car-following
    alphA = 2;
    betA = 1;
    gammA = 1;
    accel = alphA * curSpeed^betA / followingDistance^gammA;
end

end
