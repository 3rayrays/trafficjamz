function accel = calcAcceleration(frustration,curSpeed,desiredSpeed,...
    followingDistance,leadingCarSpeed,leadingCarAccel,...
    maxFollowingDistance,minFollowingDistance)

AlphaMinus = 1.55;
AlphaPlus = 2.15;
BetaMinus = 1.08;
BetaPlus = -1.67;
GammaMinus = 1.65;
GammaPlus = -0.89;
carLength = 10;

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
            accel = 7.8 * frustration;
        elseif curSpeed >= 6.096 && curSpeed < 12.192
            accel = 6.7 * frustration;
        else
            accel = 4.8 * frustration;
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
    if curSpeed > leadingCarSpeed
        accel = min(accel, leadingCarAccel - 0.5*...
            (curSpeed - leadingCarSpeed)^2 / (followingDistance - carLength));
    else
        accel = min(accel, leadingCarAccel + 0.25 * accel);
    end
else
    %car-following
    if curSpeed > leadingCarSpeed
        Alpha = AlphaMinus;
        Beta = BetaMinus;
        Gamma = GammaMinus;
    else
        Alpha = AlphaPlus;
        Beta = BetaPlus;
        Gamma = GammaPlus;
    end
    accel = Alpha * curSpeed ^ Beta * (leadingCarSpeed - curSpeed)/...
            (followingDistance - carLength)^Gamma;
    if curSpeed < desiredSpeed
        accel = accel * sqrt(frustration);
    end
end

end
