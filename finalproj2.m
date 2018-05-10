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
numberOfCars = 3;
% initialize currentPositions
currentPositions = [];

%% car struct definition 
car = struct('index',[],'desiredSpeed',[],'frustration',[],'acceleration',[],'position',[],'speed',[],'time',[]);

% model constants
decelerationConstant = -5;
minFollowingDistance = 10;
roadLength = 100;

% model anonymous functions

%% simulation loop
for n=2:(numIterations+1)
    t(n) = t(n-1) + dt;
    if n==2 || length(currentPositions(:,1))<numberOfCars
        % initialize the first car
        index = index + 1;
        car(index) = initializeCar(index,t(n));
        if index==1
            car(index).position(n-1) = 50;
        end
        % current position of car 1 is: index 1, position, speed, lane 1.
        currentPositions = [currentPositions; index car(index).position(end) car(index).speed(end) 1];
        % currentPositions(currentPositions(1,:)==index,2) gets position 
        % of car with index index.
    end
    currentCars = currentPositions(:,1);
    for a=1:length(currentCars)
        i = currentCars(a);
        car(i).time(end+1) = t(n);
        car(i).speed(end+1) =  (car(i).speed(end) + car(i).acceleration * dt);
        car(i).position(end+1) = car(i).position(end) + car(i).speed(end) * dt;
        car(i).frustration(end+1) = ...
            (car(i).speed(end)<car(i).desiredSpeed)* car(i).frustration(end);
        [followingDistance,leadingCarSpeed] = calcDistance(i,currentPositions);
        car(i).acceleration = calcAcceleration(car(i).frustration(end), ...
            car(i).speed(end),car(i).desiredSpeed, followingDistance, leadingCarSpeed);
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
        end
    end
end

%% transform data

posnmatrix = [];

for i=1:index
    times = car(i).time;
    starting = find(t==times(1));
    ending = find(t==times(end));
    car(i).position = [-1*ones(1,starting-1), car(i).position, roadLength + ones(1,length(t) - ending)];
    posnmatrix = [posnmatrix; car(i).position];
end


%% visualize
road = 0:1:roadLength;
toproad(1:roadLength+1) = 4;
bottomroad(1:roadLength+1) = 2;
midroad(1:roadLength+1) = 3;

colors = {'yellow','magenta','cyan','red','blue','green','black'};
%%
fig = figure;
for a = 1:length(posnmatrix(1,:))
    hold on;
    road1=plot(road,toproad,'black');
    road2=plot(road,bottomroad,'black');
    carIndex = 1;
    for dt = 1:length(car)
        carposn(dt) = scatter(posnmatrix(dt,a), 3,100,'filled','s','MarkerEdgeColor','black','MarkerFaceColor',colors{carIndex},'LineWidth',1.5);
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
