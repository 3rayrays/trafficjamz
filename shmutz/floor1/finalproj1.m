%% floor: model one car on a single-lane road
% there is nothing for the car to respond to, so it is going a constant
% speed, although speed is already being governed by rules that the driver
% will follow in the presence of other cars. when the car reaches the end
% of the finite road, a new car is launched at the start of the road, so
% that density of cars is constant over time.

%% simulation constants
dt = 0.25;
% simulation length
simLength = 100;
% numIterations
numIterations = simLength / dt;

%% car struct definition 
car = struct('index',[],'desiredSpeed',[],'frustration',[],'acceleration',[],'position',[],'speed',[]);

%% model constants
decelerationConstant = -.5;
minFollowingDistance = 2;
roadLength = 100;

%% model anonymous functions

%% initialize a car
car(1) = initializeCar(1);
% current position of car 1 is: index 1, position, lane 1.
currentPositions = [1 car(1).position(1) 1];
%% simulation loop
for n=2:(numIterations+1)
    if n==2
        m=2;
        index=1;
    elseif (car(index).position(m)>= roadLength)
        index=2;    
        car(index) = initializeCar(index);
        m = 2;
    else
        m = m + 1;
    end
    if size(currentPositions,1)==1
        followingDistance=100;
    end
    car(index).speed(m) = car(index).speed(m-1) + car(index).acceleration * dt;
    car(index).position(m) = car(index).position(m-1) + car(index).speed(m-1) * dt;
    car(index).frustration(m) = ...
        (car(index).speed(m-1)<car(index).desiredSpeed)* car(index).frustration(m-1);
    car(index).acceleration = calcAcceleration(car(index).frustration(m), ...
        car(index).speed(m),car(index).desiredSpeed, followingDistance);
    %if(car(1).position(m)>=roadLength)
    %    car(1) = initializeCar(1);
    %end
end

%% visualize
road = 0:1:roadLength;
toproad(1:roadLength+1) = 4;
bottomroad(1:roadLength+1) = 2;
midroad(1:roadLength+1) = 3;

%%
n = car(1).position;
m = car(2).position;
nImages = length(n) + length(m);

fig = figure;
for idx = 1:nImages
    hold on;
    road1=plot(road,toproad,'black');
    road2=plot(road,bottomroad,'black');
    if idx <= length(n)
        carposn=scatter(n(idx), 3,100,'filled','s','blue');
    else
        carposn2 = scatter(m(idx-length(n)),3,100,'filled','s','green');
    end
    hold off;
    ylim([0 7]);
    xlim([0 roadLength]);
    drawnow
    frame = getframe(fig);
    delete(carposn);
    delete(carposn2);
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
