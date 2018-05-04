function car = initializeCar(index)

initializeDesiredSpeed = @() 1 + rand * 1;
initializeFrustration = @() rand;

car(index).index = index;
car(index).desiredSpeed = initializeDesiredSpeed();
car(index).frustration = initializeFrustration();
car(index).acceleration = calcAcceleration(car(index).frustration);
car(index).position = 0;
car(index).speed = 0;
car = car(index);

end