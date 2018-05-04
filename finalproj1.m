%% floor: model one car on a single-lane road
% there is nothing for the car to respond to, so it is going a constant
% speed, although speed is already being governed by rules that the driver
% will follow in the presence of other cars. when the car reaches the end
% of the finite road, a new car is launched at the start of the road, so
% that density of cars is constant over time.

%% car struct definition 
car = struct('index',[],'desiredSpeed',[],'frustration',[],'acceleration',[],'position',[],'speed',[]);

%% model constants
deceleration.constant = -.5;

%% model anonymous functions

%% initialize a car
car(1) = initializeCar(1);

%% simulation loop

car(1).acceleration = calcAcceleration(car(1).frustration);