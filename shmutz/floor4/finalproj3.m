%% floor: model one car on a single-lane road
% there is nothing for the car to respond to, so it is going a constant
% speed, although speed is already being governed by rules that the driver
% will follow in the presence of other cars. when the car reaches the end
% of the finite road, a new car is launched at the start of the road, so
% that density of cars is constant over time.

%% simulation constants
dt = 0.1;
% simulation length
simLength = 50;
% numIterations
numIterations = simLength / dt;
% initialize time
t = 0;
% initialize index
index = 0;
% number of cars on road at once
numberOfCars = 6;
% number of lanes on the road at the beginning of the road
numLanes = 2;
% initialize currentPositions
currentPositions = [];

%% car struct definition 
car = struct('index',[],'desiredSpeed',[],'frustration',[],'acceleration',[],'position',[],'speed',[],'time',[],'lane',[],'honk',[]);

% model constants
decelerationConstant = -5;
minFollowingDistance = 10;
maxFollowingDistance = 30;
roadLength = 100;

frustrationThreshold = 1.5;
baseFrustration = 1;

% model anonymous functions

%% simulation loop
for n=2:(numIterations+1)
    t(n) = t(n-1) + dt;
    if n==2 || length(currentPositions(:,1))<numberOfCars && sum(currentPositions(:,2)<minFollowingDistance)==0
        % initialize the first car
        index = index + 1;
        car(index) = initializeCar(index,t(n),numLanes);
%         if index==1
%             car(index).position(n-1) = 50;
%         end
        % current position of car 1 is: index 1, position, speed, lane 1.
        currentPositions = [currentPositions; ...
            index car(index).position(end) car(index).speed(end) ...
            car(index).acceleration car(index).lane];
        % currentPositions(currentPositions(1,:)==index,2) gets position 
        % of car with index index.
    end
    currentCars = currentPositions(:,1);
    for a=1:length(currentCars)
        i = currentCars(a);
        car(i).time(end+1) = t(n);
        car(i).speed(end+1) =  (car(i).speed(end) + car(i).acceleration * dt);
        car(i).speed(end) = (car(i).speed(end)>=0) * car(i).speed(end);
        car(i).position(end+1) = car(i).position(end) + car(i).speed(end) * dt;
        car(i).frustration(end+1) = ...
            (car(i).speed(end)<car(i).desiredSpeed)* car(i).frustration(end);
        car(i).lane(end+1) = car(i).lane(end);
        car(i).honk(end+1) = car(i).honk(end);
        % if frustration is beyond the threshold and you aren't in the
        % middle of a lane change, OR randomly change lanes 1/5 of time
        % that you can
        if (car(i).frustration(end)>frustrationThreshold || rand<=0.1 ) && rem(car(i).lane(end-1),1)==0
            % can you change lanes?
            laneChange = canChangeLanes(i, currentPositions, numLanes);
            if laneChange == 0 % if you can't change lanes, stay in your lane & honk
                car(i).lane(end) = car(i).lane(end);
                car(i).honk(end) = 1;
                % frustration is somewhat relieved for honking
                car(i).frustration(end) = (car(i).frustration(end) - baseFrustration)/2 + baseFrustration;
                % make those around you more frustrated because you honked
                for c=1:length(currentCars)
                    j=currentCars(c);
                    if i~=j
                        %if they are close by to the car, then they are
                        %affected
                        if abs(car(j).position(end) - car(i).position(end))<= maxFollowingDistance
                            % frustration increases by some function...
                            car(j).frustration(end) = car(j).frustration(end) + 0.05;
                        end
                    end
                end
            else % start to change lanes
                car(i).lane(end) = (car(i).lane(end) + laneChange) / 2;
                car(i).honk(end)=0;
            end
        elseif rem(car(i).lane(end-1),1)~=0 % if you are in the middle of a lane change
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
        [followingDistance,leadingCarSpeed,leadingCarAccel] = calcDistance(i,currentPositions);
        car(i).acceleration = calcAcceleration(car(i).frustration(end), ...
            car(i).speed(end),car(i).desiredSpeed, followingDistance, leadingCarSpeed, leadingCarAccel);
        % set the current position of the car in the currentPositions matrix
        % equal to the current position of the car.
        if car(i).position(end)>=roadLength
            % if the car has gone off the road, remove it from
            % currentPositions
            currentPositions = currentPositions(currentPositions(:,1)~=i,:);
        else 
            % else update their currentPosition 
            currentPositions(currentPositions(:,1)==i,2)=car(i).position(end);
            currentPositions(currentPositions(:,1)==i,3)=car(i).speed(end);
            currentPositions(currentPositions(:,1)==i,4)=car(i).acceleration;
            currentPositions(currentPositions(:,1)==i,5)=car(i).lane(end);
        end
    end
end

%% transform data

posnmatrix = [];
lanematrix = [];
honkmatrix = [];

for i=1:index
    times = car(i).time;
    starting = find(t==times(1));
    ending = find(t==times(end));
    car(i).position = [-1*ones(1,starting-1), car(i).position, roadLength + ones(1,length(t) - ending)];
    car(i).lane = [ones(1,starting-1), car(i).lane, ones(1,length(t)-ending)];
    car(i).honk = [zeros(1,starting-1), car(i).honk, zeros(1,length(t)-ending)];
    lanematrix = [lanematrix; car(i).lane];
    posnmatrix = [posnmatrix; car(i).position];
    honkmatrix = [honkmatrix; car(i).honk];
end


%% visualize
road = 0:1:roadLength;
toproad(1:roadLength+1) = 2.5;
bottomroad(1:roadLength+1) = .5;
midroad(1:roadLength+1) = 1.5;

colors = {'yellow','magenta','cyan','blue','green','black'};
%%
fig = figure;
for a = 1:length(posnmatrix(1,:))
    hold on;
    road1=plot(road,toproad,'black');
    road2=plot(road,bottomroad,'black');
    road3=plot(road,midroad,'magenta');
    carIndex = 1;
    for dt = 1:length(car)
        carposn(dt) = scatter(posnmatrix(dt,a), lanematrix(dt,a),100,'filled','s','MarkerEdgeColor','black','MarkerFaceColor',colors{carIndex},'LineWidth',1.5);
        if honkmatrix(dt,a)==1
            honk(dt) = scatter(posnmatrix(dt,a),lanematrix(dt,a),'red','filled');
        else
            honk(dt) = scatter(posnmatrix(dt,a),-10,'red');
        end
        if carIndex >= length(colors)
            carIndex = 1;
        else
            carIndex = carIndex + 1;
        end
        ylim([-5 11]);
        xlim([0 roadLength]);
    end
    hold off;
    drawnow
    frame = getframe(fig);
    delete(carposn);
    delete(honk);
    im{a} = frame2im(frame);
end
close;

filename = 'testAnimated.gif'; % Specify the output file name
for a = 1:length(posnmatrix(1,:))
    [A,map] = rgb2ind(im{a},256);
    if a == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',.5);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',.05);
    end
end
