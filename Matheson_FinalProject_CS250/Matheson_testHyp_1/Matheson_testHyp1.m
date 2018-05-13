%% Kai Matheson
% testing hypothesis 1: Average speed of cars does not change with changes
% in minFollowingDistance, but average individual variation in speed does. 

% vary minFollowingDistances
minFollowingDistances = 1:maxFollowingDistance;

% these vectors will hold values for average speed and variance at diff
% values of minFollowingDistances
avgSPEED = [];
avgVARIANCE = [];

for ind=1:length(minFollowingDistances)
    
    % these vectors will hold values for average speed and average var
    % in each individual run of the simulation
    avgSpeed= [];
    avgVariance = [];
    
    for runs=1:50
        clearvars -except avgSpeed avgVariance ...
            minFollowingDistances avgSPEED avgVARIANCE ind runs
        % simulation constants
        dt = 0.1;
        % simulation length
        simLength = 50;
        % numIterations
        numIterations = simLength / dt;
        % number of cars on road at once
        numberOfCars = 10;
        % number of lanes on the road at the beginning of the road
        numLanes = 3;
        
        % car struct definition
        
        % index: index of the car
        % desiredSpeed: speed at which car would travel in absence of other cars
        % frustration: level representing driver's frustration, range [1,2]
        % acceleration: current acceleration rate
        % position: vector of positions corresponding to time vector
        % speed: vector of speeds corresponding to time vector
        % time: vector of timesteps at which the car is on the road
        % lane: vector tracking which lane the car is in at each timestep
        % honk: vector tracking honking status at each timestep
        car = struct('index',[],'desiredSpeed',[],'frustration',[],...
            'acceleration',[],'position',[],'speed',[],'time',[],...
            'lane',[],'honk',[]);
        
        % model constants
        
        % minFollowingDistance = distance between two cars for following car to
        % transition from car-following behavior to emergency deceleration
        minFollowingDistance = minFollowingDistances(ind);
        % maxFollowingDistance = distance between two cars for following car to
        % transition from free driving to car-following behavior
        maxFollowingDistance = 30;
        % roadLength = length of road being simulated
        roadLength = 200;
        % frustrationThreshold = value at which drivers will either switch lanes
        % or honk to relieve frustration
        frustrationThreshold = 1.5;
        % baseFrustration = minimum value of frustration
        baseFrustration = 1;
        
        % initialize parameters
        
        % initialize time
        t = 0;
        % initialize index of car. index tracks the index of the last car that
        % was initialized
        index = 0;
        % initialize currentPositions matrix is a 5-column matrix storing the
        % current state of the cars in the simulation at any given time, and is of
        % length equal to the number of current cars on the road. the columns are:
        % 1. index; 2. position; 3. speed; 4. acceleration; 5. lane.
        currentPositions = [];
        
        % simulation loop
        for n=2:(numIterations+1)
            % calculate next timestep in the time vector
            t(n) = t(n-1) + dt;
            % if we need to initialize the first car OR we can add another car on
            % to the road when the number of cars on the road is less than the
            % amount we want to have on the road AND there are no cars within
            % minFollowingDistance of the start of the road, so there is enough
            % room to enter onto the road, then we can initialize another car
            if n==2 || (length(currentPositions(:,1))<numberOfCars && ...
                    sum(currentPositions(:,2)<minFollowingDistance)==0)
                % iterate to next index
                index = index + 1;
                % initalize a car with that index at the current timestep with
                % the number of lanes that we have.
                car(index) = initializeCar(index,t(n),numLanes);
                % add the initialized car to the currentPositions matrix
                currentPositions = [currentPositions; ...
                    index car(index).position(end) car(index).speed(end) ...
                    car(index).acceleration car(index).lane];
            end
            % currentCars = list of indices of cars currently on the road
            currentCars = currentPositions(:,1);
            % iterate through each car
            for a=1:length(currentCars)
                % 'i' is index of the current car in position 'a' of currentCars
                i = currentCars(a);
                % add the current time to the end of the car's time vector
                car(i).time(end+1) = t(n);
                % calculate current speed using last timestep's acceleration
                car(i).speed(end+1) =  (car(i).speed(end) + ...
                    car(i).acceleration * dt);
                % if the speed is negative, set it equal to 0
                car(i).speed(end) = (car(i).speed(end)>=0) * car(i).speed(end);
                % calculate the next position using the speed
                car(i).position(end+1) = car(i).position(end) + ...
                    car(i).speed(end) * dt;
                % calculate frustration using the speed
                car(i).frustration(end+1) = ...
                    (car(i).speed(end)<car(i).desiredSpeed) * ...
                    car(i).frustration(end) + ...
                    (car(i).speed(end)>=car(i).desiredSpeed) * 1 ;
                % initialize current lane and current honk status to be the same
                % as in the last timestep, then it will be possibly changed below
                car(i).lane(end+1) = car(i).lane(end);
                car(i).honk(end+1) = car(i).honk(end);
                % if frustration is beyond the threshold and you aren't in the
                % middle of a lane change, OR randomly change lanes 1/100 of time
                if (car(i).frustration(end)>=frustrationThreshold || ...
                        rand<=0.01 ) && rem(car(i).lane(end-1),1)==0
                    % check whether you are able to change lanes
                    laneChange = canChangeLanes(i, currentPositions, numLanes,minFollowingDistance);
                    % if you can't change lanes, stay in your lane & honk
                    if laneChange == 0
                        car(i).honk(end) = 1;
                        % frustration is relieved from honking
                        car(i).frustration(end) = baseFrustration;
                        % make those around you more frustrated because you honked
                        for c=1:length(currentCars)
                            j=currentCars(c);
                            if i~=j
                                %if they are within maxFollowingDistance of you
                                % in any lane, then they are affected by the honk
                                if abs(car(j).position(end) - ...
                                        car(i).position(end))<= ...
                                        maxFollowingDistance
                                    % frustration increases by 0.05
                                    car(j).frustration(end) = ...
                                        car(j).frustration(end) + 0.05;
                                end
                            end
                        end
                        % if laneChange == some lane, then start changing lanes
                    else
                        % then, car is in between past lane and its desired lane
                        car(i).lane(end) = (car(i).lane(end) + laneChange) / 2;
                        % car is not honking
                        car(i).honk(end)=0;
                    end
                    % if the car is in the middle of a lane change
                elseif rem(car(i).lane(end-1),1)~=0
                    % finish the lane change
                    if car(i).lane(end-1) - car(i).lane(end-2) < 0
                        car(i).lane(end) = car(i).lane(end) - 0.5;
                        car(i).honk(end)=0;
                    else
                        car(i).lane(end) = car(i).lane(end) + 0.5;
                        car(i).honk(end)=0;
                    end
                    % frustration level goes down after changing lanes
                    car(i).frustration(end) = baseFrustration;
                end
                % get the current car's following distance, and their leading
                % car's speed and acceleration
                [followingDistance,leadingCarSpeed,leadingCarAccel] = ...
                    calcDistance(i,currentPositions,roadLength);
                % calculate the current acceleration
                car(i).acceleration = calcAcceleration(car(i).frustration(end), ...
                    car(i).speed(end),car(i).desiredSpeed, followingDistance, ...
                    leadingCarSpeed, leadingCarAccel,maxFollowingDistance,...
                    minFollowingDistance);
                % if the car has gone off the road
                if car(i).position(end)>=roadLength
                    % then remove it from currentPositions
                    currentPositions = currentPositions(currentPositions(:,1)~=i,:);
                else
                    % else update their currentPosition, speed, accel, and lane
                    currentPositions(currentPositions(:,1)==i,2)=car(i).position(end);
                    currentPositions(currentPositions(:,1)==i,3)=car(i).speed(end);
                    currentPositions(currentPositions(:,1)==i,4)=car(i).acceleration;
                    currentPositions(currentPositions(:,1)==i,5)=car(i).lane(end);
                end
            end
        end
       
        % these vectors will hold the average speed of each car in one 
        % run of the simulation
        avgspeed = [];
        variancespeed = [];
        for i=1:index
            avgspeed = [avgspeed, mean(real(car(i).speed(car(i).speed<Inf)))];
            variancespeed = [variancespeed,var(real(car(i).speed(car(i).speed<Inf)))];
        end
        % calculate the average speed for the entire simulation and add it
        % to avgSpeed vector. the same for avgVariance.
        avgSpeed(end+1) = real(mean(real(avgspeed(avgspeed<Inf))));
        avgVariance(end+1) = real(mean(real(variancespeed(variancespeed<Inf))));
        
    end
    
    % calculate average speed & variance of the 50 runs of the simulation
    avgSPEED(end+1) = mean(real(avgSpeed(avgSpeed<Inf)));
    avgVARIANCE(end+1) = mean(real(avgVariance(~isnan(avgVariance))));

end

%%
% display 
figure;
hold on;
plot(minFollowingDistances,avgSPEED);
title('Average speed by minimum following distance');
ylabel('Average speed (km/s)');
xlabel('Minimum following distance (km)');
%ylim([1 2]);
hold off;

figure;
hold on;
plot(minFollowingDistances,avgVARIANCE,'r');
title('Average variance in speed by minimum following distance');
ylabel('Average variance in speed');
xlabel('Minimum following distance (km)');
ylim([0 200]);
hold off;