%% floor: model one car on a single-lane road
% there is nothing for the car to respond to, so it is going a constant
% speed, although speed is already being governed by rules that the driver
% will follow in the presence of other cars. when the car reaches the end
% of the finite road, a new car is launched at the start of the road, so
% that density of cars is constant over time.

%% simulation constants
dt = 0.25;
% simulation length
simLength = 15;
% numIterations
numIterations = simLength / dt;

%% car struct definition 
car = struct('index',[],'desiredSpeed',[],'frustration',[],'acceleration',[],'position',[],'speed',[]);

%% model constants
decelerationConstant = -.5;
minFollowingDistance = 2;

%% model anonymous functions

%% initialize a car
car(1) = initializeCar(1);
% current position of car 1 is: index 1, position, lane 1.
currentPositions = [1 car(1).position(1) 1];
%% simulation loop
for n=2:(numIterations+1)
    if size(currentPositions,1)==1
        followingDistance=100;
    end
    car(1).speed(n) = car(1).speed(n-1) + car(1).acceleration * dt;
    car(1).position(n) = car(1).position(n-1) + car(1).speed(n-1) * dt;
    car(1).frustration(n) = ...
        (car(1).speed(n-1)<car(1).desiredSpeed)* car(1).frustration(n-1);
    car(1).acceleration = calcAcceleration(car(1).frustration(n), ...
        car(1).speed(n),car(1).desiredSpeed, followingDistance);
end

%% visualize
roadLength = 16;
road = 0:1:roadLength;
toproad(1:roadLength+1) = 4;
bottomroad(1:roadLength+1) = 2;
midroad(1:roadLength+1) = 3;

%%
n = car(1).position;
nImages = length(n);

fig = figure;
for idx = 1:nImages
    hold on;
    road1=plot(road,toproad,'black');
    road2=plot(road,bottomroad,'black');
    carposn=scatter(n(idx), 3,100,'filled','s','blue');
    hold off;
    ylim([0 7]);
    xlim([0 roadLength]);
    drawnow
    frame = getframe(fig);
    delete(carposn);
    im{idx} = frame2im(frame);
end
close;
%%
filename = 'testAnimated.gif'; % Specify the output file name
for idx = 1:nImages
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',.5);
    else
        imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',.05);
    end
end
