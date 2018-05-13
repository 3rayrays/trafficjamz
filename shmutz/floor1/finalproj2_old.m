%% floor: model two cars on a single-lane road
% add in another car, so there are two cars on the road at once. the front
% car has a lower desired speed than the following car, which may result
% in increasing frustration of the following car and perhaps honking. or,
% the following car may be patient enough so that it will not honk.
%% simulation constants
dt = 0.25;
% simulation length
simLength = 20;
% numIterations
numIterations = simLength / dt;

t = 0;
%% car struct definition 
car = struct('index',[],'desiredSpeed',[],'frustration',[],'acceleration',[],'position',[],'speed',[]);

%% model constants
decelerationConstant = -.5;
minFollowingDistance = 2;

%% model anonymous functions

%% initialize a car
car(1) = initializeCar(1);
car(2) = initializeCar(2);
% current position of car 1 is: index 1, position, lane 1.
currentPositions = [1 car(1).position(1) 1];
%% simulation loop
for n=2:(numIterations+1)
    t(n) = t(n-1) + dt;
    if size(currentPositions,1)==1
        followingDistance=100;
    else followingDistance=[followingDistance; ...
            car(1).position(n) - car(2).position(n)]
    end
    if t==1
        car(2) = initializeCar(2);
        currentPositions = [currentPositions; 2 car(2).position(1) 1];
    elseif t>1
        car(2).speed(n) = car(2).speed(n-1)+car(2).acceleration*dt;
        car(2).position(n) = car(2).position(n-1)+car(2).speed(n-1)*dt;
        car(2).frustration(n) = ...
            (car(2).speed(n-1)<car(2).desiredSpeed)*car(2).frustration(n-1);
        car(2).acceleration = calcAcceleration(car(2).frustration(n),...
            car(2).speed(n),car(2).desiredSpeed,followingDistance(2));
    end
    car(1).speed(n) = car(1).speed(n-1) + car(1).acceleration * dt;
    car(1).position(n) = car(1).position(n-1) + car(1).speed(n-1) * dt;
    car(1).frustration(n) = ...
        (car(1).speed(n-1)<car(1).desiredSpeed)* car(1).frustration(n-1);
    car(1).acceleration = calcAcceleration(car(1).frustration(n), ...
        car(1).speed(n),car(1).desiredSpeed, followingDistance(1));
end

%% visualize
roadLength = 100;
road = 0:1:roadLength;
toproad(1:roadLength+1) = 4;
bottomroad(1:roadLength+1) = 2;
midroad(1:roadLength+1) = 3;

%%
n = car(1).position;
nImages = length(n);
m = car(2).position;

fig = figure;
for idx = 1:nImages
    hold on;
    road1=plot(road,toproad,'black');
    road2=plot(road,bottomroad,'black');
    carposn=scatter(n(idx), 3,100,'filled','s','blue');
    carposn2=scatter(m(idx),3,100,'filled','s','green');
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
