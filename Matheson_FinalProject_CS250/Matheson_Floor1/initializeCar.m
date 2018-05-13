function car = initializeCar(index,t)

% anonymous function to initialize desired speed between 30 km/s & 20 km/s
initializeDesiredSpeed = @() 30 + rand * 20;
% anonymous function to initialize frustration between 1 and 1.5
initializeFrustration = @() 1 + rand/2;

car(index).index = index;
car(index).desiredSpeed = initializeDesiredSpeed();
car(index).frustration = initializeFrustration();
% initialize speed between 10 km/s and 50 km/s
car(index).speed = 10 + rand * 40;
car(index).position = 0;
car(index).acceleration = 0;
car(index).time = t;
% initialize lane to be 1 because there is only 1 lane
car(index).lane = 1;
car(index).honk = 0;
car = car(index);

end